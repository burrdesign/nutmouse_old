<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-04-17
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum festhalten von Statistiken
 */
 
class Stats {

	private static $stats_site_table = "bd_stats_site";
	private static $stats_session_table = "bd_stats_session";

	public static function callUrl($url, $session){
		if(!is_array($session)){
			return;
		}
		
		if(Config::get("stats_enable") == 1){
			//URL wurde aufgerufen
			$sql = new SqlManager();
			$insert = array(
				'statsSiteURL' => $url,
				'statsSiteDate' => date("Y-m-d H:i:s", time()),
				'statsSiteSessionKey' => $_SESSION['BD']['sessionKey']
			);
			$sql->insert(self::$stats_site_table, $insert);
		}
	}
	
	public static function newSession($session){
		if(!is_array($session)){
			return;
		}
		
		if(Config::get("stats_enable") == 1){
			//neue Session wurde initialisiert
			$sql = new SqlManager();
			$insert = array(
				'statsSessionId' => $session['BD']['session'],
				'statsSessionEnterDate' => date("Y-m-d H:i:s", time()),
				'statsSessionReferer' => $_SERVER['HTTP_REFERER'],
				'statsSessionUserAgent' => $_SERVER['HTTP_USER_AGENT'],
				'statsSessionRemoteAddress' => $_SERVER['REMOTE_ADDR']
			);
			$sql->insert(self::$stats_session_table, $insert);
			$_SESSION['BD']['sessionKey'] = $sql->getLastInsertID();
		}
	}
	
	public static function getFilterSql($removeme=""){
		$filter_robots = array();
		$filter_sites = array();
		
		$filter_robots = array_filter(split(";", Config::get("stats_robot_filter")));
		$filter_sites = array_filter(split(";", Config::get("stats_site_filter")));
		
		$filter_sqlwhere = "";
		
		$sql = new SqlManager();
		
		if(count($filter_robots) > 0){
			//Robotfilter aufbauen
			$sep = "";
			$filter_sqlwhere .= " AND (";
			foreach($filter_robots as $robot){
				if(!empty($robot)){
					$filter_sqlwhere .= $sep . "statsSessionUserAgent NOT LIKE '%" . $sql->escape($robot) . "%'";
					$sep = " AND ";
				}
			}
			$filter_sqlwhere .= ")";
		}
			
		if(count($filter_sites) > 0){
			//Robotfilter aufbauen
			$sep = "";
			$filter_sqlwhere .= " AND (";
			foreach($filter_sites as $site){
				if(!empty($site)){
					if(strpos($site, "*") !== false){
						if(strpos($site, "*") == 0){
							$site = str_replace("*", "", $site);
							$filter_sqlwhere .= $sep . "statsSiteURL NOT LIKE '%" . $sql->escape($site) . "'";
							$sep = " AND ";
						} else {
							$site = str_replace("*", "", $site);
							$filter_sqlwhere .= $sep . "statsSiteURL NOT LIKE '" . $sql->escape($site) . "%'";
							$sep = " AND ";
						}
					} else {
						$filter_sqlwhere .= $sep . "statsSiteURL != '" . $sql->escape($site) . "'";
						$sep = " AND ";
					}
				}
			}
			$filter_sqlwhere .= ")";
		}
		
		return $filter_sqlwhere;
	}
	
	public static function getStatsSessionCnt($from, $to){
		$sql = new SqlManager();
		$stats = Cache::loadCache("stats");
		
		$from = date("Y-m-d", strtotime($from));
		$to = date("Y-m-d", strtotime($to));

		if(!is_array($stats['sessioncnt']) || $from != $stats['from'] || $to != $stats['to']){
			//Cache löschen
			Cache::clearCache("stats");
			
			//Statistiken aus DB laden
			$stats = array();
			$stats['sessioncnt'] = array();
			$stats['sessioncnt']['stats'] = array();
			$sql->setQuery("
				SELECT
					COUNT(statsSiteKey) AS statsPageCnt,
					YEAR(statsSessionEnterDate) AS statsSessionYear, 
					MONTH(statsSessionEnterDate) AS statsSessionMonth, 
					DAY(statsSessionEnterDate) AS statsSessionDay
				FROM bd_stats_session
				LEFT JOIN bd_stats_site ON (statsSessionKey = statsSiteSessionKey)
				WHERE statsSessionEnterDate >= '{{start}}' AND statsSessionEnterDate <= '{{end}}' " . Stats::getFilterSql() . "
				GROUP BY statsSessionKey
				");
			$sql->bindParam("{{start}}", $from . ' 00:00:00');
			$sql->bindParam("{{end}}", $to . ' 23:59:59');
			$result = $sql->execute();
			
			while($session = mysql_fetch_array($result)){
				if($session['statsPageCnt'] > 0){
					$date = sprintf("%04d", $session['statsSessionYear']);
					$date .= "-" . sprintf("%02d", $session['statsSessionMonth']);
					$date .= "-" . sprintf("%02d", $session['statsSessionDay']);
					$stats['sessioncnt']['stats'][$date]++;
				}
			}
			
			$stats['from'] = $from;
			$stats['to'] = $to;
		}
		
		if(date("Y-m-d", time()) > $from && date("Y-m-d", time()) < $to){			
			//Statistik für heute immer aus DB laden, damit die Daten live sind!
			$today = date("Y-m-d",time());
			$sql->setQuery("
				SELECT
					COUNT(statsSiteKey) AS statsPageCnt,
					YEAR(statsSessionEnterDate) AS statsSessionYear, 
					MONTH(statsSessionEnterDate) AS statsSessionMonth, 
					DAY(statsSessionEnterDate) AS statsSessionDay
				FROM bd_stats_session
				LEFT JOIN bd_stats_site ON (statsSessionKey = statsSiteSessionKey)
				WHERE statsSessionEnterDate >= '{{start}}' AND statsSessionEnterDate <= '{{end}}' " . Stats::getFilterSql() . "
				GROUP BY statsSiteKey
				");
			$sql->bindParam("{{start}}", $today . ' 00:00:00');
			$sql->bindParam("{{end}}", $today . ' 23:59:59');
			$result = $sql->execute();
			
			while($session = mysql_fetch_array($result)){
				if($session['statsPageCnt'] > 0){
					$date = sprintf("%04d", $stat['statsSessionYear']);
					$date .= "-" . sprintf("%02d", $stat['statsSessionMonth']);
					$date .= "-" . sprintf("%02d", $stat['statsSessionDay']);
					if($date == $today){
						$stats['sessioncnt']['stats'][$date]++;
					}
				}
			}
		}
		
		Cache::saveCache("stats",$stats);
		
		return $stats['sessioncnt'];
	}
	
	public static function getStatsBrowserCnt($from, $to){
		$sql = new SqlManager();
		$stats = Cache::loadCache("stats");
		
		$from = date("Y-m-d", strtotime($from));
		$to = date("Y-m-d", strtotime($to));

		if(!is_array($stats['browsercnt']) || $from != $stats['from'] || $to != $stats['to']){
			//Cache löschen
			Cache::clearCache("stats");
			
			//Statistiken aus DB laden
			$stats = array();
			$stats['browsercnt'] = array();
			$stats['browsercnt']['stats'] = array();
			$sql->setQuery("
				SELECT
					COUNT(statsSiteKey) AS statsPageCnt,
					statsSessionUserAgent
				FROM bd_stats_session
				LEFT JOIN bd_stats_site ON (statsSessionKey = statsSiteSessionKey)
				WHERE statsSessionEnterDate >= '{{start}}' AND statsSessionEnterDate <= '{{end}}' " . Stats::getFilterSql() . "
				GROUP BY statsSessionKey
				");
			$sql->bindParam("{{start}}", $from . ' 00:00:00');
			$sql->bindParam("{{end}}", $to . ' 23:59:59');
			$result = $sql->execute();
			
			while($session = mysql_fetch_array($result)){
				//Browser ermitteln
				$browser = self::getBrowserFromUserAgent($session['statsSessionUserAgent']);
				//und Statistik hoch zählen
				if($session['statsPageCnt'] > 0){
					$stats['browsercnt']['stats'][$browser]++;
				}
			}
			
			$stats['from'] = $from;
			$stats['to'] = $to;
		}
		
		if(date("Y-m-d", time()) > $from && date("Y-m-d", time()) < $to){			
			//Statistik für heute immer aus DB laden, damit die Daten live sind!
			$today = date("Y-m-d",time());
			$sql->setQuery("
				SELECT
					COUNT(statsSiteKey) AS statsPageCnt,
					statsSessionUserAgent
				FROM bd_stats_session
				LEFT JOIN bd_stats_site ON (statsSessionKey = statsSiteSessionKey)
				WHERE statsSessionEnterDate >= '{{start}}' AND statsSessionEnterDate <= '{{end}}' " . Stats::getFilterSql() . "
				GROUP BY statsSessionKey
				");
			$sql->bindParam("{{start}}", $today . ' 00:00:00');
			$sql->bindParam("{{end}}", $today . ' 23:59:59');
			$result = $sql->execute();
			
			while($session = mysql_fetch_array($result)){
				//Browser ermitteln
				$browser = self::getBrowserFromUserAgent($session['statsSessionUserAgent']);
				//und Statistik hoch zählen
				if($session['statsPageCnt'] > 0){
					$stats['browsercnt']['stats'][$browser]++;
				}
			}
		}
		
		return $stats['browsercnt'];
	}
	
	public static function getBrowserFromUserAgent($agent){
		//Browser anhand der UserAgent-Kennung ermitteln
		$browser = "unknown";
		if(strpos($agent, "Firefox") !== false){
			$browser = "Firefox";
		} elseif(strpos($agent, "MSIE") !== false){
			$browser = "Internet Explorer";
		} elseif(strpos($agent, "Chrome") !== false){
			$browser = "Chrome";
		} elseif(strpos($agent, "Safari") !== false){
			$browser = "Safari";
		} elseif(strpos($agent, "Opera") !== false){
			$browser = "Opera";
		}
		return $browser;
	}
	
	public static function getStatsPagesPerSession($from, $to){
		$sql = new SqlManager();
		$stats = Cache::loadCache("stats");
		
		$from = date("Y-m-d", strtotime($from));
		$to = date("Y-m-d", strtotime($to));

		if(!is_array($stats['pagespersession']) || $from != $stats['from'] || $to != $stats['to']){
			//Cache löschen
			Cache::clearCache("stats");
			
			//Statistiken aus DB laden
			$stats = array();
			$stats['pagespersession'] = array();
			$stats['pagespersession']['stats'] = array();
			$sql->setQuery("
				SELECT COUNT(*) AS statsPageCnt
				FROM bd_stats_site
				JOIN bd_stats_session ON (statsSessionKey = statsSiteSessionKey)
				WHERE statsSessionEnterDate >= '{{start}}' AND statsSessionEnterDate <= '{{end}}' " . Stats::getFilterSql() . "
				GROUP BY statsSessionKey
				");
			$sql->bindParam("{{start}}", $from . ' 00:00:00');
			$sql->bindParam("{{end}}", $to . ' 23:59:59');
			$result = $sql->execute();
			
			while($res = mysql_fetch_array($result)){
				if($res['statsPageCnt'] < 10){
					$stats['pagespersession']['stats']["&lt; 10"]++;
				} elseif($res['statsPageCnt'] >= 10 && $res['statsPageCnt'] < 25){
					$stats['pagespersession']['stats']["10 - 24"]++;
				} elseif($res['statsPageCnt'] >= 25 && $res['statsPageCnt'] < 50){
					$stats['pagespersession']['stats']["25 - 49"]++;
				} elseif($res['statsPageCnt'] >= 50 && $res['statsPageCnt'] < 100){
					$stats['pagespersession']['stats']["50 - 99"]++;
				} else {
					$stats['pagespersession']['stats']["&gt; 99"]++;
				}
			}
			
			$stats['from'] = $from;
			$stats['to'] = $to;
		}
		
		if(date("Y-m-d", time()) > $from && date("Y-m-d", time()) < $to){			
			//Statistik für heute immer aus DB laden, damit die Daten live sind!
			$today = date("Y-m-d",time());
			$sql->setQuery("
				SELECT COUNT(*) AS statsPageCnt
				FROM bd_stats_site
				JOIN bd_stats_session ON (statsSessionKey = statsSiteSessionKey)
				WHERE statsSessionEnterDate >= '{{start}}' AND statsSessionEnterDate <= '{{end}}' " . Stats::getFilterSql() . "
				GROUP BY statsSessionKey
				");
			$sql->bindParam("{{start}}", $today . ' 00:00:00');
			$sql->bindParam("{{end}}", $today . ' 23:59:59');
			$result = $sql->execute();
			
			while($res = mysql_fetch_array($result)){
				if($res['statsPageCnt'] < 10){
					$stats['pagespersession']['stats']["&lt; 10"]++;
				} elseif($res['statsPageCnt'] >= 10 && $res['statsPageCnt'] < 25){
					$stats['pagespersession']['stats']["10 - 24"]++;
				} elseif($res['statsPageCnt'] >= 25 && $res['statsPageCnt'] < 50){
					$stats['pagespersession']['stats']["25 - 49"]++;
				} elseif($res['statsPageCnt'] >= 50 && $res['statsPageCnt'] < 100){
					$stats['pagespersession']['stats']["50 - 99"]++;
				} else {
					$stats['pagespersession']['stats']["&gt; 99"]++;
				}
			}
		}
		
		return $stats['pagespersession'];
	}
	
	public static function getStatsPageCnt($from, $to){
		$sql = new SqlManager();
		$stats = Cache::loadCache("stats");
		
		$from = date("Y-m-d", strtotime($from));
		$to = date("Y-m-d", strtotime($to));

		if(!is_array($stats['pagecnt']) || $from != $stats['from'] || $to != $stats['to']){
			//Cache löschen
			Cache::clearCache("stats");
			
			//Statistiken aus DB laden
			$stats = array();
			$stats['pagecnt'] = array();
			$stats['pagecnt']['stats'] = array();
			$sql->setQuery("
				SELECT
					COUNT(*) AS statsPageCnt,
					statsSiteURL
				FROM bd_stats_site
				JOIN bd_stats_session ON (statsSessionKey = statsSiteSessionKey)
				WHERE statsSessionEnterDate >= '{{start}}' AND statsSessionEnterDate <= '{{end}}' " . Stats::getFilterSql() . "
				GROUP BY statsSiteURL
				ORDER BY statsPageCnt DESC
				LIMIT 15
				");
			$sql->bindParam("{{start}}", $from . ' 00:00:00');
			$sql->bindParam("{{end}}", $to . ' 23:59:59');
			$result = $sql->execute();
			
			while($res = mysql_fetch_array($result)){
				$stats['pagecnt']['stats'][$res['statsSiteURL']] = $res['statsPageCnt'];
			}
			
			$stats['from'] = $from;
			$stats['to'] = $to;
		}
		
		if(date("Y-m-d", time()) > $from && date("Y-m-d", time()) < $to){			
			//Statistik für heute immer aus DB laden, damit die Daten live sind!
			$today = date("Y-m-d",time());
			$sql->setQuery("
				SELECT
					COUNT(*) AS statsPageCnt,
					statsSiteURL
				FROM bd_stats_site
				JOIN bd_stats_session ON (statsSessionKey = statsSiteSessionKey)
				WHERE statsSessionEnterDate >= '{{start}}' AND statsSessionEnterDate <= '{{end}}' " . Stats::getFilterSql() . "
				GROUP BY statsSiteURL
				ORDER BY statsPageCnt DESC
				LIMIT 15
				");
			$sql->bindParam("{{start}}", $today . ' 00:00:00');
			$sql->bindParam("{{end}}", $today . ' 23:59:59');
			$result = $sql->execute();
			
			while($res = mysql_fetch_array($result)){
				$stats['pagecnt']['stats'][$res['statsSiteURL']] = $res['statsPageCnt'];
			}
		}
		
		return $stats['pagecnt'];
	}

}
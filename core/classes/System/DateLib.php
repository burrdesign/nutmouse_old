<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-03-29
 *
 * @Beschreibung: Hauptbibliothek für Datumsformatierungen und -funktionen
 */
 
class DateLib {

	private static $days_names = array(
		"de" => array(
			"Sunday" => "Sonntag",
			"Monday" => "Montag",
			"Tuesday" => "Dienstag",
			"Wednesday" => "Mittwoch",
			"Thursday" => "Donnerstag",
			"Friday" => "Freitag",
			"Saturday" => "Samstag")
		);
		
	private static $month_names = array(
		"de" => array(
			"January" => "Januar",
			"Fabruary" => "Februar",
			"March" => "M&auml;rz",
			"April" => "April",
			"Mai" => "Mai",
			"June" => "Juni",
			"July" => "Juli",
			"August" => "August",
			"September" => "September",
			"October" => "Oktober",
			"November" => "November",
			"December" => "Dezember")
		);

	public static function fmt($fmt, $timestamp, $lang="de"){
		$fmt_org = $fmt;
		$fmt_array = array();
		
		$date = date($fmt, $timestamp);
		
		if(strpos($fmt,"l") !== false){
			//Wochentag ausgeschrieben
			foreach(self::$days_names[$lang] as $wrong => $right){
				$date = str_replace($wrong,$right,$date);
			}
		}
		
		if(strpos($fmt,"F") !== false){
			//Monat ausgeschrieben
			foreach(self::$month_names[$lang] as $wrong => $right){
				$date = str_replace($wrong,$right,$date);
			}
		}
		
		return $date;
	}

}
<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-03-10
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum Handling von Admin-Sessions
 *		und den Login- bzw. Logout-Actions
 */
 
class Admin {

	private $message = array();
	
	public function checkLogin($post){
		if($_SESSION['BD']['ADMIN']['login_status'] != 1){
			$this->doLogin($post);
		}
	}
	
	public function doLogin($post){
		if(isset($post['login_user']) && isset($post['login_password'])){
			//nötige Variablen sind übergeben => Login versuchen
			$login = array();
			$sql = new SqlManager();
			$sql->setQuery("
				SELECT * FROM bd_sys_admin_user
				WHERE adminLogin = '{{login}}' AND adminPassword = '{{password}}'
				LIMIT 1
				");
			$sql->bindParam("{{login}}",$post['login_user']);
			$sql->bindParam("{{password}}",md5($post['login_password']));
			$login = $sql->result();
			
			//wurde ein Adminuser gefunden?
			if($login['adminKey']){
				$_SESSION['BD']['ADMIN']['login_status'] = 1;
				$_SESSION['BD']['ADMIN']['user'] = array();
				$_SESSION['BD']['ADMIN']['user'] = $login;
				
				//LastLogin-Datum akualisieren
				$update = array();
				$update['adminKey'] = $_SESSION['BD']['ADMIN']['user']['adminKey'];
				$update['adminLastLogin'] = date("Y-m-d H:i:s", time());
				$sql->update("bd_sys_admin_user", $update);
				
				//Benutzerrechte laden
				$_SESSION['BD']['ADMIN']['user']['rights'] = array();
				$sql->setQuery("
					SELECT * FROM bd_sys_admin_right
					WHERE rightGroupKey = {{group}}"
					);
				$sql->bindParam("{{group}}",$_SESSION['BD']['ADMIN']['user']['adminGroupKey'],"int");
				$rights = $sql->execute();
				while($right = mysql_fetch_array($rights)){
					$_SESSION['BD']['ADMIN']['user']['rights'][$right['rightModuleKey']] = $right['rightAccess'];
				}
			} else {
				//Kein Adminuser gefunden
				$this->message['type'] = 'error';
				$this->message['text'] = 'Benutzerdaten sind ung&uuml;tig!';
			}
		}
	}
	
	public function doLogout(){
		if($_SESSION['BD']['ADMIN']['login_status'] == 1){
			unset($_SESSION['BD']['ADMIN']);
			$this->message['type'] = 'ok';
			$this->message['text'] = 'Sie wurden erfolgreich abgemeldet!';
		}
	}
	
	public function getMessage(){
		return $this->message;
	}
}
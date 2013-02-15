<?php

/**
 * @Nutmouse CMS
 * @Version: 0.2
 * @Copyright: BurrDesign
 * @Date: 2012-02-02
 *
 * @Beschreibung:
 *		Hilfs-Klasse zum Handling von Admin-Sessions
 *		und den Login- bzw. Logout-Actions
 */
 
include_once($_SERVER['DOCUMENT_ROOT'] . '/core/classes/Db/SqlManager.php');
 
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
				$_SESSION['BD']['ADMIN']['user'] = $login;
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
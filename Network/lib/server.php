<?php
	
	function delete_Cookie($name) {
		setcookie($name,null,-1,'/');
		unset($_COOKIE[$name]);
	}
	
	function sessionCookie() {
		if (isset($_COOKIE["aspdm_sess_id"])) {
			$_SESSION["sess_username"] = $_COOKIE["aspdm_sess_username"];
			$_SESSION["sess_id"] = $_COOKIE["aspdm_sess_id"];
		} else {
			delete_Cookie("aspdm_sess_id");
			delete_Cookie("aspdm_sess_username");
		}
	}
	
	function sessionValid() {
		if (isset($_SESSION["sess_username"]) && isset($_SESSION["sess_id"])) {
			include 'lib/db_info.php';
			$conn = mysql_connect($DB_HOST, $DB_USER, $DB_PASS);
			mysql_select_db($DB_NAME, $conn);
			$username = mysql_real_escape_string($_SESSION["sess_username"]);

			$query = "SELECT id, username, password
			FROM users
			WHERE username = '$username';";
			$result = mysql_query($query);

			if(mysql_num_rows($result) == 0) { // User not found. redirect to login form...
				return sessionInvalid();
			}

			$userData = mysql_fetch_array($result, MYSQL_ASSOC);
			$chk_id = hash('sha256',$userData['username'].$userData['id'].$userData['password']);
			
			if (strcasecmp($_SESSION["sess_username"],$userData['username'])!=0) {
				return sessionInvalid();
			}
			if (strcmp($_SESSION['sess_id'],$chk_id)!=0) {
				return sessionInvalid();
			}
			return 1;
		}
		return sessionInvalid();
	}
	
	function sessionInvalid() {
		if (isset($_SESSION)) {
			session_destroy();
			unset($_SESSION);
		}
		delete_Cookie("aspdm_sess_id");
		delete_Cookie("aspdm_sess_username");
		return 0;
	}
	
	function getServerName() {
		return (isset($_SERVER['HTTP_HOST']))?$_SERVER['HTTP_HOST']:$_SERVER['SERVER_NAME'];
	}
	
	function MsgBox($m="") {
		echo '<script language="javascript">';
		echo 'alert("'.$m.'")';
		echo '</script>';
	}
	
	function js_redirect($url="") {
		echo '<script language="javascript">';
		echo 'window.location.replace("'.$url.'");';
		echo '</script>';
	}
	
?>
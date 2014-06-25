<?php
ob_start();
session_start();

$username = $_POST['username'];
$password = $_POST['password'];

include 'lib/db_info.php';
include 'lib/server.php';

$conn = mysql_connect($host, $db_user, $db_pass);
mysql_select_db($db_name, $conn);

$username = mysql_real_escape_string($username);

//$query = "SELECT id, username, password, salt
$query = "SELECT id, username, password
FROM users
WHERE username = '$username';";

$result = mysql_query($query);

if(mysql_num_rows($result) == 0) // User not found. So, redirect to login_form again.
{
	header('Location: login.php?i=u');
	exit();
}

$userData = mysql_fetch_array($result, MYSQL_ASSOC);
//$hash = hash('sha256', $userData['salt'] . hash('sha256', $password) );
$hash = hash('sha256', $password);

if($hash != $userData['password']) // Incorrect password. So, redirect to login_form again.
{
	header('Location: login.php?i=p&u=' . $username);
}else{ // Redirect to home page after successful login.
	session_regenerate_id();
	$_SESSION['sess_id'] = hash('sha256',$userData['username'].$userData['id'].$userData['password']);
	$_SESSION['sess_username'] = $userData['username'];
	
	delete_Cookie("aspdm_sess_id");
	delete_Cookie("aspdm_sess_username");
	
	if(isset($_REQUEST["remember"])){
		$sess_time = time()+60*60*24*7*2;
        setcookie("aspdm_sess_id",$_SESSION['sess_id'],$sess_time,'/');
        setcookie("aspdm_sess_username",$_SESSION['sess_username'],$sess_time,'/');
    }
	
	session_write_close();
	header('Location: home.php');
}
?>
<?php
ob_start();
session_start();

$username = $_POST['username'];
$password = $_POST['password'];

$host = "mysql.2freehosting.com";
$db_user = "******************";
$db_pass = "******************";
$db_name = "******************";

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
	$_SESSION['sess_user_id'] = $userData['id'];
	$_SESSION['sess_username'] = $userData['username'];
	session_write_close();
	header('Location: home.php');
}
?>
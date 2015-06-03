<?php
	$pageName = basename($_SERVER['PHP_SELF']);
	
	//Start session
	session_start();
	include 'lib/server.php';
	sessionCookie();
	$sess_valid = sessionValid();
	
	if (!function_exists("in_arrayi"))
		include 'lib/utils.php';
	
	include 'lib/pagelock.php';
	
	if (in_arrayi($pageName,$LOCKED_PAGES)) {
		if (!$sess_valid) {
			sessionInvalid();
			header('Location: login.php');
			exit();
		}
	}
	
	if (strcasecmp($pageName,"login.php")==0) {
		if ($sess_valid) {
			header('Location: home.php');
		}
	}
?>
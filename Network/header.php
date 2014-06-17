<?php
	$pageName = basename($_SERVER['PHP_SELF']);
	
	if (strcasecmp($pageName,"login.php")!=0) {
		//Start session
		session_start();
	}
?>

<meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
<meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=0.6"/>
<link type="image/png" href="src/ahk.png" rel="icon">
<link rel="stylesheet" href="src/font-awesome-4.0.3/css/font-awesome.min.css">
<link type="text/css"  href="src/bootstrap.css" rel="stylesheet">
<link type="text/css"  href="src/style.css" rel="stylesheet">
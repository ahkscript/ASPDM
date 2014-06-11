<?php
	$pageName = basename($_SERVER['PHP_SELF']);

	if (strcasecmp($pageName,"login.php")!=0)
	echo '&nbsp;<a href="home.php">Sign In/Out</a>';
	if (strcasecmp($pageName,"index.php")!=0)
	echo '&nbsp;<a href="index.php">List Packages</a>';
	if (strcasecmp($pageName,"submit.php")!=0)
	echo '&nbsp;<a href="submit.php">Submit Package</a>';
	if (strcasecmp($pageName,"about.php")!=0)
	echo '&nbsp;<a href="about.php">About ASPDM</a>';
?>
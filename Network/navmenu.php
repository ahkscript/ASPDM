<?php
	$pageName = basename($_SERVER['PHP_SELF']);

	if (strcasecmp($pageName,"login.php")!=0) {
		
		if(!isset($_SESSION['sess_user_id']) || (trim($_SESSION['sess_user_id']) == ''))
			echo '<a href="home.php">Sign In</a>';
		else
			echo '<a href="home.php" class="username">Hi, ' . $_SESSION["sess_username"] . '</a>&nbsp;<a href="logout.php">Sign Out</a>';
	}
	if (strcasecmp($pageName,"index.php")!=0)
	echo '&nbsp;<a href="index.php">List Packages</a>';
	if (strcasecmp($pageName,"submit.php")!=0)
	echo '&nbsp;<a href="submit.php">Submit Package</a>';
	if (strcasecmp($pageName,"about.php")!=0)
	echo '&nbsp;<a href="about.php">About ASPDM</a>';
?>
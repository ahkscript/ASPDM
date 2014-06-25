<?php
	$pageName = basename($_SERVER['PHP_SELF']);
	
	if (strcasecmp($pageName,"login.php")!=0) {
		
		if(isset($sess_valid) && $sess_valid)
			echo '<a href="home.php" class="username">Hi, ' . $_SESSION["sess_username"] . '</a>&nbsp;<a href="logout.php">Sign Out</a>';
		else
			echo '<a href="home.php">Sign In</a>';
	}
	
	if (strcasecmp($pageName,"index.php")!=0)
	echo '&nbsp;<a href="index.php">List Packages</a>';
	
	if(isset($sess_valid) && $sess_valid) {
		if (strcasecmp($pageName,"submit.php")!=0)
		echo '&nbsp;<a href="submit.php">Submit Package</a>';
	}
	
	if (strcasecmp($pageName,"about.php")!=0)
	echo '&nbsp;<a href="about.php">About ASPDM</a>';
?>
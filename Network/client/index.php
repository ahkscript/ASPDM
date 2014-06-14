<?php
	include '../lib/utils.php';
	
	echo "<h1>Not Ready Yet...</h1>";
	echo '<a href="/">Click here for the homepage.</a>';
	$version = iniget("update.ini","version");
	echo '<hr><a href="ASPDM_Install-v'.$version.'.exe">Click here to download the preview release. [Version: '.$version.']</a>';
?>
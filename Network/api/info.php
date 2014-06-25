<?php
	include '../lib/utils.php';
	
	$f = (isset($_GET["f"])) ? htmlspecialchars($_GET["f"]) : NULL;
	$c = (isset($_GET["c"])) ? htmlspecialchars($_GET["c"]) : NULL;
	print_metadata($f,$c);
?>
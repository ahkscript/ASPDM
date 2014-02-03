<?php

$vars = array("name","fullname","author",
              "license","version","ahkversion",
			  "type","category","description",
			  "forumURL","packageURL","screenshotURL");
//-------

reset($vars);
foreach ($vars as $varname) {
	$val = (isset($_GET[$varname])) ? htmlspecialchars($_GET[$varname]) : "NULL/ERROR";
	echo $varname . " : " . $val . "<br />\n";
}

?>
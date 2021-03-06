<?php
	include '../lib/utils.php';
?>
<html>
<head>
<title>Client | ASPDM</title>
<link type="text/css"  href="/client/style.css" rel="stylesheet">
<style>
	table { text-align:center;vertical-align:middle; }
	#dnl{padding:1px;border-style:solid;border-width:2px;border-radius:0;border-color:#333;color:#FEFEFE;background-color:#468847;font-size:12px;font-family:sans-serif;font-weight:700}
	#dnl:hover{ cursor:pointer;background-color:#EFEFEF;color:#468847 }
	#dnl:active{ position:relative;top:2px }
	#dnl td { vertical-align:middle;text-align:center; }
	#sp { margin:auto;text-align:center;width:300px; }
	#info { font-size:10px;color:#666; }
	hr { width:640px; }
</style>
</head>
<body>
<div id="content" style="margin-top:200px">
	<h1>
		<a id="logolink" href="/">
			<img src="/src/ahk.png" id="logo"> ASPDM : Package Manager
			</a>
	</h1>
	<hr><br><br>
<?php
	$version = iniget("update.ini","version");
	echo '<div id="sp">';
	$file = 'ASPDM_Install-v'.$version.'.exe';
	echo '<a href="'.$file.'" id="link" style="display:inline-block">';
?>
		<table id="dnl">
			<tr>
				<td><img src="/src/install48.png" alt="Logo"></td>
<?php
				echo '<td style="min-width:160px;">Download<br>Version '.$version.' (beta)</td>';
?>
			</tr>
		</table>
	</a>
	</div>
<?php
	date_default_timezone_set("America/New_York"); // EST vs EDT time => EST with Daylight Savings Time
	$timetype = date("I")?"EDT":"EST";
	echo '<div id="info"><p>Last updated: '.date("F jS, Y H:i:s",filemtime($file)).' ('.$timetype.')</p>';
	echo '<p><b>MD5: '.md5_file($file).'<br>SHA-1: '.sha1_file($file).'</b></p></div>';
?>
	<br><br>
	<hr>
		<div id="footer">
			<a href="/">ASPDM Homepage</a> - <a href="/client/archive.php">Download Archive</a>
		</div>
</div>
</body>
</html>

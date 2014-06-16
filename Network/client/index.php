<?php
	include '../lib/utils.php';
?>
<html>
<head>
<title>Client | ASPDM</title>
<style>
	body {
		font-family:Arial,sans-serif;
		text-align:center;
		margin:auto;
	}
	table { text-align:center;vertical-align:middle; }
	#dnl{
		border: solid 1px;
		border-radius: 4px;
		font-size:12px;
		background-color:#E5E5E5;
	}
	#dnl td { vertical-align:middle;text-align:center; }
	#content { margin-top:200px; }
	#sp { margin:auto;text-align:center;width:300px; }
	a:active { position:relative;top:1px; }
	#info { font-size:10px;color:#666; }
</style>
</head>
<body>
<div id="content">
<?php
	echo '<h1>ASPDM : Package Manager - Preview</h1><hr><br><br>';
	
	$version = iniget("update.ini","version");
	echo '<div id="sp">';
	$file = 'ASPDM_Install-v'.$version.'.exe';
	echo '<a href="'.$file.'" id="link">';
?>
		<table id="dnl">
			<tr>
				<td><img src="/src/install48.png" alt="Logo"></td>
<?php
				echo '<td>Click here to download the preview release.<br>[Version: '.$version.']</td>';
?>
			</tr>
		</table>
	</a>
	</div>
<?php
	date_default_timezone_set("America/New_York"); // EST vs EDT time => EST with Daylight Savings Time
	echo '<div id="info"><p>Last updated: '.date("F jS, Y H:i:s",filemtime($file)).' (UTC-05:00).</p>';
	echo '<p><b>MD5: '.md5_file($file).'<br>SHA-1: '.sha1_file($file).'</b></p></div>';
?>
	<br><br>
	<hr><a href="/">Click here for the homepage.</a>
</div>
</body>
</html>
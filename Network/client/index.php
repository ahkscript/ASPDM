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
</style>
</head>
<body>
<div id="content">
<?php
	echo '<h1>ASPDM : Package Manager - Preview</h1><hr><br><br>';
	
	$version = iniget("update.ini","version");
	echo '<div id="sp">';
	echo '<a href="ASPDM_Install-v'.$version.'.exe" id="link">';
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
	
	<br><br>
	<hr><a href="/">Click here for the homepage.</a>
<div>
</body>
</html>
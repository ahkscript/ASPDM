<?php
	include '../lib/utils.php';
?>
<html>
<head>
<title>Client | ASPDM</title>
<script src="/src/sorttable.js"></script>
<style>
	html, body {
		font-family:Helvetica,Arial,sans-serif;
		text-align:center;
		margin:auto;
	}
	#content { margin-top:48px; }
	a:active { position:relative;top:1px; }
	h1 a { color:black; }
	a { color:#0088cc;text-decoration:none; }
	#logo {
		height:48px;
		width:48px;
		vertical-align:middle;
	}
	h1 { font-size:24px; }
	h1, h4 { margin:4px; }
	hr { border: #666 solid;border-width: 1px 0 0;width:800px; }
	#footer { font-size:10px; }
	#footer a:hover { text-decoration:underline; }
	#list { margin:auto;font-family:Consolas,Courier New,Courier,serif;font-size:12px;width:780px; }
	#list td { padding:4px; }
	#list thead { color:blue;text-decoration:underline;cursor:pointer; }
	.hash { font-size:11px }
</style>
</head>
<body>
<div id="content">
	<h1>
		<a id="logolink" href="/">
			<img src="/src/ahk.png" id="logo"> ASPDM : Package Manager
			</a>
	</h1>
	<h4>Download archive</h4>
	<hr><br>
	<table id="list" class="sortable">
	<?php
		date_default_timezone_set("America/New_York"); // EST vs EDT time => EST with Daylight Savings Time
		$timetype = date("I")?"EDT":"EST";
		if (isset($_REQUEST["hash"]) || isset($_REQUEST["checksum"])) {
			$hash = 1;
			echo '<thead><tr><td>File</td><td>Last modified '.'('.$timetype.')'.'</td><td>Size</td><td>Checksum</td></tr></thead>';
		} else {
			$hash = 0;
			echo '<thead><tr><td>File</td><td>Last modified '.'('.$timetype.')'.'</td><td>Size</td></tr></thead>';
		}
	?>
		<tbody>
			<?php
			$i = 0;
			if ($hash)
				foreach (glob("*.{exe,zip}",GLOB_BRACE) as $file) {
					echo '<tr><td><a href="'.$file.'">'.$file.'</a></td><td>'.date("Y-m-d H:i",filemtime($file)).'</td><td>'.formatSizeUnits(filesize($file)).'</td><td><b class="hash">[ MD5 ] '.md5_file($file).'<br>[SHA-1] '.sha1_file($file).'</b></td></tr>';
					$i = $i + 1;
				}
			else
				foreach (glob("*.{exe,zip}",GLOB_BRACE) as $file) {
					echo '<tr><td><a href="'.$file.'">'.$file.'</a></td><td>'.date("Y-m-d H:i",filemtime($file)).'</td><td>'.formatSizeUnits(filesize($file)).'</td></tr>';
					$i = $i + 1;
				}
			if (!$i)
				if ($hash)
					echo '<tr><td><a href="#">-</a></td><td>-</td><td>-</td><td>-</td></tr>';
				else
					echo '<tr><td><a href="#">-</a></td><td>-</td><td>-</td></tr>';
			?>
		</tbody>
	</table>
	<br>
	<hr>
		<div id="footer">
			<a href="/">ASPDM Homepage</a> - <a href="/client">Download Client</a>&nbsp;-&nbsp;
			<?php
				if ($hash)
					echo '<a href="/client/archive.php">Hide Checksums</a>';
				else
					echo '<a href="/client/archive.php?hash">Show Checksums</a>';
			?>
		</div>
</div>
</body>
</html>
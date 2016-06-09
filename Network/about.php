<?php include 'header.php'; ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Forked Web Design from here: http://win32.libav.org/win64/ -->

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>About | ASPDM</title>

		<meta content="text/html; charset=utf-8" http-equiv="Content-Type"/>
		<meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=0.6"/>
		<link type="image/png" href="src/ahk.png" rel="icon"/>
		<link rel="stylesheet" href="src/font-awesome-4.0.3/css/font-awesome.min.css"/>
		<link type="text/css"  href="src/bootstrap.css" rel="stylesheet"/>
		<link type="text/css"  href="src/style.css" rel="stylesheet"/>

	</head>

	<body>
		<div class="container">
			<h1><a href="/" id="logolink"><img id="logo" src="src/ahk.png"> ASPDM - AHKScript.org's Package/StdLib Distribution and Management</a></h1>
			<div id="body">

			<div id="headerlinks">
				<?php include 'navmenu.php'; ?>
			</div>

			<h2>About ASPDM</h2>
			<div>
				<b>ASPDM</b> stands for <a href="http://ahkscript.org/"><b>AHKScript.org</b></a>'s Package/StdLib Distribution and Management. It is meant to provide an easy and practical way to install libraries and tools written for and in the <a href="http://autohotkey.com">AutoHotkey</a> scripting language. It is recommended to read the <a href="https://github.com/ahkscript/ASPDM/blob/master/Specifications/Guidelines.md">official guidelines</a> and <a href="https://github.com/ahkscript/ASPDM/tree/master/Specifications">other specifications</a> prior to releasing packages for the ASPDM package manager. The ASPDM local client is entirely written in AutoHotkey itself and requires AutoHotkey v1.1.13.00+ to be installed (older versions and v2+ are not officially supported). ASPDM also aims to standardise the organisation of community-shared scripts and libraries: to create a "defacto"/official <i>Standard Library</i> (or known as "StdLib"). The ASPDM code itself is released under the MIT/ADPL(?) License. If you would like to contribute to this project, you may do so through many ways such as reporting bugs, providing code improvements or even discuss ideas on either our <a href="https://github.com/ahkscript/ASPDM/issues">GitHub repository</a>, <a href="https://trello.com/b/XVP4M76d">Trello board</a> or <a href="http://ahkscript.org/boards/viewtopic.php?f=6&t=1241">Forum topic</a>.
			</div>

			<h3>Credits</h3>
			<div>
				Thanks to the whole AutoHotKey team and its contributors, and especially to @george2, @perfaram, @fincs, and @joedf, who worked on the ASPDM project!
			</div>
			<hr class="max">

			<h1>Notice</h1>
				<h4>Content terms and conditions</h4>
				<p>
				Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at scelerisque magna, sed hendrerit enim. Aliquam interdum, felis non euismod dignissim, arcu nisi eleifend enim, sed mollis sem sem quis sem. Donec in iaculis quam, sed pretium quam. Donec congue, nunc vitae elementum tempus, nibh neque scelerisque ante, at tempus lacus augue convallis dui. Maecenas vitae elit consequat, volutpat nisl nec, mollis mi. Curabitur non tellus ut enim tristique commodo. Nulla pulvinar tellus augue, eget auctor est euismod nec. Maecenas vestibulum tortor at lacus aliquet, sed rhoncus leo elementum. Aliquam eleifend aliquet odio ut euismod. Morbi volutpat orci in ipsum facilisis, porttitor eleifend ipsum viverra. Nullam quis vehicula nisi.
				</p>
			</div>

			<?php include 'footer.php'; ?>

		</div>
	</body>
</html>

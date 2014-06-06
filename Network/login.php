<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Forked Web Design from here: http://win32.libav.org/win64/ -->

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
		<meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=0.6">
		<title>Login | ASPDM</title>
		<link type="image/png" href="src/ahk.png" rel="icon">
		<link rel="stylesheet" href="src/font-awesome-4.0.3/css/font-awesome.min.css">
		<link type="text/css"  href="src/bootstrap.css" rel="stylesheet">
		<script src="src/sorttable.js"></script>
		<script src="src/ValidateForm.js"></script>
		<link type="text/css"  href="src/style.css" rel="stylesheet">
		
		<script type="text/javascript">
			function remember_me_tip(x) {
				if (x)
					document.getElementById("rememberme_notice").style.display = "block";
				else
					document.getElementById("rememberme_notice").style.display = "none";
			}
		</script>
		
	</head>

	<body>
		<div class="container">
			<h1><a href="http://ahkscript.org" id="logolink"><img id="logo" src="src/ahk.png"></a> ASPDM - AHKScript.org's Package/StdLib Distribution and Management</h1>
			<div id="body">

				<div id="headerlinks">
					<a href="index.php">List Packages</a>
					<a href="submit.html">Submit Package</a>
					<a href="about.html">About ASPDM</a>
				</div>

			<h2>Log in with an AHKScript.org account</h2>
			
			<div style="position:absolute;top:72px;right:0;display:block;z-index:99;font-size:36px;color:rgba(128,128,128,0.7);transform:rotate(45deg);-ms-transform:rotate(45deg);-webkit-transform:rotate(45deg);">PREVIEW</div>
			
			<div class="center" style="width:340px;">
				<form action="p_login.php" method="post">
					<h4>Enter your account info:</h4>
					<?php
					if(isset($_GET["i"])) {
						$i = strtolower($_GET["i"]);
						if ($i === "u")
							echo "<div class=\"fullw\" style=\"color:red;font-weight:bold\">User not found.</div>";
						if ($i === "p")
							echo "<div class=\"fullw\" style=\"color:red;font-weight:bold\">Incorrect password.</div>";
						if ($i === "n")
							echo "<div class=\"fullw\" style=\"color:red;font-weight:bold\">Please write your login information.</div>";
					}
					?>
						<!--
						<div class="fullw">
							User Name: <input type="text" name="username" placeholder="Username"></div>
						<div class="fullw">
							&nbsp;Password: <input type="password" name="password" placeholder="********"></div> -->
						
						<table class="form">
							<tr>
								<td style="text-align:right">User Name:</td>
								<td><input type="text" name="username" placeholder="Username" 
									<?php if(isset($_GET["u"])) {echo "value=\"" . strtolower($_GET["u"]) . "\"";} ?> ></td>
							</tr>
							<tr>
								<td style="text-align:right">Password:</td>
								<td><input type="password" name="password" placeholder="********"></td>
							</tr>
						</table>
							
							
						<div class="fullw" style="height:32px;">
							<div onmouseover="remember_me_tip(1)" onmouseout="remember_me_tip(0)">
								<label><input type="checkbox" name="remember" value="yes"> Remember me</label>
							</div>
							<div id="rememberme_notice" class="infobox" style="display:none;" onmouseover="remember_me_tip(0)">
								Remember my login session for <b>two weeks</b> so that I can come back without logging in.
							</div>
						</div>
					<input type="Submit" value="Sign In" class="big" onclick="return ValidateForm(this.form)">
				</form>
				<div class="infobox" style="margin-top:16px;display:block">
					<a href="http://ahkscript.org/boards/ucp.php?mode=sendpassword">Forgot your password?</a><br>
					<br>Need an account on AHKScript.org?
					<br><a href="http://ahkscript.org/boards/ucp.php?mode=register">Create Account</a>
				</div>
			</div>
				<hr class="max">

			<h1>Notice</h1>
				<h4>Content terms and conditions </h4>
				<p>
				Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at scelerisque magna, sed hendrerit enim. Aliquam interdum, felis non euismod dignissim, arcu nisi eleifend enim, sed mollis sem sem quis sem. Donec in iaculis quam, sed pretium quam. Donec congue, nunc vitae elementum tempus, nibh neque scelerisque ante, at tempus lacus augue convallis dui. Maecenas vitae elit consequat, volutpat nisl nec, mollis mi. Curabitur non tellus ut enim tristique commodo. Nulla pulvinar tellus augue, eget auctor est euismod nec. Maecenas vestibulum tortor at lacus aliquet, sed rhoncus leo elementum. Aliquam eleifend aliquet odio ut euismod. Morbi volutpat orci in ipsum facilisis, porttitor eleifend ipsum viverra. Nullam quis vehicula nisi.
				</p>
			</div>
			<div id="footer">
				<p>Hosted by <a href="http://www.2freehosting.com/"><img src="src/2fh_icon.png" alt="2FH"></a>
				-
				<a href="http://joedf.users.sourceforge.net/"> Joe DF</a>
				-
				Original Web Design from here: <a href="http://win32.libav.org/win64/">http://win32.libav.org/win64/</a>
				</p>
			</div>
		</div>
	</body>
</html>
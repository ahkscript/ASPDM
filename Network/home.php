<?php
//Start session
session_start();

//Check whether the session variable SESS_MEMBER_ID is present or not
if(!isset($_SESSION['sess_user_id']) || (trim($_SESSION['sess_user_id']) == '')) {
header("location: login.php");
exit();
}
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Forked Web Design from here: http://win32.libav.org/win64/ -->

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>User Home | ASPDM</title>
		
		<?php include 'header.php'; ?>
		
	</head>

	<body>
		<div class="container">
			<h1><a href="http://ahkscript.org" id="logolink"><img id="logo" src="src/ahk.png"></a> ASPDM - AHKScript.org's Package/StdLib Distribution and Management</h1>
			<div id="body">
			
			<div id="headerlinks">
				<?php include 'navmenu.php'; ?>
			</div>
			
			<h2>User Home</h2>
			<div>
				<h3>Welcome, <?php echo $_SESSION["sess_username"]; ?></h4>
				
				<div class="userhome">
					<div>
						<table>
							<tr><th><h4>Lorem Ipsum</h4></th><th><h4>Version</h4></th></tr>
							<tr><td>Package_AAAA.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_BBBB.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_CCCC.ahkp</td><td>[version: 1.0.0.0]</td></tr>
						</table>
					</div>
					<div>
						<table>
							<tr><th><h4>Lorem Ipsum</h4></th><th><h4>Version</h4></th></tr>
							<tr><td>Package_AAAA.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_BBBB.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_CCCC.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_DDDD.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_EEEE.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_FFFF.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_GGGG.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_HHHH.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_IIII.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_JJJJ.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_KKKK.ahkp</td><td>[version: 1.0.0.0]</td></tr>
						</table>
					</div>
					<div>
						<table>
							<tr><th><h4>Lorem Ipsum</h4></th><th><h4>Version</h4></th></tr>
							<tr><td>Package_AAAA.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_BBBB.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_CCCC.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_DDDD.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_EEEE.ahkp</td><td>[version: 1.0.0.0]</td></tr>
							<tr><td>Package_FFFF.ahkp</td><td>[version: 1.0.0.0]</td></tr>
						</table>
					</div>
			</div>
			<hr class="max">

			<h1>Notice</h1>
				<h4>Content terms and conditions </h4>
				<p>
				Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at scelerisque magna, sed hendrerit enim. Aliquam interdum, felis non euismod dignissim, arcu nisi eleifend enim, sed mollis sem sem quis sem. Donec in iaculis quam, sed pretium quam. Donec congue, nunc vitae elementum tempus, nibh neque scelerisque ante, at tempus lacus augue convallis dui. Maecenas vitae elit consequat, volutpat nisl nec, mollis mi. Curabitur non tellus ut enim tristique commodo. Nulla pulvinar tellus augue, eget auctor est euismod nec. Maecenas vestibulum tortor at lacus aliquet, sed rhoncus leo elementum. Aliquam eleifend aliquet odio ut euismod. Morbi volutpat orci in ipsum facilisis, porttitor eleifend ipsum viverra. Nullam quis vehicula nisi.
				</p>
			</div>
			
			<?php include 'footer.php'; ?>
			
		</div>
	</body>
</html>
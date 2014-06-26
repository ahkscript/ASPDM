<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Forked Web Design from here: http://win32.libav.org/win64/ -->

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>User Home | ASPDM</title>
		
		<?php include 'header.php'; ?>
		
	</head>

	<body>
		<div class="container">
			<h1><a href="/" id="logolink"><img id="logo" src="src/ahk.png"> ASPDM - AHKScript.org's Package/StdLib Distribution and Management</h1></a>
			<div id="body">
			
			<div id="headerlinks">
				<?php include 'navmenu.php'; ?>
			</div>
			
			<h2>User Home</h2>
			<div>
				<h3>Welcome, <?php echo $_SESSION["sess_username"]; ?></h4>
				
				<div class="userhome">
					<?php
						include 'lib/db_info.php';
						$conn = mysql_connect($DB_HOST, $DB_USER, $DB_PASS);
						mysql_select_db($DB_NAME, $conn);
						$username = mysql_real_escape_string($_SESSION["sess_username"]);
						$query = "SELECT usertype, email, packs, userurl
						FROM users
						WHERE username = '$username';";
						$result = mysql_query($query);
						if(mysql_num_rows($result) == 0) { // User not found. redirect to login form...
							header('Location: login.php?i=u');
							exit();
						}
						$info = mysql_fetch_array($result, MYSQL_ASSOC);
					?>
					<div class="table" style="display:block;margin: 16px auto;">
						<table>
							<tr><th colspan="2">Account Information</th></tr>
							<tr><td>Rank:</td><td><?php echo $info["usertype"]; ?></td></tr>
							<tr><td>Email:</td><td><a href="mailto:<?php echo $info["email"]; ?>"><?php echo $info["email"]; ?></a></td></tr>
							<tr><td>URL:</td><td><a href="<?php echo $info["userurl"]; ?>"><?php echo $info["userurl"]; ?></a></td></tr>
						</table>
					</div>
					<div class="table">
						<table>
							<tr><th><h4>Submitted Packages</h4></th><th><h4>Version</h4></th></tr>
							<?php
							if (!function_exists("get_metadata"))
								include 'lib/utils.php';
							
							if (strlen($info["packs"])==0)
								echo '<tr><td>None</td><td>-</td></tr>';
							else {
								$sp_t = strtok($info["packs"], ";");
								while ($sp_t != false) {
									$sp_f = $sp_t.'.ahkp';
									$sp_d = get_metadata($sp_f);
									if (is_object($sp_d))
										echo '<tr><td><a href="/dl_file.php?f='.$sp_f.'">'.$sp_f.'</a></td><td>'.($sp_d->version).'</td></tr>';
									else
										echo '<tr><td><a href="/dl_file.php?f='.$sp_f.'">'.$sp_f.'</a></td><td>ERROR</td></tr>';
									$sp_t = strtok(";");
								}
							}
							?>
						</table>
					</div>
					<div class="table" style="width:64%">
						<table>
							<tr><th><h4>Pending packages</h4></th><th><h4>File</h4></th><th><h4>Version</h4></th></tr>
							<?php
							$username_tmp = safe_var($_SESSION['sess_username']);
							$pending_user_tmpdir = './packs/tmp/'.$username_tmp;
							
							if (!file_exists($pending_user_tmpdir))
								mkdir($pending_user_tmpdir);
							
							if ($handle = opendir($pending_user_tmpdir)) {
								$_tmpcount = 0;
								while (false !== ($entry = readdir($handle))) {
									if ($entry != "." && $entry != "..") {
										$_tmpdata = get_metadata($pending_user_tmpdir.'/'.$entry,0,1);
										
										if (is_object($_tmpdata))
											echo '<tr><td>'.($_tmpdata->id).'.ahkp</td><td><a href="/dl_file.php?f='.$entry.'&tmp='.$username_tmp.'">'.$entry.'</a></td><td>'.($_tmpdata->version).'</td></tr>';
										else
											echo '<tr><td>ERROR: get_metadata</td><td>-</td><td>-</td></tr>';
											
										$_tmpcount+=1;
									}
								}
								if (!$_tmpcount)
									echo '<tr><td>None</td><td>-</td><td>-</td></tr>';
								closedir($handle);
							} else {
								echo '<tr><td>ERROR: opendir</td><td>-</td><td>-</td></tr>';
							}
							?>
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
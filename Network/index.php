<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Forked Web Design from here: http://win32.libav.org/win64/ -->

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
		<meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=0.6">
		<title>ASPDM - AHKScript.org's Package/StdLib Distribution and Management</title>
		<link type="image/png" href="src/ahk.png" rel="icon">
		<link rel="stylesheet" href="src/font-awesome-4.0.3/css/font-awesome.min.css">
		<link type="text/css"  href="src/bootstrap.css" rel="stylesheet">
		<link type="text/css"  href="src/bootstrap_buttons.min.css" rel="stylesheet">
		<link type="text/css"  href="src/bootstrap_buttons-theme.min.css" rel="stylesheet">
		<script src="src/jquery-1.11.0.min.js"></script>
		<script src="src/sorttable.js"></script>
		<link type="text/css"  href="src/style.css" rel="stylesheet">
        <link type="text/css"  href="src/modal.css" rel="stylesheet">
        <script>
			function openDialog(modal) {
				Avgrund.show( "#"+modal );
			}
			function closeDialog() {
				Avgrund.hide();
			}
		</script>
		<style>
			/* Special Modal "anti-body-scroll" trick
			 * See here:  http://coding.abel.nu/2013/02/prevent-page-behind-jquery-ui-dialog-from-scrolling */
			#full_wrapper { overflow-y:scroll;height:100%; }
			html, body { margin:0;overflow:hidden;height:100%; }
			
			/* Align webpage height, Weird... caused by avgrund? */
			.container { margin-top:0 !important; }
		
			/* Extra popup styling */
			.avgrund-popup p { margin: 0 0 4px; }
			.avgrund-popup .close { position: absolute; right: 8px; top: 4px; }
			.avgrund-popup .description { margin-top: 8px !important; height:184px; line-height: 17px; }
			.dialog_button { display: inline-block !important; }
			.avgrund-popup .packname { margin-bottom: -6px; }
			.avgrund-popup th, .avgrund-popup td { padding-left: 8px; }
			
			.avgrund-popup .h {
				display: inline-block;
				/* margin-left: 4px; */
				vertical-align: middle;
				max-width: 456px;
			}
			.btn-download, .btn-install {
				float: right;
				margin-right: 4px;
				position: relative;
				top: 18px;
			}
			.setup-btns {
				position: absolute;
				display: inline;
				right: 20px;
			}
			
			.avgrund-popup .h h3 {
				line-height: 16px;
				display: inline-block;
			}
			.avgrund-popup .h .hsub {
				position: relative;
				top: -16px;
				font-size:11px;
				display:block
			}
			.avgrund-popup table {
				margin: 0;
				font-size: 11px;
			}
			.avgrund-popup th {
				color: #FEFEFE;
				background-color: #1691BE !important;
			}
			.avgrund-popup td {
				border-top: 1px solid #DDDDDD;
				border-bottom: 1px solid #DDDDDD;
			}
			
			/* avgrund has bugs... this is a temp bugfix */
			.avgrund-popup-animate { z-index: 99; }
		</style>
	</head>

	<body>
	<div id="full_wrapper">
    <?php
		include 'lib/utils.php';
	
    $num = 0;
	if ($handled = opendir('packs')) {
		while (false !== ($entry = readdir($handled))) {
			if ($entry != "." && $entry != ".." && $entry != "tmp") {
                if (pathinfo($entry, PATHINFO_EXTENSION)=='ahkp'){
                    $file = "packs/" . str_replace("./","",$entry);
                    $handle = fopen($file, "r");
                    fseek($handle,8);
                    $size = fread_UINT($handle);
                    $jsondata = fread($handle,$size);

                    //$date = date('Y-m-d H:i', filectime($file));
                    $date = filemtime($file);
                    $date = date('Y-m-d H:i', $date);
                    
                    $obj = json_decode($jsondata);
                    $j_author = $obj->author;
                    $j_name = $obj->name;
                    $j_id = $obj->id;
                    $j_type = $obj->type;
					
					$h_forumurl = $obj->forumurl;
                    $h_forumurl = (strlen($h_forumurl))?(" (<a href=\"" . $h_forumurl . "\">View forum topic</a>)"):"";
					
					$j_tags = json_encode($obj->tags);
                    $j_tags = ($j_tags==="{}")?"None":substr($j_tags,1,-1);
                    $j_tags = str_replace('"', '', $j_tags);
                    $j_tags = str_replace(',', ', ', $j_tags);
					
					$j_required = json_encode($obj->required);
                    $j_required = ($j_required==="{}")?"None":substr($j_required,1,-1);
                    $j_required = str_replace('"', '', $j_required);
                    $j_required = str_replace(',', ', ', $j_required);
					
                    $j_description = html_linefmt($obj->description);
                    $j_description = (strlen($j_description))?$j_description:"No description.";
					
                    $j_size = formatSizeUnits(filesize($file));
					
					$a_license = html_licensefmt($obj->license);
    ?>
    	<aside id="<?=$j_id?>" class="avgrund-popup">
			<button type="button" class="close" aria-hidden="true" onclick="closeDialog()">&times;</button>
			
			<div class="packname">
				<div class="h"><h3><?=$j_name?></h3><span class="hsub">by <?=$j_author?><?=$h_forumurl?></span></div>
				<div class="setup-btns">
					
					<!-- PHP Download script necessary for compatibility with all browsers, especially IE... -->
					<a href="/dl_file.php?f=<?=$j_id?>.ahkp" class="btn btn-sm btn-success dialog_button btn-download" type="button">Download</a>

					<a href="aspdm://<?=$j_id?>.ahkp" class="btn btn-sm btn-primary dialog_button btn-install" type="button">Install</a>
				</div>
			</div>
			
			<table class="sortable">
				<tr><th colspan="2">Information</th><tr>
				<tr><td>Type              : </td><td><?=$j_type?></td></tr>
				<tr><td>Tags              : </td><td><?=$j_tags?></td></tr>
				<tr><td>Size              : </td><td><?=$j_size?></td></tr>
				<tr><td class="important">Required Packages : </td><td><?=$j_required?></td></tr>
				<tr><td class="important_blue">License : </td><td><?=$a_license?></td></tr>
			</table>
            <p class="description"><?=$j_description?></p>
		</aside>
    <?php
                    $num=$num+1;
                }
			}
		}
		closedir($handled);
	};
	?>
        
		<div class="container">
			
			<h1><a href="http://ahkscript.org" id="logolink"><img id="logo" src="src/ahk.png"></a> ASPDM - AHKScript.org's Package/StdLib Distribution and Management</h1>
			<div id="body">

				<div id="headerlinks">
					<a href="home.php">Sign In/Out</a>
					<a href="submit.html">Submit Package</a>
					<a href="about.html">About ASPDM</a>
				</div>
				
			<h2>Latest AutoHotkey packages</h2>
			<div class="file-listing">
				<table class="sortable">
                <tr><th>Type</th><th id="th01a">Name</th><th>Options</th><th>Maintainer</th><th>Last modified</th><th>Size</th></tr>
<?php	
    $num = 0;
	if ($handled = opendir('packs')) {
		while (false !== ($entry = readdir($handled))) {
			if ($entry != "." && $entry != ".." && $entry != "tmp") {
                if (pathinfo($entry, PATHINFO_EXTENSION)=='ahkp'){
                    $file = "packs/" . str_replace("./","",$entry);
                    $handle = fopen($file, "r");
                    fseek($handle,8);
                    $size = fread_UINT($handle);
                    $jsondata = fread($handle,$size);

                    //$date = date('Y-m-d H:i', filectime($file));
                    $date = filemtime($file);
                    $date = date('Y-m-d H:i', $date);
                    
                    $obj = json_decode($jsondata);
                    $j_author = $obj->author;
                    $j_name = $obj->name;
                    $j_id = $obj->id;
                    $j_type = $obj->type;
                    $j_size = formatSizeUnits(filesize($file));
					
					$j_forum = $obj->forumurl;
                    $j_forum = (strlen($j_forum))?$j_forum:"#";
    ?>
    					<tr><td><a href="#"><?=$j_type?></a></td>
                        <td><a href="#" onclick="javascript:openDialog('<?=$j_id?>');"><?=$j_name?></a></td>
						<td align="right">
							<a href="#" onclick="javascript:openDialog('<?=$j_id?>');" title="Information"><i class="fa fa-info-circle"></i></a>
							<a href="<?=$j_forum?>" title="Forum"><i class="fa fa-comments"></i></a>
							<!-- PHP Download script necessary for compatibility with all browsers, especially IE... -->
							<a href="/dl_file.php?f=<?=$j_id?>.ahkp" title="Download"><i class="fa fa-cloud-download"></i></a></td>
						<td align="right"><a href="#"><?=$j_author?></a></td>
						<td align="right"><?=$date?></td>
						<td align="right"><?=$j_size?></td></tr>
    <?php
                    $num=$num+1;
                }
			}
		}
		closedir($handled);
	};
?>
                </table>
				<hr class="max">
			</div>

				<h1>Notice</h1>
				<h4>Package terms and conditions </h4>
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
		<div class="avgrund-cover"></div>
	<script type="text/javascript" src="src/modal.js"></script>
	</div>
	</body>
</html>

﻿<?php
	function html_linefmt($str) {
		$order   = array("\r\n", "\n", "\r");
		$replace = '<br />';
		// Processes \r\n's first so they aren't converted twice.
		return str_replace($order, $replace, $str);
	}
	
	function html_licensefmt($str) {
		$str = trim($str);
		if ( (strlen($str)<2) || (stristr($str,"ASPDM")) )
			return "<a href=\"https://github.com/ahkscript/ASPDM/blob/master/Specifications/License.md\">ASPDM Default License</a>";
		if (stristr($str,"MIT"))
			return "<a href=\"http://opensource.org/licenses/MIT\">" . $str . "</a>";
		if (stristr($str,"BSD"))
			if (stristr($str,"2"))
				return "<a href=\"http://opensource.org/licenses/BSD-2-Clause\">" . $str . "</a>";
			else
				return "<a href=\"http://opensource.org/licenses/BSD-3-Clause\">" . $str . "</a>";
		if (stristr($str,"LGPL"))
			return "<a href=\"http://opensource.org/licenses/lgpl-license\">" . $str . "</a>";
		if (stristr($str,"GPL"))
			return "<a href=\"http://opensource.org/licenses/gpl-license\">" . $str . "</a>";
		if (stristr($str,"Apache"))
			return "<a href=\"http://opensource.org/licenses/Apache-2.0\">" . $str . "</a>";
		if (stristr($str,"MPL") || stristr($str,"Mozilla"))
			return "<a href=\"http://opensource.org/licenses/MPL-2.0\">" . $str . "</a>";
		if (stristr($str,"CC0"))
			return "<a href=\"http://creativecommons.org/publicdomain/zero/1.0\">" . $str . "</a>";
		if ( (stristr($str,"CC")) || (stristr($str,"creative")) || (stristr($str,"commons")) )
			return "<a href=\"http://creativecommons.org/licenses\">" . $str . "</a>";
		return $str;
	}
?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<!-- Forked Web Design from here: http://win32.libav.org/win64/ -->

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta content="text/html; charset=utf-8" http-equiv="Content-Type">
		<meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=0.6">
		<title>ahkscript.org - Package/StdLib Distribution and Management</title>
		<link type="image/png" href="src/ahk.png" rel="icon">
		<link rel="stylesheet" href="src/font-awesome-4.0.3/css/font-awesome.min.css">
		<link type="text/css"  href="src/bootstrap.css" rel="stylesheet">
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
	</head>

	<body>
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
                    $j_category = $obj->category;
                    $j_description = $obj->description;
                    $j_size = formatSizeUnits(filesize($file));
    ?>
    	<aside id="<?=$j_id?>" class="avgrund-popup">
			<h3><?=$j_name?></h3>
			<p>Author/Maintainer : <?=$j_author?></p>
            <p>Type              : <?=$j_type?></p>
            <p>Category          : <?=$j_category?></p>
            <p>Size              : <?=$j_size?></p>
            <p><?=$j_description?></p>
<!--<button style:"text-align: right;" onclick="javascript:closeDialog();">Close</button>-->
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
			
			<h1><a href="http://ahkscript.org" id="logolink"><img id="logo" src="src/ahk.png"></a> ahkscript.org - Package/StdLib Distribution and Management</h1>
			<div id="body">

				<div id="headerlinks">
					<a href="login.html">Sign In/Out</a>
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
    ?>
    					<tr><td><a href="#"><?=$j_type?></a></td>
                        <td><a href="#" onclick="javascript:openDialog('<?=$j_id?>');"><?=$j_name?></a></td>
						<td align="right">
							<a href="#" onclick="javascript:openDialog('<?=$j_id?>');" title="Information"><i class="fa fa-info-circle"></i></a>
							<a href="#" title="License"><i class="fa fa-file"></i></a>
							<a href="<?=$file?>" title="Download"><i class="fa fa-cloud-download"></i></a></td>
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
				<p>Hosted by <a href="http://github.com">GitHub</a>
				-
				<a href="http://joedf.users.sourceforge.net/"> Joe DF</a>
				-
				Original Web Design from here: <a href="http://win32.libav.org/win64/">http://win32.libav.org/win64/</a>
				</p>
			</div>
		</div>
		<div class="avgrund-cover"></div>
<script type="text/javascript" src="src/modal.js"></script>
	</body>
</html>
﻿<?php
	function print_metadata($file,$content_item) {
		if ($file == NULL) {
			echo "ERROR: Invalid parameters";
			return 0;
		}
		$file = "packs/" . str_replace("./","",$file);
		if (!file_exists($file)) {
			echo "ERROR: File does not exist.";
			return 0;
		}
		$handle = fopen($file, "r");
		fseek($handle,8);
		$size = fread_UINT($handle);
		if ($content_item==NULL){
            $jsondata = fread($handle,$size);
			echo $jsondata;
        } else {
			$obj = json_decode(fread($handle,$size));
			$j_item = $obj->$content_item;
			if (!strlen($j_item))
				echo "ERROR: json item non-existent";
			else
				echo $j_item;
		}
		return $jsondata;
	}
	
	function fread_UINT($handle) {
		$bytes = strrev(fread($handle,4));
		$size = "0x";
		for ($i = 0; $i < 4; $i++) {
			$v = dechex(ord($bytes[$i]));
			if (strlen($v)==1)
				$v = "0" . $v;
			$size = $size . $v;
		}
		return hexdec($size);
	}

    function formatSizeUnits($bytes)
        {
            if ($bytes >= 1073741824)
            {
                $bytes = number_format($bytes / 1073741824, 2) . ' GB';
            }
            elseif ($bytes >= 1048576)
            {
                $bytes = number_format($bytes / 1048576, 2) . ' MB';
            }
            elseif ($bytes >= 1024)
            {
                $bytes = number_format($bytes / 1024, 2) . ' KB';
            }
            elseif ($bytes > 1)
            {
                $bytes = $bytes . ' bytes';
            }
            elseif ($bytes == 1)
            {
                $bytes = $bytes . ' byte';
            }
            else
            {
                $bytes = '0 bytes';
            }

            return $bytes;
    }
	
	//$f = (isset($_GET["f"])) ? htmlspecialchars($_GET["f"]) : NULL;
	//$c = (isset($_GET["c"])) ? htmlspecialchars($_GET["c"]) : NULL;
	//print_metadata($f,$c);
?>
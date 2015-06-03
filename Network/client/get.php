<?php
	include '../lib/utils.php';
	
	//see: http://www.media-division.com/the-right-way-to-handle-file-downloads-in-php/

	//- turn off compression on the server
	if (function_exists("apache_setenv"))
		@apache_setenv('no-gzip', 1);
	@ini_set('zlib.output_compression', 'Off');

	if(!isset($_REQUEST['v']) || empty($_REQUEST['v'])) {
		$version = iniget("update.ini","version");
	} else {
		$path_parts = pathinfo($_REQUEST['v']);
		$version = strtolower($path_parts['basename']); //safety
	}
	
	// get filename
	$file = 'ASPDM_Install-v'.$version.'.exe';

	// make sure the file exists
	if (is_file($file)) {
		header("Content-type: application/octet-stream"); //Invalid, but Firefox seems to be affected by this...
		header('Content-Description: File Transfer');
		header("Content-Disposition: attachment; filename=\"$file\"");
		header("Pragma: public");
		header('Expires: 0');
		header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
		header('Content-Length: ' . filesize($file));
		ob_clean();
		flush();
		if (!readfile($file)) { // files should be smaller than 5 MB
			// file couldn't be opened
			print(file_get_contents('http://'.$_SERVER['HTTP_HOST'].'/error_docs/500.html'));
			exit;
		}
	} else {
		// file does not exist
		print(file_get_contents('http://'.$_SERVER['HTTP_HOST'].'/error_docs/404.html'));
		exit;
	}
?>
<?php
	//see: http://www.media-division.com/the-right-way-to-handle-file-downloads-in-php/

	//- turn off compression on the server
	@apache_setenv('no-gzip', 1);
	@ini_set('zlib.output_compression', 'Off');

	if(!isset($_REQUEST['f']) || empty($_REQUEST['f'])) {
		//header("HTTP/1.0 400 Bad Request");
		//header('Location: http://'.$_SERVER['HTTP_HOST'].'/error_docs/400.html');
		print(file_get_contents('http://'.$_SERVER['HTTP_HOST'].'/error_docs/400.html'));
		exit;
	}

	// get filename
	$path_parts = pathinfo($_REQUEST['f']);
	$pack = $path_parts['basename'];
	$file = "packs/".strtolower($pack);

	// make sure the file exists
	if (is_file($file)) {
		header("Content-type: application/octet-stream"); //Invalid, but Firefox seems to be affected by this...
		header('Content-Description: File Transfer');
		header("Content-Disposition: attachment; filename=\"$pack\"");
		header("Pragma: public");
		header('Expires: 0');
		header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
		header('Content-Length: ' . filesize($file));
		ob_clean();
		flush();
		if (!readfile($file)) { // packages are limited to 5 MB
			// file couldn't be opened
			//header("HTTP/1.0 500 Internal Server Error");
			//header('Location: http://'.$_SERVER['HTTP_HOST'].'/error_docs/500.html');
			print(file_get_contents('http://'.$_SERVER['HTTP_HOST'].'/error_docs/500.html'));
			exit;
		}
	} else {
		// file does not exist
		//header("HTTP/1.0 404 Not Found");
		//header('Location: http://'.$_SERVER['HTTP_HOST'].'/error_docs/404.html');
		print(file_get_contents('http://'.$_SERVER['HTTP_HOST'].'/error_docs/404.html'));
		exit;
	}
?>
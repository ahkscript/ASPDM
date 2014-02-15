<?php
// http://www.php.net/manual/en/features.file-upload.php#114004
// http://www.php.net/manual/en/function.mime-content-type.php#87856

//header('Content-Type: text/plain; charset=utf-8');

if(!function_exists('mime_content_type')) {

	function mime_content_type($filename) {

		$mime_types = array(

			'txt' => 'text/plain',
			'htm' => 'text/html',
			'html' => 'text/html',
			'php' => 'text/html',
			'css' => 'text/css',
			'js' => 'application/javascript',
			'json' => 'application/json',
			'xml' => 'application/xml',
			'swf' => 'application/x-shockwave-flash',
			'flv' => 'video/x-flv',

			// images
			'png' => 'image/png',
			'jpe' => 'image/jpeg',
			'jpeg' => 'image/jpeg',
			'jpg' => 'image/jpeg',
			'gif' => 'image/gif',
			'bmp' => 'image/bmp',
			'ico' => 'image/vnd.microsoft.icon',
			'tiff' => 'image/tiff',
			'tif' => 'image/tiff',
			'svg' => 'image/svg+xml',
			'svgz' => 'image/svg+xml',

			// archives
			'zip' => 'application/zip',
			'rar' => 'application/x-rar-compressed',
			'exe' => 'application/x-msdownload',
			'msi' => 'application/x-msdownload',
			'cab' => 'application/vnd.ms-cab-compressed',

			// audio/video
			'mp3' => 'audio/mpeg',
			'qt' => 'video/quicktime',
			'mov' => 'video/quicktime',

			// adobe
			'pdf' => 'application/pdf',
			'psd' => 'image/vnd.adobe.photoshop',
			'ai' => 'application/postscript',
			'eps' => 'application/postscript',
			'ps' => 'application/postscript',

			// ms office
			'doc' => 'application/msword',
			'rtf' => 'application/rtf',
			'xls' => 'application/vnd.ms-excel',
			'ppt' => 'application/vnd.ms-powerpoint',

			// open office
			'odt' => 'application/vnd.oasis.opendocument.text',
			'ods' => 'application/vnd.oasis.opendocument.spreadsheet',
		);

		$ext = pathinfo($filename, PATHINFO_EXTENSION);
		if (array_key_exists($ext, $mime_types)) {
			return $mime_types[$ext];
		}
		elseif (function_exists('finfo_open')) {
			$finfo = finfo_open(FILEINFO_MIME);
			$mimetype = finfo_file($finfo, $filename);
			finfo_close($finfo);
			return $mimetype;
		}
		else {
			return 'application/octet-stream';
		}
	}
}

try {
	
	// Undefined | Multiple Files | $_FILES Corruption Attack
	// If this request falls under any of them, treat it invalid.
	if (
		!isset($_FILES['file']['error']) ||
		is_array($_FILES['file']['error'])
	) {
		throw new RuntimeException('Invalid parameters.');
	}

	// Check $_FILES['file']['error'] value.
	switch ($_FILES['file']['error']) {
		case UPLOAD_ERR_OK:
			break;
		case UPLOAD_ERR_NO_FILE:
			throw new RuntimeException('No file sent.');
		case UPLOAD_ERR_INI_SIZE:
		case UPLOAD_ERR_FORM_SIZE:
			throw new RuntimeException('Exceeded filesize limit.');
		default:
			throw new RuntimeException('Unknown errors.');
	}

	// You should also check filesize here. 
	if ($_FILES['file']['size'] > 5248000) {
		throw new RuntimeException('Exceeded filesize limit. (5 MB)');
	}

	$ext = pathinfo($_FILES['file']['tmp_name'], PATHINFO_EXTENSION);
	// DO NOT TRUST $_FILES['file']['mime'] VALUE !!
	// Check MIME Type by yourself.
	if (
		(mime_content_type($_FILES['file']['tmp_name']) != "application/octet-stream") &&
		($ext != "ahkp")
	) {
		throw new RuntimeException('Invalid file format.');
	}

	// You should name it uniquely.
	// DO NOT USE $_FILES['file']['name'] WITHOUT ANY VALIDATION !!
	// On this example, obtain safe unique name from its binary data.
	$filename = sprintf('%s.%s',sha1_file($_FILES['file']['tmp_name']),$ext);
	echo 'File is uploaded successfully.';

} catch (RuntimeException $e) {

	echo $e->getMessage();

}

?>
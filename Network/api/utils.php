<?php
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
	
	function in_arrayi($needle, $haystack) {
		return in_array(strtolower($needle), array_map('strtolower', $haystack));
	}
	
	function valid_ahkp($file) {
		$handle = fopen($file, "r");
		$magic = fread($handle,8);
		$m_int = fread_UINT($handle);
		fseek($handle,0x0C);
		$m_st=fgetc($handle);
		fseek($handle,0x0B+$m_int);
		$m_en=fgetc($handle);
		fclose($handle);
		//echo "[" . $magic . "|" . $m_int . "|" . $m_st . "|" . $m_en . "]";
		return ( ($magic === "AHKPKG00") && ($m_int >= 80) && ($m_int<5242880) && ($m_st === "{") && ($m_en === "}") );
	}
	
	function formatSizeUnits($bytes) {
		if ($bytes >= 1073741824)
			$bytes = number_format($bytes / 1073741824, 2) . ' GB';
		elseif ($bytes >= 1048576)
			$bytes = number_format($bytes / 1048576, 2) . ' MB';
		elseif ($bytes >= 1024)
			$bytes = number_format($bytes / 1024, 2) . ' KB';
		elseif ($bytes > 1)
			$bytes = $bytes . ' bytes';
		elseif ($bytes == 1)
			$bytes = $bytes . ' byte';
		else
			$bytes = '0 bytes';
		return $bytes;
	}
?>
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
	
	function iniget($inifile, $key) {
		$h = fopen($inifile, "r");
		if ($h) {
			while (($line = fgets($h)) !== false) {
				// process the line read.
				if ($pos=stristr($line,$key))
				{
					fclose($h);
					return strtok(substr($line,$pos+strlen($key)+1),"\r\n");
				}
			}
			fclose($h);
		} else {
			// error opening the file.
			return "error";
		}
		return "null";
	}
	
	function in_arrayi($needle, $haystack) {
		return in_array(strtolower($needle), array_map('strtolower', $haystack));
	}
	
	function get_metadata($file,$raw=0) {
		if ($file == NULL)
			return -1;
		$file = $_SERVER['DOCUMENT_ROOT'] . "/packs/" . str_replace("/","",strtolower($file)); //Remove '/' to avoid exploit
		if (!file_exists($file))
			return -2;
		$handle = fopen($file, "r");
		fseek($handle,8);
		$size = fread_UINT($handle);
		if ($raw)
			return fread($handle,$size);
		else
			return json_decode(fread($handle,$size));
	}
	
	function print_metadata($file,$content_item) {
		if ($file == NULL) {
			echo "ERROR: Invalid parameters";
			return 0;
		}
		$file = "../packs/" . str_replace("/","",strtolower($file)); //Remove '/' to avoid exploit
		if (!file_exists($file)) {
			echo "ERROR: File does not exist.";
			return 0;
		}
		$handle = fopen($file, "r");
		fseek($handle,8);
		$size = fread_UINT($handle);
		if ($content_item==NULL)
			echo fread($handle,$size);
		else if ( in_arrayi($content_item,array("ahkflavour","required","tags")) )
		{
			$obj = json_decode(fread($handle,$size));
			$obj = json_encode($obj->$content_item);
			echo ($obj==="{}")?"":substr($obj,1,-1);
		}
		else
		{
			$obj = json_decode(fread($handle,$size));
			$j_item = $obj->$content_item;
			if (!strlen($j_item))
				echo "ERROR: json item non-existent";
			else
				echo $j_item;
		}
		return 1;
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
	
	function html_escape($str) {
		return str_replace('>', "&gt;",str_replace('<', "&lt;", $str));
	}
	
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
			return "<a href=\"http://opensource.org/licenses/MIT\">MIT License</a>";
		if (stristr($str,"BSD"))
			if (stristr($str,"2"))
				return "<a href=\"http://opensource.org/licenses/BSD-2-Clause\">BSD 2-Clause License</a>";
			else if (stristr($str,"3"))
				return "<a href=\"http://opensource.org/licenses/BSD-3-Clause\">BSD 3-Clause License</a>";
			else
				return "<a href=\"http://opensource.org/licenses/BSD-3-Clause\">" . $str . "</a>";
		if (stristr($str,"LGPL"))
			if (stristr($str,"2.1"))
				return "<a href=\"http://opensource.org/licenses/LGPL-2.1\">LGPL v2.1</a>";
			else if (stristr($str,"3"))
				return "<a href=\"http://opensource.org/licenses/LGPL-3.0\">LGPL v3.0</a>";
			else
				return "<a href=\"http://opensource.org/licenses/lgpl-license\">" . $str . "</a>";
		if (stristr($str,"GPL"))
			if (stristr($str,"2"))
				return "<a href=\"http://opensource.org/licenses/GPL-2.0\">GPL v2.0</a>";
			else if (stristr($str,"3"))
				return "<a href=\"http://opensource.org/licenses/GPL-3.0\">GPL v3.0</a>";
			else
				return "<a href=\"http://opensource.org/licenses/gpl-license\">" . $str . "</a>";
		if (stristr($str,"Apache"))
			return "<a href=\"http://opensource.org/licenses/Apache-2.0\">Apache License v2.0</a>";
		if (stristr($str,"MPL") || stristr($str,"Mozilla"))
			return "<a href=\"http://opensource.org/licenses/MPL-2.0\">Mozilla Public License v2.0</a>";
		if (stristr($str,"CC0"))
			return "<a href=\"http://creativecommons.org/publicdomain/zero/1.0\">Public domain (CC0 1.0)</a>";
		if ( (stristr($str,"CC")) || (stristr($str,"creative")) || (stristr($str,"commons")) )
			return "<a href=\"http://creativecommons.org/licenses\">" . $str . "</a>";
		return $str;
	}
?>
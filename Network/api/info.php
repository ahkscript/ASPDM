<?php
	function print_metadata($file,$content_item) {
		if ($file == NULL) {
			echo "ERROR: Invalid parameters";
			return 0;
		}
		$file = "../packs/" . str_replace("./","",$file);
		if (!file_exists($file)) {
			echo "ERROR: File does not exist.";
			return 0;
		}
		$handle = fopen($file, "r");
		fseek($handle,8);
		$size = fread_UINT($handle);
		if ($content_item==NULL)
			echo fread($handle,$size);
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

	$f = (isset($_GET["f"])) ? htmlspecialchars($_GET["f"]) : NULL;
	$c = (isset($_GET["c"])) ? htmlspecialchars($_GET["c"]) : NULL;
	print_metadata($f,$c);
?>
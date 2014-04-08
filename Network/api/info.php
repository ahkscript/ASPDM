<?php
	include 'utils.php';

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

	$f = (isset($_GET["f"])) ? htmlspecialchars($_GET["f"]) : NULL;
	$c = (isset($_GET["c"])) ? htmlspecialchars($_GET["c"]) : NULL;
	print_metadata($f,$c);
?>
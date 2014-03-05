<?php
	if ($handle = opendir('../packs')) {
		while (false !== ($entry = readdir($handle))) {
			if ($entry != "." && $entry != "..") {
				echo "$entry\n";
			}
		}
		closedir($handle);
	}
?>
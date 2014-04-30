<?php
	include 'utils.php';

	if (isset($_GET["full"]))
	{
		echo "{";
		$i = 0;
		if ($handle = opendir('../packs')) {
			while (false !== ($entry = readdir($handle))) {
				if ($entry != "." && $entry != ".." && $entry != "tmp") {
					$i = $i + 1;
					if ($i>1)
						echo ',';
					echo '"'.$entry.'":';
					print_metadata($entry,NULL);
				}
			}
			closedir($handle);
		}
		echo "}";
	}
	else
	{
		if ($handle = opendir('../packs')) {
			while (false !== ($entry = readdir($handle))) {
				if ($entry != "." && $entry != ".." && $entry != "tmp") {
					echo $entry . "\n";
				}
			}
			closedir($handle);
		}
	}
?>
<?php
	include '../lib/utils.php';

	if (isset($_GET["full"]))
	{
		echo "{";
		$i = 0;
		if ($handle = opendir('../packs')) {
			if (isset($_GET["sort"]))
			{
				$files = array();
				while(false != ($entry = readdir($handle))) {
					if ($entry != "." && $entry != ".." && $entry != "tmp") {
						$files[] = $entry; // put in array.
					}   
				}
				natcasesort($files); // natural sort array
				foreach($files as $entry) {
					$i = $i + 1;
					if ($i>1)
						echo ',';
					echo '"'.$entry.'":';
					print_metadata($entry,NULL);
				}
			}
			else
			{
				while (false !== ($entry = readdir($handle))) {
					if ($entry != "." && $entry != ".." && $entry != "tmp") {
						$i = $i + 1;
						if ($i>1)
							echo ',';
						echo '"'.$entry.'":';
						print_metadata($entry,NULL);
					}
				}
			}
			closedir($handle);
		}
		echo "}";
	}
	else if (isset($_GET["lim"]))
	{
		$lim=abs(intval($_GET["lim"]));
		$origin=abs(intval($_GET["origin"])); //Defaults to '0' (zero)
		
		if ($lim!=$origin) {
			echo "{";
			$i = 0;
			$k = 1;
			if ($handle = opendir('../packs')) {
				if (isset($_GET["sort"]))
				{
					$files = array();
					while(false != ($entry = readdir($handle))) {
						if ($entry != "." && $entry != ".." && $entry != "tmp") {
							$files[] = $entry; // put in array.
						}   
					}
					natcasesort($files); // natural sort array
					foreach($files as $entry) {
						if ($k>=$origin) {
							$i+=1;
							if ($i>1)
								echo ',';
							echo '"'.$entry.'":';
							print_metadata($entry,NULL);
							if ($i==$lim)
								break;
						}
						$k+=1;
					}
				}
				else
				{
					while (false !== ($entry = readdir($handle))) {
						if ($entry != "." && $entry != ".." && $entry != "tmp") {
							if ($k>=$origin) {
								$i+=1;
								if ($i>1)
									echo ',';
								echo '"'.$entry.'":';
								print_metadata($entry,NULL);
								if ($i==$lim)
									break;
							}
							$k+=1;
						}
					}
				}
				closedir($handle);
			}
			echo "}";
		}
	}
	else
	{
		if ($handle = opendir('../packs')) {
			if (isset($_GET["sort"]))
			{
				$files = array();
				while(false != ($entry = readdir($handle))) {
					if ($entry != "." && $entry != ".." && $entry != "tmp") {
						$files[] = $entry; // put in array.
					}   
				}
				natcasesort($files); // natural sort array
				foreach($files as $entry) {
					echo $entry . "\n";
				}
			}
			else
			{
				while (false !== ($entry = readdir($handle))) {
					if ($entry != "." && $entry != ".." && $entry != "tmp") {
						echo $entry . "\n";
					}
				}
			}
			closedir($handle);
		}
	}
?>
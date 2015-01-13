<?php
	$var = (isset($_REQUEST['_c']))?$_REQUEST['_c']:"NULL";
	$var = str_replace(array('"',"'",'\\'),"",$var);
	
	print('{api:{"name":"aspdm","check":"'.$var.'"}}');
?>
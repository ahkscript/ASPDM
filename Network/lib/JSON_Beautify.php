<?php
	
	//fork of "JSON_Beautify.ahk"
	
	function JSON_Uglify($JSON) {
		if (!is_object($JSON)) {
			$JSON = trim($JSON);
			$len = strlen($JSON);
			if (!$len)
				return "";
			str_replace(array("\n","\r","\f","\b","\t"),"",$JSON);
			$_JSON="";
			$in_str=0;
			$l_char="";

			for($c = 0; $c < $len; $c++) {
				$char = $JSON[$c]; 
				if ( (!$in_str) && (ord($char)==0x20) )
					continue;
				if( (ord($char)==0x22) && (ord($l_char)!=0x5C) )
					$in_str = (!$in_str);
				$l_char = $char;
				$_JSON .= $char;
			}
			return $_JSON;
		}
		else
			return json_encode($JSON);
	}

	function JSON_Beautify($JSON, $gap) {
		//fork of http://pastebin.com/xB0fG9py
		$JSON = JSON_Uglify($JSON);
		
		$indent="";
		
		if (is_int($gap)) {
			$i=0;
			while ($i < $gap) {
				$indent .= " ";
				$i+=1;
			}
		} else {
			$indent = $gap;
		}
		
		$_JSON="";
		$in_str=0;
		$k=0;
		$l_char="";
		$len = strlen($JSON);
		
		for($c = 0; $c < $len; $c++) {
			$char = $JSON[$c];
			if (!$in_str) {
				if ( ($char==="{") || ($char==="[") ) {
					$_JSON .= $char."\n".str_repeat($indent,++$k);
					continue;
				}
				else if ( ($char==="}") || ($char==="]") ) {
					$_JSON .= "\n".str_repeat($indent,--$k).$char;
					continue;
				}
				else if ( ($char===",") ) {
					$_JSON .= $char."\n".str_repeat($indent,$k);
					continue;
				}
			}
			if( (ord($char)==0x22) && (ord($l_char)!=0x5C) )
				$in_str = (!$in_str);
			$l_char = $char;
			$_JSON .= $char;
		}
		return $_JSON;
	}
?>
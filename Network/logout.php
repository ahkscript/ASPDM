<?php
session_start();
include 'lib/server.php';
sessionInvalid();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<title>Logout</title>
	</head>
	<body>
		<h1>logged out.</h1>
		<p>You will be redirected in <span id="counter">3</span> second(s).
		<br><a href="/index.php">Click here to be redirected immediately.</a></p>
		<script type="text/javascript">
		function countdown() {
			var i = document.getElementById('counter');
			if (parseInt(i.innerHTML)<=0) {
				location.href = 'index.php';
			}
			var j = (parseInt(i.innerHTML)-1);
			i.innerHTML = (j>=0)?j:0;
		}
		setInterval(function(){ countdown(); },1000);
		</script>
	</body>
</html>
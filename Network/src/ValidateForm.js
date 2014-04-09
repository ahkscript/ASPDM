function ValidateForm(frm) {
	if (isBlank(frm.username.value)) {
		alert("Please provide your username.");
		frm.username.focus();
		return false;
	}
	if (isBlank(frm.password.value)) {
		alert("Please provide your password.");
		frm.password.focus();
		return false;
	}
	return true;
}

function isBlank(s) {
	return s.match(/^$|\s+/);
}
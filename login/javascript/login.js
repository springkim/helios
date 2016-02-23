var global;
function id_submit() {
	var id = document.getElementById("ID").value;

	if (id == "") {
		alert("Please enter id.");
		return false;
	}
	//var enc_id = CryptoJS.SHA3(id);
	document.getElementById("HID").value = id;
	return true;
}
function pw_submit() {
	var pw = document.getElementById("PW").value;
	var salt=document.getElementById("SALT").value;
	if (pw == "") {
		alert("Please enter password.");
		return false;
	}
	var enc_pw = CryptoJS.SHA3(salt+pw);
	document.getElementById("HPW").value = enc_pw;
	return true;
}
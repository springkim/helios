function CheckSubmit() {
	var file = document.getElementById("FILE").value;
	if (file_chk() == false) {
		return false;
	}
	return true;
}
/**
 * @name : file check
 * @check1 : 확장자검사
 */
function file_chk() {
	var file = document.getElementById("FILE").value;
	var execs = new Array(".pl", ".cpp", ".c", ".py");
	var bSubmitCheck = false;
	if (!file) {
		alert("please select your submit file");
		return false;
	}

	while (file.indexOf("\\") != -1) {
		file = file.substring(file.indexOf("\\") + 1);
	}
	ext = file.substring(file.indexOf(".")).toLowerCase();
	for (var i = 0; i < execs.length; i++) {
		if (execs[i] == ext) {
			bSubmitCheck = true;
			break;
		}
	}
	if (!bSubmitCheck) {
		alert("enable upload file.\n\n" + (execs.join("  "))
				+ "please select again");
		return false;
	}
	alert("ok");
	return true;
}
/**
 * @name : file size check
 * @check1 : file size < 4mb
 */
function filesizechk(objFile) {
	var nMaxSize = 4 * 1024 * 1024; // 4 MB
	var nFileSize = objFile.files[0].size;
	if (nFileSize > nMaxSize) {
		document.getElementById("FILE").value = "";
		document.getElementById("fakeFile").value = "";
		alert("Please upload a file less than 4MB");
	} else {
		document.getElementById("fakeFile").value = document
				.getElementById("FILE").value;
	}
}
function goFile() {
	document.getElementById("FILE").click();
}
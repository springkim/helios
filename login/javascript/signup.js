/*
 *	@Project  : Helios
 *	@Architecture : Kim Bom
 *	signup.js
 *
 *	@Created by KimBom On 2016. 1. 2...
 *	@Copyright (C) 2015 KimBom. All rights reserved.
 */

/**
 * @name CheckBlank
 * @check1 : 공백검사
 * @check2 : ID,PW,EMAIL,CPW,FILE 유효성 검사
 */
function CheckSubmit() {
	var id = document.getElementById("ID").value;
	var pw = document.getElementById("PW").value;
	var name = document.getElementById("NAME").value;
	var guild = document.getElementById("GUILD").value;
	var phone = document.getElementById("PHONE").value;
	var email = document.getElementById("EMAIL").value;
	var file = document.getElementById("FILE").value;
	// 공백검사
	if (id == "" || pw == "" || name == "" || guild == "" || phone == ""
			|| email == "" || file == "") {
		alert("Please enter all information.");
		return false;
	}
	// 아이디 검사
	if (id_keyup() == false) {
		alert("id error");
		return false;
	}
	// 비밀번호 검사
	if (pw_keyup() == false) {
		alert("password error");
		return false;
	}
	// 이메일 검사
	if (em_keyup() == false) {
		alert("email error");
		return false;
	}
	// 확인 비밀번호 검사
	if (cpw_keyup() == false) {
		alert("confirm password error");
		return false;
	}
	//확인 아이디 검사
	if(cid_keyup()==false){
		alert("confirm id error");
		return false;
	}
	// 파일 확장자 검사
	if (file_chk() == false) {
		alert("file upload error");
		return false;
	}
	// SHA3 암호화
	var salt=CryptoJS.lib.WordArray.random(32);
	var enc_pw=CryptoJS.SHA3(salt+pw);
	//var enc_id=CryptoJS.SHA3(id);
	document.getElementById("HPW").value = enc_pw;
	document.getElementById("HID").value = id;
	document.getElementById("HSALT").value = salt;
	return true;
	
}
/**
 * @name : id_keyup 
 * @check1 : id length<4
 * @check2 : id already exist
 * @check3 : only use alpha,digit,under bar
 */
function id_keyup() {
	var i = document.getElementById("ID");
	// 알파벳,숫자,언더바가 아니면 삭제한다.
	if (i.value.length > 0) {
		i.value = i.value.replace(/[^(\d|a-z|A-Z|_)]+/g, '');
	}
	var ids = document.getElementById("IDS").value;
	var already_id = ids.split(',');
	var id = document.getElementById("ID").value;
	if (id.length >= 4) {
		//var enc_id=CryptoJS.SHA3(id);
		var char4 = document.getElementById("char4");
		char4.style.visibility = "hidden";
		for ( var i in already_id) {
			// 이미 존재하는 ID일경우 오류 출력
			if (already_id[i] == id) {
				var sameid = document.getElementById("sameid");
				sameid.style.visibility = "visible";
				return false;
			}
		}
		var sameid = document.getElementById("sameid");
		sameid.style.visibility = "hidden";
	} else {
		// ID의 길이가 4이하면 오류메세지 출력
		var sameid = document.getElementById("sameid");
		sameid.style.visibility = "hidden";
		var char4 = document.getElementById("char4");
		char4.style.visibility = "visible";
		return false;
	}
	return true;
}
/**
 * @name : cid_keyup
 * @check1 : 비밀번호와 같은지 검사
 */
function cid_keyup() {
	var id = document.getElementById("ID").value;
	var cid = document.getElementById("CID").value;
	if (cid == id) {
		var c_id = document.getElementById("cid");
		c_id.style.visibility = "hidden";
		return true;
	} else {
		var c_id = document.getElementById("cid");
		c_id.style.visibility = "visible";
		return false;
	}
}
/**
 * @name : pw_keyup
 * @check1 : pw length<4
 */
function pw_keyup() {
	var pw = document.getElementById("PW").value;
	var i = document.getElementById("PW");
	if (i.value.length > 0) {
		i.value = i.value.replace(/[^(\d|a-z|A-Z|_)]+/g, '');
	}
	if(pw!=i.value){
		var ivc = document.getElementById("ivchar");
		ivc.style.visibility = "visible";
		return false;
	}else{
		var ivc = document.getElementById("ivchar");
		ivc.style.visibility = "hidden";
	}
	// 길이가 4이하면 에러
	if (pw.length >= 4) {
		var pw4 = document.getElementById("pass4");
		pw4.style.visibility = "hidden";
		return true;
	} else {
		var pw4 = document.getElementById("pass4");
		pw4.style.visibility = "visible";
		return false;
	}
}
/**
 * @name : cpw_keyup
 * @check1 : 비밀번호와 같은지 검사
 */
function cpw_keyup() {
	var pw = document.getElementById("PW").value;
	var cpw = document.getElementById("CPW").value;
	if (cpw == pw) {
		var c_pw = document.getElementById("cpass");
		c_pw.style.visibility = "hidden";
		return true;
	} else {
		var c_pw = document.getElementById("cpass");
		c_pw.style.visibility = "visible";
		return false;
	}
}
/**
 * @name : not empty keyup
 * @check1 : 공백검사
 * @param1 : 속성 ID
 * @param2 : 경고 메세지 ID
 */
function nempty_keyup(param1, param2) {
	var value = document.getElementById(param1).value;
	if (value == "") {
		var bar = document.getElementById(param2);
		bar.style.visibility = "visible";
	} else {
		var bar = document.getElementById(param2);
		bar.style.visibility = "hidden";
	}
}
/**
 * @name : email_keyup
 * @check1 : email check
 */
function em_keyup() {
	var email = document.getElementById("EMAIL").value;
	var regex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
	if (regex.test(email) === false) {
		var em = document.getElementById("emchk");
		em.style.visibility = "visible";
		return false;
	} else {
		var em = document.getElementById("emchk");
		em.style.visibility = "hidden";
		return true;
	}
}
/**
 * @name : tel_keyup
 * @check1 : 숫자만 입력가능(다른문자가 들어오면 제거)
 */
function tel_keyup() {
	var i = document.getElementById("PHONE");
	if (i.value.length > 0) {
		i.value = i.value.replace(/[^\d]+/g, '');
	}
	if (i.value == "") {
		var em = document.getElementById("phonechk");
		em.style.visibility = "visible";
		return true;
	} else {
		var em = document.getElementById("phonechk");
		em.style.visibility = "hidden";
	}
	return true;
}
/**
 * @name : file check
 * @check1 : 확장자검사
 */
function file_chk() {
	var file = document.getElementById("FILE").value;
	var execs = new Array(".jpg", ".gif",  ".bmp", ".png",".jpeg");
	var bSubmitCheck = false;
	if (!file) {
		alert("please select your photo");
		return;
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
/**
 * @name : go file
 * @comment : 파일을 클릭하게 합니다.
 */
function goFile() {
	document.getElementById("FILE").click();
}
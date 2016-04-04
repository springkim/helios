
$(document).ready(function() {
	$("#checkid").click(function() {
		var id = $('#ID').val();
		if(id!=""){
			$.ajax({
				url : 'check_id_overlap.pl',
				data : {
					"ID" : id
				},
				success : function(r) {
					if (r==1) {
						$('#ID_EDITBOX').removeClass("has-success");
						$('#ID_EDITBOX').addClass("has-error");
						$('#IDCHECK_DIALOG').removeClass("fa-thumbs-o-up");
						$('#IDCHECK_DIALOG').addClass("fa-ban");
						$('#IDCHECK_DIALOG_COLOR').removeClass("alert-success");
						$('#IDCHECK_DIALOG_COLOR').addClass("alert-danger");
						$('#IDCHECK_TITLE').html('<strong>Fail</strong>');
						$('#IDCHECK_COMMENT').html('<h5>The user ID is overlapped.</br> Please enter a new ID.</h5>');
					} else {
						$('#ID_EDITBOX').removeClass("has-error");
						$('#ID_EDITBOX').addClass("has-success");
						$('#IDCHECK_DIALOG').removeClass("fa-ban");
						$('#IDCHECK_DIALOG').addClass("fa-thumbs-o-up");
						$('#IDCHECK_DIALOG_COLOR').removeClass("alert-danger");
						$('#IDCHECK_DIALOG_COLOR').addClass("alert-success");
						$('#IDCHECK_TITLE').html('<strong>Success</strong>');
						$('#IDCHECK_COMMENT').html('<h5>This ID is available.</h5>');
					}
				}
			})
		}else{
			$('#IDCHECK_DIALOG').removeClass("fa-thumbs-o-up");
			$('#IDCHECK_DIALOG').addClass("fa-ban");
			$('#IDCHECK_DIALOG_COLOR').removeClass("alert-success");
			$('#IDCHECK_DIALOG_COLOR').addClass("alert-danger");
			$('#IDCHECK_TITLE').html('<strong>Fail</strong>');
			$('#IDCHECK_COMMENT').html('<h5>This input is empty!!</br>Please enter the ID.</h5>');
		}
	})
	$('#ID').keyup(function(){
		$('#ID_EDITBOX').removeClass("has-error");
		$('#ID_EDITBOX').removeClass("has-success");
		$('#ID').val($('#ID').val().replace(/[^\d|a-z|A-Z|_]+/g,''));
		
	})
	$('#ID').blur(function(){
		$('#ID').val($('#ID').val().replace(/[^\d|a-z|A-Z|_]+/g,''));
	})
	$('#PW').keyup(function(){
		$('#PW').val($('#PW').val().replace(/[^\d|a-z|A-Z|_]+/g,''));
		if($('#PW').val().length<8){
			$('#PW_EDITBOX').removeClass("has-warning");
			$('#PW_EDITBOX').removeClass("has-success");
			$('#PW_EDITBOX').addClass("has-error");
		}else{
			$('#PW_EDITBOX').removeClass("has-error");
			$('#PW_EDITBOX').addClass("has-warning");
			if($('#PW').val()==$('#CPW').val()){
				$('#PW_EDITBOX').removeClass("has-warning");
				$('#PW_EDITBOX').addClass("has-success");
				$('#CPW_EDITBOX').removeClass("has-warning");
				$('#CPW_EDITBOX').addClass("has-success");
			}
		}
	})
	$('#CPW').keyup(function(){
		$('#CPW').val($('#CPW').val().replace(/[^\d|a-z|A-Z|_]+/g,''));
		if($('#CPW').val().length<8){
			$('#CPW_EDITBOX').removeClass("has-warning");
			$('#CPW_EDITBOX').removeClass("has-success");
			$('#CPW_EDITBOX').addClass("has-error");
		}else{
			$('#CPW_EDITBOX').removeClass("has-error");
			$('#CPW_EDITBOX').addClass("has-warning");
			if($('#PW').val()==$('#CPW').val()){
				$('#PW_EDITBOX').removeClass("has-warning");
				$('#PW_EDITBOX').addClass("has-success");
				$('#CPW_EDITBOX').removeClass("has-warning");
				$('#CPW_EDITBOX').addClass("has-success");
			}
		}
	})
	$('#NAME').blur(function(){
		$('#NAME').val($('#NAME').val().replace(/[^a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]+/g,''));
		if($('#NAME').val().length==0){
			$('#NAME_EDITBOX').removeClass("has-success");
			$('#NAME_EDITBOX').addClass("has-error");
		}else{
			$('#NAME_EDITBOX').removeClass("has-error");
			$('#NAME_EDITBOX').addClass("has-success");
		}
	})
	$('#NAME').keyup(function(){
		$('#NAME').val($('#NAME').val().replace(/[^a-z|A-Z|ㄱ-ㅎ|ㅏ-ㅣ|가-힣]+/g,''));
		if($('#NAME').val().length==0){
			$('#NAME_EDITBOX').removeClass("has-success");
			$('#NAME_EDITBOX').addClass("has-error");
		}else{
			$('#NAME_EDITBOX').removeClass("has-error");
			$('#NAME_EDITBOX').addClass("has-success");
		}
	})
	$('#EMAIL').keyup(function(){
		var regex=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
		if(regex.test($('#EMAIL').val())==false){
			$('#EMAIL_EDITBOX').removeClass("has-success");
			$('#EMAIL_EDITBOX').removeClass("has-warning");
			$('#EMAIL_EDITBOX').addClass("has-error");
		}else{
			$('#EMAIL_EDITBOX').removeClass("has-success");
			$('#EMAIL_EDITBOX').removeClass("has-error");
			$('#EMAIL_EDITBOX').addClass("has-warning");
		}
	})
	$("#checkemail").click(function() {
		var email = $('#EMAIL').val();
		if(email!=""){
			$.ajax({
				url : 'check_email_overlap.pl',
				data : {
					"EMAIL" : email
				},
				success : function(r) {
					var regex=/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
					if(regex.test($('#EMAIL').val())==false){
						$('#EMAIL_EDITBOX').removeClass("has-success");
						$('#EMAIL_EDITBOX').removeClass("has-warning");
						$('#EMAIL_EDITBOX').addClass("has-error");
						$('#EMAILCHECK_DIALOG').removeClass("fa-thumbs-o-up");
						$('#EMAILCHECK_DIALOG').addClass("fa-ban");
						$('#EMAILCHECK_DIALOG_COLOR').removeClass("alert-success");
						$('#EMAILCHECK_DIALOG_COLOR').addClass("alert-danger");
						$('#EMAILCHECK_TITLE').html('<strong>Fail</strong>');
						$('#EMAILCHECK_COMMENT').html('<h5>Email format is not valid.</br> Please enter a new E-mail.</h5>');
					}
					else if (r==1) {
						$('#EMAIL_EDITBOX').removeClass("has-success");
						$('#EMAIL_EDITBOX').removeClass("has-warning");
						$('#EMAIL_EDITBOX').addClass("has-error");
						$('#EMAILCHECK_DIALOG').removeClass("fa-thumbs-o-up");
						$('#EMAILCHECK_DIALOG').addClass("fa-ban");
						$('#EMAILCHECK_DIALOG_COLOR').removeClass("alert-success");
						$('#EMAILCHECK_DIALOG_COLOR').addClass("alert-danger");
						$('#EMAILCHECK_TITLE').html('<strong>Fail</strong>');
						$('#EMAILCHECK_COMMENT').html('<h5>The E-mail is overlapped.</br> Please enter a new E-mail.</h5>');
					} else {
						$('#EMAIL_EDITBOX').removeClass("has-error");
						$('#EMAIL_EDITBOX').removeClass("has-warning");
						$('#EMAIL_EDITBOX').addClass("has-success");
						$('#EMAILCHECK_DIALOG').removeClass("fa-ban");
						$('#EMAILCHECK_DIALOG').addClass("fa-thumbs-o-up");
						$('#EMAILCHECK_DIALOG_COLOR').removeClass("alert-danger");
						$('#EMAILCHECK_DIALOG_COLOR').addClass("alert-success");
						$('#EMAILCHECK_TITLE').html('<strong>Success</strong>');
						$('#EMAILCHECK_COMMENT').html('<h5>This E-mail is available.</h5>');
					}
				}
			})
		}else{
			$('#EMAILCHECK_DIALOG').removeClass("fa-thumbs-o-up");
			$('#EMAILCHECK_DIALOG').addClass("fa-ban");
			$('#EMAILCHECK_DIALOG_COLOR').removeClass("alert-success");
			$('#EMAILCHECK_DIALOG_COLOR').addClass("alert-danger");
			$('#EMAILCHECK_TITLE').html('<strong>Fail</strong>');
			$('#EMAILCHECK_COMMENT').html('<h5>This input is empty!!</br>Please enter the E-mail.</h5>');
		}
	})
	$('#signup').click(function(){
		if($('#ID_EDITBOX').hasClass('has-success')==false){
			$('#SIGNUP_TITLE').html('<strong>ID Fail</strong>');
			$('#SIGNUP_COMMENT').html('<h5>Please check the ID availability.</h5>');
			$('#SIGNUPDLG').click();
			return false;
		}
		if($('#PW_EDITBOX').hasClass('has-success')==false || $('#CPW_EDITBOX').hasClass('has-success')==false){
			$('#SIGNUP_TITLE').html('<strong>Password Fail</strong>');
			$('#SIGNUP_COMMENT').html('<h5>Please check the password availability.</h5>');
			$('#SIGNUPDLG').click();
			return false;
		}
		if($('#NAME_EDITBOX').hasClass('has-success')==false){
			$('#SIGNUP_TITLE').html('<strong>Name Fail</strong>');
			$('#SIGNUP_COMMENT').html('<h5>Please check the Name availability.</h5>');
			$('#SIGNUPDLG').click();
			return false;
		}
		if($('#EMAIL_EDITBOX').hasClass('has-success')==false){
			$('#SIGNUP_TITLE').html('<strong>E-mail Fail</strong>');
			$('#SIGNUP_COMMENT').html('<h5>Please check the E-mail availability.</h5>');
			$('#SIGNUPDLG').click();
			return false;
		}
		var salt=CryptoJS.lib.WordArray.random(32);
		$('#EPW').val($('#PW').val());
		for(var i=0;i<=777;i++){
			$('#EPW').val(CryptoJS.SHA3(salt+$('#EPW').val()));
		}
		$('#SALT1').val(salt);
		$('#SUBMIT_BTN').click();
		$('#SIGNUPFORM').submit();
		return true;
	})
});

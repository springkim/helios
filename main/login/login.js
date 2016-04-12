
$(document).ready(function() {
	$('#login').click(function(){
		var id = $('#ID').val();
		var pw = $('#PW').val();
		if(id=="" && pw==""){
			$('#LOGIN_TITLE').html('<strong>ID, PW is missing</strong>');
			$('#LOGIN_COMMENT').html('<h5>Please input your id.</br>Please input your password.</h5>');
			$('#LOGINDLG').click();
			return false;
		}else if(id==""){
			$('#LOGIN_TITLE').html('<strong>ID is missing</strong>');
			$('#LOGIN_COMMENT').html('<h5>Please input your id.</h5>');
			$('#LOGINDLG').click();
			return false;
		}else if(pw==""){
			$('#LOGIN_TITLE').html('<strong>PW is missing</strong>');
			$('#LOGIN_COMMENT').html('<h5>Please input your password.</h5>');
			$('#LOGINDLG').click();
			return false;
		}
		
		$.ajax({
			url:'get_id_salt.pl',
			data : {
				"ID" : id
			},
			success : function(r) {
				var salt=r;
				$('#EPW').val($('#PW').val());
				for(var i=0;i<=777;i++){
					$('#EPW').val(CryptoJS.SHA3(salt+$('#EPW').val()));
				}
				//alert($('#EPW').val());
				$('#LOGINFORM').submit();
			},
			error:function(a,b,c){
				alert('ajax fail'+c);
			}
		})
		
		return false;
	})
});

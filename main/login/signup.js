
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
					} else {
						$('#ID_EDITBOX').removeClass("has-error");
						$('#ID_EDITBOX').addClass("has-success");
						$('#IDCHECK_DIALOG').removeClass("fa-ban");
						$('#IDCHECK_DIALOG').addClass("fa-thumbs-o-up");
						$('#IDCHECK_DIALOG_COLOR').removeClass("alert-danger");
						$('#IDCHECK_DIALOG_COLOR').addClass("alert-success");
						$('#IDCHECK_TITLE').html('<strong>Success</strong>');
					}
				}
			})
		}else{
			$('#IDCHECK_DIALOG').removeClass("fa-thumbs-o-up");
			$('#IDCHECK_DIALOG').addClass("fa-ban");
			$('#IDCHECK_DIALOG_COLOR').removeClass("alert-success");
			$('#IDCHECK_DIALOG_COLOR').addClass("alert-danger");
			$('#IDCHECK_TITLE').html('<strong>Fail</strong>');
		}
	});
	$('#ID').keyup(function(){
		$('#ID_EDITBOX').removeClass("has-error");
		$('#ID_EDITBOX').removeClass("has-success");
	})
});

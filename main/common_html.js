
$("#autologin").on('switchChange.bootstrapSwitch',function(){
	/*bs-switch is on ? */
	if($('#userid').val()==""){
		return;
	}
	if($('#autologin').bootstrapSwitch('state')){
		$.ajax({
			url:'ajax/set_autologin.pl',
			data:{"id":$('#userid').val(),"TF":"1"},
			error:function(a,b,c){
				alert('ajax fail'+c);
			}
		})
	}else{
		$.ajax({
			url:'ajax/set_autologin.pl',
			data:{"id":$('#userid').val(),"TF":"0"},
			success:function(){
				$(location).attr('href','../login/logout.pl');
			}
		})
	}
})


$("#savelog").on('switchChange.bootstrapSwitch',function(){
	/*bs-switch is on ? */
	if($('#userid').val()==""){
		return;
	}
	if($('#savelog').bootstrapSwitch('state')){
		$.ajax({
			url:'ajax/set_savelog.pl',
			data:{"id":$('#userid').val(),"TF":"1"},
			error:function(a,b,c){
				alert('ajax fail'+c);
			}
		})
	}else{
		$.ajax({
			url:'ajax/set_savelog.pl',
			data:{"id":$('#userid').val(),"TF":"0"},
			success:function(){
				$(location).attr('href','../login/logout.pl');
			}
		})
	}
})
var notice_cnt=1;

$(document).ready(function() {
	$("#notice0").css("display","block");
	setInterval(function() {
		var len=$('.notice_box').length;	
		var bar=notice_cnt%1000/10;
		$("#progress_bar").css("width",bar+"%");
		
		var curr=notice_cnt/1000;
		var befo=((notice_cnt/1000)+(len-1))%len;
		
		$("#notice"+befo).css("display","none");
		$("#notice"+curr).css("display","block");
		notice_cnt++;
		if(notice_cnt==len*1000){
			notice_cnt=0;
		}
		
	}, 5);
});

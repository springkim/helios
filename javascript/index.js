function Equalizer1(){
	var bars = document.getElementsByClassName('bar1');
	[].forEach.call(bars, function (bar) {
	   bar.style.height = Math.random() * 100 + '%';
	});
}
function Equalizer2(){
	var bars = document.getElementsByClassName('bar2');
	[].forEach.call(bars, function (bar) {
	   bar.style.height = Math.random() * 100 + '%';
	});
}
function Equalizer3(){
	var bars = document.getElementsByClassName('bar3');
	[].forEach.call(bars, function (bar) {
	   bar.style.height = Math.random() * 100 + '%';
	});
}
var song_status=0;
var e1,e2,e3;
function SongBtn(){
	if(song_status==1){
		document.getElementById("songaudio").pause();
		song_status=0;
		clearTimeout(e1);
		clearTimeout(e2);
		clearTimeout(e3);
	}else{
		document.getElementById("songaudio").play();
		song_status=1;
		e1 = setInterval(function(){Equalizer1()},200);
		e2 = setInterval(function(){Equalizer2()},300);
		e3 = setInterval(function(){Equalizer3()},400);
	}
}
//======================================================================
function startClock() { // internal clock//
	var today=new Date();
	var h=today.getHours();
	var m=today.getMinutes();
	var s=today.getSeconds();
	m = checkTime(m);
	s = checkTime(s);
	var time=h+":"+m+":"+s;
	document.getElementById('clock').innerHTML = time;
	var t = setTimeout(function(){startClock()},500);
	
}
function checkTime(i) {
if (i<10) {i = "0" + i};  // add zero in front of numbers < 10 
	return i;
}
function checkDate(i) {
 	i = i+1 ;  // to adjust real month
   	return i;
}
function emblem_next(){
	var index=document.getElementById("EMBLEM_INDEX").value;
	var sz=document.getElementById("EMBLEM_SZ").value;
	var max_index=Math.ceil(sz/9);
	
	
	var new_index=(index-0)+1;
	if(new_index==max_index){
		new_index=0;
	}
	
	document.getElementById("STATE3_"+index).style.display="none";
	document.getElementById("STATE3_"+new_index).style.display="block";
	
	var i=0;
	var lim=Math.max(new_index * 9 , sz);
	for(i=index * 9;i<lim;i++){
		document.getElementById("EMBLEM_"+i).style.display="none";
	}
	lim=(new_index-0)+1;
	for(i=new_index * 9;i<lim * 9 && i<sz;i++){
		document.getElementById("EMBLEM_"+i).style.display="block";
	}
	
	document.getElementById("EMBLEM_INDEX").value=new_index;
	return false;
}
function emblem_prev(){
	var index=document.getElementById("EMBLEM_INDEX").value;
	var sz=document.getElementById("EMBLEM_SZ").value;
	var max_index=Math.ceil(sz/9);
	
	
	var new_index=(index-0)-1;
	if(new_index==-1){
		new_index=max_index-1;
	}
	
	document.getElementById("STATE3_"+index).style.display="none";
	document.getElementById("STATE3_"+new_index).style.display="block";
	
	var i=0;
	var lim=Math.max(new_index * 9 , sz);
	for(i=index * 9;i<lim;i++){
		document.getElementById("EMBLEM_"+i).style.display="none";
	}
	lim=(new_index-0)+1;
	for(i=new_index * 9;i<lim * 9 && i<sz;i++){
		document.getElementById("EMBLEM_"+i).style.display="block";
	}
	
	document.getElementById("EMBLEM_INDEX").value=new_index;
	return false;
}
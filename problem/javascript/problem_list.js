
function problem_go(param){
	document.getElementById("PR_PATH").value=param;
	document.PROBLEM_VIEW.submit();
	return false;
}

function all_problem(){
	var d=document.getElementById("OTHER_PARAM");
	d.value="SELECT * FROM problem";
	document.PROBLEM_LIST_VIEW.submit();
	return false;
}
function level_problem(param){
	var d=document.getElementById("OTHER_PARAM");
	d.value="SELECT pr_path,pr_title,pr_level,pr_group,pr_subgroup FROM problem WHERE pr_level=\'"+param+"\' ORDER BY pr_path";
	document.PROBLEM_LIST_VIEW.submit();
	return false;
}
function solve_problem(){
	var id=document.getElementById("HID").value;
	var d=document.getElementById("OTHER_PARAM");
	d.value="SELECT problem.pr_path,pr_title,pr_level,pr_group,pr_subgroup FROM problem,userinfo_problem WHERE userinfo_problem.ui_id=\'" + id + "\' and problem.pr_path=userinfo_problem.pr_path and userinfo_problem.uip_status=\'Accepted\'";
	document.PROBLEM_LIST_VIEW.submit();
	return false;
}
function try_problem(){
	var id=document.getElementById("HID").value;
	var d=document.getElementById("OTHER_PARAM");
	d.value="SELECT problem.pr_path,pr_title,pr_level,pr_group,pr_subgroup FROM problem,userinfo_problem WHERE userinfo_problem.ui_id=\'" + id + "\' and problem.pr_path=userinfo_problem.pr_path and userinfo_problem.uip_status<>\'Accepted\'";
	document.PROBLEM_LIST_VIEW.submit();
	return false;
}
function non_solve_problem(){
	var id=document.getElementById("HID").value;
	var d=document.getElementById("OTHER_PARAM");
	var all_p="SELECT problem.pr_path,pr_title,pr_level,pr_group,pr_subgroup FROM problem";
	var solve_p="SELECT problem.pr_path,pr_title,pr_level,pr_group,pr_subgroup FROM problem,userinfo_problem WHERE userinfo_problem.ui_id=\'" + id + "\' and problem.pr_path=userinfo_problem.pr_path and userinfo_problem.uip_status=\'Accepted\'";
	
	d.value="("+all_p+")except("+solve_p+")";
	
	document.PROBLEM_LIST_VIEW.submit();
	return false;
}
function group_select(param1,param2){
	document.getElementById("GROUP").value=param1;
	document.getElementById("SUBGROUP").value=param2;
	document.PROBLEM_LIST_VIEW.submit();
	return false;
}
function search_keyup(){
	var i = document.getElementById("SEARCH");
	// 알파벳,숫자,언더바가 아니면 삭제한다.
	if (i.value.length > 0) {
		i.value = i.value.replace(/[^(\d|a-z|A-Z|_|ㄱ-ㅎ|ㅏ-ㅣ|가-힣)]+/g, '');
	}
}
function search_problem(){
	var i = document.getElementById("SEARCH").value;
	var d=document.getElementById("OTHER_PARAM");
	d.value="SELECT pr_path,pr_title,pr_level,pr_group,pr_subgroup FROM problem WHERE pr_path like \'problem/problem_list/%"+i+"%\' or pr_title like \'%"+i+"%\'"
	document.PROBLEM_LIST_VIEW.submit();
	return false;
}
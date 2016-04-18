#include<stdio.h>
int main(){
	int t;
	int a,b;
	FILE* fp=fopen("ans","r");
		char aaa[65536];
		fgets(aaa,65535,fp);
		printf("%s",aaa);
	return 0;
}

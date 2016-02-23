#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<time.h>
int main(int argc,char* argv[]){
	struct tm* t;
	time_t timer;
	int hour=0;
	int min=0;
	char cmd[512]={0};
	if(argc<4){
		puts("Usage : [hour] [min] [execute program](24시간제)");
		exit(EXIT_FAILURE);
	}
	hour=atoi(argv[1]);
	min=atoi(argv[2]);
	sprintf(cmd,"./%s",argv[3]);
	while(1){
		sleep(30);
		timer=time(0);
		t=localtime(&timer);
		if(hour==t->tm_hour && t->tm_min==min){
			system(cmd);
			sleep(60);
		}
	}
	return EXIT_SUCCESS;
}

#include<stdio.h>
int main(){
	int t;
	int a,b;
	int arr[10];
	int i;
	for(i=0;i<10000;i++){
		arr[i]=10;
	}	
	scanf("%d",t);
	while(t--){
		scanf("%d %d",&a,&b);
		printf("%d\n",a+b);
	}
	return 0;
}

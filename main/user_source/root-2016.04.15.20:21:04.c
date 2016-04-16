#include<stdio.h>
static void* arr[10000][1000];
int main(){
	int t;
	int a,b;
	scanf("%d",&t);
	while(t--){
		int i,j;
		for(i=0;i<10000;i++){
			for(j=0;j<100;j++){
				arr[i][j]=malloc(10000000);
			}
		}
		scanf("%d %d",&a,&b);
		printf("%d\n",a+b);
	}
	return 0;
}

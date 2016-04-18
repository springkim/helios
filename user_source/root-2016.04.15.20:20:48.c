#include<stdio.h>
int main(){
	int t;
	int a,b;
	scanf("%d",&t);
	while(t--){
		scanf("%d %d",&a,&b);
		int i,j;
		int c=0;
		for(i=0;i<100000;i++){
			j=i;
			for(;j<100000;j++){
				if(j%2==0)c++;
			}
		}	
		printf("%d\n",a+b+c);
	}
	return 0;
}

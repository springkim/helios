#include<stdio.h>
#include<search.h>
int cmp(const void* a,const void* b){
	return *(int*)a<*(int*)b?-1:*(int*)a>*(int*)b;
}
int main(){
	int n;
	int a[100];
	int i;	
	scanf("%d",&n);
	for(i=0;i<n;i++){
		scanf("%d",a+i);
	}
	qsort(a,n,4,cmp);
	for(i=0;i<n;i++){
		printf("%d ",a[i]);
	}
	return 0;
}

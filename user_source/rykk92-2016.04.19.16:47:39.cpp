#include<iostream>
#include<algorithm>
#include<array>
using namespace std;
struct Z{
	int a;
	char b;
	double c;
};
class AAA{
	public:
	Z z[10];i
//	AAA():z({0}){}
};
void main(){
	AAA c;
	array<Z,10> a;
	for(int i=0;i<10;i++){
		cout << a[i].a << a[i].b <<a[i].c<<endl;
	}
//	fill(z,z+10,Z(1,1,2));
	return 0;
}

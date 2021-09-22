// example of template for unbound c array type like int a[] = { 1, 2, 3 };
#include <iostream>

template<typename T>
void foo( T (& array)[] )
{
	std::cout << "foo(T(&array)[])" << std::endl;
}

template<typename T, size_t sz>
void foo( T (& array)[sz] )
{
	std::cout << "foo(T(&array)[sz])" << std::endl;
}

extern int arr[];

int main(int argc, const char* argv[])
{
	int b[] = {1, 2, 3};
	
	foo(arr);
	foo(b);
	
	return 0;
}

int arr[] = {1, 2, 3, 4};
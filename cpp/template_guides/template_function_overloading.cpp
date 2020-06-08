//example of function overloading with template

#include <iostream>

template<typename T>
auto max(T a,  T b)
{
	std::cout << "template max" << std::endl;
	return a > b ? a : b;
}

int max(int a, int b)
{
	std::cout << "free function" << std::endl;
	return a > b ? a : b;
}


int main(int argc,  const char* argv[])
{
	auto a = max(1, 3); // call ordinary function
	auto b = max(2.4, 2.1);
	auto c = max<>(5,3); // call template version
	return 0;
}
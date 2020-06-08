#include <cstring>
#include <iostream>

//leack example

template<class T>
const T& max( const T& a, const T& b)
{
	std::cout << "common max" << std::endl;
	return a < b ? b : a;
}

const char* max(const char* a,  const char* b)
{
	std::cout << "const char* max" << std::endl;
	return std::strcmp(b, a) < 0 ? a : b;
}

template<typename T>
const T& max(const T& a, const T& b, const T& c)
{
	return max( max(a,b), c);
}

int main(int argc, const char* argv[])
{
	const char* s1 = "abc";
	const char* s2 = "abcde";
	const char* s3 = "abcdef";
	
	auto m2 = ::max(s1, s2, s3); // possible leack
	return 0;
}
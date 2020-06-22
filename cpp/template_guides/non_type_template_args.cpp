// example of using of non type template args
#include <iostream>
#include <string>
#include <type_traits>

template<const char* const name>
void print_name()
{
	std::cout << std::string(name) << std::endl;
}

template<const char* name>
class MyClass
{
};


template<decltype(auto) N> // C++17
struct C
{
	using type = decltype(N);
};

int main(int argc, const char* argv[])
{
	//print_name<"not_compiled_name">();
	static const char name_1[] = "compile_name_1"; 
	print_name<name_1>();
	MyClass<name_1> mc;
	static int i; // only static storage duration is acceptable for C<i>
	std::cout << std::boolalpha << std::is_reference<C<(i)>::type>::value << std::endl;
	
	return 0;
}
//solution for creating sfinae template that check existing size_type and size() method
#include <iostream>
#include <vector>

template<typename T>
auto len(const T& t) -> decltype( (void)(t.size()), T::size_type() ) // by t.size() we check that T has a method size() during template substitution
{
	return t.size();
}

int main()
{
	std::allocator<int> x;
	std::vector<int> a = {1, 2, 3};
	//auto l = len(x); //should be an error during sfinae
	auto l = len(a);
	std::cout << "size: " << l << std::endl;
	return 0;
}
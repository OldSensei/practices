// example of various using of variadic template
#include <array>
#include <cstdint>
#include <iostream>
#include <utility>

template<typename T, size_t size>
class MyArray
{
public:
	template<typename ... Args>
	MyArray(Args&& ... args) : data{ std::forward<Args>(args)...}
	{}
	
	friend std::ostream& operator<<(std::ostream& os, const MyArray<T, size>& a)
	{
		for(const auto& e : a.data)
			os << e << std::endl;
		
		return os;
	}
	
private:
	T	data[size];
};

// deduction guide
template<typename T, typename ... U>
MyArray(T, U...) -> MyArray<T, (1 + sizeof...(U))>;


//fold expression example
template<typename ... Args>
auto static_sum( Args&&... args )
{
	return  (0 + ... + args);
}

template<typename T, size_t N, size_t... Indeces>
auto array_sum_impl(const T (&arr)[N], std::index_sequence<Indeces...>)
{
	return static_sum(arr[Indeces]...);
}

template<typename T, size_t N>
auto array_sum(const T (&arr)[N])
{
	return array_sum_impl(arr, std::make_index_sequence<N>{});
}


//example of using
template<typename ... Bases>
class Derived: public Bases...
{
public:
	using Bases::operator()...;
};

class A
{
		public:
		void operator()(int c)
		{
			std::cout << "A::operator(" << c << ")" << std::endl;
		}
};

class B
{
		public:
		void operator()(int c, int d)
		{
			std::cout << "A::operator(" << c << "," << d << ")" << std::endl;
		}
};

int main(int argc, const char* const argv[])
{
	MyArray ma{1, 2, 3, 4, 5};

	std::cout << ma;
	
	int a[3] = {5, 6, 3};
	std::cout <<  array_sum(a) << std::endl;

	Derived<A, B> dab;
	dab(1);
	dab(1,2);
	return 0;
}
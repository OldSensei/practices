#include <string_view>
#include <utility>
#include <array>
#include <iostream>

namespace detail
{
	template<const std::string_view& str1, typename, const std::string_view& str2, typename>
	struct concat;

	template<const std::string_view& str1, size_t ... Indeces1, const std::string_view& str2, size_t ... Indeces2>
	struct concat<str1, std::index_sequence<Indeces1...>, str2, std::index_sequence<Indeces2...>>
	{
		static constexpr std::array<char, sizeof...(Indeces1) + sizeof...(Indeces2) + 1> value{ str1[Indeces1]..., str2[Indeces2]..., 0 };
	};
}

namespace
{
	template<const std::string_view& ... strs> struct concat;
	
	template<>
	struct concat<>
	{
		static constexpr std::string_view value = "";
	};

	template<const std::string_view& str1, const std::string_view& str2>
	struct concat<str1, str2>
	{
		static constexpr std::string_view value = detail::concat<str1, std::make_index_sequence<str1.size()>,
									str2,  std::make_index_sequence<str2.size()>>::value.data();
	};

	template<const std::string_view& str, const std::string_view& ... rest_strs>
	struct concat<str, rest_strs...>
	{
		static constexpr std::string_view value = concat<str, concat<rest_strs...>::value>::value;
	};

}

static constexpr std::string_view hello = "Hello ";
static constexpr std::string_view world = "World!";
static constexpr std::string_view result = "Hello World!";

int main()
{
	constexpr std::string_view str = concat<hello, world>::value;
	static_assert(str == result);
	std::cout << str << std::endl;
	return 0;
}
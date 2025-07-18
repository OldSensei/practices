#include "data_structures/avl_tree.hpp"
#include "sort/radix.hpp"

#include <iostream>
#include <iterator>
#include <vector>
#include <type_traits>
#include <algorithm>

#include "data/test_data_settings.hpp"
#include "utils/test_data_reader.hpp"
#include "utils/timer.hpp"

namespace
{
	template<typename T>
	void print(const data_struct::AVLTree<T>& tree)
	{
		if (tree.isEmpty())
		{
			std::cout << "null" << std::endl;
		}

		for (const auto& it : tree)
		{
			std::cout << it << " ";
		}

		std::cout << std::endl;
	}
}

int main(int argc, const char* argv[])
{
	/*auto input = Test::Data::readFromBinFile(Test::Data::DATA_FILENAME);
	auto copy = input;
	std::uint64_t timerValueStorage = 0;

	{
		Utils::Timer t{ timerValueStorage };
		Sort::radix<3>(input);
	}
	std::cout << std::endl << "elapsed: " << timerValueStorage << " ns" << std::endl;

	{
		Utils::Timer t{ timerValueStorage };
		std::sort(copy.begin(), copy.end());
	}
	std::cout << "std::sort elapsed: " << timerValueStorage << " ns" << std::endl;

	std::cout << "array correctly sorted: " << std::boolalpha << (input == copy) << std::endl;
	*/

	data_struct::AVLTree<int> tree;

	tree.Add(15);
	tree.Add(9);
	tree.Add(20);
	tree.Add(7);
	tree.Add(8);
	tree.Add(16);
	tree.Add(10);
	tree.Add(12);
	tree.Add(6);

	print(tree);

	std::cout << std::endl;
	tree.Remove(6);
	print(tree);

	std::cout << std::endl;
	tree.Remove(7);
	print(tree);

	return 0;
}
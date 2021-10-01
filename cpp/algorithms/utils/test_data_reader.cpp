#include "test_data_reader.hpp"

#include <fstream>
namespace Test::Data
{
	std::vector<std::uint64_t> readFromBinFile(std::string_view filename)
	{
		std::vector<std::uint64_t> data;
		std::ifstream f(filename.data(), std::ios::binary);
		if (f)
		{
			std::uint32_t number = 0;
			f.read(reinterpret_cast<char*>(&number), sizeof(std::uint32_t));
			std::uint64_t length{ number };
			data.reserve(length);
			while (f.read(reinterpret_cast<char*>(&number), sizeof(std::uint32_t)))
			{
				data.emplace_back(number);
			}
		}
		return data;
	}
} // namespace Test::Data
#pragma once

#include <string_view>
#include <vector>

namespace Test::Data
{
	std::vector<std::uint64_t> readFromBinFile(std::string_view filename);
} // namespace Test::Data

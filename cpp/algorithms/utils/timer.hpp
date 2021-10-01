#pragma once

#include <chrono>
#include <cstdint>

namespace Utils
{
	class Timer
	{
	public:
		explicit Timer(std::uint64_t& timeStorage);
		~Timer();

	private:
		std::uint64_t& storage;
		std::invoke_result_t<decltype(std::chrono::high_resolution_clock::now)> start;
	};

} // namespace Utils

#include "timer.hpp"

namespace Utils
{
	Timer::Timer(std::uint64_t& timeStorage) :
		storage{timeStorage},
		start{ std::chrono::high_resolution_clock::now() }
	{}

	Timer::~Timer()
	{
		auto endTime = std::chrono::high_resolution_clock::now();
		storage = (endTime - start).count();
	}
} // namespace Utils

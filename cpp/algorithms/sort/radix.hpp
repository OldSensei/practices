#pragma once

#include <array>
#include <cstdint>
#include <vector>

namespace Sort
{
	template<std::uint8_t DigitCount, template<typename...> typename C, typename ... Cargs>
	void radix(C<Cargs...>& input)
	{
		auto temp = input;

		auto processInput = [](const auto& input, auto& output, std::uint64_t exp)
		{
			std::array<std::uint64_t, 10> digits = {};
			for (auto number : input)
			{
				const std::uint8_t digit = static_cast<std::uint8_t>((number / exp) % 10);
				++digits[digit];
			}

			for (std::uint8_t index = 1; index < digits.size(); ++index)
			{
				digits[index] += digits[index - 1];
			}

			for (std::uint64_t index = input.size() - 1; index < input.size(); --index)
			{
				auto number = input[index];
				const std::uint8_t digit = static_cast<std::uint8_t>((number / exp) % 10);
				output[--digits[digit]] = input[index];
			}
		};

		std::add_pointer_t<std::remove_reference_t<decltype(input)>> origin = nullptr;
		auto result = origin;
		if constexpr (DigitCount % 2 == 0)
		{
			origin = &temp;
			result = &input;
		}
		else
		{
			origin = &input;
			result = &temp;
		}

		std::uint64_t exp = 1;
		for (std::uint8_t degree = 0; degree < DigitCount; ++degree)
		{
			result = std::exchange(origin, result);
			processInput(*origin, *result, exp);
			exp *= 10;
		}
	}
} // namespace Sort
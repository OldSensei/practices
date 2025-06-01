#include <cstddef>
#include <array>
#include <bit>
#include <iostream>

namespace
{
    enum class Endianness
    {
        little = 0,
        big = 1,
        unsupported = 2
    };

    //type punning is not allowed in compile-time, so unsafe (implying UB) runtime version:
    Endianness GetEndiannessUB()
    {
        union 
        {
            std::uint16_t number;
            std::array<std::byte, 2> byteRepresentation;
        } mix {0x0102};

        // in c++ compile time we can't use non-active union member
        if (mix.byteRepresentation[0] == std::byte{0x02}) 
        {
            return Endianness::little;
        }
        else if (mix.byteRepresentation[0] == std::byte{0x01})
        {
            return Endianness::big;
        }

        return Endianness::unsupported;
    }

    // a bit safer approach using memcpy, but still it's runtime
    Endianness GetEndiannessMem()
    {
        std::uint16_t magic = 0x0102;
        std::array<std::byte, sizeof(magic)> bytes;

        std::memcpy(bytes.data(), &magic, sizeof(magic));

        if (bytes[0] == std::byte{0x02}) 
        {
            return Endianness::little;
        }
        else if (bytes[0] == std::byte{0x01})
        {
            return Endianness::big;
        }

        return Endianness::unsupported;
    }

    // you get the idea... Just check what platform we are compiling for
    consteval Endianness GetEndiannessHack()
    {
        #if defined(_MSC_VER) && (defined(_M_X64) || defined(_M_IX86))
            return Endianness::little;
        #else
            return Endianness::unsupported;
        #endif
    }

    // since c++20, compile-time portable way
    consteval Endianness GetEndiannessCt()
    {
        if constexpr (std::endian::native == std::endian::little)
        {
            return Endianness::little;
        }
        else if constexpr (std::endian::native == std::endian::big)
        {
            return Endianness::big;
        }
        return Endianness::unsupported;
    }

    std::ostream& operator<<(std::ostream& out, const Endianness& endianness)
    {
        switch (endianness)
        {
        case Endianness::little:
                return out << "little";
        case Endianness::big:
                return out << "big";
        }
        
        return out << "unsupported";
    }
}


int main()
{
    std::cout << "GetEndiannessUB endiannes: " << GetEndiannessUB() << std::endl;
    std::cout << "GetEndiannessMem endiannes: " << GetEndiannessMem() << std::endl;

    constexpr const Endianness endian = GetEndiannessCt();
    static_assert(endian == Endianness::little);

    constexpr const Endianness endian2 = GetEndiannessHack();
    static_assert(endian2 == Endianness::little);

    return 0;
}
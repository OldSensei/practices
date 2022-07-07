io.write(string.format("%x", 0xff & 0xabcd), "\n") -- 0xcd
io.write(string.format("%x", 0xff | 0xabcd), "\n") -- 0xabff
io.write(string.format("%x", 0xaaaa ~ -1), "\n") -- 0xffffffffffff5555
io.write(string.format("%x", ~ 0), "\n") -- ffffffffffffffff

-- bit shift
io.write(string.format("%x", 0xff << 12), "\n") -- ff000
io.write(string.format("%x", 0xff >> -12), "\n") -- ff000

io.write(string.format("%x", -1 << 80), "\n") -- 0 coze max bit count is 64

-- unsigned integer
local x = 3 << 62 -- Lua doesn't have dedicated type for unsigned values
io.write(string.format("0x%x", x), "\n")
io.write(string.format("%u", x), "\n")

-- comparison
print(0x7fffffffffffffff < 0x8000000000000000) -- false
print(math.ult(0x7fffffffffffffff, 0x8000000000000000)) -- true
local mask = 0x8000000000000000
print((0x7fffffffffffffff ~ mask) < (0x8000000000000000 ~ mask)) -- true

-- packing & unpacking
local s = string.pack("iii", 1, -2, 450)
print(#s) -- 12
print(string.unpack("iii", s)) -- 1 -2 450 13 - the last number is the position after the last item read

s = "hello\0Lua\0world\0"
local i = 1
while i<= #s do
    local res
    res, i = string.unpack("z", s, i) -- third argument - a position where to start reading from
    print(res)
end

--[[
    integer coding options:
    b - char
    h - short
    i - int
    l - long
    j - Lua integer size
    in - where n is a number from 1 to 16 (i7, i4 etc) is machine independed fixed size integer (in bytes)
]]
local x = string.pack("i7", 1 << 54)
print(string.unpack("i7", x)) -- 18014398509481984       8
x = string.pack("i7", -(1 << 54))
print(string.unpack("i7", x)) -- -18014398509481984      8

-- x = string.pack("i7", 1 << 55) -- integer overflow error

-- upper - case option for integer - unsigned version
s = "\xFF"
print((string.unpack("b", s))) -- -1
print((string.unpack("B", s))) -- 255

--[[
    string coding options
    z - zero terminated string
    cn - string with a fixed length n
    sn - string with explicit length, n - size of unsigned integer to store string length
]]

s = string.pack("s1", "hello")
for i = 1, #s do print((string.unpack("B", s, i))) end
--[[
5 - length
104 - h
101 - e
108 - l
108 - l
111 - o
]]

--[[
    float coding options
    f - single precision
    d - double precision
    n - lua float
]]
-- endianess: > big endian; < little endian
print("--endianess--")
s = string.pack(">i4", 1000000) -- 0000 0000 0000 1111 0100 0010 0100 0000
for i = 1, #s do print((string.unpack("B", s, i))) end
--[[
    0   - 0000 0000
    15  - 0000 1111
    66  - 0100 0010
    64  - 0100 0000
]]

s = string.pack("<i2 i2", 500, 24)
for i = 1, #s do print((string.unpack("B", s, i))) end
--[[
    244 - 1111 0100
    1   - 0000 0001
    24  - 0001 1000
    0   - 0000 0000
]]

-- option = - return the default native machine's endianess

-- alignes: !n - force data to be aligned at indeces that are multiples of n
print("alignes")
s = string.pack("i5 !8i4", 245, 0x7AA)
for i = 1, #s do print((string.unpack("B", s, i))) end

--binary files
local f = assert(io.open([[e:\work\projects\practices\lua\bits_bytes.lua]], "rb"))
local blockSize = 16
while true do
    local bytes = f:read(blockSize)
    if not bytes then break end
    for i = 1, #bytes do
        local b = string.unpack("B", bytes, i)
        io.write(string.format("%02X ", b))
    end
    io.write(string.rep("   ", blockSize - #bytes))
    bytes = string.gsub(bytes, "%c", ".")
    io.write(" ", bytes, "\n")
end
f:close()

-- exercises
-- 1
local function udiv (n, d)
    if d < 0 then
    if math.ult(n, d) then return 0
    else return 1
    end
    end
    local q = ((n >> 1) // d) << 1
    local r = n - q * d
    if not math.ult(r, d) then q = q + 1 end
    return q
end

local function umod(a, b)
    local r = udiv(a, b)
    return a - b * r
end

print(umod(3 << 62,5))

-- 4
local function HammingWeight(num)
    local weight = 0
    local bin = string.pack("j", num)
    for i = 1, #bin do
        local n = string.unpack("B", bin, i)
        for j = 0, 7 do
            if ((n >> j) & 0x1 == 0x1) then
                weight = weight + 1
            end
        end
    end
    return weight
end

print(HammingWeight(0xFFFA))

-- 6
local function newBitArray(n)
    local array = { bitCount = n, store = "" }
    local byteCount = math.floor(n / 8)

    if ((n / 8  - byteCount) > 0.0) then
        byteCount = byteCount + 1
    end

    for i=1, byteCount do
        array.store = array.store .. string.pack("B", 0)
    end

    return array
end

local function setBit(a, n, v)
    assert(n <= a.bitCount)

    local byteIndex = math.floor(n / 8) + 1
    local byte = string.unpack("B", a.store, byteIndex)
    local bitIndex = n - (byteIndex - 1) * 8

    local mask = 0x1 << bitIndex
    if v then
        byte = byte | mask
    else
        mask = ~mask
        byte = byte & mask
    end
    
    local newString = ""
    for i = 1, #a.store do
        if (i ~= byteIndex) then
            newString = newString .. string.pack("B", string.unpack("B", a.store, i))
        else
            newString = newString .. string.pack("B", byte)
        end
    end
    a.store = newString
end

local function testBit(a, n)
    assert(n <= a.bitCount)

    local byteIndex = math.floor(n / 8) + 1
    local byte = string.unpack("B", a.store, byteIndex)
    local bitIndex = n - (byteIndex - 1) * 8

    local v = (byte >> bitIndex) & 0x1
    return v == 0x1
end

local ar = newBitArray(16)
setBit(ar, 0, true)
setBit(ar, 15, true)
print(testBit(ar, 0))
print(testBit(ar, 1))
print(testBit(ar, 15))
setBit(ar, 0, false)
print(testBit(ar, 0))
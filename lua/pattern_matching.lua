-- string.find
local str = "world hello world"
local i, j = string.find(str, "hello")
print(i, j, string.sub(str, i, j))
print(string.find(str, "aaa"))

print(string.find(str, "world"))
print(string.find(str, "world", 6)) -- start from 6
-- string.find(str, "[") cause an error becouse "[" has a special meaning
print(string.find(str, "[", 1, true)) -- last parametr means plain searching

-- string.match
print(string.match(str, "hello")) -- print hello
local date = "Today is 17/7/1990"
print(string.match(date, "%d+/%d+/%d+")) -- print 17/7/1990

-- string.gsub

local a, number = string.gsub("Lua is cute cute", "cute", "greate")
print(a, number) -- Lua is greate greate
a = string.gsub("Lua is cute cute", "cute", "greate", 1)
print(a) -- Lua is greate cute

-- string.gmatch
local s = "some string"
local words = {}
for w in string.gmatch(s, "%a+") do
    words[#words + 1] = w
end

for i = 1, #words do
    print(words[i])
end


--[[
    character classes
    . - all characters
    %a - letters
    %c - control character
    %d - digits
    %g - printable characters except space
    %l - lower - case letters
    %p - punctuation character
    %s - space characters
    %u - upper-case character
    %w - alphanumeric character
    %x - hexadecimal digits
]]

-- Upper-case version of any of the character classes represent the complement of the class.
print((string.gsub("hello, world!", "%A", "."))) -- "hello..world." i.e %A means any non letter character

-- char-set: []
print((string.gsub("Hello 123 890", "[0-7]", "."))) -- Hello ... 89.
-- complement of char-set: [^]
print((string.gsub("Hello 123 890", "[^0-7]", "."))) -- ......123...0

--[[
modifiers
+ - 1 or more repetition
* - 0 or more repetition
- - 0 or more repetition (lazy i.e. shortest)
? - 0 or 1 repetition
]]
print((string.gsub("() asd(d ) m ( )", "%(%s*%)", "s"))) -- s asd(d ) m s


-- balanced sting: %b
print((string.gsub("a (enclosed (in) parentheses) line", "%b()", ""))) -- a line
print((string.gsub("a astring b", "%bab", ""))) -- a

-- frontier pattern: %f[char-set] - match an empty string if next char in char-set but the previous one is not:
print((string.gsub("the anthem is the theme", "%f[%w]the%f[%W]", "one"))) -- one anthem is one theme

-- captures:
pair = "name = Anna"
key, value = string.match(pair, "(%a+)%s*=%s*(%a+)") -- match return all captures
print(key, value) -- name Anna

q, quotted =  string.match([[then he said: "It's all right!"]], "([\"'])(.-)%1") -- %n, where n is digit - get results of n-th capturing
print("q:", q, "quotted:", quotted)

local trim = function(s)
    local s = string.gsub(s, "^%s*(.-)%s*$", "%1") -- ^ in the beginning of pattern: start of the line; $ - in the end of pattern: the end of line
    return s
end

print(trim("  AbcD Tr "))
print((string.gsub("hello world!", "%a", "%0-%0"))) -- %0 means all match

local function expand(s)
    local substitution = { world = "moon", hello = "greetings"}
    return (string.gsub(s, "$(%w+)", substitution))
end

local function expand2(s)
    local substitution = { world = "moon", hello = "greetings", a = 0x8ffff}
    return (string.gsub(s, "$(%w+)", function (n) return tostring(substitution[n]) end))
end

print(expand("Hello $world"))
print(expand("Hello $moon"))
print(expand2("Hello $a"))

-- url encoding
local function unescape(s)
    local s = string.gsub(s, "+", " ")
    s = string.gsub(s, "%%(%x%x)", function (n)
        return string.char(tonumber(n, 16))
    end)
    return s
end

local function escape(s)
    local s = string.gsub(s, "[&=+%%%c]", function (n)
        return string.format("%%%02X", string.byte(n))
    end)
    s = string.gsub(s, " ", "+")
    return s
end


local cgi = {}
local function decode(s)
    for name, value in string.gmatch(s, "([^&=]+)=([^&=]+)") do
        name = unescape(name)
        value = unescape(value)
        cgi[name] = value
    end
end

local function encode(t)
    local tb = {}
    for name, value in pairs(t) do
        tb[#tb + 1] = (escape(name) .. "=" .. escape(value))
    end
    return table.concat(tb, "&")
end

decode([[name=al&query=a%2Bb+%3D+c&q=yes+or+no]])
for key, value in pairs(cgi) do
    print(key, value)
end

print(encode(cgi))

-- special meaning of ()
print(string.match("hello", "()ll()")) --  3 5 () returns position 

-- exercises
--1
local function split(str, delim)
    local dict = {}
    local delim = "[^" .. delim .. "]+" -- todo: add escaping
    for word in string.gmatch(str, delim) do
        dict[#dict + 1] = word
    end
    return dict
end

w = split("a whole new world", " ")
for _,v in ipairs(w) do
    print( v )
end

--3
local function transliterate(str, map)
    return (string.gsub(str, "(%w+)", 
                function (n)
                    if map[n] == nil then
                        return n
                    end
                    return (map[n] or "")
                end))
end
print("exercise 3:", '"' .. transliterate( "ala  ba bar", { ala="b1", bar=false}) .. '"')

--5
local function escape_2(input_str)
    return (string.gsub(input_str, ".", function (n) return string.format("\\x%02X", string.byte(n)) end))
end
print(escape_2("\0\1hello\200"))

--7
local function reverseUtf8(str)
    local result = ""
    for c in string.gmatch(str, utf8.charpattern) do
        result = c .. result
    end
    return result
end

print("\xE2\x88\x9E", reverseUtf8("\xE2\x88\x9E"))
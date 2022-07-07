a = "one string"
b = string.gsub(a, "one", "another")

print("a:", a)
print("b:", b)

print("length of a:", #a) -- length always in bytes
print("length of b:", #b)

c = a .. ' ' .. b -- concatenation
print(c)

-- long string equals c++ raw strings
d = [[
<html>
<head>
<title>An HTML page</title>
</head>
<body>
 <a href="http://www.lua.org">Lua</a>
</body>
</html>
]]
print(d)

-- in case if string contains [[ or ]]
-- you can vary [[]] by change number of '=' character 
e = [==[
a = b[c[i]]
]==]

f = [===[
a = b[c[i]==]
]===]
print(e)
print(f)


print('string library:')
print('string.len(a):', string.len(a))
print('string.rep("b", 4):', string.rep('b', 4))
print('string.reverse("a long line"):', string.reverse("a long line"))
print('string.lower("A Long line"):', string.lower("A Long line"))
print('string.upper("a long line"):', string.upper("a long line"))
print('string.sub("a long line", 1, 3):', string.sub("a long line", 1, 3))
print('string.sub("a long line", 1, -1):', string.sub("a long line", 1, -1))
print('string.sub("a long line", 2, -2):', string.sub("a long line", 2, -2))
print('string.char(97):', string.char(97))
print('string.char(97, 98, 99, 100):', string.char(97, 98, 99, 100))
print('string.byte("abcd"):', string.byte("abcd"))
print('string.byte("abcd", 1):', string.byte("abcd", 1))
print('string.byte("abcd", 2):', string.byte("abcd", 2))
print('string.byte("abcd", -1):', string.byte("abcd", -1))
print('string.byte("abcd", 1, -1):', string.byte("abcd", 1, -1))
print('string.format("x=%d y=%f z=0x%X y1=%.4f s=%s x1=%02d", 10, 11.23, 12, 7.0, "abcd", 7):', string.format("x=%d y=%f z=0x%X y1=%.4f s=%s x1=%02d", 10, 11.23, 12, 7.0, "abcd", 7))
print('string.find("Hello world!", "wor"):', string.find("Hello world!", "wor"))
print('string.find("Hello world!", "war"):', string.find("Hello world!", "war"))
print('string.gsub("hello world", "l", "."):', string.gsub("hello world", "l", "."))
print('string.gsub("hello world", "a", "."):', string.gsub("hello world", "a", "."))

function insert(str, pos, inserted_str)
    before = string.sub(str, 1, pos - 1)
    after = string.sub(str, pos, -1)
    return before .. inserted_str .. after
end

print(insert("hello world!", 1, "start: "))
print(insert("hello world!", -1, " :end"))
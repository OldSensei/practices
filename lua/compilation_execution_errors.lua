-- load function use to run a chunk of lua code

local path = string.match(arg[0], [[(.+\)]])

f = load("i = i + 1")

i = 0
f();
print(i) -- 1
f()
print(i) -- 2

j = 10
local j = 0
g = load("j = j + 1; print(j)") -- always compile a chunk in the global environment
h = function() j = j + 1; print(j) end

g() -- 11
h() -- 1

f = assert(loadfile(path .. [[data\foo.lua]]))
print(foo) -- nil, coze we just compile code,but do not run it
f() -- do actually assignment of foo
print(foo)
foo("aaa")

--[[
    to create a binary compiled file:
    luac54 <filename>

    to list generated opcodes:
    luac -l
]]

local function sb(x, y, z)
    local a = x + y - z
    return a
end

print("Binary Representation of a lua function: ")
local bytes = string.dump(sb)
for i = 1, #bytes do
    local b = string.unpack("B", bytes, i)
    io.write(string.format('%02x ', b))
    if i % 16 == 0 then
        io.write("\n")
    end
end

io.write('\n')

-- error handling

--print("enter the number:")
--[[
    this below is equals to:
    n = io.read("*n")
    if not n then
        error("Invalid argument")
    end
]]
--local n = assert(io.read("*n"), "Invalid argument")

-- using of pcall - protected call
local isOk, ret = pcall(function()
    print(c[1]) -- rise error if c is not a table
end)

print('isOk:', isOk)
print('ret:', ret)

-- pcal return any object that was put to the error
isOk, ret = pcall(
    function()
        error({code = 121})
    end
)
print('isOk:', isOk)
print('ret:', ret.code) -- 121

-- tracebak

local function foo2(str)
    if type(str) ~= 'string' then
        error("argument not a string", 2)
    end
    io.write(str)
end

local function bar()
    n = 1
    foo2(n)
end

print('xpcall:')
isOk, ret = xpcall(function() bar() end, debug.traceback)
print('ret:', ret)


-- exercises
--16.1
local function loadwithprefix(prefix, code)
    local n = 1
    local t = {prefix, code, nil}
    local function reader()
        local ret = t[n]
        n = n + 1
        return ret
    end
    local f = assert(load(reader))
    return f
end

local fv = loadwithprefix('local a = ...; ', "a = a + 2; return a")
print(fv(100))

--16.2
local function multiload(...)
    local t = table.pack(...)
    local n = 1
    local function reader()
        local a = n
        n = n + 1
        print("t[", a, "] = ", t[a])
        return t[a]
    end
    local f = assert(load(reader))
    return f
end

local fv2 = multiload("local x = 10;", "x = x + 1;", "print(x);")
fv2()

--16.3
local function stringrep_n(s, n)
    local program = "local s = '" .. s .."'; local r ='';"
    local n = n
    while n > 1 do
        if n % 2 ~= 0 then 
            program = program .. " r = r .. s;"
        end
        program = program .. " s = s .. s;"
        n = math.floor(n/2)
    end
    program = program .. " r = r .. s; return r;"
    print("program:", program)
    return assert(load(program))
end


local string_ab_5 = stringrep_n("ab", 5)
print("string_5(ab): ", string_ab_5())
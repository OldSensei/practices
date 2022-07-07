-- function without parenthesis
print 'Hello world!'

print { a = 'a', b = 'b' }

function aaa(a, b, c)
    print("a:", a, "b:", b, "c:", c)
end

-- call with less argument count
aaa(1, 2, 3)
aaa(1, 2)
aaa(1)
aaa()

-- call with greater argument count
aaa(1, 2, 3, 4)

--multiple results
s, e = string.find("Hello Lua!", "Lua")
print('string.find("Hello Lua!", "Lua"):', s, e)

function maximum(sequence)
    local i = 1
    local m = sequence[i]
    for k = 2, #sequence do
        if sequence[k] > m then
            m = sequence[k]
            i = k
        end
    end
    return m, i
end

print("maximum{1, 2, 54, 6, 10, 4}:", maximum{1, 2, 54, 6, 10, 4})


function foo0() end
function foo1() return "a" end
function foo2() return "a", "b" end

x, y = foo2(); print("x, y = foo2(): ", x, y)
x = nil 
y = nil
x = foo2(); print("x = foo2(): ", x, y)
x, y, z = 10, foo2(); print("x, y, z = 10, foo2():", x, y, z)

x, y = foo0(); print("x, y = foo0(): ", x, y)
x, y = foo1(); print("x, y = foo1(): ", x, y)

-- multiple results are returned only if function take the last place in expression
x, y = foo2(), 20; print("x, y = foo2(), 20:", x, y)
x, y = foo0(), 20, 30; print("x, y = foo0(), 20, 30:", x, y)

print(foo2())
print(foo2() .. "x")

x = { foo2() }
for k, v in ipairs(x) do
    print("[" .. k .. "] = " .. v)
end

print("\n")
x = { foo0(), foo2() }
print("[1] = " .. (x[1] or "nil"))
print("[2] = " .. x[2])
print("[3] = " .. x[3])

print("\n")
x = { foo2(), 20 } -- in such case only first foo2 value is used
for k, v in ipairs(x) do
    print("[" .. k .. "] = " .. v)
end

function foo4(mode)
    if (mode == 0) then return foo0()
    elseif (mode == 1) then return foo1()
    else return foo2()
    end
end

print(foo4(2))

-- variadic function
function add(...)
    print("add args:", ...)
    s = 0
    for _, v in ipairs({...}) do
        s = s + v
    end
    return s
end

print(add(12, 1, 2, 5))

--[[]
table.pack
table.unpack
]]--

function nonil(...)
    t = table.pack(...)
    for k = 1, t.n do
        if (t[k] == nil) then return false end
    end
    return true
end

print(nonil(1, 2, nil))
print(nonil(1, 2, 3))
print(table.unpack{1, 2, 3})
a, b = table.unpack{ 10, 23, 4} -- only first two elements
print(a, b)

print(table.unpack({"Sun", "Mon", "Tue", "Wed"}, 2, 3)) -- get 2nd and 3rd elements

-- tail call
function f(x, sum)
    if (x > 0) then return f(x - 1, sum + x)
    else return sum end
end

print(f(5, 0))


-- exercises
--1.
function print_array(a)
    print(table.unpack(a))
end

print_array{ 1, 2, 3, 5, 10}

--2.
function ret_args(...)
    return select(2, ...)
end

print(ret_args(1, "a", "b", 5))

--4.
function copy_except(t, n)
    local new = {}
    local i = 1
    for k, v in ipairs(t) do
        if k ~= n then
            new[i] = v
            i = i + 1
        end
    end
    return new
end

function comb(t, s)
    local result = {{}}
    local insert_index = 1
    if t == nil then return result end

    for k = 1, #t do
        local new = copy_except(t, k)
        local r = comb(new, s + 1)
        for j = 1, #r do
            result[insert_index] = { t[k], table.unpack(r[j])}
            insert_index = insert_index + 1
        end
    end
    return result
end

r = comb({1, 2, 3}, 1)
for k, v in ipairs(r) do
    s = ""
    for j = 1, #v do
        s = s .. v[j] .. " "
    end
    print(s)
end

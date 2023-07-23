co = coroutine.create(function () print("hi") end)
print(type(co))  -- print a "thread" type
-- coroutine 4 statuses: suspended, running, normal, dead
print(coroutine.status(co)) -- suspended

-- to run a coroutine call resume
coroutine.resume(co) -- hi

print(coroutine.status(co)) -- dead status

-- yield to suspend coroutine
co = coroutine.create(function ()
    for i = 1, 5 do
        print("co", i)
        coroutine.yield()
    end
end)

coroutine.resume(co) -- co 1
print(coroutine.status(co)) -- suspend

coroutine.resume(co) -- co 2
coroutine.resume(co) -- co 3
coroutine.resume(co) -- co 4
coroutine.resume(co) -- co 5
coroutine.resume(co) -- nothing; coroutine finished execution

-- next calling of coroutine after the one had finished results to error
print(coroutine.resume(co)) -- like pcall: no rised error but return false and error description

-- if coroutine resume another it's state is normal (resumed coroutine has running state)

-- the first resume which doesn't have corresponding yield can pass arguments to main coroutine function:
co = coroutine.create( function (a, b, c)
    print("co", a, b, c + 5)
end)

coroutine.resume(co, 1, 2, 3) -- co 1 2 8

-- coroutine.resume returns true/false (if coroutine successfull) and aditional arguments had put to yield call
co = coroutine.create( function (a, b)
    coroutine.yield(a + b, a - b)
end)
print(coroutine.resume(co, 20, 10)) -- true 30 10

-- coroutine.yield returns all additional arguments passed to corresponding resume:
co = coroutine.create( function (x)
    print("co1", x)
    print("co2", coroutine.yield())
end)

coroutine.resume(co, "hi") -- co1 hi
coroutine.resume(co, 4, 5, 6) -- co2 4 5 6

-- when coroutine finished it's returned values passed to the corresponding resume:
co = coroutine.create( function()
return 6, 7
end)
print(coroutine.resume(co)) -- true 6 7

--[[
    consumer - producer implimentation by corutines
]]

local receive = function ( prod )
    local status, value = coroutine.resume(prod)
    return value
end

local send = function ( x )
    coroutine.yield( x )
end

function producer()
    return coroutine.create( function ()
        while true do
            local x = io.read()
            send(x)
        end
    end)
end

function consumer(prod)
    while true do
        local value = receive(prod)
        io.write(value, "\n")
    end
end

-- consumer(producer()) -- infinity reading from console

-- iterators by coroutines:

local function printResult(a)
    for i = 1, #a do io.write(a[i], " ") end
    io.write("\n")
end

local function permgen(a, n)
    n = n or #a
    if n <= 1 then
        coroutine.yield(a)
    else
        for i = 1, n do
            a[i], a[n] = a[n], a[i]

            permgen(a, n - 1)

            a[i], a[n] = a[n], a[i]
        end
    end
end

local function permutations(a)
    local co = coroutine.create( function() permgen(a) end)
    return function () -- iterator itself
        local stat, res = coroutine.resume(co)
        return res
    end
end

for p in permutations{"a", "b", "c", "d"} do
    printResult(p)
end

--[[
    there is in Lua a wrapper for creation of function that resume coroutine ( see iterator example):
    function permutations(a)
        return coroutine.wrap(function() permgen(a) end)
    end

    but there is no way to check the status of a coroutine created, sice it is wrapped by usual function
]]

local template = ";" .. string.match(arg[0], [[(.+\)]]) .. [[modules\?.lua]]
package.path = package.path .. template

local libIO = require "lib_async_io"

function run(code)
    local co = coroutine.wrap(function()
        code()
        libIO.stop()
    end)

    co()
    libIO.runLoop()
end

local plMem = {}
setmetatable(plMem, {
    __mode = "k"
})

function putLine(stream, line)
    local co = coroutine.running() -- access calling coroutine

    local callback = plMem[co] or (function () coroutine.resume(co) end)
    plMem[co] = callback
    print(callback, line)
    libIO.writeLine(stream, line, callback)
    coroutine.yield()
end

local glMem = {}
setmetatable(plMem, {
    __mode = "k"
})

function getLine(stream, line)
    local co = coroutine.running()

    local callback = glMem[co] or (function (l) coroutine.resume(co, l) end)
    glMem[co] = callback

    libIO.readLine(stream, callback)
    local line = coroutine.yield()
    return line
end


----[[
print("Run reversing of input:")
run(function()
    local t = { }
    local inp = assert(io.open([[C:\work\projects\practices\lua\data\inp.txt]], "r")) --io.input()
    local out = assert(io.open([[C:\work\projects\practices\lua\data\out.txt]], "w"))--io.output()

    while true do
        local line = getLine(inp)
        if not line then
            break;
        end
        t[#t + 1] = line
    end

    for i = #t, 1, -1 do
        putLine(out, t[i] .. "\n")
    end
end)

-- Exercises:
-- 24.1

local receive2 = function ( )
    return coroutine.yield()
end

local send2 = function ( cons, value )
    local stat = coroutine.resume( cons, value )
end

function producer2(cons)
    while true do
        local x = io.read()
        send2(cons, x)
    end
end

function consumer2()
    return coroutine.create( function (value)
        local value = value
        while true do
            io.write(value, "\n")
            value = receive2()
        end
    end)
end

-- producer2(consumer2())

--24.2

local function combinations( t, n )
    local res = {}
    local function helper(t, n)
        local last = #t - #res
        for i = 1, last do
            res[#res + 1] = t[i]
            t[i], t[last] = t[last], t[i]

            if (#res < n) then
                 helper(t, n)
            else
                coroutine.yield(res)
            end

            res[#res] = nil
            t[i], t[last] = t[last], t[i]
        end
    end

    return coroutine.wrap( function ()
        helper(t, n)
    end)
end

print("---------------")
for c in combinations({"a", "b", "c"}, 2) do
    printResult(c)
end

-- 24.3
-- see reversing of input
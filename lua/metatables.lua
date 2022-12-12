t = {}
print(getmetatable(t)) -- nil because by default<, Lua do not add meta table to table

t1 = {}
setmetatable(t, t1)
print(getmetatable(t)) -- some address

-- from Lua we can set metatables only for tables, for other values use C

-- for strings Lua uses the one meta table
print(getmetatable("hihi"))
print(getmetatable("hoho"))

local path_to_dir = string.match(arg[0], [[(.+\)]])
local template = ";" .. path_to_dir .. [[modules\?.lua]]
package.path = package.path .. template

-- see module set.lua for addition information
local Set = require "set"

s1 = Set.new{10, 20, 30, 50}
s2 = Set.new{30, 1}
s3 = s1 + s2

print(getmetatable(s1))
print(getmetatable(s2))

print(Set.tostring(s3))

print("(s1 + s2) * s1:", Set.tostring((s1 + s2) * s1))

-- Lua uses the metatable from first argument if it exist with the needed operation
-- if it is not, usong the metatable of second, if it doesn't exist too - throw error
s4 = {}
s5 = {}
st = {
    __add = function(a, b) print("st meta table"); return a; end
}
st2 = {
    __add = function(a, b) print("st2 meta table"); return b; end
}
setmetatable(s4, st)
setmetatable(s5, st2)
s6 = s4 + s5 -- st meta table
s6 = s5 + s4 -- st2

-- relational
s1 = Set.new{2, 4}
s2 = Set.new{4, 10, 2}

print("s1:", s1)
print("s2:", s2)
print("s1 <= s2:", s1 <= s2)
print("s1 < s2:", s1 < s2)
print("s1 >= s1:", s1 >= s1)
print("s1 > s1:", s1 > s1)
print("s1 == s2 * s1:", s1 == s2 * s1)
-- equality for different types is always false

s1 = Set.new{}
print("getmetatable(s1):", getmetatable(s1))
--setmetatable(s1, {}) -- produce error: cannot change a protected metatable

--[[
    table-access metamethods
]]

-- for absent fields use __index
local prototype = {x = 0, y = 0, width = 100, height = 100}
local mt = {}
function new(o)
    setmetatable(o, mt)
    return o
end
mt.__index = function(_, key)
    print("using method")
    return prototype[key]
end

w = new{x=10, y=20}
print(w.width) -- using method\n 100
-- you can assign table directly to __index instead of using methods
mt.__index = prototype
print(w.width) -- 100
-- if we want to access field without using __index, call rawget(t, i)
print(rawget(w, "x")) -- 10
print(rawget(w, "width")) -- nil

-- __newindex is used when we assign a value to an absent index in a table
-- if __newindex is a table then assignment will happen to thid table
-- rawset(t, k, v) is equal to t[k] = v with bypassing any metamethods

--[[ Tables with default values ]]

function setDefault(t, d)
    local mt = {__index = function () return d end}
    setmetatable(t, mt)
end

local tab = {x=10, y = 20}
print(tab.x, tab.z) -- 10 nil
setDefault(tab, 0)
print(tab.x, tab.z) -- 10 0

-- optimized version:
local mt3 = {__index = function (t) return t.___ end}
function setDefault2(t, d)
    t.___ = d
    setmetatable(t, mt3)
end

--[[Tracking table access]]

local track = function(t)
    local proxy = {}
    local mt = {
        __index = function(_, k) -- _ - table, k - key
            print("access to element " .. tostring(k))
            return t[k]
        end,

        __newindex = function(_, k, v)
            print("update element " .. tostring(k) .. " to " .. tostring(v))
            t[k] = v
        end,

        __pairs = function()
            return function(_, k)
                local nextkey, nextvalue = next(t, k) -- next - is a raw function returning next key and the value of that key. next(t, nil) returned the first key 
                if nextkey ~= nil then
                    print("treversing element " .. tostring(nextkey))
                end
                return nextkey, nextvalue
            end
        end,

        __len = function () return #t end
    }

    setmetatable(proxy, mt)
    return proxy
end

t = {}
t = track(t)

t[2] = "hello"
print(t[2])

t = track{10, 20}
print(#t) -- 2
for k, v in pairs(t) do print(k, v) end

--[[read - only tables]]
local readOnly = function(t)
    local proxy = {}
    local mt = {
        __index = t,
        __newindex = function(_, k, v)
            error("Trying to update read only table", 2)
        end
    }
    setmetatable(proxy, mt)
    return proxy
end

t = readOnly({"Sunday", "Monday", "Tuesday", "Wednesday",
"Thursday", "Friday", "Saturday"})

print(t[1]) -- Sunday
-- t[2] = "Noday" -- error

--Exercises
--20.1
s1 = Set.new{10, 20, 30, 50}
s2 = Set.new{30, 1}

print("s1 - s2 = ", s1 - s2)
-- 20.2
print("#s1:", #s1)

-- 20.3
local read_only_mt = {
    __index = function(t, k) return t.__tb[k] end,
    __newindex = function(_, k, v)
        error("Trying to update read only table", 2)
    end
}

local readOnly2 = function(t)
    local proxy = { __tb = t }
    setmetatable(proxy, read_only_mt)
    return proxy
end

local t1 = readOnly2({2, 3, 4})
print(t1[2])
--t1[2] = 1

--20.4 & 20.5
local function fileAsArray(filename)
    if not FilesArrayMT then
        FilesArrayMT = {
            __index = function(t, k)
                if k >= t.__fsize then return nil end

                t.__file:seek("set", k)
                return t.__file:read(1)
            end,
        
            __newindex = function(t, k, v)
                t.__file:seek("set", k)
                local tp = type(v)
                if tp == "number" then t.__file:write(string.char(v))
                elseif tp == "string" then t.__file:write(v:sub(1, 1))
                else
                    error("wrong type of data", 2)
                end
                t.__fsize = t.__file:seek("end")
            end,
        
            __len = function(t) return t.__fsize end,

            __pairs = function(t)
                return function(s, k)
                    local v = s[k]
                    if not v then return nil end
                    return k + 1, v
                end, t, 1
            end
        }
    end

    local proxy = {
        __file = assert(io.open(filename, "r+b"))
    }
    proxy.__fsize = proxy.__file:seek("end")

    setmetatable(proxy, FilesArrayMT)
    return proxy
end

local farr = fileAsArray(path_to_dir .. "data\\external_world_test.txt")
print("farr size:", #farr)
print("farr[17]:", farr[17])
farr[19] = "b"
print("farr size:", #farr, "farr[19]:", farr[19])

print("pairs(farr):")
for _, v in pairs(farr) do
    io.write(v)
end
-- _G - global table with global variables
for n in pairs(_G) do print(n) end

-- dynamic global variables
_G.v1 = "a"
local v = "v1"
print(_G[v])

-- protect a global environment from occasional creating of global varables

local declaredNames = {}
setmetatable(_G, {
    __newindex = function (t, k, v)
        if not declaredNames[k] then
            local w = debug.getinfo(2, "S").what -- get where function was called
            if w ~= "main" and w ~= "C" then
                error("Attempt to set a global variable: " .. k, 2)
            end
            declaredNames[k] = true
        end
        rawset(t, k, v) -- ignoring of metamethods
    end,

    __index = function (_, k)
        if not declaredNames[k] then
            error("Attempt to read undeclared variable " .. k, 2)
        else
            return nil
        end
    end
})

-- lua distrib contains strict.lua for controlling global variables in described above way

-- Lua has no global variables, it pretends to have and use free name concept
xv = 10
print("_ENV.xv: ", _ENV.xv) -- use free name xv and added it to _ENV. _ENV is predefined local upvalue for every chunk

-- global variables with dynamic names
function getfield(f)
    local v = _G
    for w in string.gmatch(f, "[%a_][%w_]*") do
        v = v[w]
    end
    return v
end


-- invalidate acess to global variables by _ENV = nil
--[[
local print, sin = print, math.sin
_ENV = nil
print(13)
print(sin(13))
print(math.cos(13)) -- error: attempt to index a nil value (upvalue '_ENV')
]]

do
a = 13
local a = 10
print(a) -- 10
print(_ENV.a) -- 13
print(_G.a) -- 13
end
-- usually _G and _ENV refer to the same thing

-- create a new environment - purge all globals include functions like print and so on
--[[
a = 15
_ENV = {}
print(a) -- error: attempt to call a nil value (global 'print')
]]

--[[
a = 1
_ENV = {g = _G}
a = 15
g.print(_ENV.a, g.a) -- 15 1
]]

-- environment by inheritance
--[[
a = 1
local newgt = {}
setmetatable(newgt, { __index = _G })
_ENV = newgt
print(a) -- 1
]]

-- If we define a new local variable called _ENV, references to free names will bind to that new variable
function factory(_ENV)
    return function() return a end
end

f1 = factory{a = 5}
f2 = factory{a = 7}

print(f1()) -- 5
print(f2()) -- 7

-- loadfile/load and etc. accept argument for initializing _ENV:
-- env = {}
-- loadfile("config.lua", "t", env)()

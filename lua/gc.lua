-- garbage collector
-- weak table
-- weakness is set by field __mode of an metatable; value shoulb be a string: k - weak keys, v - weak values, kv - weak are both of keys and values 
a = {}
mt = { __mode = "k" }
setmetatable(a, mt)
key = {}
a[key] = 1
key = {} -- overwrite key by new table, the previous one has started to be as object to delete
a[key] = 2
collectgarbage() -- force garbage collection
for k,v in pairs(a) do print(v) end -- print only 2

-- numbers, Booleans and strings are not collectable items, so gc doesn't remove it
-- memorization technics
local results = {}
setmetatable(results, { __mode = "v"}) -- use weak table for caching of the results
function createRGB(r, g, b)
    local key = string.format("%d-%d-%d", r, g, b)
    local color = results[key]
    if color == nil then
        color = {red = r, green = g, blue = b}
        results[key] = color
    end
    return color
end


-- tables with default values
-- first implimentation:
local defaults = {}
setmetatable(defaults, {__mode = "k"})
local mt = { __index = function (t) return defaults[t] end }
function setDefault1(t, d)
    defaults[t] = d
    setmetatable(t, mt)
end

-- second implimentation
local metas = {}
setmetatable(metas, { __mode = "v"})
function setDefault2(t, d)
    local mt = metas[d]
    if mt == nil then
        mt = { __index = function() return d end }
        metas[d] = mt
    end
    setmetatable(t, mt)
end

-- ephemeron tables: allow to break reference cycle; in Lua (since 5.2) ephemeron table is a table with weak keys and strong values
do
    local mem = {} 
    setmetatable(mem, { __mode = "k"})
    function factory(o)
        local res = mem[o]
        if not res then
            res = (function () return o end) -- until Lua 5.2 there was a cycle reference, so object was not being collected by gc
            mem[o] = res
        end
        return res
    end
end


-- finalizer
o = { x = "hi"}
setmetatable(o, { __gc = function (o) print(o.x) end})
o = nil
collectgarbage() -- > print hi

-- finalization method is called only for marked entities. You mark entity by setting metatable with __gc metamethod
-- if object to finalize was not finalized, that is, it's finalized function will be called at the end of the program

local t = { __gc = function ()
    print("at the end of the programm")
end}
setmetatable(t, t)
_G["*AA*"] = t -- global environment's variable will be removed by the end of programm

-- object can be "ressurected" by gc if it needs for accss for other objects
do
    local A = { x = "this is A"}
    local B = { f = A }
    setmetatable(B, { __gc = function (o) print(o.f.x) end })
    A, B = nil
    collectgarbage() --> this is A
end

-- run function at every cycle of garbage collection
do
    local mt = { __gc = function (o)
        print("new cycle")
        setmetatable({}, getmetatable(o))
    end }
    setmetatable({}, mt) -- create a first object
end

collectgarbage()
collectgarbage()
collectgarbage()


--[[ 
collectgarbage() allows to controll the process of collection
it's first argument is a string cpecifieng what to do
-- and second argument, if it needs - the data
"stop": stops the collector until another call to collectgarbage with the option "restart".
"restart": restarts the collector.
"collect": performs a complete garbage-collection cycle, so that all unreachable objects are
            collected and finalized. This is the default option.

"step": performs some garbage-collection work. The second argument, data, specifies the
        amount of work, which is equivalent to what the collector would do after allocating
        data bytes.
"count": returns the number of kilobytes of memory currently in use by Lua. This result is a
            floating-point number that multiplied by 1024 gives the exact total number of bytes.
            The count includes dead objects that have not yet been collected.
"setpause": sets the collector's pause parameter. The data parameter gives the new value in
            percentage points: when data is 100, the parameter is set to 1 (100%).
"setstepmul": sets the collector's step multiplier (stepmul) parameter. The new value is given
                by data, also in percentage points.
]]


-- simple iterator example
-- use closure to save state
local function iterator(t)
local i = 0
return function ()
      i = i + 1
      return t[i]
    end
end

t = { 2, 5, 6, 8 }
for v in iterator(t) do
    print(v)
end

-- using of while instead of for
local i = iterator(t)
while true do
    local v = i()
    if not v then break end

    print(v)
end

-- generic for
-- for var_1, ..., var_n in explist do block end
-- equals to
--[[
do
    local _f, _s, _var = explist
    while true do
        local var_1, ..., var_n = _f(_s, _var)
        _var = var_1
        if _var == nil then break end
        block
    end 
end
]]
-- s is invariant state
-- f iterator function
-- var initial value

-- stateless iterator
-- simple example
local function iter(t, i)
    i = i + 1
    local v = t[i]
    if v then
        return i, v
    end
end

local function ipairs_m(t)
    return iter, t, 0
end

print("===========stateless iterator=========")
local t = { "a", "b", "c", "d" }
for k, v in ipairs_m(t) do
    print(v)
end

-- iterator for ordered traversing of a table
local function pairsByKeys(t, f) -- f is a order
    local a = {}
    for k in pairs(t) do
        a[#a + 1] = k
    end
    table.sort(a, f)
    local i = 0
    return function()
        i = i + 1
        return a[i], t[a[i]]
    end
end

local ntable = {
    a = 1,
    c = 2,
    b = 3
}

for k, v in pairs(ntable) do
    io.write(" ", k, " : ", v)
end
io.write("\n")

for k, v in pairsByKeys(ntable) do
    io.write(" ", k, " : ", v)
end
io.write("\n")

-- true iterator
local function true_iter(t, f)
    for k,v in pairs(t) do
        f(k, v)
    end
end
print("true iterator:")
true_iter(ntable, print)

--exercise
--18.1 & 18.2
local function fromto(n, m, step)
    local invar = {from = n, to = m, ["step"] = step}
    local iter = function(s, f)
        if f == nil then return s.from end
        local a = f + s.step
        if a < s.from then return nil end 
        if a >= s.to then return nil
        else
            return a
        end
    end
    return iter, invar, nil
end

print("18.1 iter fromto: 10, 15:")
for v in fromto(10, 15, 2) do
    io.write(v, " ")
end
io.write("\n")

-- 18.4
local function substrings(str)
    local substrs = {}
    for l = 0, #str - 1 do
        local p = 1
        while(p + l <= #str) do
            substrs[#substrs + 1] = string.sub(str, p, p+l)
            p = p + 1
        end
    end
    local iter = function(s, v)
        local value = s[v + 1]
        if value then
            return v + 1, value
        end
        return nil
    end
    return iter, substrs, 0
end

for k,v in substrings("abcd") do
    io.write(v, " ")
end

io.write("\n")
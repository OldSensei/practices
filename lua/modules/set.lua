local Set = {}

local mt = {} -- create a meta table

function Set.new(l)
    local set = {}
    setmetatable(set, mt)
    for _, v in ipairs(l) do set[v] = true end
    return set
end

function Set.union(a, b)
    local res = Set.new{}
    for k in pairs(a) do res[k] = true end
    for k in pairs(b) do res[k] = true end
    return res
end

function Set.subtraction(a, b)
    local res = Set.new{}
    for k in pairs(a) do
        if not b[k] then
            res[k] = true
        end
    end
    return res
end

function Set.intersection(a, b)
    local res = Set.new{}
    for k in pairs(a) do
        res[k] = b[k]
    end
    return res
end

function Set.tostring(set)
    local l = {}
    for e in pairs(set) do
        l[#l + 1] = e
    end
    return "{" .. table.concat(l, ", ") .. "}"
end

function Set.len(set)
    local i = 0
    for k in pairs(set) do i = i + 1 end
    return i
end
mt.__add = Set.union
mt.__mul = Set.intersection
mt.__sub = Set.subtraction
mt.__len = Set.len
--[[
    metamethods list:
    +: __add
    *: __mul
    -: __sub
    / (float division): __div
    (floor division): __idiv
    negation: __unm
    modulo: __mod
    exponentiation: __pow
    bitwise operations:
    and: __band
    or: __bor
    xor: __bxor
    not: __bnot
    left shift: __shl
    right shift: __shr

    concatination operator: __concat
]]

--[[
    Relational metamethods:
    equal to: __eq
    less than: __lt
    less or equal: __le
]]
mt.__le = function(a, b)
    for k in pairs(a) do
        if not b[k] then return false end
    end
    return true
end

mt.__lt = function(a, b)
    return (a <= b) and not (b <= a)
end

mt.__eq = function(a,b)
    return a <= b and b <= a
end

-- __tostring - metamethod that is called by print
mt.__tostring = Set.tostring

-- protect metatable: user can't change the meta table for table
-- just set up __metatable field
mt.__metatable = "not your buisness"

-- pairs has a metamethod: __pairs
-- length is a metamethod: __len 
return Set
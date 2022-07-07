a = { p = print }

a.p("Hello world!")

-- the example of anonymous function
network = {
    { name = "grauna", IP = "210.26.30.34" },
    { name = "arraial", IP = "210.26.30.23" },
    { name = "lua", IP = "210.26.23.12" },
    { name = "derain", IP = "210.26.32.20" },
}

-- reverse alphabetical order
table.sort(network, function(a, b) return (a.name > b.name) end)

for k,v in pairs(network) do
    print(k, ":", v.name, v.IP)
end


function derivative(f, delta)
    delta = delta or 1e-4
    return  function (x)
                return (f(x + delta) - f(x)) / delta
            end
end

c = derivative(math.sin)
print(math.cos(5.2), c(5.2))


-- non-global functions
Lib = {}

Lib.foo = function (x)  return x + 1 end
-- alternative approach
function Lib.bar (x) return x + 2 end

print(Lib.foo(1))
print(Lib.bar(1))

-- local function
do
    local f = function (x) return x * 2 end
    -- alternative approach
    local function f1(x) return x * 2 end
    print(f(3))
    print(f1(3))

    -- recursion problem
    --[[
      local fact = function(x)
        if x == 0 then return 1
        else
            return x * fact(x - 1) -- buggy, coze local fact hasn't been declared yet, Lua will try to use global fact
        end
      end

      -- for solving issue:
      local fact
      fact = function (x)
        if x == 0 then return 1
        else
            return x * fact(x - 1)
        end
      end
    ]]
end

--closure
local newCounter = function ()
    local c = 0
    return  function ()
                c = c + 1
                return c
            end
end

print("using of closures:")
c1 = newCounter()
c2 = newCounter()
print(c1()) --> 1
print(c1()) --> 2
print(c2()) --> 1


-- example of sandbox (some kind of)
do
    local oldSin = math.sin
    math.sin = function( degree )
        return oldSin(degree * (math.pi / 180))
    end
end

print(math.sin(90))

--exercises
--1: integral
local integral = function(f, a, b, delta)
    local delta = delta or 1e-4
    local int = 0
    for i = a, b, delta do
        int = int + delta * f(i)
    end
    return int
end

local line_f = function(x) return -1 * x + 1 end
print(integral(line_f, 0, 1, 0.005))

function F (x)
    return {
    set = function (y) x = y end,
    get = function () return x end
    }
    end
    
    o1 = F(10)
    o2 = F(20)
    print(o1.get(), o2.get())
    o2.set(100)
    o1.set(300)
    print(o1.get(), o2.get())
   
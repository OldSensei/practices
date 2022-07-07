-- example of operations with numbers
print(type(1)) -- number
print(type(1.0)) -- number

print(math.type(1)) -- integer
print(math.type(1.0)) -- float

print(1e3) -- 1000.0

-- operators
print(1 + 2)
print(1.0 + 2)
print(6 / 2)
print(5 % 2) -- 1
print(5 // 2) -- floor division: 2
print(-5 // 2) -- -3 floor to the nearest to the -infinity
print( math.pi )
print( math.pi % 0.1 )
print( math.pi % 0.01 )

print(2^2) -- 4.0
print(4^0.5) -- 2.0

print(math.sin(math.pi / 2)) -- 1.0
print(math.max(10, 1, -20, 2.34))
print( 10 < 9, 11 > 5, 2 == 2, 2 ~=1)

print(math.random()) -- random number in [0, 1)
print(math.random(6)) -- random number in [1, 6]
print(math.random(2, 5)) -- random number in [2, 5]

math.randomseed(os.time()) -- set generation seed

print('rounding functions:')
print(math.ceil(-3.3))
print(math.ceil(3.3))
-- modf returns 2 result: integer and fraction part
print(math.modf(-3.3)) 
print(math.modf(3.3))

print('conversions:')
-- 3.2 | 0 error coz of fractional part
-- 2^64 | 0 error coz of out of range
print(2.0 | 0)

print(math.tointeger(22.0)) -- another way to convert to int
print(math.tointeger(2.5)) -- nil

print(10 % 3)

-- transform uniform distribution to normal
function normal_rnd() -- Box-Muller transform
    return math.sqrt( -2 * math.log(math.random())) *
            math.cos(2 * math.pi * math.random())
end

print(normal_rnd())
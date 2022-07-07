a = {}
k = 'x'
a[k] = 10
print(a[k], '==', a['x'])
b = a
b[k] = b[k] + 1
print(a[k])
print("a.x ==", a.x)

a = nil; b = nil
a = {}
i = 10; j = "10"; k = "+10"
a[i] = "number key"
a[j] = "string key"
a[k] = "another string key"

print("a[i]: ", a[i])
print("a[j]: ", a[j])
print("a[k]: ", a[k])

print("a[tonumber(j)]: ", a[tonumber(j)])
print("a[tonumber(k)]: ", a[tonumber(k)])

days = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
print("days[1]:", days[1], "days[4]:", days[4])

a = nil
a = { x = 10, y = 20 }
print( "a.x:", a.x )

polyline = {
    color = "red",
    thickness = 2.0,
    npoints = 4,
    { x = 0, y = 0}, -- polyline[1]
    { x = -10, y = 0},
    { x = -10, y = 1},
    { x = 0, y = 1},
}

print("polyline[2].x:", polyline[2].x, "polyline[2].y", polyline[2].y)
print("polyline[4].x:", polyline[4].x, "polyline[4].y", polyline[4].y)

-- another ctor: in such way we can declare key names unsupported by other means
opnames = { ["+"] = "add", ["-"] = "sub", ["*"] = "mul", ["/"] = "div" }
i = 20; s = "-"
a = nil
a = { [i + 0] = s, [i + 1] = s .. s, [i+2] = s .. s .. s }
print("opnames[s]:", opnames[s])
print("a[22]:", a[22])


print("traverse the table")
t = { 10, print, x = 12, k = "hi"}
for k, v in pairs(t) do
    print(k, v)
end

print("traverse the list")
t = { 10, print, 12, "hi"}
for k, v in ipairs(t) do
    print(k, v)
end

print("traverse the sequence")
t = { 10, print, 12, "hi"}
for k = 1, #t do
    print(k, t[k])
end

t = nil
print("Table library:")
t = {10, 5, 20}
print("source table:", "{" .. t[1] .. ", " .. t[2] .. ", " .. t[3] .. "}")
table.insert(t, 1, 15)
print("table.insert(t, 1, 15):", "{" .. t[1] .. ", " .. t[2] .. ", " .. t[3] .. ", " .. t[4] .. "}")
table.insert(t, 25)
print("table.insert(t, 25):", "{" .. t[1] .. ", " .. t[2] .. ", " .. t[3] .. ", " .. t[4] .. ", " .. t[5] .. "}")
table.remove(t, 2)
print("table.remove(t, 2):", "{" .. t[1] .. ", " .. t[2] .. ", " .. t[3] .. ", " .. t[4] .. "}")
table.remove(t) -- remove the last element
print("table.remove(t):", "{" .. t[1] .. ", " .. t[2] .. ", " .. t[3] .. "}")

-- using new syntax: move
-- add a new element to the first position
table.move(t, 1, #t, 2) -- move elements from 1 unti #t to position 2
t[1] = 1 -- pass  a new element to the first position
print("table.move(t, 1, #t, 2):", "{" .. t[1] .. ", "..  t[2] .. ", " .. t[3] .. ", " .. t[4] .. "}")

-- example of removing of the first element
table.move(t, 2, #t, 1) -- move elements from 2 until #t to position 1
t[#t] = nil -- remove last element
print("table.move(t, 2, #t, 1):", "{" .. t[1] .. ", "..  t[2] .. ", " .. t[3] .. "}")

function calculate_polynomial(polynomial, x)
    x_exp = 1
    sum = polynomial[1]
    for k = 2, #polynomial do
        x_exp = x_exp * x
        sum = sum + polynomial[k] * x_exp
    end
    return sum
end

print("calculate_polynomial({ 1, 2, 3}, 2):", calculate_polynomial({ 1, 2, 3}, 2))
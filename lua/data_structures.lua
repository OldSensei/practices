-- array
local a = {}
for i = 0, 10 do
    a[i] = 0
end

print(#a) -- if array starts with non 1 index # work wrongly

local squares = { 1, 4, 9, 16, 25, 36 }
print(squares[2]) -- 4

-- matrices & multi-dimensional arrays
-- first approach (jagged matrix)
-- matrix N x M
local M = 5
local N = 4
local mt = {}
for i = 1, N do
    local row = {}
    mt[i] = row
    for j = 1, M do
        row[j] = 0
    end
end

-- second approach
local mt2 = {}
for i = 1, N do
    local aux = (i - 1) * M
    for j = 1, M do
        mt2[aux + j] = 0
    end
end

-- multiplication of sparse matrices (jagged matrices)
local function mul(a, b)
    local c = {}
    for i = 1, #a do
        local result = {}
        for k, va in pairs(a[i]) do
            for j, vb in pairs(b[k]) do
                local res = (result[j] or 0) + va * vb
                result[j] = (res ~= 0) and res or nil
            end
        end
        c[i] = result
    end
    return c
end

-- linked-list
local list = nil
local function addNode(list, v)
    local l = { next = list, value = v }
    return l
end

local function travers(list, f)
    local l = list
    while l do
        f(l.value)
        l = l.next
    end
end

list = addNode(list, 3)
list = addNode(list, 5)
list = addNode(list, 10)
travers(list, print)

-- deque
local function createDeque()
    return { first = 0, last = -1 }
end

local function pushFirst(list, value)
    local first = list.first - 1
    list.first = first
    list[first] = value
end

local function pushLast(list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
end

local function popFirst(list)
    local first = list.first
    if first > list.last then error("list is empty") end
    local value = list[first]
    list[first] = nil
    list.first = first + 1

    return value
end

local function popLast(list)
    local last = list.last
    if last < list.first then error("list is empty") end
    local value = list[last]
    list[last] = nil
    list.last = last +-1

    return value
end

local deque = createDeque()
pushLast(deque, 5)
pushLast(deque, 10)
pushFirst(deque, 1)

print("deque:",popFirst(deque), popLast(deque)) -- 1 10

-- reverse table

local days = {"Sunday", "Monday", "Tuesday", "Wednesday",
                "Thursday", "Friday", "Saturday" }
local revDays = {}
for k, v in pairs(days) do
    revDays[v] = k
end

local x = "Tuesday"
print(revDays[x])

-- sets and bugs (multisets)
local function Set(list)
    local set = {}
    for _, v in ipairs(list) do set[v] = true end
    return set
end
local reserved = Set{"while", "if", "else", "do"}

local function Bag(list)
    local bag = {}
    for _, v in ipairs(list) do bag[v] = 0 end
    return bag
end

local function insert(bag, element)
    bag[element] = (bag[element] or 0) + 1
end

local function remove(bag, element)
    local count = bag[element]
    bag[element] = (count and count > 1) and count - 1 or nil
end

-- string buffers
-- table as a string buffer
local function createString()
    local t = {}
    for l in io.lines() do
        t[#t + 1] = l
    end
    t[#t + 1] = "" -- for case when we need to add separator to last line
    return table.concat(t, "\n")
end

-- graphs
local function name2node(graph, name)
    local node = graph[name]
    if not node then
        node = {name = name, adj = {}}
        graph[name] = node
    end
    return node
end

local function readGraph()
    local graph = {}
    for line in io.lines() do
        local namefrom, nameto = string.match(line, "(%S+)%s+(%S+)")
        local nodefrom = name2node(graph, namefrom)
        local nodeto = name2node(graph, nameto)
        nodefrom.adj[nodeto] = true
    end
    return graph
end

local function findPath(curr, to, path, visited)
    local path = path or {}
    local visited = visited or {}
    if visited[curr] then 
        return nil
    end

    visited[curr] = true
    path[#path + 1] = curr
    if curr == to then
        return path
    end

    for node in pairs(curr.adj) do
        local p = findPath(node, to, path, visited)
        if p then return p end
    end
    table.remove(path)
end

local function printPath(path)
    for i=1, #path do
        print(path[i].name)
    end
end

local g = {}
local a_node = name2node(g, "a")
local b_node = name2node(g, "b")
local c_node = name2node(g, "c")
local d_node = name2node(g, "d")
local e_node = name2node(g, "e")
a_node.adj[b_node] = true
a_node.adj[c_node] = true
b_node.adj[d_node] = true
d_node.adj[e_node] = true

printPath(findPath(a_node, e_node))

-- exercises
-- 1
local function add(a, b, r, c)
    local c_m = {}
    for i = 1, r do
        local va = a[i]
        local row = {}
        local vb = b[i]
        for j = 1, c do
            local v1 = va[j]
            local v2 = vb[j]
            if not v1 then
                row[j] = v2
            elseif not v2 then
                row[j] = v1
            else
                row[j] = v1 + v2
            end
        end
        c_m[#c_m + 1] = row
    end
    return c_m
end

local am = { {1, 2, nil, 3},
              {4, 5, 2, nil} }

local bm = { {4, 1, nil, 1},
              {4, 5, 2, 1} }

local function print_m(m, r, c)
    for i = 1, r do
        io.write("\n")
        v = m[i]
        for j = 1, c do
            v2 = v[j]
            if not v2 then io.write(" nil")
            else
                io.write(" ", tostring(v2))
            end
        end
    end
end

print_m(add(am, bm, 2, 4), 2, 4)

-- 2
local function createDeque2()
    return { first = 0, last = 0 }
end

local function pushFirst2(list, value)
    list[list.first] = value
    list.first = list.first - 1
end

local function pushLast2(list, value)
    list.last = list.last + 1
    list[list.last] = value
end

local function popFirst2(list)
    if list.last == list.first then error("list is empty") end
    local first = list.first + 1
    local value = list[first]
    list[first] = nil
    list.first = first
    if list.first == list.last then list.first = 0; list.last = 0 end
    return value
end

local function popLast2(list)
    if list.last == list.first then error("list is empty") end
    local last = list.last
    local value = list[last]
    list[last] = nil
    list.last = last - 1

    if list.first == list.last then list.first = 0; list.last = 0 end

    return value
end

local deque2 = createDeque2()
pushLast2(deque2, 3)
pushLast2(deque2, 4)
pushFirst2(deque2, 2)
pushFirst2(deque2, 1)

print("\n", popFirst2(deque2), popFirst2(deque2), popFirst2(deque2), popLast2(deque2))

-- segment tree
local function createSegmentTree(op, ...)
    local t = table.pack(...)
    local n = math.pow(2, math.floor(math.log(t.n - 1) / math.log(2)) + 1)
    local result = { }
    for i = 1, n do
        result[n + i - 1] = t[i] or 0
    end
    for i = n - 1, 1, -1 do
        result[i] = op(result[2 * i], result[2 * i + 1])
    end
    return result
end

local add = function (a, b)
    return a + b
end

local st = createSegmentTree(add, 1, 2, 3, 4, 5)

local function sum(st, index, sl, sr, l, r)
    io.write("sum: ", index, " sl: ", sl, " sr: ", sr, " l: ", l, " r: ", r, "\n")

    if l > r then
        return 0
    end

    if l == sl and r == sr then
        return st[index]
    end

    local m = (sl + sr) // 2
    return sum(st, index * 2, sl, m, l, math.min(r, m)) +
            sum(st, index * 2 + 1, m + 1, sr, math.max(m + 1, l), r)
end

local function update(st, index, l, r, pos, new_value)
    if l == r then
        st[index] = new_value
    else
        local m = (l + r) // 2
        if pos <= m then
            update(st, index * 2, l, m, pos, new_value)
        else
            update(st, index * 2 + 1, m + 1, r, pos, new_value)
        end
        st[index] = st[index * 2] + st[index * 2 + 1]
    end


end

for k, v in ipairs(st) do
    io.write(v, ' ')
end

io.write("\nsum: ", sum(st, 1, 1, 8, 3, 4), "\n")

update(st, 1, 1, 8, 3, 9)

for k, v in ipairs(st) do
    io.write(v, ' ')
end
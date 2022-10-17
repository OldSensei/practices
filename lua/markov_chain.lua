local path = string.match(arg[0], [[(.+\)]])

local template = ";" .. string.match(arg[0], [[(.+\)]]) .. [[modules\?.lua]]
package.path = package.path .. template

local words = require("words_iterator")

local function prefix(...)
    local t = table.pack(...)
    local r = t[1]
    for i = 2, t.n do
        r = r .. " " .. t[i]
    end
    return r
end

local statetab = {}
local function insert(t, prefix, value)
    local list = t[prefix]
    if not list then
        t[prefix] = {value}
    else
        list[#list + 1] = value
    end
end

local MAXGEN = 200
local NOWORD = '\n'
--[=[local w1, w2 = NOWORD, NOWORD
for nextword in words.allwords(path .. [[data\most_frequent_words_data.txt]]) do
    insert(prefix(w1, w2), nextword)
    w1 = w2; w2 = nextword;
end
insert(prefix(w1, w2), NOWORD)

-- generate text
w1, w2 = NOWORD, NOWORD
for n = 1, MAXGEN do
    local list = statetab[prefix(w1, w2)]
    local r = math.random(#list)
    local nextword = list[r]
    if nextword == NOWORD then return end
    io.write(nextword, " ")
    w1 = w2; w2 = nextword
end
]=]
local function markov_chain(filename, n, max)
    local fillDict = function(filename, n)
        local result = {}
        local t = {}
        for i = 1, n do
            t[i] = NOWORD
        end

        for nextword in words.allwords(filename) do
            insert(result, prefix(table.unpack(t)), nextword)
            table.move(t, 2, n, 1)
            t[n] = nextword
        end
        insert(result, prefix(table.unpack(t)), NOWORD)
        return result
    end

    local generate = function(t, n, max)
        local s = {}
        for i = 1, n do
            s[i] = NOWORD
        end

        for i = 1, max do
            local list = t[prefix(table.unpack(s))]
            local r = math.random(#list)
            local nextword = list[r]
            if nextword == NOWORD then return end
            io.write(nextword, " ")

            table.move(s, 2, n, 1)
            s[n] = nextword
        end
    end

    local st = fillDict(filename, n)
    generate(st, n, max)
end

markov_chain(path .. [[data\most_frequent_words_data.txt]], 2, 200)

local function print_words(words, counters, limit)
    local n = math.min(limit or math.huge, #words)
    for i = 1, n do
        io.write(words[i], "\t", counters[words[i]], "\n")
    end
end

local function get_most_frequent_words(minimal_word_len)
    local len = minimal_word_len or 0
    local counter = {}
    for line in io.lines() do
        for word in string.gmatch(line, "%w+") do
            if #word >= len then
                counter[word] = (counter[word] or 0) + 1
            end
        end
    end
    local words = {}
    for word in pairs(counter) do
        words[#words + 1] = word
    end
    table.sort(words, function(w1, w2)
        return counter[w1] > counter[w2] or
                counter[w1] == counter[w2] and w1 < w2
        end)
    return words, counter
end

local old = io.input()
io.input([[E:\work\projects\practices\lua\data\most_frequent_words_data.txt]])
local words, counter = get_most_frequent_words(3)
print_words(words, counter)

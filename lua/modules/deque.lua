local M = {}

function M.new()
    return { first = 0, last = -1 }
end

function M.pushFirst(list, value)
    local first = list.first - 1
    list.first = first
    list[first] = value
end

function M.pushLast(list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
end

function M.popFirst(list)
    local first = list.first
    if first > list.last then error("list is empty") end
    local value = list[first]
    list[first] = nil
    list.first = first + 1

    return value
end

function M.popLast(list)
    local last = list.last
    if last < list.first then error("list is empty") end
    local value = list[last]
    list[last] = nil
    list.last = last +-1

    return value
end


-- another approach to export module functions
-- package.loaded contains loaded modules. "..." refers to the module name
package.loaded[...] = M
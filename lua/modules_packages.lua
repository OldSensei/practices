-- require search for module and load it
local m = require("math")
print(m.sin(90))

-- to force a new loading needs reset  module:
--package.loaded.math = nil
--m = require("math")

-- path templates where Lua search for modules
print(package.path)

local template = ";" .. string.match(arg[0], [[(.+\)]]) .. [[modules\?.lua]]
package.path = package.path .. template

-- finding of module; searchpath can take an any path template as the second argument
print("trying to find test_foo.lua module:", package.searchpath("test_foo", package.path))

local foo = require("test_foo")
foo.greetings("Alex")

--exercise
--17.1
local deque = require("deque")
local d = deque.new()
deque.pushLast(d, 5)
deque.pushLast(d, 10)
deque.pushFirst(d, 1)

--17.4
local function simultaneos_searcher(name, path)
    local search_template = path or package.path
    local result = package.searchpath(name, search_template)
    if not result then
        return nil
    end

    local loader = loadfile(result)
    if loader then return loader end

    loader = package.loadlib(result)
    return loader
end

package.searchers[#package.searchers + 1] = simultaneos_searcher
print("package.searchers:", package.searchers)
--[[
The debug library offer a lot of tools for introspection.
The main introspection function from debug library is: getinfo()
calling: debug.getinfo(foo); return the next table:
    source:             contains string (in case of using load) or file if function was defined in file
    short_src:          short version of source (up to 60 characters)
    linedefined:        gives the number of the first line in the source where the function was defined
    lastlinedefined:    gives the number of the last line in the source where the function was defined
    what:               what this function is. Options are:
                                                    "Lua" - if function is regular Lua function
                                                    "C" - if it is regular C function
                                                    "main" - if it is the main part of Lua chunk
    name:               gives the reasonable name for the function, such as the name of a global variable that stores this function
    namewhat:           talls what previos field means:
                                                "global"
                                                "local"
                                                "method"
                                                "field"
                                                "" - Lua didn't find name for the function
    nups:               number of upvalues of the function
    nparams:            number of parameters of the function
    isvararg:           tells whether the function is variadic
    activelines:        the field is a table representing the set of active lines of the function. Active lines - it is lines with some codes
    funct:              has the function itself

Calling debug.getInfo(n) for some number n return information about active function on stack level n;
Stack level 1 is a function that calling getInfo()
If query an active function resulting table contain additional fields:
    currentline: line where current function is at the moment
    istailcall: if function wass called by tail call (in this case we can't get actual caller cuz it isn't on the stack anymore)
    
getInfo could have second parameter - a string, that allow to optimaze call and get only needed info:
    n selects name and namewhat
    f selects func
    S selects source, short_src, what, linedefined, and lastlinedefined
     selects currentline
    L selects activelines
    u selects nup, nparams, and isvararg
--]]

local function traceback()
    for level = 1, math.huge do
        local info = debug.getinfo(level, "Sl")
        if not info then break end
        if info.what == "C" then
            print(string.format("%d\tC function", level))
        else
            print(string.format("%d\t[%s]:%d", level, info.short_src, info.currentline))
        end
    end
end

traceback()
--[[
    1       [c:\work\projects\practices\lua\reflection.lua]:43
    2       [c:\work\projects\practices\lua\reflection.lua]:53
    3       C function
--]]

print(debug.traceback())
--[[
    stack traceback:
        c:\work\projects\practices\lua\reflection.lua:60: in main chunk
        [C]: in ?
--]]

--[[
    Inspection of local variables:
    debug.getlocal(n, index) - n - stack level; index - variable index;
    returned two values: name and value
    if index > count of variables - return nil
    if n is invalid - raise error
]]

function foo (a, b)
    local x
    do local c = a - b end
    local a = 1
    while true do
        local name, value = debug.getlocal(1, a) -- c is out of current scope; name, value - at the moment of getlocall calling, still not declared
        if not name then break end
        print(name, value)
        a = a + 1
    end
end

foo(10, 20)

--[[
    a       10
    b       20
    x       nil
    a       4  
--]]

--[[
    for change of local variable - use debug.setlocal(n, index, value)
    n, index - the same as in getlocal
    value - new value of variable
--]]

--[[
    Getting non-local variable value:
    debug.getupvalue(func, index) - func is a closure; index - index of variable
    debug.setupvalue(func, index, newValue) - set up new value for non-local variable. return namw of the variable, or nil in case of fail
--]]

function getvarvalue(name, level, isenv)
    local value
    local found = false

    level = (level or 1) + 1

    -- local
    for i = 1, math.huge do
        local n, v = debug.getlocal(level, i)
        if not n then break end
        if n == name then
            value = v
            found = true
        end
    end

    if found then return "local", value end

    local func = debug.getinfo(level, "f").func

    for i = 1, math.huge do
        local n, v = debug.getupvalue(func, i)
        if not n then break end
        if n == "name" then return "upvalue", v end
    end

    if isenv then return "noenv" end

    local _, env = getvarvalue("_ENV", level, true)
    if env then
        return "global", env[name]
    else
        return "noenv"
    end
end

local a = 4; print(getvarvalue("a")) --> local 4
a = "xx"; print(getvarvalue("a")) --> global xx
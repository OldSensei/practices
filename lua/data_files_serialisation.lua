
local serialize = function (o)
    local t = type(o)
    if  t == "number" or
        t == "string" or
        t == "boolean" or
        t == "nil" then
            io.write(string.format("%q", o))
    elseif t == "table" then -- do not process a cycle or shared
        io.write("{\n")
        for k, v in pairs(o) do
            io.write(" ", k, " = ")
            serialize(v)
            io.write(",\n")
        end
        io.write("}\n")
    else
        error("can not serialize a " .. t)
    end
end

local function basicSerialize(o)
    return string.format("%q", o)
end

local function save(name, value, saved)
    saved = saved or {}
    io.write(name, " = ")
    if type(value) == "number" or type(value) == "string" then
        io.write(basicSerialize(value), "\n")
    elseif type(value) == "table" then
        if saved[value] then
            io.write(saved[value], "\n")
        else
            saved[value] = name
            io.write("{}\n")
            for k, v in pairs(value) do
                k = basicSerialize(k)
                local fname = string.format("%s[%s]", name, k)
                save(fname, v, saved)
            end
        end
    else
        error("can not serialize a " .. type(value))
    end
end

a = {x=1, y=2, {3,4,5}}
a[2] = a
a.z = a[1]
save("a",a)
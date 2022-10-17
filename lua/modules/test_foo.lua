local function greetings(name)
    print("Hello " .. name .. "!")
end

local export = {
    greetings = greetings
}

return export
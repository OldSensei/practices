local function allwords(file)
    local inp = assert(io.open(file, "r"))
    local line = inp:read()
    local pos = 1
    return function()
        while line do
            local w, e = string.match(line, "(%w+[,;.:]?)()", pos)
            if w then
                pos = e
                return w
            else
                line = inp:read()
                pos = 1
            end
        end
        inp:close()
        return nil
    end
end

local export = {
    allwords = allwords
}

return export
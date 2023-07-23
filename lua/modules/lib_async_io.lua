local CmdQueue = {}

local lib = {}

function lib.readLine(stream, callback)
    local cmd = function() 
        callback(stream:read())
    end
    table.insert(CmdQueue, cmd)
end

function lib.writeLine(stream, line, callback)
    local cmd = function()
        callback(stream:write(line))
    end
    table.insert(CmdQueue, cmd)
end

function lib.stop()
    table.insert(CmdQueue, "stop")
end

function lib.runLoop()
    while true do
        local cmd = table.remove(CmdQueue, 1)
        if cmd == "stop" then
            break
        else
            cmd()
        end
    end
end

return lib
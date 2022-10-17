-- simple io model
io.input([[E:\work\projects\practices\lua\data\external_world_data.txt]])
t = io.read("a") -- read all the file
io.write(t)
--[[
    a - all file
    l - line without \n (default)
    L - line with \n
    n - number
    num - read num bytes as a string
]]

io.input([[E:\work\projects\practices\lua\data\external_world_data_2.txt]])
a, b, c = io.read("n", "n", "n") -- read three numbers, if error occurs return nil
io.write(a, " ", b, " ", c)
t = io.read(4) -- read 4 bytes
io.write("\n",t)

-- complete mode
-- assert is used for error checking
local f = assert(io.open([[E:\work\projects\practices\lua\data\external_world_data_3.txt]], "w")) -- modes: r - read, a - append, w - write/rewrite
f:write("1001001001001001001\n")
f:close()

function file_size(file)
    local current = file:seek() -- get current position
    local size = file:seek("end")
    file:seek("set", current)
    return size
end

io.write("\nsize: ", file_size(io.input()), "\n") -- io.input() - get current input stream. The same for output()

-- os module
-- os.exit() - terminate a process
-- os.exit(num, bool) - terminate and return num as status, if bool is true - make finalization of memory and other stuff
print(os.getenv("HOME")) -- if variable is undefined return nil
print(os.getenv("PATH"))
os.execute("mkdir " .. [[E:\work\projects\practices\lua\data\test_dir]])
os.execute("rmdir " .. [[E:\work\projects\practices\lua\data\test_dir]])

local f = io.popen("dir /B", "r") -- "r" means read from command
for l in f:lines() do
    print(l)
end

function sort_file(input_file, output_file)
    local inp = input_file and io.open(input_file, "r") or io.input()
    local f = io.open(output_file, "r")
    if f then
        f:close()
        io.write("File already exist: 1 - rewrite: ")
        io.input(io.stdin)
        local choose = io.read("n")
        if choose == 1 then
            f = io.open(output_file, "w")
        else
            f = io.stdout
        end
    else
        f = io.open(output_file, "w")
    end

    t = {}
    for l in inp:lines() do
        t[#t + 1] = l
    end
    inp:close()
    table.sort(t)

    for i = 1, #t do
        f:write(t[i], "\n")
    end
end

sort_file([[E:\work\projects\practices\lua\data\external_world_test.txt]], [[E:\work\projects\practices\lua\data\external_world_data_3.txt]])

function read_the_end_n_lines_of_file(file_name, n)
    local f = assert(io.open(file_name, "r"))
    local size = f:seek("end")
    local position = -1
    local new_line_count = 0
    while (size + position) > 0 do
        f:seek("end", position)
        local t = f:read(1)
        if (t == "\n") then
            new_line_count = new_line_count + 1
            if new_line_count == n then
                position = position + 1
                break
            end
            position = position - 1 -- for new line 0xa0xd
        end
        position = position - 1
    end

    if position == 0 then return "" end

    f:seek("end", position)
    local t = f:read(position * -1)
    f:close()
    return t
end


io.output(io.stdout)
print(read_the_end_n_lines_of_file([[E:\work\projects\practices\lua\data\external_world_data.txt]], 2))

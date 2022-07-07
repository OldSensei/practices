local t = os.time() -- return time as a number (POSIX)
print(t)

local day2year = 365.242
local sec2hour = 3600
local sec2day = sec2hour * 24
local sec2year = sec2day * day2year

io.write("year: ", t // sec2year + 1970, "\n")
io.write("hour: ", t % sec2day // sec2hour, "\n")
io.write("minutes: ", t % sec2hour // 60, "\n")
io.write("seconds: ", t % 60, "\n")

-- convert table date to number date
local nt = os.time( {year=2022, month=5, day=23, hour=22, min=21, sec=53} )
io.write("converted time: ", nt, "\n")
io.write("1971 Janury 1: ", os.time( { year=1971, month=1, day=1, hour=0} ))

-- os.date
local date_table = os.date("*t", 906000490) -- produce table
for k, v in pairs(date_table) do
    io.write(tostring(k), "\t:\t", tostring(v), "\n")
end

--date without second parameter - current time
io.write(os.date("a %A in %B\n"))
io.write(os.date("%d/%m/%Y\n", 906000490))
--[[
    %a abbreviated weekday name (e.g., Wed)
    %A full weekday name (e.g., Wednesday)
    %b abbreviated month name (e.g., Sep)
    %B full month name (e.g., September)
    %c date and time (e.g., 09/16/98 23:48:10)
    %d day of the month (16) [01–31]
    %H hour, using a 24-hour clock (23) [00–23]
    %I hour, using a 12-hour clock (11) [01–12]
    %j day of the year (259) [001–365]
    %m month (09) [01–12]
    %M minute (48) [00–59]
    %p either "am" or "pm" (pm)
    %S second (10) [00–60]
    %w weekday (3) [0–6 = Sunday–Saturday]
    %W week of the year (37) [00–53]
    %x date (e.g., 09/16/98)
    %X time (e.g., 23:48:10)
    %y two-digit year (98) [00–99]
    %Y full year (1998)
    %z timezone (e.g., -0300)
    %% a percent sign
]]
-- ! in the begining means time in UTC
print(os.date("!%c", 0))
t = os.date("*t")
print(os.date("%Y/%m/%d", os.time(t)))
t.day = t.day + 40
print(os.date("%Y/%m/%d", os.time(t)))

t = os.date("*t")
print(t.day, t.month)
t.day = t.day - 40
print(t.day, t.month)
t = os.date("*t", os.time(t))
print(t.day, t.month) -- normalized value


local t5_3 = os.time({year=2015, month=1, day=12})
local t5_2 = os.time({year=2011, month=12, day=16})

local dif = os.difftime(t5_3, t5_2)
print(dif // (24 * 3600))

local x = os.clock()
local s = 0
for i = 1, 500000 do s = s + i end
print(string.format("elapsed time: %.2f\n", os.clock() - x))

--exercises
--1
local function pass_month(date)
    local t = os.date("*t", date)
    t.month = t.month + 1
    return os.time(t)
end

local m = os.date("*t", pass_month(os.time()))
print(m.month)

--2
local function day_of_week(date)
    local t = os.date("*t", date)
    return t.wday -- 1 - is Sunday
end
print(day_of_week(os.time()))

--8
local function produce_time_zone()
    local t = os.time(os.date("*t"))
    local utc = os.time(os.date("!*t", t))
    local diff = os.difftime(t, utc)
    return math.tointeger(diff // 3600)
end

print(produce_time_zone())
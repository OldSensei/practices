
Account = {balance=0}
function Account.withdraw(self, v) -- explicit param
    print("Account.withdraw")
    self.balance = self.balance - v
end

function Account:deposit(v) -- implicit param self
    print("Account:deposit")
    self.balance = self.balance + v
end

Account.balance = 100
Account:withdraw(5)
print("balance:", Account.balance)
Account.withdraw(Account, 5) -- explicit pass parameter self
print("balance:", Account.balance)
Account:deposit(5)
print("balance:", Account.balance)


--[[ Object oriented approach could be implimented by using of prototype]]
--[[local mt = { __index = Account}
function Account.new(o)
    local o = o or {}
    setmetatable(o, mt)
    return o
end]]

-- such implimentation allows to make inheritance
function Account:new(o)
    o = o or {}
    self.__index = self
    setmetatable(o, self)
    return o
end

local a = Account:new{balance=10}
a:deposit(10)
print("a.balance:", a.balance) -- 20

local b = Account:new()
print(b.balance)

--inheritance
local SpecialAccount = Account:new()

function SpecialAccount:withdraw(v)
    if v - self.balance >= self:getLimit() then
        error "Insufficient funds"
    end
    self.balance = self.balance - v
end

function SpecialAccount:getLimit()
    return self.limit or 0
end
s = SpecialAccount:new{limit = 1000.0} -- at now self references to the SpecialAccount, so __index refer to the SpecialAccount
s:withdraw(200) -- call SpecialAccount:withdraw
print(s.balance)

function s:getLimit() -- overload method for instance s
    return self.balance * 0.10
end

-- s:withdraw(200) -- call error "Insufficient funds" because s:getLimit()

--[[Multiple inheritance]]

local function search_m(k, plist)
    for i = 1, #plist do
        local v = plist[i][k]
        if v then return v end
    end
end

function createClass(...)
    local c = {}
    local parents = { ... }

    setmetatable(c, { __index = function(t, k)
        return search_m(k, parents)
    end})

    c.__index = c

    function c:new(o)
        o = o or {}
        setmetatable(o, c)
        return o
    end

    return c
end

local Named = {}
function Named:getname()
    return self.name
end

function Named:setname(n)
    self.name = n
end

NamedAccount = createClass(Account, Named)

account = NamedAccount:new{name = "Paul"}
print(account:getname())

--[[ privacy ]]
-- implimented through the closures and interfaces
function newAccount(initialBalance)
    local self = {
        balance = initialBalance
    }

    local withdraw = function(v)
        self.balance = self.balance - v
    end

    local deposit = function(v)
        self.balance = self.balance + v
    end

    local getBalance = function()
        return self.balance
    end

    return {
        withdraw = withdraw,
        deposit = deposit,
        getBalance = getBalance
    }
end

local acc = newAccount(10)
acc.deposit(5)
print(acc.getBalance()) -- 15

--[[single method approach]]
-- if we are interested in only method, we could return function instead of table
function createObject(value)
    return function (action, v)
        if action == "get" then return value
        elseif action == "set" then value = v
        else
            error "unexpected action"
        end
    end
end

d = createObject(10)
print(d("get")) -- 10
d("set", 5)
print(d("get")) -- 5

--[[dual representation approach]]

local balance_t = {}

local Account2 = {}

function Account2:withdraw(v)
    balance_t[self] = balance_t[self] + v
end

function Account2:deposit(v)
    balance_t[self] = balance_t[self] - v
end

function Account2:balance()
    return balance_t[self]
end

function Account2:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    balance_t[o] = 0
    return o
end

a2 = Account2:new()
a2:deposit(100.0)
print(a2:balance())

--Exercises
--21.1
print("Exercise 21.1")
Stack = {}
function Stack:new(o)
    local stack = {}
    stack.values = o or {}

    setmetatable(stack, self)
    self.__index = self
    self.__tostring = function(t)
        local s = "{ "
        for i, v in ipairs(t.values) do
            s = s .. v .. " "
        end
        s = s .. "}"
        return s
    end

    return stack
end

function Stack:push(v)
    self.values[#self.values + 1] = v
end

function Stack:pop()
    self.values[#self.values] = nil
end

function Stack:top()
    return self.values[#self.values]
end

function Stack:isEmpty()
    return #self.values == 0
end

st1 = Stack:new{1, 5, 10}
st1:push(2)
print(st1)

--21.2
print("Exercise 21.2")
StackQueue = Stack:new()
function StackQueue:insertBottom(v)
    table.move(self.values, 1, #self.values, 2)
    self.values[1] = v
end

local st2 = StackQueue:new{2, 3, 4}
st2:push(9)
st2:insertBottom(0)
print(st2)
st2:insertBottom(12)
print(st2)

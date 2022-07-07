N = 8

--[[
    multiline comment
]]

-- check if position is free from attacks
function isplaceok (a, n, c)
    for i = 1, n - 1 do
        if (a[i] == c) or
           (a[i] - i == c - n) or
           (a[i] + i == c + n) then
            return false
        end
    end
    return true
end

function printsolution (a)
    for i = 1, N do
        for j = 1, N do
            io.write(a[i] == j and "X" or "-", " ")
        end
        io.write("\n")
    end
    io.write("\n")
end

function addqueen(a, n)
    if n > N then
        printsolution(a)
    else -- try to place n-th queen
        for c = 1, N do
            if isplaceok(a, n, c) then
                a[n] = c
                addqueen(a, n + 1)
            end
        end
    end
end

function checkpermutation (a)
    --for ind = 1, N do
    --    io.write(a[ind], " ")
    --end
    for i = 1, N do
        if (not isplaceok(a, i, a[i])) then
            --io.write("false\n")
            return false
        end
    end
    --io.write("true\n")
    return true
end

function factorial(n)
    result = 1
    for i = 1, n do
        result = result * i
    end
    return result
end

function advance (a, r)
    if r == 0 then
        return
    end

    a[r] = a[r] + 1
    if a[r] > N then
        a[r] = 1
        advance(a, r - 1)
    end
end

function swap(a, i, j)
    tmp = a[i]
    a[i] = a[j]
    a[j] = tmp
end

-- Heap's algorithm for generation of permutation
function heapGeneration(a)
    c = {}
    for i = 1, N do
        c[i] = 1
    end

    if checkpermutation(a) then
        printsolution(a)
    end

    i = 1
    while i <= N do
        if c[i] < i then
            if i % 2 == 0 then
                swap(a, 1, i)
            else
                swap(a, c[i], i)
            end

            if checkpermutation(a) then
                printsolution(a)
            end

            c[i] = c[i] + 1
            i = 1
        else
            c[i] = 1
            i = i + 1
        end
    end
end

--addqueen({}, 1)
heapGeneration({1, 2, 3, 4, 5, 6, 7, 8})

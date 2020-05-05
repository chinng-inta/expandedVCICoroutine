local functionTable = {}

local function startCoroutine(func, ...)
    local co = coroutine.create(func)
    local pair = { co = co, ret = nil }
    
    pair.ret = coroutine.resume(co, ...)
    table.insert(functionTable, pair)
end

local function updateCoroutine()
    local cnt = 0
    for i = 1, #functionTable do
        local co = functionTable[i].co
        local status = coroutine.status(co) 
        if status == "dead" then
            local c = table.remove(functionTable, i)
            table.insert(functionTable, 1, c)
            cnt = cnt + 1
        elseif status ~= "running" then
            functionTable[i].ret = coroutine.resume(co, functionTable[i].ret)
        end
    end
    for i = 1, cnt do
        table.remove(functionTable, 1)
    end
end

-- VScodeのインテリセンス(入力予測)を使用するのに必要
return {
    startCoroutine = startCoroutine,
    updateCoroutine = updateCoroutine
}
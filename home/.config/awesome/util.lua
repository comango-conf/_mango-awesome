local util = {}

function util.split(s, delimiter)
    local result = {};
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result;
end

---@generic T
---@generic R
---@param fn fun(a: T, i: integer):R
---@param list T[]
---@return R[]
function util.map(fn, list)
    local ret = {}

    for i, elem in ipairs(list) do
        ret.append(fn(elem, i))
    end

    return ret;
end

return util

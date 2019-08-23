local Type = {}
Brazier.Type = Type

function Type.isArray(x)
  if type(x) == "table" then
    if getn(x) > 0 then return true end
    for _ in pairs(x) do
      return false
    end
    return true
  else
    return false
  end
end

function Type.isBoolean(x)
  return type(x) == "boolean"
end

function Type.isFunction(x)
  return type(x) == "function"
end

function Type.isNumber(x)
  return type(x) == "number"
end

function Type.isTable(x)
  return type(x) == "table" and x[1] == nil
end

function Type.isString(x)
  return type(x) == "string"
end

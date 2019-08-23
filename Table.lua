local M = Brazier.Maybe

local Table = {}
Brazier.Table = Table

-- [K, V] @ Table[K, V] => Table[K, V]
function Table.clone(obj)
  local out = {}
  for key, value in pairs(obj) do
    out[key] = value
  end
  return out
end

-- [K] @ Table[K, _] => Array[K]
function Table.keys(obj)
  local out = {}
  for key, _ in pairs(obj) do
    table.insert(out, key)
  end
  return out
end

-- [K, V] @ K => Table[K, V] => Maybe[V]
function Table.lookup(key)
  return function(obj)
    return M.maybe(obj[key])
  end
end

-- [K, V] @ Table[K, V] => Array[(K, V)]
function Table.pairs(obj)
  local out = {}
  for key, value in pairs(obj) do
    table.insert(out, { key, value })
  end
  return out
end

-- Table[_, _] => Number
function Table.size(obj)
  local out = 0
  for _ in pairs(obj) do
    out = out + 1
  end
  return out
end

-- [V] @ Table[_, V] => Array[V]
function Table.values(obj)
  local out = {}
  for _, value in pairs(obj) do
    table.insert(out, value)
  end
  return out
end

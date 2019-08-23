local E = Brazier.Equals
local M = Brazier.Maybe
local T = Brazier.Type

local Array = {}
Brazier.Array = Array

-- [T] @ (T => Boolean) => Array[T] => Boolean
function Array.all(f)
  return function(arr)
    for _, x in ipairs(arr) do
      if not f(x) then
        return false
      end
    end
    return true
  end
end

-- [T] @ Array[T] => Array[T] => Array[T]
function Array.concat(xs)
  return function(ys)
    local out = {}
    for _, x in ipairs(xs) do
      table.insert(out, x)
    end
    for _, y in ipairs(ys) do
      table.insert(out, y)
    end
    return out
  end
end

-- [T] @ T => Array[T] => Boolean
function Array.contains(x)
  return function(arr)
    for _, item in ipairs(arr) do
      if E.eq(x)(item) then
        return true
      end
    end
    return false
  end
end

-- [T, U] @ (T => U) => Array[T] => Table[U, Number]
function Array.countBy(f)
  return function(arr)
    local out = {}
    for _, x in ipairs(arr) do
      local key = f(x)
      if out[key] ~= nil then
        out[key] = out[key] + 1
      else
        out[key] = 1
      end
    end
    return out
  end
end

-- [T] @ Array[T] => Array[T] => Array[T]
function Array.difference(xs)
  return function(arr)
    local out     = {}
    local badBoys = Array.unique(arr)
    for _, x in ipairs(xs) do
      if not Array.contains(x)(badBoys) then
        table.insert(out, x)
      end
    end
    return out
  end
end

-- [T] @ (T => Boolean) => Array[T] => Boolean
function Array.exists(f)
  return function(arr)
    for _, x in ipairs(arr) do
      if f(x) then
        return true
      end
    end
    return false
  end
end

-- [T] @ (T => Boolean) => Array[T] => Array[T]
function Array.filter(f)
  return function(arr)
    local out = {}
    for _, x in ipairs(arr) do
      if f(x) then
        table.insert(out, x)
      end
    end
    return out
  end
end

-- [T] @ (T => Boolean) => Array[T] => Maybe[T]
function Array.find(f)
  return function(arr)
    for _, x in ipairs(arr) do
      if f(x) then
        return M.Something(x)
      end
    end
    return M.None
  end
end

-- [T] @ (T => Boolean) => Array[T] => Maybe[Number]
function Array.findIndex(f)
  return function(arr)
    for i, x in ipairs(arr) do
      if f(x) then
        return M.Something(i)
      end
    end
    return M.None
  end
end

-- [T, U] @ (T => Array[U]) => Array[T] => Array[U]
function Array.flatMap(f)
  return function(arr)

    local arrs = {}
    for _, x in ipairs(arr) do
      table.insert(arrs, f(x))
    end

    local out = {}
    for _, items in ipairs(arrs) do
      for _, item in ipairs(items) do
        table.insert(out, item)
      end
    end

    return out

  end
end

-- [T, U] @ Array[T] => Array[U]
function Array.flattenDeep(arr)
  local out = {}
  for _, x in ipairs(arr) do
    if T.isArray(x) then
      out = Array.concat(out)(Array.flattenDeep(x))
    else
      table.insert(out, x)
    end
  end
  return out
end

-- [T, U] @ ((U, T) => U) => U => Array[T] => U
function Array.foldl(f)
  return function(acc)
    return function(arr)
      out = acc
      for _, x in ipairs(arr) do
        out = f(out, x)
      end
      return out
    end
  end
end

-- [T] @ (T => Unit) => Array[T] => Unit
function Array.forEach(f)
  return function(arr)
    for _, x in ipairs(arr) do
      f(x)
    end
  end
end

-- [T] @ Array[T] => Maybe[T]
function Array.head(arr)
  return Array.item(1)(arr)
end

-- [T] @ Array[T] => Boolean
function Array.isEmpty(arr)
  return getn(arr) == 0
end

-- [T] @ Number => Array[T] => Maybe[T]
function Array.item(index)
  return function(xs)
    if (1 <= index) and (index <= getn(xs)) then
      return M.Something(xs[index])
    else
      return M.None
    end
  end
end

-- [T] @ Array[T] => T
function Array.last(arr)
  return arr[getn(arr)]
end

-- [T] @ Array[T] => Number
function Array.length(arr)
  return getn(arr)
end

-- [T, U] @ (T => U) => Array[T] => Array[U]
function Array.map(f)
  return function(arr)
    local out = {}
    for _, x in ipairs(arr) do
      table.insert(out, f(x))
    end
    return out
  end
end

-- [T] @ (T => Number) => Array[T] => T
function Array.maxBy(f)
  return function(arr)
    local maxX = nil
    local maxY = -math.huge
    for _, x in ipairs(arr) do
      local y = f(x)
      if y > maxY then
        maxX = x
        maxY = y
      end
    end
    return M.maybe(maxX)
  end
end

-- [T] @ (T*) => Array[T]
function Array.pack(...)
  return { ... }
end

-- [T] @ Array[T] => Array[T]
function Array.reverse(xs)
  local out = {}
  for i, _ in ipairs(xs) do
    table.insert(out, xs[getn(xs) - (i - 1)])
  end
  return out
end

-- [T] @ T => Array[T]
function Array.singleton(x)
  return { x }
end

-- [T] @ (T => Comparable) => Array[T] => Array[T]
function Array.sortBy(f)
  return function(arr)

    local copy = {}
    for _, x in ipairs(arr) do
      table.insert(copy, x)
    end

    local comp = function(x, y)
      return f(x) < f(y)
    end

    table.sort(copy, comp)

    return copy

  end
end

-- [T] @ (T => Comparable) => Array[T] => T => Number
-- Assumes that `arr` is already sorted in terms of `f`
function Array.sortedIndexBy(f)
  return function(arr)
    return function(x)
      local y = f(x)
      for i, item in ipairs(arr) do
        if y <= f(item) then
          return i
        end
      end
      return getn(arr) + 1
    end
  end
end

-- [T] @ Array[T] => Array[T]
function Array.tail(arr)
  return Array.pack(select(2, unpack(arr)))
end

-- [K, V] @ Array[(K, V)] => Table[K, V]
function Array.toTable(arr)
  local out = {}
  for _, x in ipairs(arr) do
    out[x[1]] = x[2]
  end
  return out
end

-- [T] @ Array[T] => Array[T]
function Array.unique(arr)
  local out = {}
  for _, x in ipairs(arr) do
    if not Array.contains(x)(out) then
      table.insert(out, x)
    end
  end
  return out
end

-- [T, U] @ (T => U) => Array[T] => Array[T]
function Array.uniqueBy(f)
  return function(arr)
    local out  = {}
    local seen = {}
    for _, x in ipairs(arr) do
      local y = f(x)
      if not Array.contains(y)(seen) then
        table.insert(seen, y)
        table.insert( out, x)
      end
    end
    return out
  end
end

-- [T, U] @ Array[T] => Array[U] => Array[(T, U)]
function Array.zip(xs)
  return function(arr)
    local out    = {}
    local length = math.min(getn(xs), getn(arr))
    for i = 1, length, 1 do
      table.insert(out, { xs[i], arr[i] })
    end
    return out
  end
end

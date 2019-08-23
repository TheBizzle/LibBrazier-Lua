local O = Brazier.Table
local T = Brazier.Type

local Equals = {}
Brazier.Equals = Equals

-- [T] @ Array[T] => Array[T] => Boolean
function Equals.arrayEquals(x)
  return function(y)
    local helper = function(a, b)
      for index, item in ipairs(a) do
        if not Equals.eq(item)(b[index]) then
          return false
        end
      end
      return true
    end
    return (x == y) or ((getn(x) == getn(y)) and helper(x, y))
  end
end

-- Boolean => Boolean => Boolean
function Equals.booleanEquals(x)
  return function(y)
    return x == y
  end
end

-- Any => Any => Boolean
function Equals.eq(x)
  return function(y)
    return (x == y) or
      (T.isNumber (x) and T.isNumber (y) and Equals.numberEquals (x)(y)) or
      (T.isBoolean(x) and T.isBoolean(y) and Equals.booleanEquals(x)(y)) or
      (T.isString (x) and T.isString (y) and Equals.stringEquals (x)(y)) or
      (T.isTable  (x) and T.isTable  (y) and Equals.tableEquals  (x)(y)) or
      (T.isArray  (x) and T.isArray  (y) and Equals.arrayEquals  (x)(y))
  end
end

-- Number => Number => Boolean
function Equals.numberEquals(x)
  return function(y)
    return x == y
  end
end

-- [T, U] @ Table[T, U] => Table[T, U] => Boolean
function Equals.tableEquals(x)
  return function(y)
    local xKeys = O.keys(x)
    local helper = function(a, b)
      for i = 1, getn(xKeys), 1 do
        local key = xKeys[i]
        if not Equals.eq(x[key])(y[key]) then
          return false
        end
      end
      return true
    end
    return (x == y) or ((getn(xKeys) == getn(O.keys(y))) and helper(x, y))
  end
end

-- String => String => Boolean
function Equals.stringEquals(x)
  return function(y)
    return x == y
  end
end

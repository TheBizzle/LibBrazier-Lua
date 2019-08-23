local Function = {}
Brazier.Function = Function

-- [T] @ (T*) => Array[T]
local function pack(...)
  return { n = select("#", ...), ... }
end

-- [T] @ Array[T] => Array[T]
local function tail(arr)
  return pack(select(2, unpack(arr)))
end

-- [T, U] @ (T => U) => T => U
function Function.apply(f)
  return function(x)
    return f(x)
  end
end

-- [T] @ T => Unit => T
function Function.constantly(x)
  return function()
    return x
  end
end

-- [T, U, V] @ (T => U => V) => (U => T => V)
function Function.flip(f)
  return function(x)
    return function(y)
      return f(y)(x)
    end
  end
end

-- [T] @ T => T
function Function.id(x)
  return x
end

-- [T] @ (T => T)* => (T => T)
function Function.pipeline(...)
  local functions = pack(...)
  return function(...)
    local h   = functions[1]
    local fs  = tail(functions)
    local out = h(...)
    for _, f in ipairs(fs) do
      out = f(out)
    end
    return out
  end
end

-- [T, U, V] @ (T => U) => (T => V) => T => (U, V)
function Function.tee(f)
  return function(g)
    return function(x)
      return { f(x), g(x) }
    end
  end
end

-- (? => ?) => Function?
function Function.uncurry(f)
  return function(...)
    local args = pack(...)
    local out = f
    for _, arg in ipairs(args) do
      out = out(arg)
    end
    return out
  end
end

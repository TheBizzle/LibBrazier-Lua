local Maybe = {}
Brazier.Maybe = Maybe

-- Maybe[Nothing]
Maybe.None = {}

-- [T] @ T => Maybe[T]
function Maybe.Something(x)
  return { _type = "something", _value = x }
end

-- [T] @ (T => Boolean) => Maybe[T] => Maybe[T]
function Maybe.filter(f)
  return function(maybe)
    return Maybe.flatMap(
      function(x)
        if f(x) then
          return Maybe.Something(x)
        else
          return Maybe.None
        end
      end
    )(maybe)
  end
end

-- [T, U] @ (T => Maybe U) => Maybe[T] => Maybe[U]
function Maybe.flatMap(f)
  return function(maybe)
    return Maybe.fold(function() return Maybe.None end)(f)(maybe)
  end
end

-- [T, U] @ (Unit => U) => (T => U) => Maybe[T] => U
function Maybe.fold(ifNone)
  return function(ifSomething)
    return function(maybe)
      if Maybe.isSomething(maybe) then
        return ifSomething(maybe._value)
      else
        return ifNone()
      end
    end
  end
end

-- Maybe[_] => Boolean
function Maybe.isSomething(maybe)
  return type(maybe) == "table" and maybe._type == "something"
end

-- [T, U] @ (T => U) => Maybe[T] => Maybe[U]
function Maybe.map(f)
  return function(maybe)
    return Maybe.fold(function() return Maybe.None end)(function(x) return Maybe.Something(f(x)) end)(maybe)
  end
end

-- [T] @ T => Maybe[T]
function Maybe.maybe(x)
  if x ~= nil then
    return Maybe.Something(x)
  else
    return Maybe.None
  end
end

-- [T] @ Maybe[T] => Array[T]
function Maybe.toArray(maybe)
  return Maybe.fold(function() return {} end)(function(x) return { x } end)(maybe)
end

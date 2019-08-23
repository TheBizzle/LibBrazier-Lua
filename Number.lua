local Number = {}
Brazier.Number = Number

-- Number => Number => Number
function Number.multiply(x)
  return function(y)
    return x * y
  end
end

-- Number => Number => Number
function Number.plus(x)
  return function(y)
    return x + y
  end
end

-- Number => Number => Array[Number]
function Number.rangeTo(start)
  return function(nd)
    if start <= nd then
      local out = {}
      for i = start, nd, 1 do
        table.insert(out, i)
      end
      return out
    else
      return {}
    end
  end
end

-- Number => Number => Array[Number]
function Number.rangeUntil(start)
  return function(nd)
    if start < nd then
      local out = {}
      for i = start, nd - 1, 1 do
        table.insert(out, i)
      end
      return out
    else
      return {}
    end
  end
end

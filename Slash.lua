-- String => Unit
local function handleSlash(msg)
  if msg == 'test' msg == 'test all' then
    TestSuite.runAll()
  elseif msg == 'test array' then
    TestSuite.runArray()
  elseif msg == 'test equals' then
    TestSuite.runEquals()
  elseif msg == 'test function' then
    TestSuite.runFunction()
  elseif msg == 'test maybe' then
    TestSuite.runMaybe()
  elseif msg == 'test number' then
    TestSuite.runNumber()
  elseif msg == 'test table' then
    TestSuite.runTable()
  elseif msg == 'test type' then
    TestSuite.runType()
  end
end

SLASH_BRAZIER = '/brazier'

SlashCmdList["BRAZIER"] = handleSlash

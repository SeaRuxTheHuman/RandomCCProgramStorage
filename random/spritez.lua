w,h = term.getSize()


local sprites = {
{'<','-'},
{'>','-'},
{'_', '|'},
{'~','|'},
'#'
}

local tracker = {w/2,h/2}
local trueX, trueY = tracker[1], tracker[2]
local oldX, oldY

local function tableReplace(tableIn, numb, var)
  if type(tableIn)=='table' then
    table.remove(tableIn, tonumber(numb))
    table.insert(tableIn, tonumber(numb), var)
  else
    error('table Required')
  end
end

local function trackerUpdate(newX,newY)
  oldX,oldY = tracker[1],tracker[2]
  table.remove(tracker,1) table.insert(tracker,1,trueX+newX)
  table.remove(tracker,2) table.insert(tracker,2,trueY+newY)
  trueX, trueY = tracker[1], tracker[2]
end

local function drawCurrent(num) 
  --term.clear()
  term.setCursorPos(trueX,trueY)
  if num > 4 then
    term.write(sprites[num])
  elseif num < 5 then
    term.write(sprites[num][1])
  else
  end
end

local function drawTrails(num)
  term.clear()
  term.setCursorPos(oldX,oldY)
  if num < 5 then
    term.write(sprites[num][2])
  else
    error('drawTrails;num>4')
  end 
end

term.clear()
drawCurrent(5)

while true do
local event, key = os.pullEvent('key')
--print(keys.getName(key))
if key == keys.up then
  trackerUpdate(0,-1)
  drawTrails(3)
  drawCurrent(3)
elseif key == keys.down then
  trackerUpdate(0,1)
  drawTrails(4)
  drawCurrent(4)
elseif key == keys.left then
  trackerUpdate(-1,0)
  drawTrails(1)
  drawCurrent(1)
elseif key == keys.right then
  trackerUpdate(1,0)
  drawTrails(2)
  drawCurrent(2)
else
  term.clear()
  drawCurrent(5)
end
end



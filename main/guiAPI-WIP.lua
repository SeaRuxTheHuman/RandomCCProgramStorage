--good practice in my opinion
term.clear()
term.setCursorPos(1,1)
--Wrap initial variables
local maxX, maxY = term.getSize()
local myTable = {
{5,5,"@"}
}
local myTable2 = {}



--Something to save time
local function sReplace(list,val,data)
    if type(list)~='table' then
        error('table expected, got '..type(list))
    end
    if type(val)~= 'number' then
        error('number expected, got '..type(val))
    end
    table.remove(list,val)
    table.insert(list,val,data)
end

---Important stuff starts here
local function sWrite(list, txt)--works similar to term.write(string)
  local w,h = term.getCursorPos()
  table.insert(list, {w,h,tostring(txt)})
  term.write(tostring(txt))
end

local function sPrint(list, sString)--we know a print command when we see one ;)
    local w,h = term.getCursorPos()
    sWrite(list, sString)
    term.setCursorPos(w-string.len(sString),h+1)
end

local function sUpdate(list, numbX, numbY) --update the screen by an ammount of positive/negative x/y coordinates.
    if type(list)~='table' then
        error('table expected, got '..type(list))
    end
    if type(numbX)~= 'number' or type(numbY)~= 'number' then
        error('number expected, got '..type(val))
    end
	
	term.clear() --until i have a better way
	for i = 1,#list do
		local x,y = list[i][1], list[i][2]
		term.setCursorPos(x+numbX,y+numbY)
		sReplace(list[i],1,x+numbX)
		sReplace(list[i],2,y+numbY)
		term.write(list[i][3]) 
	end
end

local function testFilcker(xXx,yYy) -- a debugging function
	for i =1,10 do
		sleep(0.1)
		sUpdate(myTable,xXx,yYy)
	end
end

--testFilcker(1,0) -some more dubug :)
sUpdate(myTable,0,0)

while true do
event, key = os.pullEvent('key')
if key == keys.down then
  sUpdate(myTable, 0, 1)
elseif key == keys.up then
  sUpdate(myTable, 0, -1)
elseif key == keys.left then
  sUpdate(myTable, -1, 0)
elseif key == keys.right then
  sUpdate(myTable, 1, 0)
else
end
end





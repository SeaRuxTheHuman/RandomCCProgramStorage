myTable={
{2,1,'#'},
{2,2,'#'},
{2,3,'#'},
{2,4,'#'},
{2,5,'#'}
}

player='&'

trueX,trueY=1,1
oldX, oldY=1,1

term.clear()
term.setCursorPos(1,1)

local function drawMap()
    for i = 1,#myTable do
        local x,y = myTable[i][1],myTable[i][2]
        term.setCursorPos(x,y)
        term.write(myTable[i][3])
    end
end

local function canFuktionUpdate()

end

local function fuktionUpdate(numA,numB)
    oldX,oldY = trueX,trueY
    trueX,trueY = trueX+numA, trueY+numB
    term.setCursorPos(oldX,oldY)
    term.write(' ')
    term.setCursorPos(trueX, trueY)
    term.write(player)
end

--[[
local function 
    
end
]]--

while true do --the magic while loop
    event, key = os.pullEvent('key')
    kKey=keys.getName(key)
    
    term.setCursorPos(1,1)
    term.clearLine()
    --term.write()
    
    if kKey == 'up' then
        fuktionUpdate(0,-1)
    elseif kKey == 'down' then
        fuktionUpdate(0,1)
    elseif kKey == 'left' then
        fuktionUpdate(-1,0)
    elseif kKey == 'right' then
        fuktionUpdate(1,0)
    elseif kKey == 'n' then
        print('your a [insert racial slur]')
    else
    end

end

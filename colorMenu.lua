local tTable={}


local localKeys = {
{2,'1','!'}; 
{3,'2','@'};
{4,'3','#'};
{5,'4','$'};
{6,'5','%'};
{7,'6','^'};
{8,'7','&'};
{9,'8','*'};
{10,'9','('};
{11,'0',')'};
{12,'-','_'};
{13,'=','+'};
--add more keys here
{41,'`','~'};
--and here!
{51,',','<'};
{52,'.','>'};

}

local keyFile=textutils.serialise(localKeys)
f=fs.open('projectKeychecks/keyList.txt', 'w')
f.write(keyFile)
f.close()

local xSize, ySize = term.getSize()

local function dDebug()

term.setTextColor(colors.black)
for i = 1,#localKeys do
term.setCursorPos(xSize/2, i)
term.write(localKeys[i][1])
sleep(1)
end



--[[
term.setCursorPos(xSize/2,1)
term.write(localKeys[5][2])
]]--
end

local function readyStuff()
    paintutils.drawFilledBox(1,1,xSize,ySize, colors.lightBlue)
    
    paintutils.drawFilledBox(xSize/2-12,1,xSize/2+13,ySize, colors.white)
    term.setTextColor(colors.black)
    term.setBackgroundColor(colors.white)
    --dDebug()
end

local function fillTable()
    for i = 1,21 do
      table.insert(tTable, {})
        for j = 1,25 do
         table.insert(tTable[i], ' ')
        end
    end
end

fillTable()

local function writeChar(sString)
    local sString = tostring(sString)
    if string.len(sString) > 1 then 
        error('too many characters')
        --printError('too Many Characters')
    end
    
    local trX,y=term.getCursorPos()
    
    x = trX-12
    
    for i = 1,y do
      if tTable[i] == nil then
          table.insert(tTable,{})
      end
    end
    
    for i = 1,x do
        if tTable[y][i] == nil then
            table.insert(tTable,{})
        end
    end
    if trX<39 and trX>12 then 
        if tTable[y][x] ~= nil then
            table.remove(tTable[y],x)
        end
        table.insert(tTable[y],x,sString)
        term.write(sString)  
    end
    
    if trX>37 then 
        term.setCursorPos(trX-25,y+1)
    end 
end

local function mouseCursor()
    
end

readyStuff()

local shift = false

---------------------------------LOOP STARTS HERE
while true do
 local event,valA,valB,valC=os.pullEvent()
  if event == 'mouse_click' then --mouse click
      if valB > xSize/2+13 then
      break
      else
      term.setCursorPos(valB,valC)
      wW,hH = valB,valC
      end
        
  elseif event == 'key' then --key click
  
    for i = 1,#localKeys do
      if valA == localKeys[i][1] then
          kKey=localKeys[i]
          break
      else
          kKey=keys.getName(valA)
      end
    end
    
    if keys.getName(valA)=='leftShift' then
         shift=true
    end   
    
    if shift then
        if type(kKey) == 'table' then
            kKey=kKey[3]
        end
        
        if string.len(kKey) < 2 then
            writeChar(string.upper(kKey))
            shift=false
        end
    elseif not shift then  
        if type(kKey) == 'table' then
            kKey = kKey[2]
        end 
                 
        if string.len(kKey) < 2 then
            writeChar(kKey)
        end
    else
    end
       
    if keys.getName(valA) == 'space' then
        writeChar(' ')
    elseif keys.getName(valA) == 'enter' then
        term.setCursorPos(wW,hH+1)
        wW,hH=wW,hH+1
    elseif keys.getName(valA) == 'backspace' then
        local xN,yN = term.getCursorPos()
        term.setCursorPos(xN-1,yN)
        writeChar(' ')
        term.setCursorPos(xN-1,yN)
    else
    end
        
  else
  end  
end


term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1,1)


y=1
local fileDir='temp.tst'
if fs.exists(fileDir) == true then
  fs.delete(fileDir)
else
end

file = fs.open(fileDir, 'w')
for i = 1,#tTable do

    --for j = 1,#tTable[i] do
    --  term.write(tTable[i][j])
    --end
    term.write(table.concat(tTable[i]))
    file.writeLine(table.concat(tTable[i]))
    term.setCursorPos(1,y+1)
    y=y+1
    sleep(0.1)
end

file.close()

x,y=term.getSize()
term.setCursorPos(1,y)


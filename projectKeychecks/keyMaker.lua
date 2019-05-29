local tArgs = { ... }


local temp={}
local x,y=1,1
local DIR='projectKeychecks/keyList.txt'
local maxX, maxY = term.getSize()
term.clear()
term.setCursorPos(1,1)

if #tArgs > 0 then
  if fs.exists(DIR) then
    local fFile=fs.open(DIR, 'r')
    local lList=textutils.unserialize(fFile.readAll())
    fFile.close()
     for i = 1,#lList do
       print(lList[i][1]..'-'..lList[i][2]..'-'..lList[i][3])
       sleep(0.3)
     end
  else
    print('no data - file missing')
  end
  return
end

while true do
    local event, key, _ = os.pullEvent('key')
    
     if fs.exists(DIR) then
        file = fs.open(DIR,'r')
          temp = file.readAll()
          temp = textutils.unserialise(temp)
        file.close()
     end
    
      --print("2; 1; !"
    lX,lY = term.getCursorPos()
    if lY > maxY-2 then
      term.clear()
      term.setCursorPos(1,1)
      x,y=1,1
    end
    term.write('"'..key..'; ')
    Nutz = string.len(key)
    fKey=tostring(read())
    term.setCursorPos(5+Nutz+string.len(fKey),y)
    term.write('; ')
    tKey=tostring(read())
    term.setCursorPos(8+Nutz+string.len(tKey),y)
    term.write('"')
    y=y+1
    term.setCursorPos(1,y)
    
    if key == 29 and string.len(fKey) < 2 then
     break
    end
    
    table.insert(temp,{tonumber(key),fKey,tKey})
    
    if fs.exists(DIR) then
        fs.delete(DIR)
    end
 
    file=fs.open(DIR,'w')
      file.write(textutils.serialise(temp))
    file.close()
 
end

term.clear()
term.setCursorPos(1,1)
local file=fs.open(DIR, 'r')
tTable=textutils.unserialise(file.readAll())
file.close()

for i = 1,#tTable do
 print(tTable[i][1],tTable[i][2],tTable[i][3])
end



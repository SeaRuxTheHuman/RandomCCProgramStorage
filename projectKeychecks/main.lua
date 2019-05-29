keyListDIR='projectKeychecks/keyLists/keyListAlpha.txt'
local function loadData(fileDIR)
    if fs.exists(fileDIR) then
        local file = fs.open(fileDIR, 'r')
        local data = file.readAll()
        file.close()
        local data=textutils.unserialise(data)
        return data
    else
        error('Directory Invalid')
    end
end -- just something to load needed tables from
    -- external sources
    
myTable = loadData(keyListDIR)

while true do --start out enevitable while loop
local id,p1,p2,p3,p4,p5=os.pullEvent()
    if id == 'key' then
      keyInput = tostring(keys.getName(p1))
      for i=1,#myTable do
        if p1 == myTable[i][1] then
          keyInput = tostring(myTable[i][2])
          break
        end
      end
      print(keyInput)      
    end
end



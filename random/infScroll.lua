local store = {
{6,3,"#"},
{6,4,"#"},
{6,5,"#"},
{6,6,"#"}
}

local maxX,maxY=term.getSize()

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

local function sWrite(list)
    if type(list) ~= 'table' then
        error('table expected, got '..type(list))
    end
    
    for i = 1,#list do
        term.setCursorPos(list[i][1],list[i][2])
        term.write(tostring(list[i][3]))
    end
end


--need to intergrate 2ndary sWrite() like function
--into sMove() and only use actual sWrite() for
--static printing of table data

local function sMove(list,xVal,yVal)
    if type(list)~='table' then
        error('table expected, got '..type(list))        
    end
    for i=1,#list do
        local tX,tY=list[i][1],list[i][2]
        if tX < maxX then
            sReplace(list[i],1,tX+xVal)
        else
            sReplace(list[i],1,1)
        end
        if tY < maxY then
            sReplace(list[i],2,tY+yVal)
        else
            sReplace(list[i],2,1)  
        end
        
    end
end


--sWrite(store)
while true do
    local wW,hH = term.getCursorPos()
    sleep(0.1)
    sMove(store,0,1)
    
    --add something to functions that works better
    --than this 
    -->>>
    term.setCursorPos(1,hH-3)
    term.clearLine()
    --<<<
    
    sWrite(store)
end

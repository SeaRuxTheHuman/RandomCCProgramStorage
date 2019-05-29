term.clear()
term.setCursorPos(1,1)
local tArgs={...}
local temp={}

if #tArgs > 0 then
	if not fs.exists(tArgs[1]) then
		error('Usage: tablePaint [fileDir]')
	end
	
	local file = fs.open(tArgs[1], 'r')
	local result = file.readAll()
	file.close()
	local result = textutils.unserialise(result)
	local result = result
	if type(result)~='table' then
        error('table expected, got '..type(result))
    end
	for i=1,#result do
		if result[i][1]~= nil then
		term.setCursorPos(result[i][1],result[i][2])
		term.write(result[i][3])
		else
		error('check table file at entry '..i)
		end
	end
end

local function tableCheck(valueA, dataA, valueB, dataB)
    for i = 1,#temp do
        if temp[i][valueA]==dataA and temp[i][valueB]==dataB then
            return true, i 
        end
    end
    return false, nil
end

while true do
    local event,button,mX,mY = os.pullEvent('mouse_click')
    if button>1 then
        break
    end
    
    if button==1 then
        local bolen,rslt = tableCheck(1,mX,2,mY)
        if bolenA then
            table.remove(temp[rslt],1)
            table.remove(temp[rslt],2)
            table.insert(temp[rslt],1,mX,"#")
            table.insert(temp[rsly],2,mY,"#")
        else
            table.insert(temp,{mX,mY,"#"})
        end
        
        term.setCursorPos(mX,mY)
        term.write('#')
    end
end

file = fs.open('written.temp', 'w')
file.write(textutils.serialise(temp))
file.close()

term.clear()
term.setCursorPos(1,1)

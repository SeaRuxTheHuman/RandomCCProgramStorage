local tArgs = {...}
local name = tArgs[1]
local printer_name = tArgs[2] or ""
local data = {}
if #tArgs < 1 then
    error("usage: program <name> <printer name(optional)>")
end

term.clear()
term.setCursorPos(1,2)
print("#>>"..name)
if not fs.isDir("/cheWIPS") then
    fs.makeDir("cheWIPS")
end
if fs.isDir("/cheWIPS") and fs.exists("/cheWIPS/"..name)  then
    local file = fs.open("/cheWIPS/"..name, "r")
    file.readLine()--skip first line as it has title data
    repeat
        local line = file.readLine()
        if line and #line>0 then
            data[#data+1]=line
            print("> "..line)
        end
    until line == "" or not line
end
term.scroll(1)
local posX,posY = term.getCursorPos()
term.setCursorPos(1,posY)
term.write("> ")


local function save_data()
    fs.delete("/cheWIPS/"..name)
    local file = fs.open("/cheWIPS/"..name, "w")
    file.writeLine("#>>"..name)
    for _,d in pairs(data) do
        file.writeLine(d)
    end
    file.close()
end

local function print_data()
    local printer = peripheral.wrap(printer_name) or peripheral.find('printer')
    if printer.getInkLevel() < 1 then
        error( "out of ink" )
    end
    if printer.getPaperLevel() < 1 then
        error( "out of paper" )
    end
    printer.newPage()
    printer.write("#>>"..name)
    local x,y = printer.getPageSize()
    y=y-1
    for i = 1,#data do
        if i>=y then
            print('page full, ending page')
            print('(multi-page not yet supported)')
            break
        end
        printer.setCursorPos(1,i+1)
        printer.write(data[i])
    end
    local ended = printer.endPage()
    if not ended then
        printError("printer is full, waiting for empty")
        repeat
            ended = printer.endPage()
        until ended
    end
end

local function main()
    local line = ""
    local ctrl = false
    local pX,pY = term.getCursorPos()
    local sX,sY = term.getSize()
    while true do
        local e = {os.pullEvent()}
        if e[1] =="char" then
            line = line..e[2]
            term.write(e[2])
        elseif e[1] == "key" then
            if  e[2] == keys.enter then
                data[#data+1]=line
                line = ""
                pX,pY = term.getCursorPos()
                if pY+1 <= sY-3 then
                    pY=pY+1
                    term.setCursorPos(1,pY)
                    term.write("> ")
                else
                    term.scroll(1)
                    pX,pY = term.getCursorPos()
                    term.setCursorPos(1,pY)
                    term.write("> ")
                end

            elseif e[2] == keys.backspace then
                line = line:sub(1,#line-1)
                pX,pY = term.getCursorPos()
                term.setCursorPos(pX-1,pY)
                term.write(" ")
                term.setCursorPos(pX-1,pY)
            elseif e[2] == 29 then
                ctrl = e[3]
            elseif ctrl and e[2] == keys.d then --save
                save_data()
                print(" SAVED!")
                term.write("> ")
            elseif ctrl and e[2] == keys.p then --print

                local ok,err = pcall(print_data)
                if not ok then
                    printError(err)
                else
                    print('printed')
                end
            elseif ctrl and e[2] == keys.x then --exit
                break
            end
        elseif e[1] == "key_up" and e[2] == 29 then
            ctrl = false
        end
    end
end

main()

redstone.setOutput('top', true)
local chest_data = {}
    chest_data.dump_chests = {}
    chest_data.overflow_list = {}
    chest_data.chest_IDs = {}
    chest_data.sort_table = {}

local function search(item_list, target)
    for slot, item in pairs(item_list) do
        if target == item.name then
            return slot
        end
    end
end

local function get_paper_lists()
    local prefix = "minecraft:chest"
    local cItemName = "computercraft:printout"
    for _,name in pairs(peripheral.getNames()) do
        if name:find(prefix) then
            local chest = peripheral.wrap(name)
            if search(chest.list(), cItemName) then
                local data = chest.getItemMeta(search(chest.list(), cItemName))
                local new_id = false
                for line, text in pairs(data.printout.lines) do
                    if text:find("#>>") then
                        new_id = text:sub(4,text:find(" ")-1)
                        if text:sub(4,11) == "overflow" then
                            table.insert(chest_data.overflow_list, name)
                        elseif text:sub(4,7) == "dump" then
                            table.insert(chest_data.dump_chests, name)
                        else
                            chest_data.chest_IDs[new_id] = name
                        end
                    elseif new_id and text:sub(1,1) ~= " " and new_id~="overflow" and new_id ~= "dump" then
                        chest_data.sort_table[text:sub(1,text:find(" ")-1)] = new_id
                    end
                end
            end
        end
    end
end

local function gen_config()
    get_paper_lists()
    local file = fs.open("config.txt", "w")
    file.write(textutils.serialize(chest_data))
    file.close()
    print('generated new config')
end

local function load_config()
    if not fs.exists("config.txt") then gen_config() end
    local file = fs.open("config.txt", "r")
    local config = file.readAll()
    file.close()
    config = textutils.unserialize(config)
    if not config or type(config) ~= "table" then
        print('malformed config; replacing with new config')
        fs.delete("config.txt")
        gen_config()
    else
        for group,data in pairs(config) do
            chest_data[group]=data
        end
        print("config loaded succsesfully")
    end
end


local function dump_storage(from, to)
    from = peripheral.wrap(from)
    to = peripheral.wrap(to)
    if from and to then
        for i = 1, #from do
            from.pushItems(to, i)
        end
    end
end

local function overflow(item_check, item_meta)
    print('run overflow')
    for i = 1,#chest_data.overflow_list do
        local loaded = peripheral.wrap(chest_data.overflow_list[i])
        if loaded then
            if #loaded.list() == loaded.size() then
                for slot,item in pairs(loaded.list()) do
                    if item.name == item_check.name and item.count < item_meta.maxCount then
                        print('overflow_end-case1')
                        return chest_data.overflow_list[i]
                    end
                end
            else
                print('overflow_end-case2')
                return chest_data.overflow_list[i]
            end
        end
    end
    printError('overflow_end-case3')
    return false
end

local function sort(chest)
    chest = peripheral.wrap(chest)
    if not chest then
        return
    end
    local contents = chest.list()
    for i,_ in pairs(contents) do
        if contents[i].name ~= "computercraft:printout" then
            if chest_data.sort_table[contents[i].name] and chest_data.chest_IDs[chest_data.sort_table[contents[i].name]] ~= "overflow" then
                chest.pushItems(chest_data.chest_IDs[chest_data.sort_table[contents[i].name]], i)
            else
                if overflow(contents[i], chest.getItem(i).getMetadata()) then
                    chest.pushItems(overflow(contents[i], chest.getItem(i).getMetadata()), i)
                else
                    error("all overflow chests are full")
                end
            end
        end
    end
end
--idea, use printed pages to assign sort values
--to chests without doing it manually


local function check_update(chest_table)
    print("starting check")
    for i = 1, #chest_table do
        local loaded = peripheral.wrap(chest_table[i])
        if loaded then
            local contents = loaded.list()
            if #contents > 0 then
                sort(chest_table[i])
                --print("checked1")
            end
            --print('checked2')
        else
            print('non_existant chest')
        end
        print("finished check")
    end
end

local function main()
    load_config()
    --[[
    for k,v in pairs(chest_data.overflow_list) do
        print(k,v)
    end
    sleep(3)
    ]]--
    local interval = 1
    local timer = os.startTimer(interval)
    while true do
        local event = {os.pullEvent()}
        if event[1] == "timer" and event[2] == timer then
            check_update(chest_data.dump_chests)
            print("checked"..event[2])
            timer = os.startTimer(interval)
        end
    end
end



local ok, err = pcall(main)
if not ok then
    printError(err)
    redstone.setOutput('top', false)
end

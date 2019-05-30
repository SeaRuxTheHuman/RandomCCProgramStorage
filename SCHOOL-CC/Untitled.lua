local temp = {}
local kKey = '#'
while true do
  local id,p1,p2,p3 = os.pullEvent()
  if id == 'key' then
    kKey = keys.getName(p1)
  end

  if id == 'mouse_click' then
    table.insert(temp,{p2,p3,kKey,colors.blue,colors.white})
  end
end

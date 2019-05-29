local temp = {}
local tempB = {}

while true do
local id, p1 = os.pullEvent('key')
  if p1 == keys.leftCtrl then
    break
  end
  
  if string.len(keys.getName(p1)) <= 1 then
    table.insert(temp, {keys.getName(p1)})
  end
  
  if keys.getName(p1) == 'space' then
    table.insert(temp, {' '})
  end
  
  term.write(temp[#temp][1])
end

print('')
for i = 1,#temp do
  table.insert(tempB, temp[i][1])
end

print(table.concat(tempB))

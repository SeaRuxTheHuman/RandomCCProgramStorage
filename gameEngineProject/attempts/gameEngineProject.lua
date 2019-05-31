--game engine project

solids = { --each table in this table
  {1,1,35,32768,1}; --a '#' at x:1,y:1 with a black background and white text (forground)
--{x, y, charNumb, backgroundColorNumber,foregroundColorNumber}

  {1,2,35,32768,1}; {13,1,35,32768,1};
  {1,3,35,32768,1}; {13,2,35,32768,1};
  {1,4,35,32768,1}; {13,3,35,32768,1};
  {1,5,35,32768,1}; {13,4,35,32768,1}; {13,5,35,32768,1};
}

interactables = {
  {7,3,2,32768,1,'dialog',{1,2,"|Hello World|"}}
--{x, y, charNumb, backgroundColorNumber,foregroundColorNumber, action, {action variables}}
}

obj = {

  actions = { --put all our actions here
    dialog = function(self,tTable)
      term.setCursorPos(tTable[1],tTable[2])
      term.write(tTable[3])
    end;
  };

  draw = function(self, tTable, num) --draw from a interactable/solid table
    term.setCursorPos(tTable[num][1],tTable[num][2])
    term.setBackgroundColor(tTable[num][4])
    term.setTextColor(tTable[num][5])
    term.write(string.char(tTable[num][3]))
  end;

  run = function(self,act,tVars) --run an action from a table of interactables
    if act == 'dialog' then
      self.actions:dialog(tVars)
    else
      --self.actions:
    end
  end;
}

local function onClick(lTable,clickX,clickY)
  for i = 1,#lTable do
    if lTable[i][6] ~= nil then
      if lTable[i][1] == clickX and lTable[i][2] == clickY then
        --compair clickX, clickY to tables x,y
        obj:run(lTable[i][6], lTable[i][7])
      else
        --print('nope')
      end
    else
      --print('nope')
    end
  end
end

local function main(lTable)
  local runable = false
  for i = 1,#lTable do
    if lTable[i][6] == nil then
      obj:draw(lTable, i)
    else
      obj:draw(lTable, i)
      --obj:run(lTable[i][6], lTable[i][7])
    end
  end
end

term.clear()
term.setCursorPos(1,1)

main(solids)
--sleep(1)
main(interactables)
while true do
  local id,p1,p2,p3 = os.pullEvent('mouse_click')
  --onClick(interactables,p1,p2)
  term.clear()
  main(solids)
  main(interactables)
  onClick(interactables,p2,p3)
  
end


term.setCursorPos(1,19)



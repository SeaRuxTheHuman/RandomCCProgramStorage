--game engine project

--here we set global params

w,h = term.getSize()
quitGame = false

--we put out tables here untill we load them from an external file
solids = { --each table in this table
  {1,1,35,32768,1}; --a '#' at x:1,y:1 with a black background and white text (forground)
--{x, y, charNumb, backgroundColorNumber,foregroundColorNumber}

  {2,1,35,32768,1}; {3,1,35,32768,1};
  {4,1,35,32768,1}; {5,1,35,32768,1};
  {6,1,35,32768,1}; {7,1,35,32768,1};
  {8,1,35,32768,1}; {9,1,35,32768,1};
  {10,1,35,32768,1}; {11,1,35,32768,1};
  {12,1,35,32768,1}; {7,1,35,32768,1};

  {1,2,35,32768,1}; {13,1,35,32768,1};
  {1,3,35,32768,1}; {13,2,35,32768,1};
  {1,4,35,32768,1}; {13,3,35,32768,1};
  {1,5,35,32768,1}; {13,4,35,32768,1};
  {1,6,35,32768,1}; {13,5,126,32768,1};
  {1,7,92,32768,1}; {13,7,92,32768,1};
  {14,5,92,32768,1}; {15,5,95,32768,1};
  {15,7,35,32768,1}; {15,6,35,32768,1};

  {2,7,35,32768,1}; {3,7,35,32768,1};
  {4,7,35,32768,1}; {5,7,35,32768,1};
  {6,7,35,32768,1}; {7,7,35,32768,1};
  {8,7,35,32768,1}; {9,7,35,32768,1};
  {10,7,35,32768,1}; {11,7,35,32768,1};
  {12,7,35,32768,1}; {13,8,35,32768,1};
  {15,8,35,32768,1};
  {15,9,35,32768,1};
  {15,10,47,32768,1}; {14,10,35,32768,1};
                      {13,10,35,32768,1};
}

interactables = {
  {7,3,64,32768,1,'basicDialog',{1,2,"|Hello World|"}}
--{x, y, charNumb, backgroundColorNumber,foregroundColorNumber, action, {action variables}}
}


actions = {

  w,h = term.getSize();

  basicDialog = function(self,tTable)
    term.setCursorPos(tTable[1],tTable[2])
    term.write(tTable[3])
    sleep(1)
    term.setCursorPos(tTable[1],tTable[2])
    term.write(string.rep(' ',#tTable[3]))
  end;
}


--handle our objects (backrounds, interactable, the player, ect)
obj = {

  draw = function(self, tTable, num) --draw from a interactable/solid table
    term.setCursorPos(tTable[num][1],tTable[num][2])
    term.setBackgroundColor(tTable[num][4])
    term.setTextColor(tTable[num][5])
    term.write(string.char(tTable[num][3]))
  end;

  drawFull = function(self, tTable)
    for i = 1,#tTable do
      term.setCursorPos(tTable[i][1],tTable[i][2])
      term.setBackgroundColor(tTable[i][4])
      term.setTextColor(tTable[i][5])
      term.write(string.char(tTable[i][3]))
    end
  end;

  run = function(self,act,tVars) --run an action from a table of interactables
    if act == 'basicDialog' then
      actions:basicDialog(tVars)
    elseif act == 'action' then
      --add more actions like this here until I can find a better way
    end
  end;

  player = { --player info, movement, interactions, stuff here
    playerInfo = {7,10,2}; --x,y,char

    update = function(self,xUpdate,yUpdate,lTableA,lTableB)--update player location - also handles if player can move
      for i = 1,#lTableA do
        if self.playerInfo[1]+xUpdate == lTableA[i][1]  and self.playerInfo[2]+yUpdate == lTableA[i][2] then
          term.setCursorPos(1,h)
          term.write("Invalid Move")
          sleep(0.2)
          return
        end
      end

      for i = 1,#lTableB do
        if self.playerInfo[1]+xUpdate == lTableB[i][1]  and self.playerInfo[2]+yUpdate == lTableB[i][2] then
          term.setCursorPos(1,h)
          term.write("Invalid Move")
          sleep(0.2)
          return
        end
      end

      self.playerInfo[1] = self.playerInfo[1]+xUpdate
      self.playerInfo[2] = self.playerInfo[2]+yUpdate
    end;

    draw = function(self,lTableA,lTableB) --draw were the player is and make sure old player location is not visible
      term.clear()
      obj:drawFull(lTableA)
      obj:drawFull(lTableB)
      term.setCursorPos(self.playerInfo[1],self.playerInfo[2])
      term.write(string.char(self.playerInfo[3]))
    end;

    mainKey = function(self,xUpdate,yUpdate,lTableA,lTableB) --dose the job of obj.player:draw and obj.player:update in same function (plus maybe more)
      self:update(xUpdate,yUpdate,lTableA,lTableB)
      self:draw(lTableA,lTableB)
    end;

    actMouse = function(self,clickX,clickY,lTableA, lTableB)
      for i = 1,#lTableA do
        if clickX == lTableA[i][1] and clickY == lTableA[i][2] and lTableA[i][6] ~= nil then
          if clickX >= self.playerInfo[1]-1 and clickX <= self.playerInfo[1]+1 and clickY >= self.playerInfo[2]-1 and clickY <= self.playerInfo[2]+1 then
            obj:run(lTableA[i][6], lTableA[i][7])
            obj:drawFull(lTableB)
            term.setCursorPos(self.playerInfo[1],self.playerInfo[2])
            term.write(string.char(self.playerInfo[3]))
          end
        end
      end
    end;
  }
}
---here we handle our inputs (keys, mouse, maybe more in future?)
input = {

  mouse = function(self,clickX,clickY,lTableB, lTableA)
    --mouse interactions (relys on player location)
    obj.player:actMouse(clickX,clickY,lTableA, lTableB)

  end;

  key = function(self,key,lTableA,lTableB)
    --key push interactions (relys on player movement)
    if key == keys.up then
      obj.player:mainKey(0,-1,lTableA,lTableB)
    elseif key == keys.down then
      obj.player:mainKey(0,1,lTableA,lTableB)
    elseif key == keys.left then
      obj.player:mainKey(-1,0,lTableA,lTableB)
    elseif key == keys.right then
      obj.player:mainKey(1,0,lTableA,lTableB)
    elseif key == keys.q then
      quitGame = true
    else
    end
  end;
}

--define a function that sets up a screen
local function start(lTableA, lTableB)
  term.clear()
  term.setCursorPos(1,1)
  for i = 1,#lTableA do
    obj:draw(lTableA, i)
  end
  for i = 1,#lTableB do
    obj:draw(lTableB, i)
  end
  obj.player:draw(solids, interactables)
end

start(solids, interactables) --load up the screen

----loop here

while not quitGame do
  local id,p1,p2,p3 = os.pullEvent()
  if id == "mouse_click" then
    input:mouse(p2,p3,solids,interactables)
  elseif id == "key" then
    input:key(p1,solids,interactables)
  else
  end
end

term.clear()
term.setCursorPos(1,1)
sleep(0.1)
term.setTextColor(colors.lime)
term.setBackgroundColor(colors.black)
print('Thank You For Playing!')
term.setTextColor(colors.white)

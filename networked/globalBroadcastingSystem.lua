w,h = term.getSize()

local function printCenterd(str, yIn, offSet)
  if offSet == nil then
    offSet=0
  end
  term.setCursorPos(math.ceil(w/2-#str/2+offSet), yIn)
  term.write(str)
end


buffer = {
  ram = {}; --fuck off i know the name is stupid/inaccurate
  
  write = function(self, input)
    table.insert(self.ram, input)
  end;
  
  read = function(self, num)
    if type(num) == 'number' then
      local temp = {}
      for i=1,#self.ram do
        table.insert(temp, self.ram[i])
      end
      return temp
    else
      return self.ram
    end
  end;
  
  clear = function(self)
    self.ram = {}
  end; 
}

local draw = { 

  msgBoxY = 0;
  
  guiBg = function(self)
    term.setCursorPos(1,1)
    term.write(string.rep("#", w))
    for i=1,h-2 do
      term.setCursorPos(1,i+1)
      term.write("#"..string.rep(" ",w-2).."#")
    end
    term.setCursorPos(1,h)
    term.write(string.rep("#",w))
  end;
  
  guiFg = function(self)
    self.msgBoxY = 0
    term.setCursorPos(3,3)
    term.write('+'..string.rep('-',w-6)..'+')
    for i = 1,h-8 do
      term.setCursorPos(3,i+3)
      term.write('|'..string.rep(' ',w-6)..'|')
      self.msgBoxY = self.msgBoxY+1
    end
    term.setCursorPos(3,h-4)
    term.write('+'..string.rep('-',w-6)..'+')  
  end;
  
  message = function(self,tTable)
    term.setCursorPos(4,4)
    for i = 1, self.msgBoxY-1 do
      if i > #tTable then 
        break 
      end
      term.setCursorPos(4,3+i) 
      term.write(string.sub(tostring(tTable[i]),1,w-6))
    end
  end;
  
  allOptions = function(self)
    printCenterd(" BACK ",h-2,w/-4)
    printCenterd(" SAVE ",h-2)
    printCenterd(" NEXT ",h-2,w/4)
  end;
  
  option = function(self, num)
    local optionTable = {
      {"[BACK]",h-2,w/-4},
      {"[SAVE]",h-2, 0},
      {"[NEXT]",h-2,w/4},
	}
	printCenterd(optionTable[num][1],optionTable[num][2],optionTable[num][3])
  end;
}


menu = {
  selection = 2;
  showingMessage = 1;
  
  changeOption = function(self, num)
    if type(num) ~= 'number' then
      error('expected number, got '..type(num))
    end
    
    if self.selection <=3 and self.selection >= 1 then
      self.selection = self.selection + num
	end
  end;
  
  update = function(self, num)
	self:changeOption(num)
	draw:allOptions()
    draw:option(self.selection)
  end;
  
  updateMsg = function(self)
  
  end;
}

mMsg = {"HELLOW WORLD", "YOU ARE", "A BUNCH OF", "CUNTS!"}


quit = false
draw:guiBg()
draw:guiFg()
  draw:message(mMsg) --until dedicated function added
menu:update(0)
while not quit do
  id,p1,p2,p3,p4,p5 = os.pullEvent()
  if id == 'modem_message' then
    buffer:write(p4)
  end  
  
  if id == 'key' then
    if p1 == keys.right then
      menu:update(1)
    elseif p1 == keys.left then
      menu:update(-1)
    elseif p1 == keys.enter then
      --do menu option
    elseif p1 == keys.q or p1 == keyx.x then
      quit = true
    else
    end
  end
end

term.clear()
term.setCursorPos(1,1)


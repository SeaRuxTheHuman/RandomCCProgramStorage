




local w,h = term.getSize()
local files = fs.list('/')
local quit = false

filesystem={
	dirs = {};
	notDirs = {};
	currentDir = {'*'};
  
	updateFiles = function(self, lTable)
		self.dirs = {}
		self.notDirs = {}
		for i = 1, #lTable do
			if fs.isDir(lTable[i]) then
				table.insert(self.dirs, lTable[i])
			else
				table.insert(self.notDirs, lTable[i])      
			end
		end

	end;
	
	updateForward = function(self, dirNum)
		--if dirList[dirNum] ~= nil then
			table.insert(self.currentDir, self.dirs[dirNum])
			if fs.isDir(table.concat(self.currentDir,'/')) then
				files = fs.list(table.concat(self.currentDir),'/')
				--sleep(3)
			else
				error('currentDir is not a dir')
			end
		--else
			--error('dir number assosiation non existant')
		--end
	end;
  
	clear = function(self)
		self.dirs = {}
		self.notDirs = {}
	end;
  
	printDirs = function(self)
		term.setTextColor(colors.green)
		for i = 1,#self.dirs do
			print(self.dirs[i])
		end
		term.setTextColor(colors.white)
	end;
  
	returnDirs = function(self)
		return self.dirs
	end;
  
	printFiles = function(self)
		for i = 1,#self.notDirs do
			print(self.notDirs[i])
		end
	end;
  
	returnFiles = function(self)
		return self.notDirs
	end;
}


local draw = {
	bgColorPrimary = colors.lightGray;
	bgColorSecondary = colors.gray;
	bgColorCurrent = bgColorPrimary;
	txtColor = colors.black;
	barColor = {colors.blue, colors.red, colors.green, colors.black};
	dirColor = colors.purple;
	
	switchColor = function(self)
		if self.bgColorCurrent == self.bgColorPrimary then
			self.bgColorCurrent = self.bgColorSecondary
			return self.bgColorSecondary
		else
			self.bgColorCurrent = self.bgColorPrimary
			return self.bgColorPrimary
		end
	end;
	
	files = function(self, lTable)
		term.setTextColor(self.txtColor)
		for i = 1, #lTable do
			self:switchColor()
			term.setBackgroundColor(self.bgColorCurrent)
			x,y = term.getCursorPos()
			term.setCursorPos(1, y+1)
			term.clearLine()
			
			if fs.isDir(lTable[i]) then
				term.setBackgroundColor(self.dirColor)
				term.write('()')
				term.setBackgroundColor(self.bgColorCurrent)
				term.write(lTable[i])
			else
				term.write('  ')
				term.write(lTable[i])
			end
		end
	end;
	
	background = function(self)
		term.setBackgroundColor(self.bgColorPrimary)
		term.clear()
		term.setCursorPos(1,1)
	end;
	
	menuBar = function(self)
		term.setTextColor(self.barColor[4])
		paintutils.drawLine(1,1,w,1,self.barColor[1])
		term.setBackgroundColor(self.barColor[2])
		term.setCursorPos(w-2,1)
		term.write('[X]')
		--[[term.setBackgroundColor(self.barColor[3])
		term.setCursorPos(1,1)
		term.write('<<<')]]--
		term.setCursorPos(1,2)
	end;
	
	backButton = function(self)
		term.setBackgroundColor(self.barColor[3])
		term.setCursorPos(1,1)
		term.write('<<<')
		term.setCursorPos(1,2)
	end;
}

click = {
	
	count = #filesystem:returnFiles() + #filesystem:returnDirs() + 1;
	
	check = function(self, mouseY)
		--filesystem:updateForward(mouseY-1)
		if mouseY <= #filesystem:returnDirs() then
			filesystem:updateForward(mouseY-1)
			term.clear()
			term.setCursorPos(1,1)
			print(filesystem:returnDirs()[mouseY-1])
			print(mouseY-#filesystem:returnDirs()-1)
			sleep(3)
		elseif mouseY > #filesystem:returnDirs() and mouseY < #filesystem:returnFiles() + #filesystem:returnDirs() + 1 then
		  -- DEBUG CODE:
			term.clear()
			term.setCursorPos(1,1)
			print(table.concat(filesystem.currentDir,'/')..'/'..filesystem:returnFiles()[mouseY-#filesystem:returnDirs()-1])
			print(mouseY-#filesystem:returnDirs()-1)
			sleep(3)
		  --
			shell.run(table.concat(filesystem.currentDir,'/')..'/'..filesystem:returnFiles()[mouseY-#filesystem:returnDirs()-1])
		end
	end
}

main = {
		
	menu = function(self, lTable)
		
		filesystem:updateFiles(lTable)
		draw:background() 
		draw:files(filesystem:returnDirs())
		draw:files(filesystem:returnFiles())
		draw:menuBar() 
	end;
}

main:menu(files)

while not quit do
	local id,p1,p2,p3 = os.pullEvent()
	if id == 'mouse_click' then
		if p3 <=1 and p2 >=w-2 then
			quit = true
		elseif p3 <=1 and p2 <=3 then
			files = fs.list('/')
			filesystem.currentDir = {'*'}
			main:menu(files)
		else
			--filesystem:updateForward(p3-1)
			click:check(p3)
			main:menu(files)
			draw:backButton()
		end
	end
end


term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
term.clear()
term.setCursorPos(1,1)






















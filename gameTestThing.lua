local w,h = term.getSize()

local floor = {
    len = w;
    height = h-1;
    
    draw = function(self)
        term.setCursorPos(1,self.height)
        term.write(string.rep("=", self.len))
    end
}

local player = {
    locX = 2;
    locY = h-2;
    height = 2;
    
    draw = function(self)
        for i = 1,self.height do
            term.setCursorPos(self.locX,-self.locY)
            term.write('@')
        end 
    end
}

floor:draw()
player:draw()

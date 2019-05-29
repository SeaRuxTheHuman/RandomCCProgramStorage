local w,h = term.getSize()
local center = w/2

draw = {

    borderCol=colors.lightGray;
    backCol=colors.white;
    txtCol=colors.black;

    lines={};

    background = function(self, isColor)
      if isColor then
        term.setTextColor(self.txtCol)
        paintutils.drawFilledBox(1,1,w,h,self.backCol)
        paintutils.drawBox(1,1,w,h,self.borderCol)
      else
        term.setTextColor(self.txtCol)
        term.setBackgroundColor(self.backCol)
        term.setCursorPos(1,1)
        term.clear()
        term.write("+"..string.rep('-', w-2).."+")
        for i = 1, h-2 do
          term.setCursorPos(1,i+1)
          term.write('|'..string.rep(' ', w-2)..'|')
        end
        term.setCursorPos(1,h)
        term.write("+"..string.rep('-', w-2).."+")
      end
    end;

    menuBox = function(self,isColor,startX,startY,height,str,pxl,pxlCol)
      if pxl == nil then
        pxl = ' '
      end


      if isColor then
        if pxlCol ~= nil then
          term.setTextColor(pxlCol)
        else
          term.setTextColor(self.txtCol)
        end

        term.setBackgroundColor(self.borderCol)
        term.setCursorPos(startX,startY)
        for i=0,4+height do
          term.setCursorPos(startX, startY+i)
          term.write(pxl..string.rep(pxl, string.len(str)+2)..pxl)
        end

        paintutils.drawFilledBox(startX+1,startY+1,startX+string.len(str)+2,startY+3+height, self.backCol)
        term.setCursorPos(startX+2,startY+2)
        term.setBackgroundColor(self.backCol)
        term.setTextColor(self.txtCol)
        term.write(str)

      else
        term.setTextColor(colors.black)
        term.setBackgroundColor(colors.white)

        term.setCursorPos(startX,startY)
        term.write(pxl..string.rep(pxl, string.len(str)+2)..pxl)
        for i=1,3+height do
          term.setCursorPos(startX, startY+i)
          term.write(pxl..string.rep(" ", string.len(str)+2)..pxl)
        end
        term.setCursorPos(startX, startY+4+height)
        term.write(pxl..string.rep(pxl, string.len(str)+2)..pxl)
        term.setCursorPos(startX+2, startY+2)
        term.write(str)

      end

    end
}
term.clear()


draw:background(false)
draw:menuBox(false,5,5,0,"hello", "#")


term.setCursorPos(center,h/2+5)

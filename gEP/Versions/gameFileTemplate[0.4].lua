game = {
  pixels = {
    {x,y,charNum,bgColNum,fgColNum,type,{typeVars}}
  };

  action={--used to run actions
    run=function(self, act, lTable)
      if act == "dialog" then
        self.actionList:dialog(lTable)
      else--if- make actions run here
      end
    end;

    actionList = { --put actions here
      dialog=function(self,Tab)
       term.setCursorPos(Tab[1],Tab[2])
       term.write(tab[3])
      end;
    }
  }

  other = {
    --anything else I want the game file to have (ai? player? menus? idk :/)
  }

}


local currentPixle = game.pixels[1]

game.action:run(currentPixle[6], currentPixle[7])

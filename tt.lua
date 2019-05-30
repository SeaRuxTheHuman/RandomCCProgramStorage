local act = {
  dialog = function(self)
    print('Hello World')
  end
}

local obj = {

  draw = {
    background = function(self)
      print('A')
    end;
    
    player = function(self)
      print('B')
      act:dialog()
    end;
  };
}

obj.draw:player()

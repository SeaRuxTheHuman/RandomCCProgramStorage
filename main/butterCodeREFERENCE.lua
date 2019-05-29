tArgs = {...}

test = {
  insult = tArgs[2];
  
  
  printInsult = function(self, name)
    
    if self.insult == nil then
      self.insult = 'cunt'
    end
    
    if name == nil then
      name = 'you'
    end
    
    print(name..' is a '..self.insult)
  end
}

test:printInsult(tArgs[1])



local file = {
  save = function(self, lTable, location)
    if type(lTable)~='table' or type(location)~='string' then
        printError('saveError')
        return
    end
    local data = fs.open(location,'w')
    data.write(textutils.serialize(lTable))
    data.close()
  end;

  clear = function(self, location)
    if type(location)~='string' or not fs.exists(location) then
      printError('clearError')
      return
    end

    fs.delete(location)
    local data = fs.open(location,'w')
    data.close()
  end;

  load = function(self, location)
    if type(location)~='string' then
      printError('loadError - notString')
      return
    elseif not fs.exists(location) then
      printError('loadError - nonExistant')
      return
    end

    data = fs.open(location,'r')
    returnData = textutils.unserialize(data.readAll())
    data.close()

    return returnData
  end;
}

dataUtils = {
  random = function(self, length)
    local final = {}
    for i = 1,length do
      local temp = math.random(1)
      if temp >0 then
        table.insert(final, string.char(math.ceil(math.random(33,255))))
      elseif temp <= 0 then
        table.insert(final, math.ceil(math.random(9)))
      else
      end
    end
    return tostring(table.concat(final))
  end
}

local currency = {

  lRam = {};
  dataDIR = '$$$/dataBase';

  init = function(self)
    if not fs.exists(self.dataDIR) then
      file:clear(self.dataDIR)
      file:save(self.lRam, self.dataDIR)
    end
  end;

  verify = function(self, currencyID)
    self.lRam = file:load(self.dataDIR)
    for i=1,#self.lRam do
      if currencyID == self.lRam[i] then
        return false
      end
    end
    return true
  end;

  add = function(self, currencyID)
    if currencyID == nil then
      self.lRam = file:load(self.dataDIR)
      local randID = dataUtils:random(15)
      for i = 1,#self.lRam do
        if randID==self.lRam[i] then
          randID=dataUtils:random(15)
        end
      end
      table.insert(self.lRam,randID)
      file:clear(self.dataDIR)
      file:save(self.lRam, self.dataDIR)
      self.lRam = {}
      return true
    else
      if not self:verify(currencyID) then
        return false
      end
      self.lRam = file:load(self.dataDIR)
      table.insert(self.lRam,currencyID)
      file:clear(self.dataDIR)
      file:save(self.lRam, self.dataDIR)
    end
  end;

  remove = function(self, currencyID)

  end;
}


currency:init()

if not currency:add() then
  printError('WARNING, CURRENCY ALLREADY IN HOLDING')
end

print(textutils.serialize(file:load("$$$/dataBase")))


-- TO DO:
-- make currency:remove do something
-- make way of verfying incomeing currency is legit (maybe another table?)
-- menu/input output way of adding currency

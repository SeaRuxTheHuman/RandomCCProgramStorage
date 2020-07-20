local main = {
  current = {0, 0, 0, 1},
  mode = 1,
  chests = {
    ["minecraft:cobblestone"] = {1,3,2,4}
  }
}

row_len = 5

local function convert(cTable)
    return {
      row=cTable[1] or 0,
      column=cTable[2] or 0,
      rack=cTable[3] or 0,
      heading=cTable[4] or 1,
    }
end


local function getHeading()
    return main.current[4]
end
local function setHeading(heading)
    if heading<=4 and heading>=1 then
        main.current[4] = heading
    end
end

local function getMovement()
    if (getHeading()%2)>0 then
        return main.current[2]
    else
        return main.current[1]
    end
end

local function setMovement(dist)
    if (getHeading()%2)>0 then
        main.current[2]=main.current[2]+dist
    else
        main.current[1]=main.current[1]+dist
    end
end

local function getHeight()
    return main.current[3]
end
local function setHeight(elevation)
    main.current[3]=getHeight()+elevation
end

local function spin(direction)
    if direction>0 then 
      for s=1,direction do
        --turtle.turnLeft()
        print("turn right"..s)
        if getHeading()+1<=4 then
             setHeading(getHeading()+1)   
        else
             setHeading(1)
        end
      end
    elseif direction<0 then
      for s=1,direction*-1 do
        --turtle.turnRight()
        print("turn left"..s)
        if getHeading()-1>=1 then
             setHeading(getHeading()-1)   
        else
             setHeading(4)
        end
      end
    end
end

local function move(direction)
    if direction>0 then 
      for s=1,direction do
        --turtle.forward()
        print("go forward"..s)
        setMovement(1)
      end
    elseif direction<0 then
      for s=1,direction*-1 do
        --turtle.back()
        print("go back"..s)
        setMovement(-1)
      end
    end
end

local function elevate(direction)
    if direction>0 then 
      for s=1,direction do
        --turtle.up()
        print("go up"..s)
        setHeight(1)
      end
    elseif direction<0 then
      for s=1,direction*-1 do
        --turtle.down()
        print("go down"..s)
        setHeight(-1)
      end
    end
end

local function face(direction)
if getHeading()==4 and direction==1 then
    spin(1)
elseif getHeading()==1 and direction==4 then
    spin(-1)
elseif direction>getHeading() then
     spin(direction-getHeading())
elseif direction<getHeading() then
     spin((getHeading()-direction)*-1)
end
end

print(table.unpack(main.current))
print("-------------------------------")

local function navigate(goal)
   local goal = convert(goal)
   if goal.row ~= 0 then
     spin(1)
     move((goal.row)*row_len)
     spin(-1)
   end
   move(goal.column)
   elevate(goal.rack)
   face(goal.heading)
end
navigate(main.chests["minecraft:cobblestone"]) print(table.unpack(main.current))
print("-------------------------------")


local function reverseNavigate(goal)
   local goal = convert(goal)
   face(1)
   elevate(goal.rack*-1)
   move(goal.column*-1)
   if goal.row ~= 0 then
     spin(-1)
     move(((goal.row)*row_len)*-1)
     spin(1)
   end   
end

reverseNavigate(main.chests["minecraft:cobblestone"]) print(table.unpack(main.current))
print("-------------------------------")

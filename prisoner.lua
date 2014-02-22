
Prison = { }

Prisoner = { }

function Prisoner:new(x, y)
  local p = { }
  setmetatable(p, {__index = Prisoner})
  p.x = x
  p.y = y
  return p
end

function Prisoner:setTarget(x,y)
  p.target = { x = x, y = y }
end


--[[

   1
 4   2
   3
  
]]

function pickRandomDirection()
  return love.math.random(1,4)
end 

function pickRandomMovableDirection(position)
  function directionOk(direction, position)
    local v = directionToVector(direction)
    local nx = position.x + v.x
    local ny = position.y + v.y
    
    if 
          ny > 0
      and nx > 0
      and ny <= map.sizeY
      and nx <= map.sizeX
      and map.mapData[ny][nx] == 0
    then
      return true
    else
      return false
    end
  end
  
  while true do
    local direction = pickRandomDirection()
    if directionOk(direction, position) then
      return direction
    end
  end
end

function calcDirToTarget(from, to, map)
  -- create array filled with infinite length
  local lenArr = { }
  for y=1, map.sizeY do
    table.insert(lenArr, { })
    for x=1, map.sizeX do
      table.insert(lenArr[y], 9999) --infinity for practical purpose
    end
  end
  
  function BFS(x,y,l)
    function verifyAndRun(nx, ny, l)
      if 
          lenArr[ny][nx] > (l+1) 
        and
          map.mapData[ny][nx] == 0  --empty tile
      then
        lenArr[ny][nx] = l+1
        BFS(nx, ny, l+1)
      end 
    end
    
    -- left
    if x > 2 then
      verifyAndRun(x-1, y, l)
    end
    -- right
    if x < map.sizeX then
      verifyAndRun(x+1, y, l)
    end
    -- top
    if y > 2 then
      verifyAndRun(x, y-1, l)
    end
    -- right
    if y < map.sizeY then
      verifyAndRun(x, y+1, l)
    end
  end
  
  lenArr[to.y][to.x] = 0
  -- calculate path lenghts
  BFS(to.x, to.y, 0)
  
  -- create table [(len, dir)]
  local L = {
    (from.y >= 2) and lenArr[from.y-1][from.x] or 9999,
    (from.x < map.sizeX) and lenArr[from.y][from.x+1] or 9999,
    (from.y < map.sizeY) and lenArr[from.y+1][from.x] or 9999,
    (from.x >= 2) and lenArr[from.y][from.x-1] or 9999
  }
  
  -- find the direction with the shortest path lenght
  local bestD = nil
  local bestL = 9999
  for dir=1,4 do
    if bestL > L[dir] then
      bestL = L[dir]
      bestD = dir
    end
  end
  
  if bestD == nil then
  --  error "No path available"
  end
  
  return bestD
end

function directionToVector(dir)
  if dir == 1 then
    return { x = 0, y = -1 }
  elseif dir == 2 then
    return { x = 1, y = 0 }
  elseif dir == 3 then
    return { x = 0, y = 1 }
  elseif dir == 4 then
    return { x = -1, y = 0 }
  else
    error "Major fuckup; direction bad"
  end
end

function Prisoner:draw()
  local ds = map:getTileDrawScale()
  
  local dx = map.tileSizeX * (self.x - map.displayOffsetX - 1)
  local dy = map.tileSizeY * (self.y - map.displayOffsetY - 1)
  love.graphics.draw(self.sprite, dx, dy, 0, ds.x, ds.y)
end

function Prisoner:update()
  local direction
  if self.target then
    if self.x == self.target.x and self.y == self.target.y then
      return
    end
    
    direction = calcDirToTarget(self, self.target, map)
  else
    direction = pickRandomMovableDirection(self)
  end
  
  if direction == nil then
    return -- no path found
  end
  
  local v = directionToVector(direction)
  
  self.x = self.x + v.x
  self.y = self.y + v.y
end

-- really sorry for that but I didn't make unit base class :<
Guard = { }
setmetatable(Guard, {__index = Prisoner})

function Guard:new(x,y)
  local g = { }
  g.x = x
  g.y = y
  setmetatable(g, {__index = Guard})
  return g
end

function Guard:update()
  Prisoner.update(self)
  
  -- calculate distance to the player
  local dx = self.x-prisoner.x
  local dy = self.y-prisoner.y
  local distance = math.sqrt(dx*dx + dy*dy)
  
  if distance < 3 then
    --self.target = prisoner -- that sets the target to permanent follow
    self.target = { }
    self.target.x = prisoner.x
    self.target.y = prisoner.y
  end
end

Prison = { }

Prisoner = { }

function Prisoner:new(x, y)
  p = { }
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

function calcDirToTarget(from, to, map)
  -- create array filled with infinite length
  local lenArr = { }
  for y=1, map.sizeY do
    table.insert(lenArr, { })
    for x=1, map.sizeX do
      table.insert(lenArr[y], 999999) --infinity for practical purpose
    end
  end
  
  function BFS(x,y,l)
    function verifyAndRun(nx, ny, l)
      if 
          lenArr[nx][ny] > (l+1) 
        and
          map.mapData[ny][nx] == 0  --empty tile
      then
        lenArr[nx][ny] = l+1
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
  
  lenArr[to.x][to.y] = 0
  -- calculate path lenghts
  BFS(to.x, to.y, 0)
  
  -- create table [(len, dir)]
  local L = {
    lenArr[from.x][from.y-1],
    lenArr[from.x+1][from.y],
    lenArr[from.x][from.y+1],
    lenArr[from.x-1][from.y]
  }
  
  -- find the direction with the shortest path lenght
  local bestD = nil
  local bestL = 999999
  for dir=1,4 do
    if bestL > L[dir] then
      bestL = L[dir]
      bestD = dir
    end
  end
  
  if bestD == nil then
    error "No path available"
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
  
  local dx = map.tileSizeX * (prisoner.x - map.displayOffsetX)
  local dy = map.tileSizeY * (prisoner.y - map.displayOffsetY)
  love.graphics.draw(prisonerSprite, dx, dy, 0, ds.x, ds.y)
end

function Prisoner:update()
  local direction
  if self.target then
    direction = calcDirToTarget(self, self.target, map)
  else
    direction = pickRandomDirection()
  end
  
  local v = directionToVector(direction)
  
  self.x = self.x + v.x
  self.y = self.y + v.y
end


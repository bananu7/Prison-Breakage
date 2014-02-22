
require"util"

screenSizeX = 1024
screenSizeY = 768

Map = { 
  sizeX = 20,
  sizeY = 20,
  
  displayOffsetX = 0, --those are in tiles
  displayOffsetY = 0,
  
  
  -- with screen size of 1024x768 (woo indie)
  -- we get 32x24 tiles which is OK
  displaySizeX = 12,--32,
  displaySizeY = 8,--24,
}
Map.tileSizeX = screenSizeX / Map.displaySizeX
Map.tileSizeY = screenSizeY / Map.displaySizeY

function Map:load(tilepath)
  self.tiles = {}
  for i=0,3 do
      self.tiles[i] = love.graphics.newImage( tilepath ..i..".png" )
   end
end

function Map:draw()
  for y=1, self.displaySizeY do
      for x=1, self.displaySizeX do                                                         
        
        local tileId = self.mapData[y+self.displayOffsetY][x+self.displayOffsetX]
        local tileSprite = self.tiles[tileId]
        
        love.graphics.draw( 
          tileSprite, 
          ((x-1)*self.tileSizeX) --[[+ self.displayOffsetX]], 
          ((y-1)*self.tileSizeY) --[[+ self.displayOffsetY]] ,
          0,
          self.tileSizeX / tileSprite:getWidth(),
          self.tileSizeY / tileSprite:getHeight()
          )
      end
   end
end

function Map:getTileDrawScale()
  return {
    x = self.tileSizeX / self.tiles[1]:getWidth(),
    y = self.tileSizeY / self.tiles[1]:getHeight() 
  }
end

function Map:keypressed(key,_)
  if key == 'up' then
    self.displayOffsetY = math.max(self.displayOffsetY-1, 0)
  end
  if key == 'down' then
    self.displayOffsetY = math.min(self.displayOffsetY+1, self.sizeY-self.displaySizeY)
  end
   
  if key == 'left' then
    self.displayOffsetX = math.max(self.displayOffsetX-1, 0)
  end
  if key == 'right' then
    self.displayOffsetX = math.min(self.displayOffsetX+1, self.sizeX-self.displaySizeX)
  end
end

function Map:getMapCoordFromMouseCoord(mx, my)  
  mx = math.floor(mx / (screenSizeX / self.displaySizeX))
  my = math.floor(my / (screenSizeY / self.displaySizeY))
  
  mx = mx + self.displayOffsetX + 1
  my = my + self.displayOffsetY + 1
  return { x = mx, y = my }
end

function Map:generate()
  self.mapData = { }
  
  for y=1, map.sizeY do
    table.insert(map.mapData, { })
    for x=1, map.sizeX do
      table.insert(map.mapData[y], math.random(1,3)) --infinity for practical purpose
    end
  end

  function spawnDrunkard(x,y,steps)
    self.mapData[x][y] = 0
    for i=1,steps do
      local dir = pickRandomDirection()
      local v = directionToVector(dir)
      
      local nx = x + v.x
      local ny = y + v.y
      
      if
            ny > 0
        and nx > 0
        and ny <= map.sizeY
        and nx <= map.sizeX
      then
        self.mapData[ny][nx] = 0
        x = nx
        y = ny
      end
    end
  end

  for i=1, 20 do
    local drunkardSteps = 30
    
    x = love.math.random(2,map.sizeX-1)
    y = love.math.random(2,map.sizeY-1)
    
    spawnDrunkard(x,y,drunkardSteps)
  end
  
  -- try to fix player starting in separated room
  spawnDrunkard(3,3,20)
end
--[[
Map.mapData={
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
   { 0, 1, 0, 0, 2, 2, 2, 0, 3, 0, 3, 0, 1, 1, 1, 0, 0, 0, 0, 0},
   { 0, 1, 0, 0, 2, 0, 2, 0, 3, 0, 3, 0, 1, 0, 0, 0, 0, 0, 0, 0},
   { 0, 1, 1, 0, 2, 2, 2, 0, 0, 3, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
   { 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
   { 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 2, 2, 2, 0, 3, 3, 3, 0, 1, 1, 1, 0, 2, 0, 0, 0, 0, 0, 0},
   { 0, 2, 0, 0, 0, 3, 0, 3, 0, 1, 0, 1, 0, 2, 0, 0, 0, 0, 0, 0},
   { 0, 2, 0, 0, 0, 3, 0, 3, 0, 1, 0, 1, 0, 2, 0, 0, 0, 0, 0, 0},
   { 0, 2, 2, 2, 0, 3, 3, 3, 0, 1, 1, 1, 0, 2, 2, 2, 0, 0, 0, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
}
]]
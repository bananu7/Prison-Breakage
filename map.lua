
screenSizeX = 1024
screenSizeY = 768

Map = { 
  sizeX = 20,
  sizeY = 20,
  
  displayOffsetX = 0, --those are in pixels
  displayOffsetY = 0,
  
  
  -- with screen size of 1024x768 (woo indie)
  -- we get 32x24 tiles which is OK
  displaySizeX = 8,--32,
  displaySizeY = 6,--24,
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
        
        local tileId = self.mapData[x+self.displayOffsetX][y+self.displayOffsetY]
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
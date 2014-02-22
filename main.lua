require"map"
require"prisoner"

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  require("libraries.loveframes")
  require("ui")
  
  love.graphics.setDefaultFilter("nearest", "nearest", 0)
  
  map = Map
  map:load("assets/images/tiles/")
  
  prisonerSprite = love.graphics.newImage("assets/images/prisoner.png")
  prisoner = Prisoner:new(3, 3)
end

-- update and draw

function love.update(dt)
  loveframes.update(dt)
end

function love.draw()
  map:draw()
  prisoner:draw()
  loveframes.draw()
end

-- events

function love.mousepressed(x, y, button)
  -- Forward event to loveframes
  loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  -- Forward event to loveframes
  loveframes.mousereleased(x, y, button)
  
  local mapCoord = map:getMapCoordFromMouseCoord(x,y)
  prisoner.target = mapCoord
end

function love.keypressed(key, unicode)
  -- Forward event to loveframes
  loveframes.keypressed(key, unicode)
  
  -- forward events to the map
  map:keypressed(key, unicode)
  
  if key == "escape" then
    love.event.quit()
  end
  
  if key == "p" then
    prisoner:update()
  end
end

function love.keyreleased(key)
  -- Forward event to loveframes
  loveframes.keyreleased(key)
end

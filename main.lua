function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  require("libraries.loveframes")
  require("ui")
  
  love.graphics.setDefaultFilter("nearest", "nearest", 0)
end

function love.keypressed(key, unicode)
  
end

function love.update(dt)
  loveframes.update(dt)
end

function love.draw()
  
  loveframes.draw()
end

function love.mousepressed(x, y, button)
  -- Forward event to loveframes
  loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
  -- Forward event to loveframes
  loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
  -- Forward event to loveframes
  loveframes.keypressed(key, unicode)
  
  if key == "escape" then
    love.event.quit()
  end
end

function love.keyreleased(key)
  -- Forward event to loveframes
  loveframes.keyreleased(key)
end
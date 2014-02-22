function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  love.graphics.setDefaultFilter("nearest", "nearest", 0)
end

function love.keypressed(k)
    if k == 'escape' then
      love.event.quit()
    end
end

function love.update(dt)
end

function love.draw() 
end

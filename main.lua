require"map"
require"prisoner"

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
  require("libraries.loveframes")
  require("ui")
  
  love.graphics.setDefaultFilter("nearest", "nearest", 0)
  
  map = Map
  map:load("assets/images/tiles/")
  
  Prisoner.sprite = love.graphics.newImage("assets/images/prisoner.png")
  prisoner = Prisoner:new(3, 3)
  prisoner.target = prisoner
  
  Guard.sprite = love.graphics.newImage("assets/images/guard.png")
  guards = { }
  
  function randomPosition()
    local x = love.math.random(2, map.sizeX-1)
    local y = love.math.random(2, map.sizeY-1)
    
    if map.mapData[y][x] ~= 0 then
      return randomPosition()
    else
      return { x = x, y = y}
    end
  end
  
  for i=1, 10 do
    local p = randomPosition()
    table.insert(guards, Guard:new(p.x, p.y))
  end
end


-- update and draw

function love.update(dt)
  loveframes.update(dt)
  
  checkWinLoseConditions()
end

function love.draw()
  map:draw()
  prisoner:draw()
  
  for _,guard in ipairs(guards) do
    guard:draw()
  end
  
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
  
  function isMapEmpty(x,y)
    return map.mapData[y][x] == 0
  end
  
  function updateGuards()
    for _,guard in ipairs(guards) do
      guard:update()
    end
  end
  
  if key == "w" then
    if isMapEmpty(prisoner.x, prisoner.y-1) then
      prisoner.y = prisoner.y - 1
      updateGuards()
    end
  end
  if key == "s" then
    if isMapEmpty(prisoner.x, prisoner.y+1) then
      prisoner.y = prisoner.y + 1
      updateGuards()
    end
  end
  if key == "a" then
    if isMapEmpty(prisoner.x-1, prisoner.y) then
      prisoner.x = prisoner.x - 1
      updateGuards()
    end
  end
  if key == "d" then
    if isMapEmpty(prisoner.x+1, prisoner.y) then
      prisoner.x = prisoner.x + 1
      updateGuards()
    end
  end
  
  if key == " " then
    prisoner:update()
    updateGuards()
  end
end

function love.keyreleased(key)
  -- Forward event to loveframes
  loveframes.keyreleased(key)
end

function checkWinLoseConditions()
  if love.lost then
    local lostFrame = loveframes.Create("frame")
    lostFrame:SetName("You lost")
    lostFrame:Center()
    lostFrame:SetModal(true)
    
    local startOverButton = loveframes.Create("button", lostFrame)
    startOverButton:SetSize(lostFrame:GetWidth() - 10, 30)
    startOverButton:SetPos(5, 65)
    startOverButton:SetText("Start over")
    startOverButton.OnClick = function()
      love.load({})
    end
  end
end
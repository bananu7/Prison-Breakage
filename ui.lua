ui = {}

function ui.load()
  local width = love.graphics.getWidth()
  
  local toolbar = loveframes.Create("panel")
  toolbar:SetSize(width, 50);
  toolbar:SetPos(0, 0)
  
end

ui.load()
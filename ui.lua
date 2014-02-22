ui = {}

prisoners = { {
    name = "Andy Prowl",
    avatar = "andy-prowl.jpg"
  }, {
    name = "Bartek Banachewicz",
    avatar = "bartek.jpeg"
  }, {
    name = "Cat Plus Plus",
    avatar = "cat.jpeg"
  }, {
    name = "Cicada",
    avatar = "cicada.png"
  }, {
    name = "Etienne",
    avatar = "etienne.jpeg"
  }, {
    name = "Griwes",
    avatar = "griwes.jpeg"
  }, {
    name = "jalf",
    avatar = "jalf.png"
  }, {
    name = "Jerry Coffin",
    avatar = "jerry-coffin.jpeg"
  }, {
    name = "Mysticial",
    avatar = "mysticial.jpg"
  }, {
    name = "Rapptz",
    avatar = "rapptz.jpeg"
  }, {
    name = "R.Martinho Fernandes",
    avatar = "robot.jpeg"
  }, {
    name = "sehe",
    avatar = "sehe.png"
  }, {
    name = "Stacked Crooked",
    avatar = "stacked-crooked.png"
  }, {
    name = "ThePhD",
    avatar = "thephd.png"
  }, {
    name = "Xeo",
    avatar = "xeo.png"
  }, {
    name = "Zoidberg",
    avatar = "zoidberg.png"
  }
}

function ui.create()
  local width = love.graphics.getWidth()
  
  -- Main toolbar
  ui.toolbar = loveframes.Create("panel")
  ui.toolbar:SetSize(width, 40);
  ui.toolbar:SetPos(0, 0)
  
  -- Toolbar info
  local info = loveframes.Create("text", ui.toolbar)
  info:SetPos(70, 10)
  info:SetText({{0, 0, 0, 255}, "<Time of day and other objectives to complete, blabla>"})
  info:Center()
  
  -- Menu button
  ui.menuButton = loveframes.Create("button", ui.toolbar)
  ui.menuButton:SetSize(60, 30)
  ui.menuButton:SetPos(5, 5)
  ui.menuButton:SetText("Menu")
  ui.menuButton.OnClick = function()
    ui.showMenu()
  end
  
  -- Catalog toggle button
  ui.catalogButton = loveframes.Create("button", ui.toolbar)
  ui.catalogButton:SetSize(120, 30)
  ui.catalogButton:SetPos(ui.toolbar:GetWidth() - ui.catalogButton:GetWidth() - 5, 5)
  ui.catalogButton:SetText("Open catalog")
  ui.catalogButton.OnClick = function()
    ui.toggleCatalog()
  end
  
  ui.createCatalog()
end

function ui.showMenu()
  ui.menu = loveframes.Create("frame")
  ui.menu:SetSize(250, 100)
  ui.menu:Center()
  ui.menu:SetModal(true)
  ui.menu:SetName("Menu")
  
  local startOver = loveframes.Create("button", ui.menu)
  startOver:SetSize(ui.menu:GetWidth() - 10, 30)
  startOver:SetPos(5, 30)
  startOver:SetText("New game")
  startOver.OnClick = function()
    -- TODO this
  end
  
  local quitButton = loveframes.Create("button", ui.menu)
  quitButton:SetSize(ui.menu:GetWidth() - 10, 30)
  quitButton:SetPos(5, 65)
  quitButton:SetText("Exit game")
  quitButton.OnClick = function()
    love.event.quit()
  end
end

function ui.createCatalog()
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  
  -- Catalog list
  ui.catalogList = loveframes.Create("list")
  ui.catalogList:SetSize(250, height - 40)
  ui.catalogList:SetPos(width - ui.catalogList:GetWidth(), ui.toolbar:GetHeight())
  ui.catalogList:SetPadding(5)
  ui.catalogList:SetSpacing(5)
  ui.catalogList:SetVisible(false)
  ui.catalogList.isVisible = false
  
  local y = 0
  
  -- Prisoner panels
  for i, p in ipairs(prisoners) do
    local prisonerPanel = ui.makePrisonerPanel(p)
    y = y + 68
  end
end

function ui.toggleCatalog()
  local v = not ui.catalogList.isVisible
  
  ui.catalogList:SetVisible(v)
  ui.catalogList.isVisible = v
  
  if v then
    ui.catalogButton:SetText("Close catalog")
  else
    ui.catalogButton:SetText("Open catalog")
  end
end

function ui.makePrisonerPanel(prisoner)
  local panel = loveframes.Create("panel", ui.catalogList)
  panel:SetSize(ui.catalogList:GetWidth(), 58)
  
  local avatar = loveframes.Create("image", panel)
  avatar:SetImage("assets/images/avatars/"..prisoner.avatar)
  avatar:SetPos(5, 5)
  
  local scale = 48 / avatar:GetWidth()
  avatar:SetScale(scale)
  
  local name = loveframes.Create("text", panel)
  name:SetText(prisoner.name)
  name:SetPos(48 + 10, 5)
end

ui.create()
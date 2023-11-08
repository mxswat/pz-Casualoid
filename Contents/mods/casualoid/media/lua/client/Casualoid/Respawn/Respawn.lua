CasualoidRespawn = {}

CasualoidRespawn.respawnHandlers = {}

function CasualoidRespawn:registerHandler(data)
  Casualoid.print('self.respawnHandlers', self.respawnHandlers)
  table.insert(self.respawnHandlers, data);
end

function CasualoidRespawn:init()
  self:registerHandler(CasualoidPerks)
  self:registerHandler(CasualoidKnownMediaLines)
  self:registerHandler(CasualoidRecipes)
  self:registerHandler(CasualoidOccupation)
  self:registerHandler(CasualoidTraits)
  self:registerHandler(CasualoidSimpleStats)
  -- has to be last to correctly apply the XP multiplier
  self:registerHandler(CasualoidReadSkillBooks)
  -- Contains generic finishing touches and sync for trait gain/loss for other mods
  self:registerHandler(CasualoidPostRespawn)
end

function CasualoidRespawn:savePlayerProgress(player)
  Casualoid.print('savePlayerProgress')

  for _, handler in ipairs(self.respawnHandlers) do
    handler:save(player)
  end

  -- Save to file that this player can respawn
  local available = Casualoid.File.Load(Casualoid.getRespawnFilePath()) or {};
  available[Casualoid.getUserID()] = true;

  Casualoid.File.Save(Casualoid.getRespawnFilePath(), available);
end

function CasualoidRespawn:loadPlayerProgress()
  for _, handler in ipairs(self.respawnHandlers) do
    handler:load(getPlayer());
  end
end

function CasualoidRespawn:onKeepProgressModalClick(button)
  Casualoid.print('KeepProgressModalClick', button.internal)
  if button.internal == "YES" then
    CasualoidPerks:loadPartial(getPlayer())
  else
    ModData.remove("CasualoidRespawnData")
  end
end

function CasualoidRespawn:openKeepProgressModal()
  local height = 325
  local width = 350
  local text =
      getText("IGUI_KeepProgressModal1")
      .. getText("IGUI_KeepProgressModal2")
      .. getText("IGUI_KeepProgressModal3")
      .. getText("IGUI_KeepProgressModal4")

  local modal = ISModalRichText:new(
    getCore():getScreenWidth() / 4,
    getCore():getScreenHeight() / 2 - 300,
    width,
    height,
    text,
    true,
    self,
    self.onKeepProgressModalClick
  );

  modal:initialise()
  modal.yes:setTitle(getText('IGUI_KeepProgress'))
  modal.no:setTitle(getText('IGUI_IgnoreAndProceed'))
  modal.no:setWidthToTitle()
  modal:addToUIManager()
end

local function onCreatePlayer()
  if getPlayer():HasTrait('RespawnTrait') then
    CasualoidRespawn:loadPlayerProgress()
  elseif getPlayer():getHoursSurvived() == 0 and Casualoid.hasRespawnModData() then
    CasualoidRespawn:openKeepProgressModal()
  end
end

Events.OnCreatePlayer.Add(onCreatePlayer);

local function onPlayerDeath(player)
  CasualoidRespawn:savePlayerProgress(player)
end

Events.OnPlayerDeath.Add(onPlayerDeath)

CasualoidRespawn:init()

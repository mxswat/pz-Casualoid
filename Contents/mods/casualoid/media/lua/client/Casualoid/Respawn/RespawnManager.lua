local Debug = require "Casualoid/Debug"
local CasualoidSettings = require "Casualoid/CasualoidSettings"
local Utils = require "MxUtilities/Utils"
local RespawnUtils = require "Casualoid/Respawn/RespawnUtils"

local RespawnManager = {}

RespawnManager.respawnHandlers = {}

function RespawnManager:registerHandler(data)
  Debug:print('self.respawnHandlers', self.respawnHandlers)
  table.insert(self.respawnHandlers, data);
end

function RespawnManager:init()
  self:registerHandler(CasualoidPerks)
  self:registerHandler(CasualoidKnownMediaLines)
  self:registerHandler(CasualoidRecipes)
  self:registerHandler(CasualoidOccupation)
  self:registerHandler(CasualoidTraits)
  self:registerHandler(CasualoidSimpleStats)
  -- Contains generic finishing touches and sync for trait gain/loss for other mods
  self:registerHandler(CasualoidPostRespawn)
end

function RespawnManager:savePlayerProgress(player)
  Debug:print('savePlayerProgress')

  for _, handler in ipairs(self.respawnHandlers) do
    handler:save(player)
  end

  -- Save to file that this player can respawn
  local respawnData = CasualoidSettings:get().respawnData;
  respawnData[Utils:getUserID()] = true;

  -- Remember to save to JSON
  CasualoidSettings:save()
end

function RespawnManager:loadPlayerProgress()
  for _, handler in ipairs(self.respawnHandlers) do
    handler:load(getPlayer());
  end
end

function RespawnManager:onKeepProgressModalClick(button)
  Debug:print('KeepProgressModalClick', button.internal)
  if button.internal == "YES" then
    CasualoidPerks:loadPartial(getPlayer())
  else
    ModData.remove("CasualoidRespawnData")
  end
end

function RespawnManager:openKeepProgressModal()
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
    RespawnManager:loadPlayerProgress()
  elseif getPlayer():getHoursSurvived() == 0 and RespawnUtils.hasRespawnModData() then
    RespawnManager:openKeepProgressModal()
  end
end

Events.OnCreatePlayer.Add(onCreatePlayer);

local function onPlayerDeath(player)
  RespawnManager:savePlayerProgress(player)
end

Events.OnPlayerDeath.Add(onPlayerDeath)

RespawnManager:init()

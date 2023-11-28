local Utils = require "MxUtilities/Utils"
local CasualoidSettings = {}

---@class CasualoidSettingsData
---@field respawnData table
---@field namedContainers NamedContainersSettings

---@type CasualoidSettingsData
CasualoidSettings.data = nil
CasualoidSettings.filePath = 'casualoid-settings.json'

function CasualoidSettings:get()
  -- Remember to return an empty table is the file is nil
  self.data = self.data or Utils:loadTableFromJSONFile(self.filePath) or {}

  self.data.respawnData = self.data.respawnData or {}
  self.data.namedContainers = self.data.namedContainers or {}

  return self.data
end

function CasualoidSettings:save()
  Utils:saveTableAsJSONFile(self.filePath, self.data)
end


return CasualoidSettings

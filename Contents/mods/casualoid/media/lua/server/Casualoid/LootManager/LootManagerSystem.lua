-- if isClient() then return end

-- -- Inspired from: media\lua\server\Map\MapObjects\MOCampfire.lua

-- local Debug = require("Casualoid/Debug")

-- ---@class LootManagerSystem
-- local LootManagerSystem = {}
-- function LootManagerSystem.onNewLootManager(object)
--   Debug:print('onNewLootManager', object)
-- end

-- function LootManagerSystem.onLoadLootManager(object)
--   Debug:print('loadLootManager', object)
-- end

-- local PRIORITY = 5
-- MapObjects.OnNewWithSprite("loot_manager_0", LootManagerSystem.onNewLootManager, PRIORITY)
-- MapObjects.OnLoadWithSprite("loot_manager_0", LootManagerSystem.onLoadLootManager, PRIORITY)
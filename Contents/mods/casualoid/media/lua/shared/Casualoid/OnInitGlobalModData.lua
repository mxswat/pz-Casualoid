local ItemWeightModifier = require "Casualoid/ItemWeightModifier"

Events.OnInitGlobalModData.Add(function()
  ItemWeightModifier:run()
end)

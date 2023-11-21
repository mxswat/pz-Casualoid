local ItemWeightModifier = {}

ItemWeightModifier.WoodItems = {
  "Base.PercedWood",
  "Base.UnusableWood",
  "Base.WoodenStick",
  "Base.Plank",
  "Base.PlankNail",
  "Base.Log",
  "Base.LogStacks2",
  "Base.LogStacks3",
  "Base.LogStacks4",
  "Base.TreeBranch"
}

ItemWeightModifier.MetalItems = {
  "Base.MetalBar",
  "Base.MetalPipe",
  "Base.SheetMetal",
  "Base.ScrapMetal",
  "Base.SmallSheetMetal",
  "Base.UnusableMetal",
  "Base.MetalDrum",
  "Base.WeldingRods",
  "Base.IronIngot"
}

---@param itemName string
---@param multiplier number
function ItemWeightModifier:setWeight(itemName, multiplier)
  local item = getScriptManager():getItem(itemName)
  if item then
    item:setActualWeight(item:getActualWeight() * (1 - (multiplier * 0.01)))
  end
end

function ItemWeightModifier:run()
  local WoodWeightModifier = SandboxVars.Casualoid.WoodWeightModifier
  local MetalWeightModifier = SandboxVars.Casualoid.MetalWeightModifier
  for _, v in pairs(ItemWeightModifier.WoodItems) do
    self:setWeight(v, WoodWeightModifier)
  end

  for _, v in pairs(ItemWeightModifier.MetalItems) do
    self:setWeight(v, MetalWeightModifier)
  end
end

return ItemWeightModifier

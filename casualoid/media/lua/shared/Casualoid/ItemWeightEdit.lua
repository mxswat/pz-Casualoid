CasualoidItemEdit = {}

CasualoidItemEdit.WoodItems = {
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

CasualoidItemEdit.MetalItems = {
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

local function setWeight(itemName, multiplier)
  local item = getScriptManager():getItem(itemName)
  if item then
    item:setActualWeight(item:getActualWeight() * (1 - (multiplier * 0.01)))
  end
end

function WWModifyItems()
  local WoodWeightModifier = SandboxVars.Casualoid.WoodWeightModifier
  local MetalWeightModifier = SandboxVars.Casualoid.MetalWeightModifier
  for _, v in pairs(CasualoidItemEdit.WoodItems) do
    setWeight(v, WoodWeightModifier)
  end

  for _, v in pairs(CasualoidItemEdit.MetalItems) do
    setWeight(v, MetalWeightModifier)
  end
end

Events.OnInitGlobalModData.Add(WWModifyItems)

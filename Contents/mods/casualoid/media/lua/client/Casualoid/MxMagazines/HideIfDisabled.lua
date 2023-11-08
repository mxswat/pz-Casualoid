Events.OnGameStart.Add(function()
  local scriptManager = ScriptManager.instance;

  if SandboxVars.Casualoid.EnableMxMagazines  then
    return
  end

  local items = {
    "Casualoid.NutritionistMag1",
    "Casualoid.AnarchistCookbook1",
    "Casualoid.AnarchistCookbook2",
    "Casualoid.AnarchistCookbook3",
  }

  for _, name in ipairs(items) do
    local item = scriptManager:getItem(name)
    item:DoParam("OBSOLETE = true")
  end
end)
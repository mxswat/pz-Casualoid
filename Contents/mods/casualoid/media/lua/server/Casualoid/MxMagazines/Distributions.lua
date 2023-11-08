require "Items/Distributions"
require "Items/ProceduralDistributions"

local ItemsMap = {
  ["CookingMag1"]     = "Casualoid.NutritionistMag1",
  ["ElectronicsMag1"] = "Casualoid.AnarchistCookbook1",
  ["ElectronicsMag2"] = "Casualoid.AnarchistCookbook2",
  ["ElectronicsMag3"] = "Casualoid.AnarchistCookbook3",
}

local function insertMagazine(items)
  for i, item in ipairs(items) do
    if ItemsMap[item] then
      Casualoid.print('insertMagazine: ', ItemsMap[item], ': ', items[i + 1])
      table.insert(items, ItemsMap[item])
      table.insert(items, (items[i + 1]) + 0.1)
    end
  end
end

local function insertMagazineRecursive(room)
  for key, value in pairs(room) do
    if key == "items" then
      insertMagazine(value)
      break
    elseif type(value) == "table" then
      insertMagazineRecursive(value)
    end
  end
end

insertMagazineRecursive(Distributions[1])

for _, room in pairs(ProceduralDistributions["list"]) do
  insertMagazine(room["items"])
end

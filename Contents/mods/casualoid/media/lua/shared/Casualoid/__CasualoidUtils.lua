-- local json = require("json");

-- Casualoid = Casualoid or {}

-- Casualoid.File = {};

-- function Casualoid.getUserID()
--   return isClient()
--       and "player-" .. getWorld():getWorld() .. "-" .. getClientUsername()
--       or "player-" .. getWorld():getWorld();
-- end

-- function Casualoid.File.Save(path, table)
--   local file = getFileWriter(path, true, false);

--   file:write(json.Encode(table));
--   file:close();
-- end

-- function Casualoid.File.Load(path)
--   local file = getFileReader(path, false);

--   if file == nil then
--     return nil;
--   end

--   local content = "";
--   local line = file:readLine();
--   while line ~= nil do
--     content = content .. line;
--     line = file:readLine();
--   end

--   file:close();
--   return content ~= "" and json.Decode(content) or nil;
-- end

-- function Casualoid.print(...)
--   if not isDebugEnabled() then
--     return
--   end
--   local arguments = { ... }
--   local printResult = ''
--   for _, v in ipairs(arguments) do
--     printResult = printResult .. tostring(v or 'nil') .. " "
--   end
--   print('Casualoid:' .. printResult)
-- end

-- function Casualoid.clapAndEllipsis(text, maxSize)
--   if #text <= maxSize then
--     return text
--   else
--     local clappedText = text:sub(1, maxSize - 3) .. "..."
--     return clappedText
--   end
-- end

-- function Casualoid.parseSandboxString(text)
--   local res = {
--     values = {},
--     map = {}
--   }
--   for v in string.gmatch(text or "", "([^;]+)") do
--     res.values[#res.values + 1] = v
--     res.map[v] = true
--   end

--   return res
-- end

-- function Casualoid.printTable(node)
--   local cache, stack, output = {}, {}, {}
--   local depth = 1
--   local output_str = "{\n"

--   while true do
--     local size = 0
--     for k, v in pairs(node) do
--       size = size + 1
--     end

--     local cur_index = 1
--     for k, v in pairs(node) do
--       if (cache[node] == nil) or (cur_index >= cache[node]) then
--         if (string.find(output_str, "}", output_str:len())) then
--           output_str = output_str .. ",\n"
--         elseif not (string.find(output_str, "\n", output_str:len())) then
--           output_str = output_str .. "\n"
--         end

--         -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
--         table.insert(output, output_str)
--         output_str = ""

--         local key
--         if (type(k) == "number" or type(k) == "boolean") then
--           key = "[" .. tostring(k) .. "]"
--         else
--           key = "['" .. tostring(k) .. "']"
--         end

--         if (type(v) == "number" or type(v) == "boolean") then
--           output_str = output_str .. string.rep('\t', depth) .. key .. " = " .. tostring(v)
--         elseif (type(v) == "table") then
--           output_str = output_str .. string.rep('\t', depth) .. key .. " = {\n"
--           table.insert(stack, node)
--           table.insert(stack, v)
--           cache[node] = cur_index + 1
--           break
--         else
--           output_str = output_str .. string.rep('\t', depth) .. key .. " = '" .. tostring(v) .. "'"
--         end

--         if (cur_index == size) then
--           output_str = output_str .. "\n" .. string.rep('\t', depth - 1) .. "}"
--         else
--           output_str = output_str .. ","
--         end
--       else
--         -- close the table
--         if (cur_index == size) then
--           output_str = output_str .. "\n" .. string.rep('\t', depth - 1) .. "}"
--         end
--       end

--       cur_index = cur_index + 1
--     end

--     if (size == 0) then
--       output_str = output_str .. "\n" .. string.rep('\t', depth - 1) .. "}"
--     end

--     if (#stack > 0) then
--       node = stack[#stack]
--       stack[#stack] = nil
--       depth = cache[node] == nil and depth + 1 or depth - 1
--     else
--       break
--     end
--   end

--   -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
--   table.insert(output, output_str)
--   output_str = table.concat(output)

--   print(output_str)
-- end

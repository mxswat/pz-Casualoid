function CasualoidPrint(...)
	if not isDebugEnabled() then
		return
	end
	local arguments = { ... }
	local printResult = ''
	for _, v in ipairs(arguments) do
		printResult = printResult .. tostring(v or 'nil') .. " "
	end
	print('Casualoid:' .. printResult)
end

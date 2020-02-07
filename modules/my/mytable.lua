-------------------------------------------------------------------------------------------------------------------------------------------
--
-- mytable.lua - модуль QUIK_LUA для работы с типом table
-- (с)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--
--[[
 mytable.tostring(Table) - преобразует таблицу в строку
 mytable.tocsv(Table)    - преобразует таблицу в строку с разделителями между полями ";"
 mytable.len(T)          - возвращает количество элементов в таблице
]]
local mytable ={}
	local function merge(Table1,Table2)
		local mergeReturn = {}
		for key,val in pairs(Table1) do
			mergeReturn[key] = val
		end
		for key,val in pairs(Table2) do
			mergeReturn[key] = val
		end
		return mergeReturn
	end
-------------------------------------------------------------------------------------------------------------------------------------
	function mytable.tostring(Table)
		if Table == nil then
			return "nil"
		end
		local tostringReturn = ""
		local level = 0

		function ParseTable(a)
	      		local first = true
	      		level = level + 1  
	      		local s = '' 
			for i=1,level do 
				s = '   '..s 
			end

	      		for key, val in pairs(a) do
				local k = ""
	         		if not first then 
					tostringReturn = tostringReturn..",\n" 	
				else
					tostringReturn = tostringReturn.."\n" 	
				end
	         		if type(key) == 'number' then 
					k = '['..key..']' 
				else
					k = '[\''..key..'\']'
				end
				if type(val) == 'table' then 
	            			tostringReturn = tostringReturn..s..k..' = {'
	            			ParseTable(val)
	            			tostringReturn = tostringReturn.."\n"..s..'}'
	            			level = level - 1
	            		elseif type(val) == 'string' then
	      				val = '\''..val..'\''
	      				tostringReturn = tostringReturn..s..k..' = '..val
	            		else
	       				val = tostring(val)
	           			tostringReturn = tostringReturn..s..k..' = '..val
	            		end
	           	 	first = false
		      	end      
		end   

		tostringReturn = tostringReturn.."{"
		ParseTable(Table)
	   	tostringReturn = tostringReturn.."\n}"
		return tostringReturn
	end
-------------------------------------------------------------------------------------------------------------------------------------
	function mytable.tocsv(Table)
		local csv=""
		if Table["DATA"] == nil then
			log.Error("mytable.tocsv: no DATA in table")
			return nil
		end
		if Table["ORDER"] == nil then
			log.Error("mytable.tocsv: no ORDER in table")
			return nil
		end
		local first = true
		for _,key in ipairs(Table["ORDER"]) do
			if first == nil then
				csv = csv..";"
			end
			first = nil
			if type(Table["DATA"][key]) == "table" then
				csv = csv.."[table]"
			else
				csv = csv..tostring(Table["DATA"][key])
			end
		end
		return csv
	end
-------------------------------------------------------------------------------------------------------------------------------------
	function mytable.len(T)
		if T == nil then
			return 0
		end
		local lengthNum = 0
		local k,v
		for k,v in pairs(T) do
		   lengthNum = lengthNum + 1
		end
		log.Debug("mytable.len() = "..lengthNum)
		return lengthNum
	end
-------------------------------------------------------------------------------------------------------------------------------------
return mytable

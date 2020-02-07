-------------------------------------------------------------------------------------------------------------------------------------------
--
-- bond.lua - модуль QUIK_LUA для получения рыночной информации об облигациях 
-- (с)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--
--[[
    function bond.checkStatus(seccode)      - true - если облигация нам подходит
    function bond.isTrading(seccode)        - true - торговля seccode разрешена
    function bond.getParam(seccode,param)   - получить параметр облигации (используется другими функциями этого модуля)
    function bond.getShortName(seccode)     - наименование
    function bond.getNominal(seccode)	    - получить номинал
    function bond.getСoupon(seccode)	    - получить купон
    function bond.getNKD(seccode)	    - получить НКД
    function bond.getMatDate(seccode)	    - получить Дата погашения
    function bond.getDaysLeft(seccode)	    - получить Дней до погашения
    function bond.getPriceStep(seccode)	    - получить Шаг цены
    function bond.getLotSize(seccode)	    - получить Размер лота
    function bond.getBIDPrice(seccode)	    - получить цена лучшего предложения покупки в текущий момент
    function bond.getOFFERPrice(seccode)    - получить цена лучшего предложения продажи в текущий момент
    function bond.getBIDVolume(seccode)	    - получить объём лучшего предложения покупки в текущий момент
    function bond.getOFFERVolume(seccode)   - получить объём лучшего предложения продажи в текущий момент
    function bond.getLastPrice(seccode)	    - получить цена последней сделки
    function bond.getLastVolume(seccode)    - получить объем последней сделки
    function bond.getInfo(seccode)          - возвращает массив с информацией об облигации заданной в setClassCode() setSecCode()
    function bond.getQuotes(seccode)        - возвращаем массив (преобразованный - нумерация с середины стакана) с заявками из стакана цен
    function bond.getQuotesBID(seccode)     - возвращаем массив (преобразованный - нумерация с середины стакана) с заявками на покупку из стакана цен
    function bond.getQuotesOFFER(seccode)   - возвращаем массив с заявками на прожаду из стакана цен
    function bond.getIncomes(seccode)       - возвращает массив с информацией о денежном потоке облигации (вычисляется из даных в csv файле 'dbPath.."\\"..csvfile')
    function bond.getSecCodesList()	    - получить seccode список всех облигаций из dbPath..csvfile
    function bond.subscribeAll()	    - подписаться на все облигации из csvfile
    function bond.unsubscribeAll()          - отписаться от облигций из csvfile
]]


local bond = {}
	local dbPath     =  getScriptPath().."\\data\\" 
	local csvfile    = "bonds.lst"
  	classcode = "EQOB"

---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.checkStatus(seccode)
		if getParamEx(classcode,seccode,"STATUS").param_image == "" then
			log.Error("bond.checkStatus("..seccode.."): Облигация не найдена")
			return nil
		end

		if getParamEx(classcode,seccode,"STATUS").param_image ~= "торгуется" then
			log.Error("bond.checkStatus("..seccode.."): Облигация не торгуется")
			return nil
		end

		if getParamEx(classcode,seccode,"SEC_FACE_UNIT").param_image ~= "SUR" then
			log.Error("bond.checkStatus("..seccode.."): Валюта облигации не рубли")
			return nil
		end
		log.Debug("bond.checkStatus("..seccode..") = true")
		return true
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.isTrading(seccode)
		if bond.checkStatus then
			if bond.getParam(seccode,"TRADINGSTATUS") == "открыта" then
				log.Debug("bond.isTrading("..seccode..") = true")
				return true
			end
		end
		log.Debug("bond.isTrading("..seccode..") = nil")
		return nil
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getParam(seccode,param)
		if bond.checkStatus(seccode) then
			local val
			local res = getParamEx(classcode,seccode,param)
			if res.param_type == "1" then
				val = tonumber(res.param_value)
				log.Debug("bond.getParam("..seccode..","..param..") = "..val)
			elseif res.param_type == "2" then
				val = tonumber(res.param_value)
				log.Debug("bond.getParam("..seccode..","..param..") = "..val)
			else
				val = res.param_image
				log.Debug("bond.getParam("..seccode..","..param..") = \""..val.."\"")
			end
			return val
		else
			log.Debug("bond.getParam("..seccode..","..param..") = nil : bond.checkStatus() == nil")
			return nil
		end
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getShortName(seccode)
		local val = bond.getParam(seccode,"SHORTNAME")
		log.Debug("bond.getShortName("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getNominal(seccode)
		local val = bond.getParam(seccode,"SEC_FACE_VALUE")
		log.Debug("bond.getNominal("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getNKD(seccode)
		local val = bond.getParam(seccode,"ACCRUEDINT")
		log.Debug("bond.getNKD("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getCoupon(seccode)
		local val = bond.getParam(seccode,"COUPONVALUE")
		log.Debug("bond.getCoupon("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getMatDate(seccode) -- дата погашения
		local val = bond.getParam(seccode,"MAT_DATE")
		log.Debug("bond.getMatDate("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getDaysLeft(seccode)
		local val = bond.getParam(seccode,"DAYS_TO_MAT_DATE")
		log.Debug("bond.getDaysLeft("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getPriceStep(seccode)
		local val = bond.getParam(seccode,"SEC_PRICE_STEP")
		log.Debug("bond.getPriceStep("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getLotSize(seccode)
		local val = bond.getParam(seccode,"LOTSIZE")
		log.Debug("bond.getLotSize("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getBIDPrice(seccode)
		local val = bond.getParam(seccode,"BID")
		log.Debug("bond.getBIDPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getOFFERPrice(seccode)
		local val = bond.getParam(seccode,"OFFER")
		log.Debug("bond.getOFFERPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getBIDVolume(seccode)
		local val = bond.getParam(seccode,"BIDDEPTH")
		log.Debug("bond.getBIDVolume("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getOFFERVolume(seccode)
		local val = bond.getParam(seccode,"OFFERDEPTH")
		log.Debug("bond.getOFFERVolume("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getLastPrice(seccode)
		local val = bond.getParam(seccode,"LAST")
		log.Debug("bond.getLastPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getLastVolume(seccode)
		local val = bond.getParam(seccode,"QTY")
		log.Debug("bond.getLastVolume("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getInfo(seccode)
		log.Debug("+++ bond.getInfo("..seccode..")")

		local info = {}
		info["SHORTNAME"]          = getParamEx(classcode,seccode,"SHORTNAME").param_image                  -- Краткое название бумаги
		info["NOMINAL"]            = tonumber(getParamEx(classcode,seccode,"SEC_FACE_VALUE").param_value)   -- Номинал
		info["DAYSLEFT"]           = tonumber(getParamEx(classcode,seccode,"DAYS_TO_MAT_DATE").param_value) -- Дней до погашения
		info["NKD"]                = tonumber(getParamEx(classcode,seccode,"ACCRUEDINT").param_value)       -- НКД
		info["MAT_DATE"]           = getParamEx(classcode,seccode,"MAT_DATE").param_image		    -- Дата погашения
		info["PRICESTEP"]          = tonumber(getParamEx(classcode,seccode,"SEC_PRICE_STEP").param_value)   -- Шаг изменения цены
		info["LOTSIZE"]            = tonumber(getParamEx(classcode,seccode,"LOTSIZE").param_value)	    -- размер лота
		info["STATUS"]             = getParamEx(classcode,seccode,"STATUS").param_image	    	            -- Статус
		info["TRADINGSTATUS"]      = getParamEx(classcode,seccode,"TRADINGSTATUS").param_image		    -- Состояние сессии

		log.Debug("--- bond.getInfo() = "..mytable.tostring(info))
		return info
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.getQuotes(seccode)
		log.Debug("+++ bond.getQuotes("..seccode..")")
		if bond.isTrading == nil then
			log.Error("--- bond.getQuotes("..seccode..") = nil : Облигация не торгуется")
			return nil
		end
		local quotes = getQuoteLevel2Ex(classcode,seccode)
--		log.Debug("bond.getDOM(): Quote = "..mytable.tostring(quotes))
		if  quotes == nil then
			log.Error("--- bond.getQuotes("..seccode..") = nil : Не удалось получить стакан")
			return nil
		end
		--[[ quotes = {
				['bid_count'] = number,
				['offer_count'] = number,
				['bid'] = {
					[1] = {    			// здесь самая дешевая цена заявок покупки - это самый низ стакана
						['price'] = number,
						['quantity'] = number
					},
					[2] = {...},
					[3] = {...},
					[bid_count] = {...} 		// здесь самая дорогая цена заявок покупки - это середина стакана
				},
				['offer'] = {
					[1] = {    			// здесь самая дешевая цена предложений продажи - это середина стакана
						['price'] = number,
						['quantity'] = number
					},
					[2] = {...},
					[3] = {...},
					[last] = {...} 			// здесь самая дорогая цена предложений продажи - это самый верх стакана
				}
		   }
		]]
		-- переворачиваем таблицу bid, чтобы отсчёт начинался с середины стакана как и в таблице offer
		local newQuotes = {}
		if tonumber(quotes.offer_count) > 0 then
			newQuotes.offer = {}
			for _,offer in ipairs(quotes.offer) do
				local pos = #newQuotes.offer+1
				newQuotes.offer[pos] = {}
				newQuotes.offer[pos].price  = tonumber(offer.price)
				newQuotes.offer[pos].volume = tonumber(offer.quantity)
			end
		end
		if tonumber(quotes.bid_count) > 0 then
			newQuotes.bid = {}
			for i = #quotes.bid, 1, -1 do
				local pos = #newQuotes.bid+1
				newQuotes.bid[pos] = {}
				newQuotes.bid[pos].price  = tonumber(quotes.bid[i].price)
				newQuotes.bid[pos].volume = tonumber(quotes.bid[i].quantity)
			end
		end

		log.Debug("--- bond.getQuotes("..seccode..") = "..mytable.tostring(newQuotes))
		return newQuotes
	end
-----------------------------------------------------------------------------------------------------------------
	function bond.getQuotesBID(seccode)
		log.Debug("+++ bond.getQuotesBID("..seccode..")")
		local quotes = bond.getQuotes(seccode)
		if quotes == nil then
			log.Debug("--- bond.getQuotesBID("..seccode..") = nil")
			return nil
		end
		if quotes.bid == nil then
			log.Debug("--- bond.getQuotesBID("..seccode..") = nil")
			return nil
		end
		log.Debug("--- bond.getQuotesBID("..seccode..") = [array]")
		return quotes.bid
	end
-----------------------------------------------------------------------------------------------------------------
	function bond.getQuotesOFFER(seccode)
		log.Debug("+++ bond.getQuotesOFFER("..seccode..")")
		local quotes = bond.getQuotes(seccode)
		if quotes == nil then
			log.Debug("--- bond.getQuotesOFFER("..seccode..") = nil")
			return nil
		end
		if quotes.offer == nil then
			log.Debug("--- bond.getQuotesOFFER("..seccode..") = nil")
			return nil
		end
		log.Debug("--- bond.getQuotesOFFER("..seccode..") = [array]")
		return quotes.offer
	end
-----------------------------------------------------------------------------------------------------------------
	function bond.getIncomes(seccode)
		log.Debug("+++ bond.getIncomes("..seccode..")")
		if global_dbPath ~= nil then
			dbPath = global_dbPath
		end
		local f,err = io.open(dbPath..csvfile,"r")
		if f == nil then
			log.Debug("--- bond.getIncomes("..seccode..") = nil : "..err)
      			return nil
		end  	
		local bondsfromfile =  f:read("*all")
		f:close()
		
		-- ищем строку с нашей облигацией
		local csvString = nil
		for str in string.gmatch(bondsfromfile,"([^".."\n".."]+)") do
			if string.find(str,classcode..";"..seccode..";") ~= nil then
				csvString = str
				break
			end
		end
		if csvString == nil then
			log.Debug("--- bond.getIncomes("..seccode..") = nil : Облигация не найдена в "..csvfile)
			return nil
		end

		-- разбиваем строку по разделителю ";"
 		local Return={}
   		for str in string.gmatch(csvString, "([^; ]+)") do
      			Return[#Return+1] = str
   		end
		table.remove(Return,1)
		table.remove(Return,1)

		log.Debug("--- bond.getIncomes("..seccode..") = [array]")
--		log.Debug("--- bond.getIncomes() = "..mytable.tostring(Return))
		return Return
	end
-----------------------------------------------------------------------------------------------------------------------
	function bond.getSecCodesList()
		log.Debug("+++ bond.getSecCodesList()")
		if global_dbPath ~= nil then
			dbPath = global_dbPath
		end
		local f,err = io.open(dbPath..csvfile,"r")
		if f == nil then
			log.Error('--- bond.getSecCodesList: не удалось загрузить данные из файла:'..err)
      			return nil
		end  	
		local bondsfromfile =  f:read("*all")
		f:close()
		-- разбиваем по строкам
		local bondsList = {}
		for str in string.gmatch(bondsfromfile,"([^".."\n".."]+)") do
			-- разбиваем строку по разделителю ";" и забираем 2-ой элемент в каждой строке
			local c = 1
   			for element in string.gmatch(str,"([^; ]+)") do
				if c == 2 then
					table.insert(bondsList,element)
					break
				end
				c = c + 1
	   		end
		end
		if mytable.len(bondsList) == 0 then
			log.Debug("--- bond.getSecCodesList() = nil: не удалось спарсить данные из файла")
			return nil
		end
		log.Debug("--- bond.getSecCodesList() = "..mytable.tostring(bondsList))
		return bondsList
	end
-------------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.subscribeAll()
		log.Debug("+++ bond.subscribeAll()")
		local bondsTable = bond.getSecCodesList()
		if bondsTable == nil then
			log.Debug("--- bond.subscribeAll() = nil")
			return nil
		end
		for _,seccode in ipairs(bondsTable) do
			local res = Subscribe_Level_II_Quotes(classcode,seccode)
			log.Debug("bond.subscribeAll(): "..seccode.." "..tostring(res))
		end
		log.Debug("bond.subscribeAll(): ждём 1 сек. пока подключится подписка")
		sleep(1000)
		log.Debug("--- bond.subscribeAll() = true")
		return true
	end
-----------------------------------------------------------------------------------------------------------------------------------------------------------
	function bond.unsubscribeAll()
		log.Debug("+++ bond.unsubscribeAll()")
		local bondsTable = bond.getSecCodesList()
		if bondsTable == nil then
			log.Debug("--- bond.unsubscribeAll() = nil")
			return nil
		end
		for _,seccode in ipairs(bondsTable) do
			local res = Unsubscribe_Level_II_Quotes(classcode,seccode)
			log.Debug("bond.unsubscribeAll(): "..seccode.." "..tostring(res))
		end
		log.Debug("--- bond.unsubscribeAll() = true")
		return true
	end
-----------------------------------------------------------------------------------------------------------------------------------------------------------
return bond

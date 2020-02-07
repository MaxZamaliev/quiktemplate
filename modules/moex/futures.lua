-------------------------------------------------------------------------------------------------------------------------------------------
--
-- futures.lua - модуль QUIK_LUA для получения рыночной информации о фьючерсах
-- (с)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--
--[[
	function futures.subscribe(seccode)	 - подписаться на получение котировок для seccode
	function futures.checkStatus(seccode)	 - true если инструмент нам подходит
	function futures.isTrading(seccode)	 - true еслиинструмент сейчас торгуется
	function futures.getParam(seccode,param) - получить параметр (используется другими функциями этого модуля)
	function futures.getShortName(seccode)	 - краткое наименование
	function futures.getMatDate(seccode) 	 - дата экспирации
	function futures.getDaysLeft(seccode)    - дней до экспирации
	function futures.getSellDepo(seccode)	 - ГО при продаже
	function futures.getBuyDepo(seccode)     - ГО при покупке
	function futures.getPriceStep(seccode)   - шаг цены
	function futures.getLotSize(seccode)     - размер лота
	function futures.getBIDPrice(seccode)    - лучша цена предложения
	function futures.getOFFERPrice(seccode)  - лучшая цена спроса
	function futures.getOFFERVolume(seccode) - доступный объём по лучшей цене предложения
	function futures.getBIDVolume(seccode)   - доступный объем по лучшей цене спроса
	function futures.getLastPrice(seccode)   - цена последней сделки
	function futures.getLastVolume(seccode)  - объем последней сделки
	function futures.getClosePrice(seccode)  - цена закрытия
	function futures.getQuotes(seccode)      - получить стакан
	function futures.getQuotesBID(seccode)   - получить BID часть стакана
	function futures.getQuotesOFFER(seccode) - получить OFFER часть стакана
]]

local futures={}
	local classcode = "SPBFUT"
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.subscribe(seccode)
		local res = Subscribe_Level_II_Quotes(classcode,seccode)
		log.Debug("futures.subscribe("..seccode..") = "..tostring(res))
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.checkStatus(seccode)
		if getParamEx(classcode,seccode,"STATUS").param_image == "" then
			log.Error("futures.checkStatus("..seccode.."): Фьючерс не найден")
			return nil
		end

		if getParamEx(classcode,seccode,"STATUS").param_image ~= "торгуется" then
			log.Error("futures.checkStatus("..seccode.."): Фьючерс не торгуется")
			return nil
		end

		if getParamEx(classcode,seccode,"SEC_FACE_UNIT").param_image ~= "SUR" then
			log.Error("futures.checkStatus("..seccode.."): Валюта фьючерса не рубли")
			return nil
		end
		log.Debug("futures.checkStatus("..seccode..") = true")
		return true
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.isTrading(seccode)
		if futures.checkStatus then
			if futures.getParam(seccode,"TRADINGSTATUS") == "открыта" then
				log.Debug("bonds.isTrading("..seccode..") = true")
				return true
			end
		end
		log.Debug("futures.isTrading("..seccode..") = nil")
		return nil
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getParam(seccode,param)
		if futures.checkStatus(seccode) then
			local val
			local res = getParamEx(classcode,seccode,param)
			if res.param_type == "1" then
				val = tonumber(res.param_value)
				log.Debug("futures.getParam("..seccode..","..param..") = "..val)
			elseif res.param_type == "2" then
				val = tonumber(res.param_value)
				log.Debug("futures.getParam("..seccode..","..param..") = "..val)
			else
				val = res.param_image
				log.Debug("futures.getParam("..seccode..","..param..") = \""..val.."\"")
			end
			return val
		else
			log.Debug("futures.getParam("..seccode..","..param..") = nil : futures.checkStatus() == nil")
			return nil
		end
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getShortName(seccode)
		local val = futures.getParam(seccode,"SHORTNAME")
		log.Debug("futures.getShortName("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getMatDate(seccode) -- дата погашения
		local val = futures.getParam(seccode,"MAT_DATE")
		log.Debug("futures.getMatDate("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getDaysLeft(seccode)
		local val = futures.getParam(seccode,"DAYS_TO_MAT_DATE")
		log.Debug("futures.getDaysLeft("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getSellDepo(seccode)
		local val = futures.getParam(seccode,"SELLDEPO")
		log.Debug("futures.getSellDepo("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getBuyDepo(seccode)
		local val = futures.getParam(seccode,"BUYDEPO")
		log.Debug("futures.getSellDepo("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getPriceStep(seccode)
		local val = futures.getParam(seccode,"SEC_PRICE_STEP")
		log.Debug("futures.getPriceStep("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getLotSize(seccode)
		local val = futures.getParam(seccode,"LOTSIZE")
		log.Debug("futures.getLotSize("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getBIDPrice(seccode)
		local val = futures.getParam(seccode,"BID")
		log.Debug("futures.getBIDPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getOFFERPrice(seccode)
		local val = futures.getParam(seccode,"OFFER")
		log.Debug("futures.getOFFERPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getBIDVolume(seccode)
		local val = futures.getParam(seccode,"BIDDEPTH")
		log.Debug("futures.getBIDVolume("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getOFFERVolume(seccode)
		local val = futures.getParam(seccode,"OFFERDEPTH")
		log.Debug("futures.getOFFERVolume("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getLastPrice(seccode)
		local val = futures.getParam(seccode,"LAST")
		log.Debug("futures.getLastPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getLastVolume(seccode)
		local val = futures.getParam(seccode,"QTY")
		log.Debug("futures.getLastVolume("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getClosePrice(seccode)
		local val = futures.getParam(seccode,"CLOSEPRICE")
		log.Debug("futures.getClosePrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function futures.getQuotes(seccode)
		log.Debug("+++ futures.getQuotes("..seccode..")")
		if futures.isTrading == nil then
			log.Error("--- futures.getQuotes("..seccode..") = nil : Облигация не торгуется")
			return nil
		end
		local quotes = getQuoteLevel2Ex(classcode,seccode)
--		log.Debug("futures.getDOM(): Quote = "..mytable.tostring(quotes))
		if  quotes == nil then
			log.Error("--- futures.getQuotes("..seccode..") = nil : Не удалось получить стакан")
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

		log.Debug("--- futures.getQuotes("..seccode..") = "..mytable.tostring(newQuotes))
		return newQuotes
	end
-----------------------------------------------------------------------------------------------------------------
	function futures.getQuotesBID(seccode)
		log.Debug("+++ futures.getQuotesBID("..seccode..")")
		local quotes = futures.getQuotes(seccode)
		if quotes == nil then
			log.Debug("--- futures.getQuotesBID("..seccode..") = nil")
			return nil
		end
		if quotes.bid == nil then
			log.Debug("--- futures.getQuotesBID("..seccode..") = nil")
			return nil
		end
		log.Debug("--- futures.getQuotesBID("..seccode..") = [array]")
		return quotes.bid
	end
-----------------------------------------------------------------------------------------------------------------
	function futures.getQuotesOFFER(seccode)
		log.Debug("+++ futures.getQuotesOFFER("..seccode..")")
		local quotes = futures.getQuotes(seccode)
		if quotes == nil then
			log.Debug("--- futures.getQuotesOFFER("..seccode..") = nil")
			return nil
		end
		if quotes.offer == nil then
			log.Debug("--- futures.getQuotesOFFER("..seccode..") = nil")
			return nil
		end
		log.Debug("--- futures.getQuotesOFFER("..seccode..") = [array]")
		return quotes.offer
	end
-----------------------------------------------------------------------------------------------------------------
return futures
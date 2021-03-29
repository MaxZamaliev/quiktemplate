-------------------------------------------------------------------------------------------------------------------------------------------
--
-- main.lua расчёт стратегии "Арбитражный скальпель"
-- при возниконовении возможности совершения арбитражной сделки, покупаем/продаём базовый актив и выставляем на продажу/покупку по более выгодной цене
-- v2 добален разворот позиции
-- (с)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--
Version	 	 = "1.0"

Debug 		 = true

dofile(getScriptPath().."\\modules\\modules.lua")
dofile(getScriptPath().."\\include\\OnInit.lua")
dofile(getScriptPath().."\\include\\OnStop.lua")
dofile(getScriptPath().."\\include\\OnOrder.lua")
dofile(getScriptPath().."\\include\\OnTrade.lua")
dofile(getScriptPath().."\\include\\OnTransReply.lua")
dofile(getScriptPath().."\\include\\OnQuote.lua")

fSecCode = "SiH0"
opt = {}
optExtrem = {}
ready = nil
Debug = false
tid = nil 		-- table identificator
InPriceDelta  = 1 -- размер арбитражной прибыли при достижении которой совершаем сделку с базовым активом
OutPriceDelta = 20 -- какую прибыль хотим получить от перепродажи купленного/проданного актива
rComission    = 0  -- суммарная комиссия с момента запуска скрипта
rProfit       = 0  -- суммарный профит


position = {
		['operation'] = "",
		['seccode']   = "",
		['price']     = 0,
		['volume']    = 0
	   }

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
function OnStop()
	-- отписываемся на получение котировок с биржи
	for matDate,optionsGroup in pairs(opt) do
		for strike,position in pairs(optionsGroup) do
			option.unsubscribe(position.call)
			option.unsubscribe(position.put)
		end
	end
        futures.unsubscribe(fSecCode)
	log.Info("Result: rProfit="..rProfit.."; rComission="..rComission)
	log.Info("position[] = "..mytable.tostring(position))
	return 1
end
-------------------------------------------------------------------------------------------------------------------------------
function main()
	local maxOptionStrike = 70000
	local minOptionStrike = 62000

	-- получаем список опционов
	local optionsList = option.getFullListByBase(fSecCode)
	if optionsList == nil then
		return
	end
--log.Info("optionsList = "..mytable.tostring(optionsList))

	-- делим на пары по страйкам Si63750BC0 : Si63750BO0
	for matDate,optionsGroup in pairs(optionsList) do
		opt[matDate] = {}
		for key,secCode in ipairs(optionsGroup) do
--log.Info("Debug1: ["..key.."] = "..secCode)
			-- убираем неликвиды
			if string.sub(secCode,6,6) ~= "5" and option.checkStatus(secCode) ~= nil then
				local strike = option.getStrike(secCode)
				-- уменьшаем количество наблюдаемых опционов
				if strike >= minOptionStrike and strike <= maxOptionStrike then
					if opt[matDate][strike] == nil then
						opt[matDate][strike] = {}
					end
					if option.getType(secCode) == "Call" then
						opt[matDate][strike]["call"] = secCode
					else
						opt[matDate][strike]["put"] = secCode
					end
				end
			end
		end
	end
	log.Info("AScalp")
	log.Info("month "..mytable.tostring(opt))

	-- подписываемся на получение котировок с биржи
	for matDate,optionsGroup in pairs(opt) do
		for strike,position in pairs(optionsGroup) do
			option.subscribe(position.call)
			option.subscribe(position.put)
		end
	end
        futures.subscribe(fSecCode)
	sleep(2000)	
	ready = true
	while true do
		sleep(1000)
	end
end                               
-------------------------------------------------------------------------------------------------------------------------------

function search(callSecCode,putSecCode)

	local callQuotes = option.getQuotes(callSecCode)
	local putQuotes  = option.getQuotes(putSecCode)
	local futQuotes  = futures.getQuotes(fSecCode)
	local strike     = option.getStrike(callSecCode)
	if futQuotes == nil then
		return
	end
	if position.price > 0 then
		if position.operation == "buy" then
			-- ищем как выгодно продать
			local fPrice = futQuotes.bid[1].price
			local fVolume = futQuotes.bid[1].volume
			if ( (fPrice) >= (position.price+OutPriceDelta) ) then
--log.Info(fPrice.." >= "..position.price.." + "..OutPriceDelta)
				local profit,comission = 0
				if  fVolume >= position.volume then
					profit = ( fPrice - position.price ) * position.volume
					comission = (0.6 + math.ceil(fPrice*0.0015)/100) * position.volume
					rProfit = rProfit + profit
					rComission = rComission + comission

					log.Info("full close buy "..position.seccode..": ".."buyPrice="..position.price.."; positionVolume="..position.volume.."; sellPrice="..fPrice.."; sellVolume="..position.volume..";profit="..profit.."; comission="..comission.."; rProfit="..rProfit.."; rComission="..rComission)
					position.price = 0
					position.volume = 0
				else
					profit = ( fPrice - position.price ) * fVolume
					comission = (0.6 + math.ceil(fPrice*0.0015)/100) * fVolume

					rProfit = rProfit + profit
					rComission = rComission + comission
					log.Info("part close buy "..position.seccode..": ".."buyPrice="..position.price.."; positionVolume="..position.volume.."; sellPrice="..fPrice.."; sellVolume="..fVolume..";profit="..profit.."; comission="..comission.."; rProfit="..rProfit.."; rComission="..rComission)
					position.volume = position.volume - fVolume
				end
			end
		elseif position.operation == "sell" then
--log.Info("position[] = "..mytable.tostring(position))
			-- ищем как выгодно купить
			local fPrice = futQuotes.offer[1].price
			local fVolume = futQuotes.offer[1].volume
			if ( (fPrice) <= (position.price-OutPriceDelta) ) then
log.Info(fPrice.." <= "..position.price.." - "..OutPriceDelta)
				local profit,comission = 0
				if  fVolume >= position.volume then
					profit = ( position.price - fPrice ) * position.volume
					comission = (0.6 + math.ceil(fPrice*0.0015)/100) * position.volume
					rProfit = rProfit + profit
					rComission = rComission + comission
					log.Info("full close sell "..position.seccode..": ".."sellPrice="..position.price.."; positionVolume="..position.volume.."; buyPrice="..fPrice.."; buyVolume="..position.volume..";profit="..profit.."; comission="..comission.."; rProfit="..rProfit.."; rComission="..rComission)

					position.price = 0
					position.volume = 0
				else
					profit = ( position.price - fPrice ) * fVolume
					comission = (0.6 + math.ceil(fPrice*0.0015)/100) * fVolume
					rProfit = rProfit + profit
					rComission = rComission + comission
					log.Info("part close sell "..position.seccode..": ".."sellPrice="..position.price.."; positionVolume="..position.volume.."; buyPrice="..fPrice.."; buyVolume="..fVolume..";profit="..profit.."; comission="..comission.."; rProfit="..rProfit.."; rComission="..rComission)
					position.volume = position.volume - fVolume
				end
			end
	
		end
	end


	if callQuotes == nil or putQuotes == nil or futQuotes == nil or strike == nil then
		log.Error(callSecCode.." : "..putSecCode.." no quotes")
		return
	end

	if optExtrem[strike] == nil then
		optExtrem[strike] = {}
	end

	local profit1,profit2 = nil

	-- прямой арбитраж:   +Call -Put -Fut +strike
	if callQuotes.offer ~= nil and putQuotes.bid ~= nil and futQuotes.bid ~= nil then
		local callOffer = callQuotes.offer[1].price
		local putBid    = putQuotes.bid[1].price
		local futBid  = futQuotes.bid[1].price
		profit1 = -callOffer +putBid +futBid -strike 
		if optExtrem[strike].sell == nil then
			optExtrem[strike].sell = {}
		end

		optExtrem[strike].sell.cur = profit1
		if optExtrem[strike].sell.max == nil or optExtrem[strike].sell.max < profit1 then
			optExtrem[strike].sell.max = profit1
		end
		if optExtrem[strike].sell.min == nil or optExtrem[strike].sell.min > profit1 then
			optExtrem[strike].sell.min = profit1
		end

		if profit1 > 0 then
			log.Info("S -strike="..strike.."; -callOffer="..callOffer.."; +putBid="..putBid.."; +futBid="..futBid.."; profit="..profit1.." ( "..optExtrem[strike].sell.min.."/"..optExtrem[strike].sell.max.." )")
		end
		if profit1 >= InPriceDelta then
			if position.price == 0 then
				position.operation = "sell"
				position.seccode = fSecCode
				position.price   = futBid
				position.volume  = futQuotes.offer[1].volume
				position.comission = (0.6 + math.ceil(position.price*0.0015)/100) * position.volume
				rComission = rComission + position.comission
				log.Info("sell "..position.seccode..": price="..position.price.."; volume="..position.volume.."; comission="..position.comission)
			end
		end
	end

	-- обратный арбитраж  -Call +Put +Fut -strike = 0
	if callQuotes.bid ~= nil and putQuotes.offer ~= nil and futQuotes.offer ~= nil then
		local callBid  = callQuotes.bid[1].price
		local putOffer = putQuotes.offer[1].price
		local futOffer = futQuotes.offer[1].price
		profit2 = callBid -putOffer -futOffer +strike

		if optExtrem[strike].buy == nil then
			optExtrem[strike].buy = {}
		end
		optExtrem[strike].buy.cur = profit2

		if optExtrem[strike].buy.max == nil or optExtrem[strike].buy.max < profit2 then
			optExtrem[strike].buy.max = profit2
		end
		if optExtrem[strike].buy.min == nil or optExtrem[strike].buy.min > profit2 then
			optExtrem[strike].buy.min = profit2
		end

		if profit2 > 0 then
			log.Info("B +strike="..strike.."; +callBid="..callBid.."; -putOffer="..putOffer.."; -futOffer="..futOffer.."; profit="..profit2.." ( "..optExtrem[strike].buy.min.."/"..optExtrem[strike].buy.max.." )")
		end
		if profit2 >= InPriceDelta then
			if position.price == 0 then
				position.operation = "buy"
				position.seccode = fSecCode
				position.price   = futOffer
				position.volume  = futQuotes.offer[1].volume
				position.comission = (0.6 + math.ceil(position.price*0.0015)/100) * position.volume
				rComission = rComission + position.comission
				log.Info("buy "..position.seccode..": price="..position.price.."; volume="..position.volume.."; comission="..position.comission)
			end
		end
	end
end
-------------------------------------------------------------------------------------------------------------------------------
function searchAll()
	for matDate,optionsGroup in pairs(opt) do
		for strike,position in pairs(optionsGroup) do
			search(position.call,position.put)
		end
	end
end
-------------------------------------------------------------------------------------------------------------------------------
function OnQuote(qClassCode,qSecCode)
	if ready == nil then
		return
	end
	if qClassCode == "SPBFUT" and qSecCode == fSecCode then
		searchAll()
		return
	end
	if qClassCode == "SPBOPT" then
		for matDate,optionsGroup in pairs(opt) do
			for strike,position in pairs(optionsGroup) do
				if qSecCode == position.call or qSecCode == position.put then
				if position.call == nil or position.put == nil then
					error(strike)
				end
					search(position.call,position.put)
					return
				end
			end
		end
	end
	
end


-------------------------------------------------------------------------------------------------------------------------------------------
--
-- option.lua - тесты модуля stock
-- (с)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--

function option.test()
	local testOK_tmp = testOK
	testOK = "ok"
	local seccode = "Si64000BC0"

	option.subscribe(seccode)


--	function option.getDelta(seccode)	 - получить параметр Дельта
	if option.getDelta(seccode) == nil then
		log.Info("option.getDelta("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getGamma(seccode)        - получить параметр Гамма
	if option.getGamma(seccode) == nil then
		log.Info("option.getGamma("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getTheta(seccode)        - получить параметр Тета
	if option.getTheta(seccode) == nil then
		log.Info("option.getTheta("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getVega(seccode)         - получить параметр Вега
	if option.getVega(seccode) == nil then
		log.Info("option.getVega("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getRho(seccode)          - получить параметр Ро
	if option.getRho(seccode) == nil then
		log.Info("option.getRho("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getStrike(seccode)       - получить страйк опциона
	if option.getStrike(seccode) == nil then
		log.Info("option.getStrike("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getVolatility(seccode)   - получить волатильность
	if option.getVolatility(seccode) == nil then
		log.Info("option.getVolatility("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getTheorPrice(seccode)   - получить теоретическую цену
	if option.getTheorPrice(seccode) == nil then
		log.Info("option.getTheorPrice("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getBaseClassCode(seccode)         - получить seccode базового инструмента
	if option.getBaseClassCode(seccode) == nil then
		log.Info("option.getClassSecCode("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getBaseSecCode(seccode)         - получить seccode базового инструмента
	if option.getBaseSecCode(seccode) == nil then
		log.Info("option.getBaseSecCode("..seccode..") - failed")
		testOK = "failed"
	end


-- option.checkStatus(seccode)      - true - если акция нам подходит
	if option.checkStatus(seccode) == nil then
		log.Info("option.checkStatus("..seccode..") - failed")
		testOK = "failed"
	end

-- option.isTrading(seccode)        - true - торговля seccode разрешена
	option.isTrading(seccode)

-- option.getParam(seccode,param)   - получить параметр акции (используется другими функциями этого модуля)
	if option.getParam(seccode,"LOTSIZE") ~= 1 then
		log.Info("option.getParam("..seccode..",'LOTSIZE') - failed")
		testOK = "failed"
	end

-- option.getShortName(seccode)     - наименование
	if option.getShortName(seccode) == nil then
		log.Info("option.getShortName("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getSellDepo(seccode)
	if option.getSellDepo(seccode) == nil then
		log.Info("option.getSellDepo("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getSellDepo(seccode)
	if option.getBuyDepo(seccode) == nil then
		log.Info("option.getBuyDepo("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getDaysLeft(seccode)
	if option.getDaysLeft(seccode) == nil then
		log.Info("option.getDaysLeft("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getMatDate(seccode)
	if option.getMatDate(seccode) == nil then
		log.Info("option.getMatDate("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getPriceStep(seccode)	- Шаг цены
	if option.getPriceStep(seccode) ~= 1 then
		log.Info("option.getPriceStep("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getLotSize(seccode)	- Размер лота
	if option.getLotSize(seccode) ~= 1 then
		log.Info("option.getLotSize("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getBIDPrice(seccode)		- лучшее предложение покупки в текущий момент
	if option.getBIDPrice(seccode) == nil  then
		log.Info("option.getBIDPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getOFFERPrice(seccode)  	- лучшее предложение продажи в текущий момент
	if option.getOFFERPrice(seccode) == nil then
		log.Info("option.getOFFERPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getBIDVolume(seccode)		- лучшее предложение покупки в текущий момент
	if option.getBIDVolume(seccode) == nil  then
		log.Info("option.getBIDvolume("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getOFFERVolume(seccode)  	- лучшее предложение продажи в текущий момент
	if option.getOFFERVolume(seccode) == nil then
		log.Info("option.getOFFERVolume("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getLastPrice(seccode)	- цена последней сделки
	if option.getLastPrice(seccode) == nil then
		log.Info("option.getLastPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getLastVolume(seccode)    - объем последней сделки
	if option.getLastVolume(seccode) == nil then
		log.Info("option.getLastVolume("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getQuotes(seccode)        - возвращаем массив (преобразованный - нумерация с середины стакана) с заявками из стакана цен
	if option.getQuotes(seccode) == nil then
		log.Info("option.getQuotes("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getQuotesBID(seccode)     - возвращаем массив (преобразованный - нумерация с середины стакана) с заявками на покупку из стакана цен
	if option.getBIDPrice(seccode) > 0 then
		local bids = option.getQuotesBID(seccode)
		if  bids[1].price ~= option.getBIDPrice(seccode) then
			log.Info("option.getQuotesBID("..seccode..") price - failed")
			testOK = "failed"
		end
		if  bids[1].volume ~= option.getBIDVolume(seccode) then
			log.Info("option.getQuotesBID("..seccode..") volume - failed")
			testOK = "failed"
		end
	end

-- option.getQuotesOFFER(seccode)   - возвращаем массив с заявками на продажу из стакана цен
	if option.getOFFERPrice(seccode) > 0 then
		local offers = option.getQuotesOFFER(seccode)
		if  offers[1].price ~= option.getOFFERPrice(seccode) then
			log.Info("option.getQuotesOFFER("..seccode..") price - failed")
			testOK = "failed"
		end
		if  offers[1].volume ~= option.getOFFERVolume(seccode) then
			log.Info("option.getQuotesOFFER("..seccode..") volume - failed")
			testOK = "failed"
		end
	end

	if testOK == "ok" then
		log.Info("futures module test "..testOK)
		testOK = testOK_tmp
	end


end

option.test()

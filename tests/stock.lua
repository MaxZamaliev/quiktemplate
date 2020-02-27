-------------------------------------------------------------------------------------------------------------------------------------------
--
-- stock.lua - тесты модуля stock
-- (с)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--

function stock.test()
	local testOK_tmp = testOK
	testOK = "ok"
	local seccode = "NLMK"

	stock.subscribe(seccode)

-- stock.checkStatus(seccode)      - true - если акция нам подходит
	if stock.checkStatus(seccode) == nil then
		log.Info("stock.checkStatus("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.isTrading(seccode)        - true - торговля seccode разрешена
	stock.isTrading(seccode)

-- stock.getParam(seccode,param)   - получить параметр акции (используется другими функциями этого модуля)
	if stock.getParam(seccode,"LOTSIZE") ~= 10 then
		log.Info("stock.getParam("..seccode..",'LOTSIZE') - failed")
		testOK = "failed"
	end

-- stock.getShortName(seccode)     - наименование
	if stock.getShortName(seccode) == nil then
		log.Info("stock.getShortName("..seccode..") - failed")
		testOK = "failed"
	end


-- stock.getPriceStep(seccode)	- Шаг цены
	if stock.getPriceStep(seccode) ~= 0.02 then
		log.Info("stock.getPriceStep("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getLotSize(seccode)	- Размер лота
	if stock.getLotSize(seccode) ~= 10 then
		log.Info("stock.getLotSize("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getBIDPrice(seccode)		- лучшее предложение покупки в текущий момент
	if stock.getBIDPrice(seccode) == nil  then
		log.Info("stock.getBIDPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getOFFERPrice(seccode)  	- лучшее предложение продажи в текущий момент
	if stock.getOFFERPrice(seccode) == nil then
		log.Info("stock.getOFFERPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getBIDVolume(seccode)		- лучшее предложение покупки в текущий момент
	if stock.getBIDVolume(seccode) == nil  then
		log.Info("stock.getBIDvolume("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getOFFERVolume(seccode)  	- лучшее предложение продажи в текущий момент
	if stock.getOFFERVolume(seccode) == nil then
		log.Info("stock.getOFFERVolume("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getLastPrice(seccode)	- цена последней сделки
	if stock.getLastPrice(seccode) == nil then
		log.Info("stock.getLastPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getLastVolume(seccode)    - объем последней сделки
	if stock.getLastVolume(seccode) == nil then
		log.Info("stock.getLastVolume("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getQuotes(seccode)        - возвращаем массив (преобразованный - нумерация с середины стакана) с заявками из стакана цен
	if stock.getQuotes(seccode) == nil then
		log.Info("stock.getQuotes("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getQuotesBID(seccode)     - возвращаем массив (преобразованный - нумерация с середины стакана) с заявками на покупку из стакана цен
	if stock.getQuotesBID(seccode) == nil then
		log.Info("stock.getQuotesBID("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getQuotesOFFER(seccode)   - возвращаем массив с заявками на продажу из стакана цен
	if stock.getQuotesOFFER(seccode) == nil then
		log.Info("stock.getQuotesOFFER("..seccode..") - failed")
		testOK = "failed"
	end

--	function stock.getClosePrice(seccode)	     - Цена периода закрытия
	if stock.getClosePrice(seccode) == nil then
		log.Info("stock.getClosePrice("..seccode..") - failed")
		testOK = "failed"
	end

--	function stock.getLClosePrice(seccode)       - Официальная цена закрытия
	if stock.getLClosePrice(seccode) == nil then
		log.Info("stock.getClosePrice("..seccode..") - failed")
		testOK = "failed"
	end

--	function stock.getPrevLClosePrice(seccode)   - Официальная цена закрытия предыдущего дня
	if stock.getPrevLClosePrice(seccode) == nil then
		log.Info("stock.getPrevLClosePrice("..seccode..") - failed")
		testOK = "failed"
	end

--	function stock.getCloseAuctionPrice(seccode) - Цена аукциона
	if stock.getAuctPrice(seccode) == nil then
		log.Info("stock.getAuctPrice("..seccode..") - failed")
		testOK = "failed"
	end

	if testOK == "ok" then
		log.Info("stock module test "..testOK)
		testOK = testOK_tmp
	end

end

stock.test()

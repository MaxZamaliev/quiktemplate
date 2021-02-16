-------------------------------------------------------------------------------------------------------------------------------------------
--
-- futures.lua - тесты модуля futures
-- (с)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--

function futures.test()
	local testOK_tmp = testOK
	testOK = "ok"
	local seccode = "NMH0"

	futures.subscribe(seccode)

-- futures.checkStatus(seccode)      - true - если нам подходит
	if futures.checkStatus(seccode) == nil then
		log.Info("futures.checkStatus("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.isTrading(seccode)        - true - торговля seccode разрешена
	futures.isTrading(seccode)

-- futures.getParam(seccode,param)   - получить параметр (используется другими функциями этого модуля)
	if futures.getParam(seccode,"LOTSIZE") ~= 100 then
		log.Info("futures.getParam("..seccode..",'LOTSIZE') - failed")
		testOK = "failed"
	end

-- futures.getShortName(seccode)     - наименование
	if futures.getShortName(seccode) == nil then
		log.Info("futures.getShortName("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getSellDepo(seccode)
	if futures.getSellDepo(seccode) == nil then
		log.Info("futures.getSellDepo("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getSellDepo(seccode)
	if futures.getBuyDepo(seccode) == nil then
		log.Info("futures.getBuyDepo("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getDaysLeft(seccode)
	if futures.getDaysLeft(seccode) == nil then
		log.Info("futures.getDaysLeft("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getMatDate(seccode)
	if futures.getMatDate(seccode) == nil then
		log.Info("futures.getMatDate("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getPriceStep(seccode)	- Шаг цены
	if futures.getPriceStep(seccode) ~= 1 then
		log.Info("futures.getPriceStep("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getLotSize(seccode)	- Размер лота
	if futures.getLotSize(seccode) ~= 100 then
		log.Info("futures.getLotSize("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getBIDPrice(seccode)		- лучшее предложение покупки в текущий момент
	if futures.getBIDPrice(seccode) == nil  then
		log.Info("futures.getBIDPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getOFFERPrice(seccode)  	- лучшее предложение продажи в текущий момент
	if futures.getOFFERPrice(seccode) == nil then
		log.Info("futures.getOFFERPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getBIDVolume(seccode)		- лучшее предложение покупки в текущий момент
	if futures.getBIDVolume(seccode) == nil  then
		log.Info("futures.getBIDvolume("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getOFFERVolume(seccode)  	- лучшее предложение продажи в текущий момент
	if futures.getOFFERVolume(seccode) == nil then
		log.Info("futures.getOFFERVolume("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getLastPrice(seccode)	- цена последней сделки
	if futures.getLastPrice(seccode) == nil then
		log.Info("futures.getLastPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getLastVolume(seccode)    - объем последней сделки
	if futures.getLastVolume(seccode) == nil then
		log.Info("futures.getLastVolume("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getQuotes(seccode)        - возвращаем массив (преобразованный - нумерация с середины стакана) с заявками из стакана цен
	if futures.getQuotes(seccode) == nil then
		log.Info("futures.getQuotes("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getQuotesBID(seccode)     - возвращаем массив (преобразованный - нумерация с середины стакана) с заявками на покупку из стакана цен
	if futures.getQuotesBID(seccode) == nil then
		log.Info("futures.getQuotesBID("..seccode..") - failed")
		testOK = "failed"
	end

-- futures.getQuotesOFFER(seccode)   - возвращаем массив с заявками на продажу из стакана цен
	if futures.getQuotesOFFER(seccode) == nil then
		log.Info("futures.getQuotesOFFER("..seccode..") - failed")
		testOK = "failed"
	end

	if testOK == "ok" then
		log.Info("futures module test "..testOK)
		testOK = testOK_tmp
	end


end

futures.test()

-------------------------------------------------------------------------------------------------------------------------------------------
--
-- option.lua - ���� ����� stock
-- (�)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--

function option.test()
	local testOK_tmp = testOK
	testOK = "ok"
	local seccode = "Si64000BC0"

	option.subscribe(seccode)


--	function option.getDelta(seccode)	 - ������� ��ࠬ��� �����
	if option.getDelta(seccode) == nil then
		log.Info("option.getDelta("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getGamma(seccode)        - ������� ��ࠬ��� �����
	if option.getGamma(seccode) == nil then
		log.Info("option.getGamma("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getTheta(seccode)        - ������� ��ࠬ��� ���
	if option.getTheta(seccode) == nil then
		log.Info("option.getTheta("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getVega(seccode)         - ������� ��ࠬ��� ����
	if option.getVega(seccode) == nil then
		log.Info("option.getVega("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getRho(seccode)          - ������� ��ࠬ��� ��
	if option.getRho(seccode) == nil then
		log.Info("option.getRho("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getStrike(seccode)       - ������� ��ࠩ� ��樮��
	if option.getStrike(seccode) == nil then
		log.Info("option.getStrike("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getVolatility(seccode)   - ������� ����⨫쭮���
	if option.getVolatility(seccode) == nil then
		log.Info("option.getVolatility("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getTheorPrice(seccode)   - ������� ⥮������ 業�
	if option.getTheorPrice(seccode) == nil then
		log.Info("option.getTheorPrice("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getBaseClassCode(seccode)         - ������� seccode �������� �����㬥��
	if option.getBaseClassCode(seccode) == nil then
		log.Info("option.getClassSecCode("..seccode..") - failed")
		testOK = "failed"
	end
--	function option.getBaseSecCode(seccode)         - ������� seccode �������� �����㬥��
	if option.getBaseSecCode(seccode) == nil then
		log.Info("option.getBaseSecCode("..seccode..") - failed")
		testOK = "failed"
	end


-- option.checkStatus(seccode)      - true - �᫨ ���� ��� ���室��
	if option.checkStatus(seccode) == nil then
		log.Info("option.checkStatus("..seccode..") - failed")
		testOK = "failed"
	end

-- option.isTrading(seccode)        - true - �࣮��� seccode ࠧ�襭�
	option.isTrading(seccode)

-- option.getParam(seccode,param)   - ������� ��ࠬ��� ��樨 (�ᯮ������ ��㣨�� �㭪�ﬨ �⮣� �����)
	if option.getParam(seccode,"LOTSIZE") ~= 1 then
		log.Info("option.getParam("..seccode..",'LOTSIZE') - failed")
		testOK = "failed"
	end

-- option.getShortName(seccode)     - ������������
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

-- option.getPriceStep(seccode)	- ��� 業�
	if option.getPriceStep(seccode) ~= 1 then
		log.Info("option.getPriceStep("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getLotSize(seccode)	- ������ ���
	if option.getLotSize(seccode) ~= 1 then
		log.Info("option.getLotSize("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getBIDPrice(seccode)		- ���襥 �।������� ���㯪� � ⥪�騩 ������
	if option.getBIDPrice(seccode) == nil  then
		log.Info("option.getBIDPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getOFFERPrice(seccode)  	- ���襥 �।������� �த��� � ⥪�騩 ������
	if option.getOFFERPrice(seccode) == nil then
		log.Info("option.getOFFERPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getBIDVolume(seccode)		- ���襥 �।������� ���㯪� � ⥪�騩 ������
	if option.getBIDVolume(seccode) == nil  then
		log.Info("option.getBIDvolume("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getOFFERVolume(seccode)  	- ���襥 �।������� �த��� � ⥪�騩 ������
	if option.getOFFERVolume(seccode) == nil then
		log.Info("option.getOFFERVolume("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getLastPrice(seccode)	- 業� ��᫥���� ᤥ���
	if option.getLastPrice(seccode) == nil then
		log.Info("option.getLastPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getLastVolume(seccode)    - ��ꥬ ��᫥���� ᤥ���
	if option.getLastVolume(seccode) == nil then
		log.Info("option.getLastVolume("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getQuotes(seccode)        - �����頥� ���ᨢ (�८�ࠧ������ - �㬥��� � �।��� �⠪���) � ����� �� �⠪��� 業
	if option.getQuotes(seccode) == nil then
		log.Info("option.getQuotes("..seccode..") - failed")
		testOK = "failed"
	end

-- option.getQuotesBID(seccode)     - �����頥� ���ᨢ (�८�ࠧ������ - �㬥��� � �।��� �⠪���) � ����� �� ���㯪� �� �⠪��� 業
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

-- option.getQuotesOFFER(seccode)   - �����頥� ���ᨢ � ����� �� �த��� �� �⠪��� 業
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

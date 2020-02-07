-------------------------------------------------------------------------------------------------------------------------------------------
--
-- bond.lua - ���� ����� bond
-- (�)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--
function bond.test()
	local testOK_tmp = testOK
	testOK = "ok"
	local seccode = "RU000A0ZYKH5"


-- bond.checkStatus(seccode)      - true - �᫨ �������� ��� ���室��
	if bond.checkStatus(seccode) == nil then
		log.Info("bond.checkStatus("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.isTrading(seccode)        - true - �࣮��� seccode ࠧ�襭�
	bond.isTrading(seccode)

-- bond.getParam(seccode,param)   - ������� ��ࠬ��� ������樨 (�ᯮ������ ��㣨�� �㭪�ﬨ �⮣� �����)
	if bond.getParam(seccode,"MAT_DATE") ~= '02.12.2027' then
		log.Info("bond.getParam("..seccode..",'MAT_DATE') - failed")
		testOK = "failed"
	end

-- bond.getShortName(seccode)     - ������������
	if bond.getShortName(seccode) == nil then
		log.Info("bond.getShortName("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getNominal(seccode)	- �������
	if bond.getNominal(seccode) ~= 1000 then
		log.Info("bond.getNominal("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.get�oupon(seccode)	- �㯮�
	if bond.getCoupon(seccode) ~= 20.39 then
		log.Info("bond.getCoupon("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getNKD(seccode)		- ���
	if bond.getNKD(seccode) == nil then
		log.Info("bond.getNKD("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getMatDate(seccode)	- ��� ����襭��
	if bond.getMatDate(seccode) ~= '02.12.2027' then
		log.Info("bond.getMatDate("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getDaysLeft(seccode)	- ���� �� ����襭��
	if bond.getDaysLeft(seccode) == nil then
		log.Info("bond.getDaysLeft("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getPriceStep(seccode)	- ��� 業�
	if bond.getPriceStep(seccode) ~= 0.01 then
		log.Info("bond.getPriceStep("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getLotSize(seccode)	- ������ ���
	if bond.getLotSize(seccode) ~= 1 then
		log.Info("bond.getLotSize("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getBIDPrice(seccode)		- ���襥 �।������� ���㯪� � ⥪�騩 ������
	if bond.getBIDPrice(seccode) == nil  then
		log.Info("bond.getBIDPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getOFFERPrice(seccode)  	- ���襥 �।������� �த��� � ⥪�騩 ������
	if bond.getOFFERPrice(seccode) == nil then
		log.Info("bond.getOFFERPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getBIDVolume(seccode)		- ���襥 �।������� ���㯪� � ⥪�騩 ������
	if bond.getBIDVolume(seccode) == nil  then
		log.Info("bond.getBIDvolume("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getOFFERVolume(seccode)  	- ���襥 �।������� �த��� � ⥪�騩 ������
	if bond.getOFFERVolume(seccode) == nil then
		log.Info("bond.getOFFERVolume("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getLastPrice(seccode)	- 業� ��᫥���� ᤥ���
	if bond.getLastPrice(seccode) == nil then
		log.Info("bond.getLastPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getLastVolume(seccode)    - ��ꥬ ��᫥���� ᤥ���
	if bond.getLastVolume(seccode) == nil then
		log.Info("bond.getLastVolume("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getInfo(seccode)          - �����頥� ���ᨢ � ���ଠ樥� �� ������樨 �������� � setClassCode() setSecCode()
	if bond.getInfo(seccode).NOMINAL ~= 1000  then
		log.Info("bond.getInfo("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getQuotes(seccode)        - �����頥� ���ᨢ (�८�ࠧ������ - �㬥��� � �।��� �⠪���) � ����� �� �⠪��� 業
	if bond.getQuotes(seccode) == nil then
		log.Info("bond.getQuotes("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getQuotesBID(seccode)     - �����頥� ���ᨢ (�८�ࠧ������ - �㬥��� � �।��� �⠪���) � ����� �� ���㯪� �� �⠪��� 業
	if bond.getBIDPrice(seccode) > 0 then
		local bids = bond.getQuotesBID(seccode)
		if  bids[1].price ~= bond.getBIDPrice(seccode) then
			log.Info("bond.getQuotesBID("..seccode..") price - failed")
			testOK = "failed"
		end
		if  bids[1].volume ~= bond.getBIDVolume(seccode) then
			log.Info("bond.getQuotesBID("..seccode..") volume - failed")
			testOK = "failed"
		end
	end

-- bond.getQuotesOFFER(seccode)   - �����頥� ���ᨢ � ����� �� �஦��� �� �⠪��� 業
	if bond.getOFFERPrice(seccode) > 0 then
		local offers = bond.getQuotesOFFER(seccode)
		if  offers[1].price ~= bond.getOFFERPrice(seccode) then
			log.Info("bond.getQuotesOFFER("..seccode..") price - failed")
			testOK = "failed"
		end
		if  offers[1].volume ~= bond.getOFFERVolume(seccode) then
			log.Info("bond.getQuotesOFFER("..seccode..") volume - failed")
			testOK = "failed"
		end
	end

-- bond.getIncomes(seccode)       - �����頥� ���ᨢ � ���ଠ樥� � �������� ��⮪� ������樨 (�������� �� ����� � csv 䠩�� 'dbPath.."\\"..csvfile')
	if bond.getIncomes(seccode) == nil  then
		log.Info("bond.getIncomes("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.getSecCodesList()
	if bond.getSecCodesList(seccode) == nil then
		log.Info("bond.getSecCodesList("..seccode..") - failed")
		testOK = "failed"
	end

-- bond.subscribeAll()
	if bond.subscribeAll() == nil then
		log.Info("bond.subscribeAll() - failed")
		testOK = "failed"
	end

-- bond.unsubscribeAll()
	if bond.unsubscribeAll() == nil then
		log.Info("bond.unsubscribe() - failed")
		testOK = "failed"
	end

	if testOK == "ok" then
		log.Info("bond module test "..testOK)
		testOK = testOK_tmp
	end


end
bond.test()

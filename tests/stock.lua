-------------------------------------------------------------------------------------------------------------------------------------------
--
-- stock.lua - ���� ����� stock
-- (�)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--

function stock.test()
	local testOK_tmp = testOK
	testOK = "ok"
	local seccode = "NLMK"

	stock.subscribe(seccode)

-- stock.checkStatus(seccode)      - true - �᫨ ���� ��� ���室��
	if stock.checkStatus(seccode) == nil then
		log.Info("stock.checkStatus("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.isTrading(seccode)        - true - �࣮��� seccode ࠧ�襭�
	stock.isTrading(seccode)

-- stock.getParam(seccode,param)   - ������� ��ࠬ��� ��樨 (�ᯮ������ ��㣨�� �㭪�ﬨ �⮣� �����)
	if stock.getParam(seccode,"LOTSIZE") ~= 10 then
		log.Info("stock.getParam("..seccode..",'LOTSIZE') - failed")
		testOK = "failed"
	end

-- stock.getShortName(seccode)     - ������������
	if stock.getShortName(seccode) == nil then
		log.Info("stock.getShortName("..seccode..") - failed")
		testOK = "failed"
	end


-- stock.getPriceStep(seccode)	- ��� 業�
	if stock.getPriceStep(seccode) ~= 0.02 then
		log.Info("stock.getPriceStep("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getLotSize(seccode)	- ������ ���
	if stock.getLotSize(seccode) ~= 10 then
		log.Info("stock.getLotSize("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getBIDPrice(seccode)		- ���襥 �।������� ���㯪� � ⥪�騩 ������
	if stock.getBIDPrice(seccode) == nil  then
		log.Info("stock.getBIDPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getOFFERPrice(seccode)  	- ���襥 �।������� �த��� � ⥪�騩 ������
	if stock.getOFFERPrice(seccode) == nil then
		log.Info("stock.getOFFERPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getBIDVolume(seccode)		- ���襥 �।������� ���㯪� � ⥪�騩 ������
	if stock.getBIDVolume(seccode) == nil  then
		log.Info("stock.getBIDvolume("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getOFFERVolume(seccode)  	- ���襥 �।������� �த��� � ⥪�騩 ������
	if stock.getOFFERVolume(seccode) == nil then
		log.Info("stock.getOFFERVolume("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getLastPrice(seccode)	- 業� ��᫥���� ᤥ���
	if stock.getLastPrice(seccode) == nil then
		log.Info("stock.getLastPrice("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getLastVolume(seccode)    - ��ꥬ ��᫥���� ᤥ���
	if stock.getLastVolume(seccode) == nil then
		log.Info("stock.getLastVolume("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getQuotes(seccode)        - �����頥� ���ᨢ (�८�ࠧ������ - �㬥��� � �।��� �⠪���) � ����� �� �⠪��� 業
	if stock.getQuotes(seccode) == nil then
		log.Info("stock.getQuotes("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getQuotesBID(seccode)     - �����頥� ���ᨢ (�८�ࠧ������ - �㬥��� � �।��� �⠪���) � ����� �� ���㯪� �� �⠪��� 業
	if stock.getQuotesBID(seccode) == nil then
		log.Info("stock.getQuotesBID("..seccode..") - failed")
		testOK = "failed"
	end

-- stock.getQuotesOFFER(seccode)   - �����頥� ���ᨢ � ����� �� �த��� �� �⠪��� 業
	if stock.getQuotesOFFER(seccode) == nil then
		log.Info("stock.getQuotesOFFER("..seccode..") - failed")
		testOK = "failed"
	end

--	function stock.getClosePrice(seccode)	     - ���� ��ਮ�� �������
	if stock.getClosePrice(seccode) == nil then
		log.Info("stock.getClosePrice("..seccode..") - failed")
		testOK = "failed"
	end

--	function stock.getLClosePrice(seccode)       - ��樠�쭠� 業� �������
	if stock.getLClosePrice(seccode) == nil then
		log.Info("stock.getClosePrice("..seccode..") - failed")
		testOK = "failed"
	end

--	function stock.getPrevLClosePrice(seccode)   - ��樠�쭠� 業� ������� �।��饣� ���
	if stock.getPrevLClosePrice(seccode) == nil then
		log.Info("stock.getPrevLClosePrice("..seccode..") - failed")
		testOK = "failed"
	end

--	function stock.getCloseAuctionPrice(seccode) - ���� ��樮��
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

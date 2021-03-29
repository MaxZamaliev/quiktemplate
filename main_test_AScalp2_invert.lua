-------------------------------------------------------------------------------------------------------------------------------------------
--
-- main.lua ������ ��������� "����������� ���������"
-- ��� �������������� ����������� ���������� ����������� ������, ��������/������ ������� ����� � ���������� �� �������/������� �� ����� �������� ����
-- v2 ������� �������� �������
-- (�)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--
version	 	 = "2.0 - invert"

Debug 		 = false

dofile(getScriptPath().."\\modules\\modules.lua")
dofile(getScriptPath().."\\include\\OnInit.lua")
dofile(getScriptPath().."\\include\\OnStop.lua")
dofile(getScriptPath().."\\include\\OnOrder.lua")
dofile(getScriptPath().."\\include\\OnTrade.lua")
dofile(getScriptPath().."\\include\\OnTransReply.lua")
dofile(getScriptPath().."\\include\\OnQuote.lua")
-------------------------------------------------------------------------------------------------------------------------------

futSecCode = "SiH0" -- Si-3.20
--futSecCode = "SiM0" -- Si-6.20
goodProfit    = 1  -- ������ ����������� ������� ��� ���������� ������� ��������� ������ � ������� �������
closeProfit   = 20 -- ����� ������� ����� �������� �� ����������� ����������/���������� ������
maxVolume     = 10 -- ������������ ����� �������
-------------------------------------------------------------------------------------------------------------------------------

opt = {}
profits = {}
ready = nil
busy = nil
tid = nil
pocket = {
		['operation'] = "",
		['price']     = 0,
		['volume']    = 0,
		['rComission'] = 0,
		['rProfit']   = 0
	   }

-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
function OnStop()
	-- ������������ �� ��������� ��������� � �����
	for matDate,optionsGroup in pairs(opt) do
		for strike,position in pairs(optionsGroup) do
			option.unsubscribe(position.call.seccode)
			option.unsubscribe(position.put.seccode)
		end
	end
        futures.unsubscribe(futSecCode)
	log.Info("pocket[] = "..mytable.tostring(pocket))
	return 1
end
-------------------------------------------------------------------------------------------------------------------------------
function main()
	log.Info("AScalp v"..version)
	opt = option.getActiveListByBase(futSecCode)
--	  log.Info(futSecCode..": opt[] = "..mytable.tostring(opt))

	-- ������������� �� ��������� ��������� � �����
	for matDate,optionsGroup in pairs(opt) do
		for strike,position in pairs(optionsGroup) do
			option.subscribe(position.call.seccode)
			option.subscribe(position.put.seccode)
			log.Info(position.put.seccode.." : "..position.call.seccode)
		end
	end

        futures.subscribe(futSecCode)
	sleep(2000)


	checkAll()
        createTable()
	fillTable()
	ready = true
	while true do
		sleep(1000)
		if IsWindowClosed(tid) then
			break
		end
		updateTable()
	end
end                               
-------------------------------------------------------------------------------------------------------------------------------
function OnQuote(qClassCode,qSecCode)
	if ready == nil then
		return
	end
	if busy then
		return
	end
	busy = true
	if qClassCode == "SPBFUT" and qSecCode == futSecCode then
		checkPocket()
		checkAll()
		busy = nil
		return
	end
	if qClassCode == "SPBOPT" then
		for matDate,optionsGroup in pairs(opt) do
			for strike,position in pairs(optionsGroup) do
				if qSecCode == position.call.seccode or qSecCode == position.put.seccode then
					check(position.call.seccode,position.put.seccode)
					busy = nil
					return
				end
			end
		end
	end
	busy = nil
end
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
function countProfits(callSecCode,putSecCode)
	log.Debug("+++ countProfits("..callSecCode..","..putSecCode..")")
	local strike     = option.getStrike(callSecCode)
	if strike == nil or strike ~= option.getStrike(putSecCode) then
		log.Debug("--- countProfits("..callSecCode..","..putSecCode..") = nil,nil : can't get Strike")
		return nil,nil
	end
	local callQuotes = option.getQuotes(callSecCode)
	local putQuotes  = option.getQuotes(putSecCode)
	local futQuotes  = futures.getQuotes(futSecCode)
	if callQuotes == nil or putQuotes == nil or futQuotes == nil then
		log.Debug("--- countProfits("..callSecCode..","..putSecCode..") = nil,nil : can't get Quotes")
		return nil,nil
	end
	if profits[strike] == nil then
		profits[strike] = {}
		profits[strike].long = {}
		profits[strike].short = {}
	else
		profits[strike].long.cur  = nil
		profits[strike].short.cur = nil
	end

	-- -Call +Put +Fut -strike = 0
	if callQuotes.bid ~= nil and putQuotes.offer ~= nil and futQuotes.offer ~= nil then
		profits[strike].long.cur = callQuotes.bid[1].price -putQuotes.offer[1].price -futQuotes.offer[1].price +strike
		if profits[strike].long.max == nil or profits[strike].long.max < profits[strike].long.cur then
			profits[strike].long.max = profits[strike].long.cur
		end
		if profits[strike].long.min == nil or profits[strike].long.min > profits[strike].long.cur then
			profits[strike].long.min = profits[strike].long.cur
		end
		if profits[strike].long.cur > 0 then
			log.Info("LONG: -strike=+"..strike.."; -callBid=+"..callQuotes.bid[1].price.."; +putOffer=-"..putQuotes.offer[1].price.."; +futOffer=-"..futQuotes.offer[1].price.."; profit="..profits[strike].long.cur.." ( "..profits[strike].long.min.."/"..profits[strike].long.max.." )")
		end
	else
		if callQuotes.bid == nil then
			log.Debug("countProfits("..callSecCode..","..putSecCode.."): callQuotes.bid = nil")
		end
		if putQuotes.offer == nil then
			log.Debug("countProfits("..callSecCode..","..putSecCode.."): putQuotes.offer = nil")
		end
		if futQuotes.offer == nil then
			log.Debug("countProfits("..callSecCode..","..putSecCode.."): futQuotes.offer = nil")
		end
	end

	--  +Call -Put -Fut +strike = 0
	if callQuotes.offer ~= nil and putQuotes.bid ~= nil and futQuotes.bid ~= nil then
		profits[strike].short.cur = -callQuotes.offer[1].price +putQuotes.bid[1].price +futQuotes.bid[1].price -strike 
		if profits[strike].short.max == nil or profits[strike].short.max < profits[strike].short.cur then
			profits[strike].short.max = profits[strike].short.cur
		end
		if profits[strike].short.min == nil or profits[strike].short.min > profits[strike].short.cur then
			profits[strike].short.min = profits[strike].short.cur
		end
		if profits[strike].short.cur > 0 then
			log.Info("SHORT: +strike=-"..strike.."; +callOffer=-"..callQuotes.offer[1].price.."; -putBid=+"..putQuotes.bid[1].price.."; -futBid=+"..futQuotes.bid[1].price.."; profit="..profits[strike].short.cur.." ( "..profits[strike].short.min.."/"..profits[strike].short.max.." )")
		end
	else
		if callQuotes.offer == nil then
			log.Debug("countProfits("..callSecCode..","..putSecCode.."): callQuotes.offer = nil")
		end
		if putQuotes.bid == nil then
			log.Debug("countProfits("..callSecCode..","..putSecCode.."): putQuotes.bid = nil")
		end
		if futQuotes.bid == nil then
			log.Debug("countProfits("..callSecCode..","..putSecCode.."): futQuotes.bid = nil")
		end
	end

	log.Debug("--- countProfits("..callSecCode..","..putSecCode..") = "..tostring(profits[strike].long.cur)..","..tostring(profits[strike].short.cur))
	return profits[strike].long.cur,profits[strike].short.cur
end
-------------------------------------------------------------------------------------------------------------------------------
function check(callSecCode,putSecCode)
	if pocket.operation ~= '' then
		return
	end
	longProfit,shortProfit = countProfits(callSecCode,putSecCode)
	if longProfit ~= nil and longProfit >= goodProfit then
		sell()
	end
	if shortProfit ~= nil and shortProfit >= goodProfit then
		buy()
	end
end
-------------------------------------------------------------------------------------------------------------------------------
function checkAll()
	if pocket.operation ~= '' then
		return
	end
	for matDate,optionsGroup in pairs(opt) do
		for strike,position in pairs(optionsGroup) do
			check(position.call.seccode,position.put.seccode)
		end
	end
end
-------------------------------------------------------------------------------------------------------------------------------
function checkPocket()
	if pocket.operation == '' then
		return
	end
	-- ���� ���� �������� �������, �� �������� ������� ���� � ��������� ������� ���� ��������� closeProfit
	local futQuotes  = futures.getQuotes(futSecCode)
	if futQuotes == nil then
		log.Debug("checkPocket(): can't get Quotes")
		return nil
	end
	if pocket.operation == 'long' and futQuotes.bid ~= nil then
		if ((futQuotes.bid[1].price) >= (pocket.price + closeProfit) ) then
			closeLong()
		end
	elseif pocket.operation == 'short' and futQuotes.offer ~= nil then
		if ((futQuotes.offer[1].price) <= (pocket.price - closeProfit) ) then
			closeShort()
		end
	end
end
-------------------------------------------------------------------------------------------------------------------------------
function closeLong()
	local futQuotes  = futures.getQuotes(futSecCode)
	if futQuotes == nil or futQuotes.bid == nil then
		log.Debug("closeLong(): can't get Quotes")
		return nil
	end
	local futPrice  = futQuotes.bid[1].price
	local futVolume = futQuotes.bid[1].volume
	if futVolume < pocket.volume then
	-- ���� ������������� ������ ������������ ����� ��������� ������� ���� �������
		local orderVolume = futVolume
		log.Info("closeLong() ��������� ����� long-�������: pocket.price = "..pocket.price.."; sell.price="..futPrice.."; volume="..pocket.volume.." - "..orderVolume.." = "..tostring(pocket.volume-orderVolume))
		-- �.�. ������ �� ��� � ��� ����, �� ��������� ������
		pocket.rProfit    = pocket.rProfit + ( (futPrice - pocket.price) * orderVolume )
		pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
		pocket.volume     = pocket.volume - orderVolume
		-- pocket.price     �� ����������
		-- pocket.operation �� ����������
		log.Info("closeLong() pocket[] = "..mytable.tostring(pocket))
		return
	else
	-- ���� ������������� ������ ���������� ������ ����� ������� �������
		local orderVolume = pocket.volume
		log.Info("closeLong() ��������� long-�������: pocket.price="..pocket.price.."; sellPrice = "..futPrice..";  volume="..pocket.volume.." - "..orderVolume.." = "..tostring(pocket.volume-orderVolume))
		-- �.�. ������ �� ��� � ��� ����, �� ��������� ������
		pocket.rProfit    = pocket.rProfit + ( (futPrice - pocket.price) * orderVolume )
		pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
		pocket.volume     = 0 
		pocket.price      = 0
		pocket.operation  = ''
		log.Info("closeLong() pocket[] = "..mytable.tostring(pocket))
		return
	end
end
-------------------------------------------------------------------------------------------------------------------------------
function closeShort()
	local futQuotes  = futures.getQuotes(futSecCode)
	if futQuotes == nil or futQuotes.offer == nil then
		log.Debug("closeShort(): can't get Quotes")
		return nil
	end
	local futPrice  = futQuotes.offer[1].price
	local futVolume = futQuotes.offer[1].volume
	if futVolume < pocket.volume then
	-- ���� ������������� ������ ������������ ����� ��������� ������� ���� �������
		local orderVolume = futVolume
		log.Info("closeShort() ��������� ����� short-�������: pocket.price = "..pocket.price.."; buyPrice="..futPrice.."; volume="..pocket.volume.." - "..orderVolume.." = "..tostring(pocket.volume-orderVolume))
		-- �.�. ������ �� ��� � ��� ����, �� ��������� ������
		pocket.rProfit    = pocket.rProfit + ( (pocket.price - futPrice) * orderVolume )
		pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
		pocket.volume     = pocket.volume - orderVolume
		-- pocket.price     �� ����������
		-- pocket.operation �� ����������
		log.Info("closeShort() pocket[] = "..mytable.tostring(pocket))
		return
	else
	-- ���� ������������� ������ ���������� ������ ����� ������� �������
		local orderVolume = pocket.volume
		log.Info("closeShort() ��������� short-�������: pocket.price="..pocket.price.."; buyPrice = "..futPrice..";  volume="..pocket.volume.." - "..orderVolume.." = "..tostring(pocket.volume-orderVolume))
		-- �.�. ������ �� ��� � ��� ����, �� ��������� ������
		pocket.rProfit    = pocket.rProfit + ( (pocket.price - futPrice) * orderVolume )
		pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
		pocket.volume     = 0 
		pocket.price      = 0
		pocket.operation  = ''
		log.Info("closeShort() pocket[] = "..mytable.tostring(pocket))
		return
	end
end
-------------------------------------------------------------------------------------------------------------------------------
function buy()
	local futQuotes  = futures.getQuotes(futSecCode)
	if futQuotes == nil then
		log.Error("buy() �� ������� �������� ������")
		return nil
	end
	local futPrice  = futQuotes.offer[1].price
	local futVolume = futQuotes.offer[1].volume
	if futPrice == nil or futVolume == nil then
		log.Error("buy() �� ������� �������� ���� ��� ����� �����������")
		return nil
	end
--	log.Info("buy() current pocket[] = "..mytable.tostring(pocket))
	local orderVolume = 0
	if pocket.operation == '' then
	-- ���� ��� �������� �������
		if futVolume >= maxVolume then
			orderVolume = maxVolume
		elseif futVolume < maxVolume then
			orderVolume = futVolume
		end
		pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
		pocket.volume     = orderVolume
		pocket.price      = futPrice
		pocket.operation  = 'long'
		log.Info("buy() ��������� long-������� price="..pocket.price.."; volume="..pocket.volume)
		log.Info("buy() pocket[] = "..mytable.tostring(pocket))
		return
	end
	if pocket.operation == 'short' or pocket.operation == '' then
	-- ���� � ��� ���� �������� �������, ���� ��� ������ �� �������
		if futVolume < pocket.volume then
		-- ���� ������������� ������ ������������ ����� ��������� ������� ���� �������
			orderVolume = futVolume
			log.Info("buy() ��������� ����� short-�������: pocket.price = "..pocket.price.."; buyPrice = "..futPrice.."; volume= "..pocket.volume.." - "..orderVolume.." = "..tostring(pocket.volume-orderVolume))
			-- �.�. ������ �� ��� � ��� ����, �� ��������� ������
			pocket.rProfit    = pocket.rProfit + ( (pocket.price - futPrice) * orderVolume )
			pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
			pocket.volume     = pocket.volume - orderVolume
			-- pocket.price     �� ����������
			-- pocket.operation �� ����������
			log.Info("buy() pocket[] = "..mytable.tostring(pocket))
			return
		elseif futVolume == pocket.volume then
		-- ���� ������������� ������ ���������� ������ ����� ������� �������
			orderVolume = futVolume
			log.Info("buy() ��������� short-�������: pocket.price="..pocket.price.."; buyPrice = "..futPrice..";  volume="..pocket.volume.." - "..orderVolume.." = "..tostring(pocket.volume-orderVolume))
			-- �.�. ������ �� ��� � ��� ����, �� ��������� ������
			pocket.rProfit    = pocket.rProfit + ( (pocket.price - futPrice) * orderVolume )
			pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
			pocket.volume     = 0 
			pocket.price      = 0
			pocket.operation  = ''
			log.Info("buy() pocket[] = "..mytable.tostring(pocket))
			return
		elseif ( futVolume >= (pocket.volume + maxVolume) ) then
		-- ���� ����� � ����������� ������ ��� ��� �����
			orderVolume = pocket.volume + maxVolume
			log.Info("buy() ��������� short-������� � �������� �� maxVolume: pocket.price = "..pocket.price.."; shortVolume = "..pocket.volume.."; orderVolume = "..orderVolume.."; longVolume = "..maxVolume)
			-- �.�. ������ �� ��� � ��� ����, �� ��������� ������
			pocket.rProfit    = pocket.rProfit + ( (pocket.price - futPrice) * ( orderVolume - maxVolume ) )
			pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
			pocket.volume     = maxVolume
			pocket.price      = futPrice
			pocket.operation  = 'long'
			log.Info("buy() pocket[] = "..mytable.tostring(pocket))
			return
		else
		-- ���� ������������� ������ ���������� ����� ������� ���� ������� � �������� ���. �� �� �� maxVolume, �� �������� ���� ������������ �����
			orderVolume = futVolume
			log.Info("buy() ��������� short-������� � �������� ���: shortVolume = "..pocket.volume.."; orderVolume = "..orderVolume.."; longVolume = "..tostring(orderVolume - pocket.volume))
			-- �.�. ������ �� ��� � ��� ����, �� ��������� ������
			pocket.rProfit    = pocket.rProfit + ( (pocket.price - futPrice) * orderVolume )
			pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
			pocket.volume     = orderVolume - pocket.volume
			pocket.price      = futPrice
			pocket.operation  = 'long'
			log.Info("buy() pocket[] = "..mytable.tostring(pocket))
			return
		end
	elseif ( (pocket.operation == 'long') and (pocket.volume < maxVolume) ) then
	-- ���� � ��� ��� ���� ������� �������, �� ����� �������� �� maxVolume
		if ( futVolume >= (maxVolume - pocket.volume) ) then
		-- ���� ����� � ����������� ������ ��� ��� �����
			orderVolume = maxVolume - pocket.volume
			log.Info("buy() ��� ���� ������� �������, �������� �� maxVolume: "..pocket.volume.." + "..orderVolume.." = "..tostring(pocket.volume+orderVolume))
		else
		-- �������� ���� ������������ �����
			orderVolume = futVolume
			log.Info("buy() ��� ���� ������� �������, �������� ���� ������������ �����: "..pocket.volume.." + "..orderVolume.." = "..tostring(pocket.volume+orderVolume))
		end
		-- pocket.rProfit �� ����������
		pocket.rComission = pocket.rComission + (0.6 + math.ceil(futPrice*0.0015)/100) * orderVolume
		pocket.volume = pocket.volume + orderVolume
		-- ��������� ������� ���� ����� ��� ��� ��� ���� ������� � ���, ��� ���������� ��������
		pocket.price = ( ( pocket.price * pocket.volume ) + ( futPrice * orderVolume ) ) / (pocket.volume + orderVolume )
		-- pocket.operation �� ����������
		log.Info("buy() pocket[] = "..mytable.tostring(pocket))
		return
	else
		-- ���� � ��� ��� ������� �� ���������, �� �������
--		log.Info("buy() ��� ������� maxVolume ("..pocket.volume.."), ���������� �����������")
--		log.Info("buy() pocket[] = "..mytable.tostring(pocket))
		return nil
	end
	return nil
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function sell()
	local futQuotes  = futures.getQuotes(futSecCode)
	if futQuotes == nil then
		log.Error("sell() �� ������� �������� ������")
		return nil
	end
	local futPrice  = futQuotes.bid[1].price
	local futVolume = futQuotes.bid[1].volume
	if futPrice == nil or futVolume == nil then
		log.Error("sell() �� ������� �������� ���� ��� ����� �����������")
		return nil
	end
--	log.Info("sell() current pocket[] = "..mytable.tostring(pocket))
	local orderVolume = 0
	if pocket.operation == '' then
	-- ���� ��� �������� �������
		if futVolume >= maxVolume then
			orderVolume = maxVolume
		elseif futVolume < maxVolume then
			orderVolume = futVolume
		end
		pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
		pocket.volume     = orderVolume
		pocket.price      = futPrice
		pocket.operation  = 'short'
		log.Info("sell() ��������� short-�������: price="..pocket.price.."; volume="..pocket.volume)
		log.Info("sell() pocket[] = "..mytable.tostring(pocket))
		return
	end
	if pocket.operation == 'long' then
	-- ���� � ��� ���� ������� �������
		if futVolume < pocket.volume then
		-- ���� ������������� ������ ������������ ����� ��������� ������� ���� �������
			orderVolume = futVolume
			log.Info("sell() ��������� ����� long-�������: pocket.price = "..pocket.price.."; sell.price="..futPrice.."; volume="..pocket.volume.." - "..orderVolume.." = "..tostring(pocket.volume-orderVolume))
			-- �.�. ������ �� ��� � ��� ����, �� ��������� ������
			pocket.rProfit    = pocket.rProfit + ( (futPrice - pocket.price) * orderVolume )
			pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
			pocket.volume     = pocket.volume - orderVolume
			-- pocket.price     �� ����������
			-- pocket.operation �� ����������
			log.Info("sell() pocket[] = "..mytable.tostring(pocket))
			return
		elseif futVolume == pocket.volume then
		-- ���� ������������� ������ ���������� ������ ����� ������� �������
			orderVolume = futVolume
			log.Info("sell() ��������� long-�������:: pocket.price = "..pocket.price.."; sell.price="..futPrice.."; volume="..pocket.volume.." - "..orderVolume.." = "..tostring(pocket.volume-orderVolume))
			-- �.�. ������ �� ��� � ��� ����, �� ��������� ������
			pocket.rProfit    = pocket.rProfit + ( (futPrice - pocket.price) * orderVolume )
			pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
			pocket.volume     = 0 
			pocket.price      = 0
			pocket.operation  = ''
			log.Info("sell() pocket[] = "..mytable.tostring(pocket))
			return
		elseif ( futVolume >= (pocket.volume + maxVolume) ) then
		-- ���� ����� � ����������� ������ ��� ��� �����
			orderVolume = pocket.volume + maxVolume
			log.Info("sell() ��������� long-������� � �������� �� maxVolume: pocket.price = "..pocket.price.."; pocket.volume = "..pocket.volume.."; sellPrice="..futPrice.."; sellVolume = "..orderVolume.."; resultVolume = "..maxVolume)
			-- �.�. ������ �� ��� � ��� ����, �� ��������� ������
			pocket.rProfit    = pocket.rProfit + ( (futPrice - pocket.price) * ( orderVolume - maxVolume ) )
			pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
			pocket.volume     = maxVolume
			pocket.price      = futPrice
			pocket.operation  = 'short'
			log.Info("sell() pocket[] = "..mytable.tostring(pocket))
			return
		else
		-- ���� ������������� ������ ���������� ����� ������� ���� ������� � �������� ���. �� �� �� maxVolume, �� �������� ���� ������������ �����
			orderVolume = futVolume
			log.Info("sell() ��������� long-������� � �������� ���: pocket.price="..pocket.price.."; pocket.volume = "..pocket.volume.."; sellPrice="..futPrice.."; sellVolume = "..orderVolume.."; resultVolume = "..tostring(orderVolume - pocket.volume))
			-- �.�. ������ �� ��� � ��� ����, �� ��������� ������
			pocket.rProfit    = pocket.rProfit + ( (futPrice - pocket.price) * orderVolume )
			pocket.rComission = pocket.rComission + (0.6 + math.ceil(pocket.price*0.0015)/100) * orderVolume
			pocket.volume     = orderVolume - pocket.volume
			pocket.price      = futPrice
			pocket.operation  = 'short'
			log.Info("sell() pocket[] = "..mytable.tostring(pocket))
			return
		end
	elseif ( (pocket.operation == 'short') and (pocket.volume < maxVolume) ) then
	-- ���� � ��� ��� ���� short �������, �� ����� �������� �� maxVolume
		if ( futVolume >= (maxVolume - pocket.volume) ) then
		-- ���� ����� � ����������� ������ ��� ��� �����
			orderVolume = maxVolume - pocket.volume
			log.Info("sell() ��� ���� short-�������, �������� �� maxVolume: price="..futPrice.."; volume="..pocket.volume.." + "..orderVolume.." = "..tostring(pocket.volume+orderVolume))
		else
		-- �������� ���� ������������ �����
			orderVolume = futVolume
			log.Info("sell() ��� ���� short-�������, �������� ���� ������������ �����: price="..futPrice.."; volume="..pocket.volume.." + "..orderVolume.." = "..tostring(pocket.volume+orderVolume))
		end
		-- pocket.rProfit �� ����������
		pocket.rComission = pocket.rComission + (0.6 + math.ceil(futPrice*0.0015)/100) * orderVolume
		pocket.volume = pocket.volume + orderVolume
		-- ��������� ������� ���� ����� ��� ��� ��� ���� ������� � ���, ��� ���������� ��������
		pocket.price = ( ( pocket.price * pocket.volume ) + ( futPrice * orderVolume ) ) / (pocket.volume + orderVolume )
		-- pocket.operation �� ����������
		log.Info("sell() pocket[] = "..mytable.tostring(pocket))
		return
	else
		-- ���� � ��� ��� ������� �� ���������, �� �������
--		log.Info("sell() ��� ������� maxVolume ("..pocket.volume.."), ���������� �����������")
--		log.Info("sell() pocket[] = "..mytable.tostring(pocket))
		return nil
	end
	return nil
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function createTable()
	tid=AllocTable()
	AddColumn(tid,1,"strike",true,QTABLE_DATE_TYPE,10)
	AddColumn(tid,2,"direction",true,QTABLE_STRING_TYPE,4)
	AddColumn(tid,3,"profit",true,QTABLE_DOUBLE_TYPE,15)
	AddColumn(tid,4,"min",true,QTABLE_DOUBLE_TYPE,15)
	AddColumn(tid,5,"max",true,QTABLE_DOUBLE_TYPE,15)
	CreateWindow(tid)
	local today = os.date("%d.%m.%Y %H:%M:%S")
	SetWindowCaption(tid,"�������� month"..today)
	return tid
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function fillTable()
	for strike,position in pairs(profits) do
		if profits[strike].short ~= nil then
			row=InsertRow(tid,-1)
			SetCell(tid,row,1,tostring(strike),strike)
			SetCell(tid,row,2,"short")
			SetCell(tid,row,3,tostring(profits[strike].short.cur),profits[strike].short.cur)
			SetCell(tid,row,4,tostring(profits[strike].short.max),profits[strike].short.min)
			SetCell(tid,row,5,tostring(profits[strike].short.min),profits[strike].short.max)
		end
		if profits[strike].long ~= nil then
			row=InsertRow(tid,-1)
			SetCell(tid,row,1,tostring(strike),strike)
			SetCell(tid,row,2,"long")
			SetCell(tid,row,3,tostring(profits[strike].long.cur),profits[strike].long.cur)
			SetCell(tid,row,4,tostring(profits[strike].long.max),profits[strike].long.min)
			SetCell(tid,row,5,tostring(profits[strike].long.min),profits[strike].long.max)
		end
	end
end
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function updateTable()
	local rows,cols = GetTableSize(tid)
	for row = 1, rows do
		local strike = tonumber(GetCell(tid,row,1).value)
		local t      = GetCell(tid,row,2).image
		local cur    = tonumber(GetCell(tid,row,3).value)
		local min    = tonumber(GetCell(tid,row,4).value)
		local max    = tonumber(GetCell(tid,row,5).value)
		local nCur,nMax,nMin = nil
		if t == "short" then
			nCur = profits[strike].short.cur
			nMin = profits[strike].short.min
			nMax = profits[strike].short.max
		else
			nCur = profits[strike].long.cur
			nMin = profits[strike].long.min
			nMax = profits[strike].long.max
		end

		if cur ~= nCur then
			SetCell(tid,row,3,tostring(nCur),nCur)
		end
		if min ~= nMin then
			SetCell(tid,row,4,tostring(nMin),nMin)
		end
		if max ~= nMax then
--log.Error("strike="..strike.."; profits[]="..mytable.tostring(profits[strike]))
--log.Error(strike.." : "..max.." : "..nMax)
			SetCell(tid,row,5,tostring(nMax),nMax)
		end
	end
end
-------------------------------------------------------------------------------------------------------------------------------
function f_cb(tid,msg,par1,par2)
	if msg == QTABLE_LBUTTONDOWN then
		log.Error(mytable.tostring(profits))
	end	
end
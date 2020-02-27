-------------------------------------------------------------------------------------------------------------------------------------------
--
-- stock.lua - ������ QUIK_LUA ��� ��������� �������� ���������� �� ������
-- (�)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--
--[[
	function stock.subscribe(seccode)	     - ����������� �� ��������� �������� ����������
	function stock.checkStatus(seccode)	     - true - ���� ����� ��� ��������
	function stock.isTrading(seccode)	     - true - ���� ����� ���������
	function stock.getParam(seccode,param)       - �������� �������� ����� (������������ ������� ��������� ������� ������)
	function stock.getShortName(seccode)         - ������� �������� �����
	function stock.getPriceStep(seccode)	     - �������� ��� ����
	function stock.getLotSize(seccode)	     - �������� ������ ����
	function stock.getBIDPrice(seccode)	     - �������� ������ ���� ������
	function stock.getOFFERPrice(seccode)	     - �������� ����� ���� �����������
	function stock.getBIDVolume(seccode)	     - �������� ��������� ��� ������� ����� �� ������ ���� ������
	function stock.getOFFERVolume(seccode)       - �������� ��������� ��� ������� ����� �� ������ ���� �����������
	function stock.getLastPrice(seccode)	     - �������� ���� ��������� ������
	function stock.getLastVolume(seccode)	     - �������� ����� ��������� ������
	function stock.getClosePrice(seccode)	     - ���� ������� ��������
	function stock.getLClosePrice(seccode)       - ����������� ���� ��������
	function stock.getPrevLClosePrice(seccode)   - ����������� ���� �������� ����������� ���
	function stock.getAuctPrice(seccode)         - ���� ��������
	function stock.getQuotes(seccode)	     - �������� ������ ���
	function stock.getQuotesBID(seccode)	     - �������� ����� �� ������� ���
	function stock.getQuotesOFFER(seccode)	     - �������� ����������� �� ������� ���
	function isAuctionTime()		     - true - ���� ������ ����� ���������� ��������
	function isAuctionFinished()		     - true - ���� ������� ��������
]]

local stock = {}
	local classcode = "TQBR"
	bond2 = require "bond"


---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.subscribe(seccode)
		local res = Subscribe_Level_II_Quotes(classcode,seccode)
		log.Debug("stock.subscribe("..seccode..") = "..tostring(res))
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.checkStatus(seccode)
		if getParamEx(classcode,seccode,"STATUS").param_image == "" then
			log.Error("stock.checkStatus("..seccode.."): ����� �� �������")
			return nil
		end

		if getParamEx(classcode,seccode,"STATUS").param_image ~= "���������" then
			log.Error("stock.checkStatus("..seccode.."): ����� �� ���������")
			return nil
		end

		if getParamEx(classcode,seccode,"SEC_FACE_UNIT").param_image ~= "SUR" then
			log.Error("stock.checkStatus("..seccode.."): ������ ����� �� �����")
			return nil
		end
		log.Debug("stock.checkStatus("..seccode..") = true")
		return true
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.isTrading(seccode)
		if stock.checkStatus then
			if stock.getParam(seccode,"TRADINGSTATUS") == "�������" then
				log.Debug("bonds.isTrading("..seccode..") = true")
				return true
			end
		end
		log.Debug("stock.isTrading("..seccode..") = nil")
		return nil
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getParam(seccode,param)
		if stock.checkStatus(seccode) then
			local val
			local res = getParamEx(classcode,seccode,param)
			if res.param_type == "1" then
				val = tonumber(res.param_value)
				log.Debug("stock.getParam("..seccode..","..param..") = "..val)
			elseif res.param_type == "2" then
				val = tonumber(res.param_value)
				log.Debug("stock.getParam("..seccode..","..param..") = "..val)
			else
				val = res.param_image
				log.Debug("stock.getParam("..seccode..","..param..") = \""..val.."\"")
			end
			return val
		else
			log.Debug("stock.getParam("..seccode..","..param..") = nil : stock.checkStatus() == nil")
			return nil
		end
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getShortName(seccode)
		local val = stock.getParam(seccode,"SHORTNAME")
		log.Debug("stock.getShortName("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getPriceStep(seccode)
		local val = stock.getParam(seccode,"SEC_PRICE_STEP")
		log.Debug("stock.getPriceStep("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getLotSize(seccode)
		local val = stock.getParam(seccode,"LOTSIZE")
		log.Debug("stock.getLotSize("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getBIDPrice(seccode)
		local val = stock.getParam(seccode,"BID")
		log.Debug("stock.getBIDPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getOFFERPrice(seccode)
		local val = stock.getParam(seccode,"OFFER")
		log.Debug("stock.getOFFERPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getBIDVolume(seccode)
		local val = stock.getParam(seccode,"BIDDEPTH")
		log.Debug("stock.getBIDVolume("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getOFFERVolume(seccode)
		local val = stock.getParam(seccode,"OFFERDEPTH")
		log.Debug("stock.getOFFERVolume("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getLastPrice(seccode)
		local val = stock.getParam(seccode,"LAST")
		log.Debug("stock.getLastPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getLastVolume(seccode)
		local val = stock.getParam(seccode,"QTY")
		log.Debug("stock.getLastVolume("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getClosePrice(seccode)
		local val = stock.getParam(seccode,"CLOSEPRICE")
		log.Debug("stock.getClosePrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getLClosePrice(seccode)
		local val = stock.getParam(seccode,"LCLOSEPRICE")
		log.Debug("stock.getLClosePrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getPrevLClosePrice(seccode)
		local val = stock.getParam(seccode,"PREVLEGALCLOSEPR")
		log.Debug("stock.getLClosePrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getAuctPrice(seccode)
		local val = stock.getParam(seccode,"AUCTPRICE")
		log.Debug("stock.getCloseAuctionPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function stock.getQuotes(seccode)
		log.Debug("+++ stock.getQuotes("..seccode..")")
		if stock.isTrading == nil then
			log.Error("--- stock.getQuotes("..seccode..") = nil : ��������� �� ���������")
			return nil
		end
		local quotes = getQuoteLevel2Ex(classcode,seccode)
--log.Debug("stock.getQuotes(): Quote = "..mytable.tostring(quotes))
		if  quotes == nil then
			log.Error("--- stock.getQuotes("..seccode..") = nil : �� ������� �������� ������")
			return nil
		end
		--[[ quotes = {
				['bid_count'] = number,
				['offer_count'] = number,
				['bid'] = {
					[1] = {    			// ����� ����� ������� ���� ������ ������� - ��� ����� ��� �������
						['price'] = number,
						['quantity'] = number
					},
					[2] = {...},
					[3] = {...},
					[bid_count] = {...} 		// ����� ����� ������� ���� ������ ������� - ��� �������� �������
				},
				['offer'] = {
					[1] = {    			// ����� ����� ������� ���� ����������� ������� - ��� �������� �������
						['price'] = number,
						['quantity'] = number
					},
					[2] = {...},
					[3] = {...},
					[last] = {...} 			// ����� ����� ������� ���� ����������� ������� - ��� ����� ���� �������
				}
		   }
		]]
		-- �������������� ������� bid, ����� ������ ��������� � �������� ������� ��� � � ������� offer
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

		log.Debug("--- stock.getQuotes("..seccode..") = "..mytable.tostring(newQuotes))
		return newQuotes
	end
-----------------------------------------------------------------------------------------------------------------
	function stock.getQuotesBID(seccode)
		log.Debug("+++ stock.getQuotesBID("..seccode..")")
		local quotes = stock.getQuotes(seccode)
		if quotes == nil then
			log.Debug("--- stock.getQuotesBID("..seccode..") = nil")
			return nil
		end
		if quotes.bid == nil then
			log.Debug("--- stock.getQuotesBID("..seccode..") = nil")
			return nil
		end
		log.Debug("--- stock.getQuotesBID("..seccode..") = [array]")
		return quotes.bid
	end
-----------------------------------------------------------------------------------------------------------------
	function stock.getQuotesOFFER(seccode)
		log.Debug("+++ stock.getQuotesOFFER("..seccode..")")
		local quotes = stock.getQuotes(seccode)
		if quotes == nil then
			log.Debug("--- stock.getQuotesOFFER("..seccode..") = nil")
			return nil
		end
		if quotes.offer == nil then
			log.Debug("--- stock.getQuotesOFFER("..seccode..") = nil")
			return nil
		end
		log.Debug("--- stock.getQuotesOFFER("..seccode..") = [array]")
		return quotes.offer
	end
-----------------------------------------------------------------------------------------------------------------
	function stock.isAuctionTime()
		if isConnected() == 0 then
			log.Debug("stock.isAuctionTime() = nil")
			return nil
		end

		local dt = os.date("*t")
		-- ���� ������� ��� �����������
		if dt["wday"] == 1 or dt["wday"] == 7 then
			log.Debug("stock.isAuctionTime() = nil")
			return nil
		end

		if ( (dt["hour"] == 18) and (dt["min"] >= 40) and (dt["min"] <= 50) ) then
			log.Debug("stock.isAuctionTime() = true")
			return true
		end
		log.Debug("stock.isAuctionTime() = nil")
		return nil
	end
-----------------------------------------------------------------------------------------------------------------
	function stock.isAuctionFinished()
		local quotes = getQuotes()
		if quotes['bid_count'] > 1 or quotes['offer_count'] > 1 then
			log.Debug("stock.isAuctionFinished() = nil")
			return nil
		end
		log.Debug("stock.isAuctionFinished() = true")
		return true
	end
-----------------------------------------------------------------------------------------------------------------
return stock
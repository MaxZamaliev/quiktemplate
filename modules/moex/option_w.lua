-------------------------------------------------------------------------------------------------------------------------------------------
--
-- option.lua - ������ QUIK_LUA ��� ��������� �������� ���������� �� ��������
-- (�)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--
--[[
	function option.subscribe(seccode)	 - ����������� �� ��������� ��������� ��� seccode
	function option.unsubscribe(seccode)	 - ���������� �� ��������� ��������� ��� seccode
	function option.checkStatus(seccode)	 - true ���� ���������� ��� ��������
	function option.isTrading(seccode)	 - true ���� ���������� ������ ���������
	function option.getListByBase(baseSecCode) - �������� ������ seccode �������� � ������� ������������ baseSecCode
	function option.getParam(seccode,param)  - �������� �������� (������������ ������� ��������� ����� ������)
	function option.getDelta(seccode)	 - �������� �������� ������
	function option.getGamma(seccode)        - �������� �������� �����
	function option.getTheta(seccode)        - �������� �������� ����
	function option.getVega(seccode)         - �������� �������� ����
	function option.getRho(seccode)          - �������� �������� ��
	function option.getStrike(seccode)       - �������� ������ �������
	function option.getVolatility(seccode)   - �������� �������������
	function option.getTheorPrice(seccode)   - �������� ������������� ����
	function option.getBaseClassCode(seccode) - �������� ClassCode �������� �����������
	function option.getBaseSecCode(seccode)  - �������� SecCode �������� �����������
	function option.getShortName(seccode)	 - ������� ������������
	function option.getMatDate(seccode) 	 - ���� ����������
	function option.getDaysLeft(seccode)     - ���� �� ����������
	function option.getSellDepo(seccode)	 - �� ��� �������
	function option.getBuyDepo(seccode)      - �� ��� �������
	function option.getPriceStep(seccode)    - ��� ����
	function option.getLotSize(seccode)      - ������ ����
	function option.getBIDPrice(seccode)     - ����� ���� �����������
	function option.getOFFERPrice(seccode)   - ������ ���� ������
	function option.getOFFERVolume(seccode)  - ��������� ����� �� ������ ���� �����������
	function option.getBIDVolume(seccode)    - ��������� ����� �� ������ ���� ������
	function option.getLastPrice(seccode)    - ���� ��������� ������
	function option.getLastVolume(seccode)   - ����� ��������� ������
	function option.getClosePrice(seccode)   - ���� ��������
	function option.getQuotes(seccode)       - �������� ������
	function option.getQuotesBID(seccode)    - �������� BID ����� �������
	function option.getQuotesOFFER(seccode)  - �������� OFFER ����� �������
]]

local option={}
--	local classcode = "SPBOPT"
	local classcode = "OPTW"
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.subscribe(seccode)
		local res = Subscribe_Level_II_Quotes(classcode,seccode)
		log.Debug("option.subscribe("..seccode..") = "..tostring(res))
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.unsubscribe(seccode)
		local res = Unsubscribe_Level_II_Quotes(classcode,seccode)
		log.Debug("option.unsubscribe("..seccode..") = "..tostring(res))
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.checkStatus(seccode)
		if getParamEx(classcode,seccode,"STATUS").param_image == "" then
			log.Error("option.checkStatus("..seccode.."): ������ �� ������")
			return nil
		end

		if getParamEx(classcode,seccode,"STATUS").param_image ~= "���������" then
			log.Error("option.checkStatus("..seccode.."): ������ �� ���������")
			return nil
		end

		if getParamEx(classcode,seccode,"SEC_FACE_UNIT").param_image ~= "SUR" then
			log.Error("option.checkStatus("..seccode.."): ������ ������� �� �����")
			return nil
		end
		log.Debug("option.checkStatus("..seccode..") = true")
		return true
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.isTrading(seccode)
		if option.checkStatus then
			if option.getParam(seccode,"TRADINGSTATUS") == "�������" then
				log.Debug("bonds.isTrading("..seccode..") = true")
				return true
			end
		end
		log.Debug("option.isTrading("..seccode..") = nil")
		return nil
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getListByBase(baseSecCode)
		local list = {}
		local T = "securities"
		for i=0,getNumberOf(T)-1 do
			local I = getItem(T,i)
			if I.class_code == classcode and I.base_active_seccode == baseSecCode then
				-- ���������� ������� � �������� ������ ����������
				local mat_date = os.time({ 
					year  = string.sub(I.mat_date,1,4),
					month = string.sub(I.mat_date,5,6),
					day   = string.sub(I.mat_date,7,8)
				})
				if (mat_date - os.time()) > 0 then
					if list[I.mat_date] == nil then
						list[I.mat_date] = {}
					end
					table.insert(list[I.mat_date],I.sec_code)
				end
			end
		end
		if mytable.len(list) > 0 then
--			log.Debug("option.getListByBase("..baseSecCode..") = "..mytable.tostring(list))
			log.Debug("option.getListByBase("..baseSecCode..") = [array]")
			return list
		else
			log.Debug("option.getListByBase("..baseSecCode..") = nil")
			return nil
		end
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getParam(seccode,param)
		if option.checkStatus(seccode) then
			local val
			local res = getParamEx(classcode,seccode,param)
--log.Error("getParamEx("..classcode..","..seccode..","..param..") = "..mytable.tostring(res))
			if res.param_type == "1" then
				val = tonumber(res.param_value)
				log.Debug("option.getParam("..seccode..","..param..") = "..val)
			elseif res.param_type == "2" then
				val = tonumber(res.param_value)
				log.Debug("option.getParam("..seccode..","..param..") = "..val)
			else
				val = res.param_image
				log.Debug("option.getParam("..seccode..","..param..") = \""..val.."\"")
			end
			return val
		else
			log.Debug("option.getParam("..seccode..","..param..") = nil : option.checkStatus() == nil")
			return nil
		end
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	local function N(x) --���������� ������� (��� �������� ������)
	    if (x > 10) then
	      return 1
	   elseif (x < -10) then
	      return 0
	   else
	      local t = 1 / (1 + 0.2316419 * math.abs(x))
	      local p = 0.3989423 * math.exp(-0.5 * x * x) * t * ((((1.330274 * t - 1.821256) * t + 1.781478) * t - 0.3565638) * t + 0.3193815)
	      if x > 0 then
	         p=1-p
	      end 
	      return p   
	   end
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	local function pN(x) --����������� �� ������� ����������� �������� (��� �������� ������)
	   return math.exp(-0.5 * x * x) / math.sqrt(2 * math.pi) 
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getDelta(seccode)
		if option.checkStatus(seccode) == nil then
			return nil
		end
		local b  = option.getVolatility(seccode) -- �������������
		local S  = futures.getSettlePrice(option.getBaseSecCode(seccode)) -- ������� ���� ��������� �����������
		local Tt = option.getDaysLeft(seccode)
		local K  = option.getStrike(seccode)
		local r  = 0
		local d1 = (math.log(S / K) + (r + b * b * 0.5) * Tt) / (b * math.sqrt(Tt))
--		local d2 = d1-(b * math.sqrt(Tt))
		local delta = 0
		local e = math.exp(-1 * r * Tt)
	       	if option.getType(seccode) == "Call" then
			delta = e * N(d1)
		else
			delta = -1 * e * N(-1*d1)
		end
		return delta
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getGamma(seccode)
		if option.checkStatus(seccode) == nil then
			return nil
		end
		local b  = option.getVolatility(seccode)
		local S  = futures.getSettlePrice(option.getBaseSecCode(seccode)) -- ������� ���� ��������� �����������
		local Tt = option.getDaysLeft(seccode)
		local K  = option.getStrike(seccode)
		local r  = 0
		local d1 = (math.log(S / K) + (r + b * b * 0.5) * Tt) / (b * math.sqrt(Tt))
--		local d2 = d1-(b * math.sqrt(Tt))
		local gamma = pN(d1) / (S * b * math.sqrt(Tt))
		return gamma
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getTheta(seccode)
		if option.checkStatus(seccode) == nil then
			return nil
		end
		local b  = option.getVolatility(seccode)
		local S  = futures.getSettlePrice(option.getBaseSecCode(seccode)) -- ������� ���� ��������� �����������
		local Tt = option.getDaysLeft(seccode)
		local K  = option.getStrike(seccode)
		local r  = 0
		local d1 = (math.log(S / K) + (r + b * b * 0.5) * Tt) / (b * math.sqrt(Tt))
		local d2 = d1-(b * math.sqrt(Tt))
		local e = math.exp(-1 * r * Tt)
		local theta = (-1 * S * b * e * pN(d1)) / (2 * math.sqrt(Tt))
	       	if option.getType(seccode) == "Call" then
			---theta = Theta - (r * K * e * N(d2)) + r * S * e * N(d1)
			theta = theta - (r * K * e * N(d2))
		else
			---theta = Theta + (r * K * e * N(-1 * d2)) - r * S * e * N(-1 * d1)
      			theta = theta + (r * K * e * N(-1 * d2))
		end
		return theta
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getVega(seccode)
		if option.checkStatus(seccode) == nil then
			return nil
		end
		local b  = option.getVolatility(seccode)
		local S  = futures.getSettlePrice(option.getBaseSecCode(seccode)) -- ������� ���� ��������� �����������
		local Tt = option.getDaysLeft(seccode)
		local K  = option.getStrike(seccode)
		local r  = 0
		local d1 = (math.log(S / K) + (r + b * b * 0.5) * Tt) / (b * math.sqrt(Tt))
		local e = math.exp(-1 * r * Tt)
		local vega = S * e * pN(d1) * math.sqrt(Tt)
		return vega
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getRho(seccode)
		if option.checkStatus(seccode) == nil then
			return nil
		end
		local b  = option.getVolatility(seccode)
		local S  = futures.getSettlePrice(option.getBaseSecCode(seccode)) -- ������� ���� ��������� �����������
		local Tt = option.getDaysLeft(seccode)
		local K  = option.getStrike(seccode)
		local r  = 0
		local d1 = (math.log(S / K) + (r + b * b * 0.5) * Tt) / (b * math.sqrt(Tt))
		local d2 = d1-(b * math.sqrt(Tt))
		local e = math.exp(-1 * r * Tt)
	       	if option.getType(seccode) == "Call" then
			rho = K * Tt * e * N(d2)
		else
			rho = -1 * K * Tt * e * N(-1 * d2)
		end
		return rho
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getStrike(seccode)
		local val = option.getParam(seccode,"STRIKE")
		log.Debug("option.getStrike("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getVolatility(seccode)
		local val = option.getParam(seccode,"VOLATILITY")
		log.Debug("option.getVolatility("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getTheorPrice(seccode)
		local val = option.getParam(seccode,"THEORPRICE")
		log.Debug("option.getTheorPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getType(seccode)
		local val = option.getParam(seccode,"OPTIONTYPE")
		log.Debug("option.getType("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getBaseClassCode(seccode)
		local val = option.getParam(seccode,"OPTIONBASECLASS")
		log.Debug("option.getBaseSecCode("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getBaseSecCode(seccode)
		local val = option.getParam(seccode,"OPTIONBASE")
		log.Debug("option.getBaseSecCode("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getShortName(seccode)
		local val = option.getParam(seccode,"SHORTNAME")
		log.Debug("option.getShortName("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getMatDate(seccode) -- ���� ���������
		local val = option.getParam(seccode,"MAT_DATE")
		log.Debug("option.getMatDate("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getDaysLeft(seccode)
		local val = option.getParam(seccode,"DAYS_TO_MAT_DATE")
		log.Debug("option.getDaysLeft("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getSellDepo(seccode)
		local val = option.getParam(seccode,"SELLDEPO")
		log.Debug("option.getSellDepo("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getBuyDepo(seccode)
		local val = option.getParam(seccode,"BUYDEPO")
		log.Debug("option.getSellDepo("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getPriceStep(seccode)
		local val = option.getParam(seccode,"SEC_PRICE_STEP")
		log.Debug("option.getPriceStep("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getLotSize(seccode)
		local val = option.getParam(seccode,"LOTSIZE")
		log.Debug("option.getLotSize("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getBIDPrice(seccode)
		local val = option.getParam(seccode,"BID")
		log.Debug("option.getBIDPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getOFFERPrice(seccode)
		local val = option.getParam(seccode,"OFFER")
		log.Debug("option.getOFFERPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getBIDVolume(seccode)
		local val = option.getParam(seccode,"BIDDEPTH")
		log.Debug("option.getBIDVolume("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getOFFERVolume(seccode)
		local val = option.getParam(seccode,"OFFERDEPTH")
		log.Debug("option.getOFFERVolume("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getLastPrice(seccode)
		local val = option.getParam(seccode,"LAST")
		log.Debug("option.getLastPrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getLastVolume(seccode)
		local val = option.getParam(seccode,"QTY")
		log.Debug("option.getLastVolume("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getClosePrice(seccode)
		local val = option.getParam(seccode,"CLOSEPRICE")
		log.Debug("option.getClosePrice("..seccode..") = "..tostring(val))
		return val
	end
---------------------------------------------------------------------------------------------------------------------------------------------------------
	function option.getQuotes(seccode)
		log.Debug("+++ option.getQuotes("..tostring(seccode)..")")
		if option.isTrading == nil then
			log.Error("--- option.getQuotes("..seccode..") = nil : ��������� �� ���������")
			return nil
		end
		local quotes = getQuoteLevel2Ex(classcode,seccode)
--		log.Debug("option.getQoutes(): quotes = "..mytable.tostring(quotes))
		if  quotes == nil then
			log.Error("--- option.getQuotes("..seccode..") = nil : �� ������� �������� ������")
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

--		log.Debug("--- option.getQuotes("..seccode..") = "..mytable.tostring(newQuotes))
		log.Debug("--- option.getQuotes("..seccode..") = [array]")
		return newQuotes
	end
-----------------------------------------------------------------------------------------------------------------
	function option.getQuotesBID(seccode)
		log.Debug("+++ option.getQuotesBID("..seccode..")")
		local quotes = option.getQuotes(seccode)
		if quotes == nil then
			log.Debug("--- option.getQuotesBID("..seccode..") = nil")
			return nil
		end
		if quotes.bid == nil then
			log.Debug("--- option.getQuotesBID("..seccode..") = nil")
			return nil
		end
		log.Debug("--- option.getQuotesBID("..seccode..") = [array]")
		return quotes.bid
	end
-----------------------------------------------------------------------------------------------------------------
	function option.getQuotesOFFER(seccode)
		log.Debug("+++ option.getQuotesOFFER("..seccode..")")
		local quotes = option.getQuotes(seccode)
		if quotes == nil then
			log.Debug("--- option.getQuotesOFFER("..seccode..") = nil")
			return nil
		end
		if quotes.offer == nil then
			log.Debug("--- option.getQuotesOFFER("..seccode..") = nil")
			return nil
		end
		log.Debug("--- option.getQuotesOFFER("..seccode..") = [array]")
		return quotes.offer
	end
-----------------------------------------------------------------------------------------------------------------
return option
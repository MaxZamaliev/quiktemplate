-------------------------------------------------------------------------------------------------------------------------------------------
--
-- tests.lua
-- (ñ)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--
Version	 	 = "test"
Debug 		 = true

dofile(getScriptPath().."\\modules\\modules.lua")
dofile(getScriptPath().."\\include\\OnInit.lua")
dofile(getScriptPath().."\\include\\OnStop.lua")
dofile(getScriptPath().."\\include\\OnOrder.lua")
dofile(getScriptPath().."\\include\\OnTrade.lua")
dofile(getScriptPath().."\\include\\OnTransReply.lua")
dofile(getScriptPath().."\\include\\OnQuote.lua")

function main()
	log.Info("Tests start here *******************************************")
	testOK = "Ok"

	dofile(getScriptPath().."\\tests\\bond.lua")
	dofile(getScriptPath().."\\tests\\stock.lua")

	log.Info("Tests result - "..testOK)
	if testOK == 'failed' then
		error("test FAILED!")
	else
		error("test OK")
	end
end

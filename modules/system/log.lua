-------------------------------------------------------------------------------------------------------------------------------------------
--
-- log.lua - ������ QUIK_LUA ��� ������ �����
-- (�)2020 Max Zamaliev <zamal@inbox.ru>
--
-------------------------------------------------------------------------------------------------------------------------------------------
--
--[[
  log.OnInit()
  log.write(text)        - �������� ������ � ������� � ��� ����
  log.writeError(text)   - �������� ������ � ������� � ��� ���� ��� ������
  log.writeDebug(text)   - �������� ������ � ������� � ��� ���� ��� ���������� �������
]]
local log ={}

	local LogPath      = getScriptPath().."\\log"
	local fileName     = nil
	local curDate      = nil

	function log.OnInit()
		if curDate ~= os.date("%Y%m%d") then
			fileName = os.date("%Y%m%d").."-"..os.date("%H%M%S")
			curDate  = os.date("%Y%m%d")
		end
	end

	function log.Info(Text)
		if Text == nil then
			return nil
		end
		log.Debug("INFO: "..Text)
		local LogFile = LogPath.."\\"..fileName..".log"
		local flog,err = io.open(LogFile,"a") 
		if flog == nil then
			message("�� ������ ������� ���-���� "..LogFile.." "..err)
			return nil
		end
		local today=os.date("%d.%m.%Y %H:%M:%S")
		flog:write(today.."  "..Text.."\n")
		flog:flush()
		flog:close()
	end

	function log.Error(Text)
		if Text == nil then
			return nil
		end
		log.Debug("ERROR: "..Text)
		if (fileName == nil) then
			fileName = os.date("%Y%m%d").."-"..os.date("%H%M%S")
		end
		local LogFile = LogPath.."\\"..fileName.."_error.log"
		local flog, err = io.open(LogFile,"a") 
		if flog == nil then
			message("�� ������ ������� ���-���� "..LogFile.." "..err)
			return nil
		end
		local today=os.date("%d.%m.%Y %H:%M:%S")
		flog:write(today.."  "..Text.."\n")
		flog:flush()
		flog:close()
	end

	function log.Debug(Text)
		log.OnInit()
		if (not (Debug == true) ) then
			return nil
		end
		if Text == nil then
			return nil
		end
		if (fileName == nil) then
			fileName = os.date("%Y%m%d").."-"..os.date("%H%M%S")
		end
		local LogFile = LogPath.."\\"..fileName.."_debug.log"
		local flog, err = io.open(LogFile,"a") 
		if flog == nil then
			message("�� ������ ������� ���-���� "..LogFile.." "..err)
			return nil
		end
		local today=os.date("%d.%m.%Y %H:%M:%S")
		flog:write(today.."  "..Text.."\n")
		flog:flush()
		flog:close()
	end


return log
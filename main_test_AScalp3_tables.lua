function createTable()
	tid=AllocTable()
	AddColumn(tid,1,"strike",true,QTABLE_DATE_TYPE,10)
	AddColumn(tid,2,"direction",true,QTABLE_STRING_TYPE,4)
	AddColumn(tid,3,"profit",true,QTABLE_DOUBLE_TYPE,15)
	AddColumn(tid,4,"min",true,QTABLE_DOUBLE_TYPE,15)
	AddColumn(tid,5,"max",true,QTABLE_DOUBLE_TYPE,15)
	CreateWindow(tid)
	local today = os.date("%d.%m.%Y %H:%M:%S")
	SetWindowCaption(tid,"Арбитраж month"..today)
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
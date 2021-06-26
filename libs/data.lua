--// 로블록스 플러그인 설정 저장소의 자동 캐싱버전

local module = {Plugin = nil}

local function tableFind(t,v)
	for i,vv in pairs(t) do
		if vv == v then
			return i
		end
	end
end

function module:SetUp(Plugin)
	module.Plugin = Plugin

	local DataCache = {}
	local Data = {}
	local connections = {};

	function Data:Save(Key,Data)
		DataCache[Key] = Data
		module.Plugin:SetSetting(Key,Data)
		local connection = connections[Key]
		if connection then
			for _,f in pairs(connection) do
				f(Data);
			end
		end
	end
	function Data:Load(Key)
		if DataCache[Key] then
			return DataCache[Key]
		else
			local Data = module.Plugin:GetSetting(Key)
			DataCache[Key] = Data
			return Data
		end
	end
	function Data:ForceLoad(Key)
		local Data = module.Plugin:GetSetting(Key)
		DataCache[Key] = Data
		return Data
	end
	function Data:BindChanged(key,func)
		local t = connections[key] or {}
		connections[key] = t
		if tableFind(t,func) then
			print(("Connection already exist for function %s on %s!"):format(key,tostring(func)))
			return
		end
		table.insert(t,func);
		return function ()
			local i = tableFind(t,func)
			if i then
				table.remove(t,i)
			else
				print(("Connection function %s already remove from %s!"):format(key,tostring(func)))
			end
		end
	end

	return Data
end

return module
local module = {};

local function new(ClassName,prop)
	local new = Instance.new(ClassName);
	for index,value in pairs(prop) do
		local valueType = typeof(value);
		local indexType = typeof(index);

		-- child
		if indexType ~= "string" and valueType == "Instance" then
			value.Parent = new;
		elseif valueType == "function" then
			-- connect event
			if index ~= "whenCreated" then
				new[index]:Connect(value);
			end
		elseif indexType == "string" then
			-- property
			new[index] = value
		end
	end
	local whenCreated = prop["whenCreated"];
	if whenCreated then
		whenCreated(new);
	end
	return new;
end

local storage = {};
module.Storage = {};

function module.getObject(name)
	return storage[name];
end

function module.Import(ClassName)
	return function (prop)
		if type(prop) == "string" then
			local lastName = prop;
			return function (nprop)
				nprop.Name = lastName;
				local item = new(ClassName,nprop);
				storage[lastName] = item;
				return item;
			end;
		end
		return new(ClassName,prop);
	end;
end

return module;

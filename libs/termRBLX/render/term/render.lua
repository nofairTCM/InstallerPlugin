---@diagnostic disable:undefined-global

local module = {};

local function new(ClassName,prop)
    local new = Instance.new(ClassName);
    for index,value in pairs(prop) do
        local valueType = typeof(value);
        local indexType = typeof(index);

        -- child
        if indexType ~= "string" and valueType == "Instance" then
            value.Parent = new;
        elseif value == "function" then
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

function module.Import(ClassName)
    local lastName = "";
    local function name(prop)
        prop.Name = lastName;
        return new(ClassName,prop);
    end
    return function (prop)
        if type(prop) == "string" then
            lastName = prop;
            return name;
        end
        return new(ClassName,prop);
    end;
end

return module;
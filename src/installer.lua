
--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-11 20:24:44
    # Modified by   : Qwreey
    # Modified time : 2021-05-22 16:24:50
    # Description   : |
        Time format = yyy-mm-dd hh:mm:ss
        Time zone = GMT+9

        설치 관리자입니다
  ]]

---@diagnostic disable:undefined-global
local module = {};
local ServerStorage = game:GetService("ServerStorage");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local HTTP = game:GetService("HttpService");

local props = {
    "name",
    "author",
    "import",
    "github",
    "lic",
    "info",
    "publishStatus",
    "version",
    "buildVersion",
    "type",
    "toolboxID",
    "index"
};
-- check thing's properties
local function checkThing(thing)
    for _,property in pairs(props) do
        assert(thing[property],property .. " is not exist!");
    end
end

-- make new instance
local function new(ClassName,Property)
    local Parent = Property and Property.Parent;
    local this = Instance.new(ClassName,Parent);

    if Parent then
        local old = Parent:FindFirstChild(Property.Name or ClassName);
        if old then
            old:Destroy();
        end
    end

    for i,v in pairs(Property) do
        this[i] = v;
    end

    return this;
end

-- get server side storage
function module:getServerSideStorage()
    local this = ServerStorage:FindFirstChild("nofairTCM_Server")
        or new("Folder",{Parent = ServerStorage,Name = "nofairTCM_Server"});
    local installerDB = this:FindFirstChild("installerDB") or new(
        "Folder",{Parent = this,Name = "installerDB"}
    );
    return {
        this = this;
        modules = this:FindFirstChild("modules") or new(
            "Folder",{Parent = this,Name = "modules"}
        );
        libs = this:FindFirstChild("libs") or new(
            "Folder",{Parent = this,Name = "libs"}
        );
        installerDB = installerDB;
        installedModules = installerDB:FindFirstChild("libs") or new(
            "Folder",{Parent = installerDB,Name = "installedModules"}
        );
        installedLibs = installerDB:FindFirstChild("libs") or new(
            "Folder",{Parent = installerDB,Name = "installedLibs"}
        );
    };
end

-- get client side storage
function module:getClientSideStorage()
    local this = ReplicatedStorage:FindFirstChild("nofairTCM_Client")
        or new("Folder",{Parent = ReplicatedStorage,Name = "nofairTCM_Client"});
    return {
        this = this;
        modules = this:FindFirstChild("modules") or new(
            "Folder",{Parent = this,Name = "modules"}
        );
        libs = this:FindFirstChild("libs") or new(
            "Folder",{Parent = this,Name = "libs"}
        );
    };
end

-- set database (github)
function module:setDB(newDB)
    self.db = newDB;
end

-- get item
function module:getThing(name)
    local thing = self.db[name];
    if not thing then error(("module/plugin/lib %s was not found from database!"):format(name)) end
    checkThing(thing);
    return thing;
end

-- check is installed
function module:isInstalled(name)
    local thing = self:getThing(name);
    local server = self:getServerSideStorage();
    local thingType = thing.type

    if thingType == "lib" then
        return server.installedLibs:FindFirstChild(thing.name);
    elseif thingType == "module" then
        return server.installedModules:FindFirstChild(thing.name);
    end
end

-- check update
function module:checkUpdate(name)
    local thing = self:getThing(name);
    local status = isInstalled(name);
    if not status then
        error(("module/lib/plugin was not found! (got : %s)"):format(name));
    end
    return thing.publishVersion > status.Value;
end

-- install item
function module:install(name)
    local thing = self:getThing(name);
    local thingType = thing.type;
    local server = self:getServerSideStorage();
    local client = self:getClientSideStorage();

    local import = thing.import;
    if import then
        for _,name in pairs(import) do
            self:install(name);
        end
    end

    local obj = game:GetObjects(thing.toolboxID)[1];

    if obj then
        local version = obj:FindFirstChild("version");
        if not version then
            error("version file was not found from asset");
        end
        version = HTTP:JSONDecode(version);
        if version.publishVersion ~= thing.publishVersion then
            error("asset publish version and github publish version does not match!, please wait for github user content refreshing");
        end

        local __setup = obj:FindFirstChild("__setup");
        if __setup then -- for custom setup codes
            require(__setup)();
        end

        local clientObj = obj:FindFirstChild("client");
        local serverObj = obj:FindFirstChild("server");

        -- setup install status
        local status = new("IntValue",
            {
                Name = thing.name;
                Parent = server[
                    (thingType == "lib" and "installedLibs") or
                    (thingType == "module" and "installedModules") or
                    "undefined"
                ];
                Value = thing.publishVersion;
            }
        );

        -- client install
        if clientObj then
            local parent = client[
                (thingType == "lib" and "libs") or
                (thingType == "module" and "modules") or
                "undefined"
            ];

            local str = thingType .. "\\";
            for _,o in pairs(clientObj:GetChildren()) do
                local oName = o.Name;
                local find = parent:FindFirstChild(oName);
                if find then
                    find:Destroy();
                end
                o.Parent = parent;
                str = str .. oName .. "\\";
            end

            new("StringValue",{
                Parent = status;
                Name = "client";
                Value = str;
            });
        end

        -- server install
        if serverObj then
            local parent = server[
                (thingType == "lib" and "libs") or
                (thingType == "module" and "modules") or
                "undefined"
            ];

            local str = thingType .. "\\";
            for _,o in pairs(serverObj:GetChildren()) do
                local oName = o.Name;
                local find = parent:FindFirstChild(oName);
                if find then
                    find:Destroy();
                end
                o.Parent = parent;
                str = str .. oName .. "\\";
            end

            new("StringValue",{
                Parent = status;
                Name = "server";
                Value = str;
            });
        end
    end
end

-- get installed object
function module:getInstalledObjs()
    return self.db;
end

return module;
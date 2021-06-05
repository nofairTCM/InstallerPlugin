
--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-11 20:24:44
    # Modified by   : Qwreey
    # Modified time : 2021-06-05 20:53:07
    # Description   : |
        Time format = yyy-mm-dd hh:mm:ss
        Time zone = GMT+9

        설치 관리자입니다
  ]]

---@diagnostic disable:undefined-global
local module = {};
local ServerStorage = game:GetService("ServerStorage");
local ServerScript = game:GetService("ServerScriptService");
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local ReplicatedFirst = game:GetService("ReplicatedFirst");
local HTTP = game:GetService("HttpService");
local void = function() end;

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
    "majorVersion",
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

local function replace(parent,t)
    local str = "";
    for _,o in pairs(t) do
        local oName = o.Name;
        local find = parent:FindFirstChild(oName);
        if find then
            find:Destroy();
        end
        o.Parent = parent;
        str = str .. oName .. ";";
    end

    return str;
end

local function remove(parent,t,log)
    log = log or void;
    if (not t) or (not parent) then
        return;
    elseif type(t) == "string" then
        log("decoding string . . .\n")
        local tmp = {};
        for str in string.gmatch(t,"[^;]+") do
            table.insert(tmp,str);
        end
        t = tmp;
    end
    log(("try to remove items from %s\n"):format(parent.Name));
    for _,v in pairs(t) do
        local obj = parent:FindFirstChild(v);
        if obj then
            obj:Destroy();
            log(("removed %s\n"):format(v));
        end
    end
end

-- get server side storage
function module:getServerSideStorage()
    local this = ServerStorage:FindFirstChild("nofairTCM_Server")
        or new("Folder",{Parent = ServerStorage,Name = "nofairTCM_Server"});
    return {
        this = this;
        __installer = this:FindFirstChild("__installer") or new(
            "Folder",{Parent = this,Name = "__installer"}
        );
        init = ServerScript:FindFirstChild("nofairTCM_ServerInit")
            or new("Folder",{Parent = ServerScript,Name = "nofairTCM_ServerInit"});
    };
end

-- get client side storage
function module:getClientSideStorage()
    return {
        this = ReplicatedStorage:FindFirstChild("nofairTCM_Client")
            or new("Folder",{Parent = ReplicatedStorage,Name = "nofairTCM_Client"});
        init = ReplicatedFirst:FindFirstChild("nofairTCM_ClientInit")
            or new("Folder",{Parent = ReplicatedFirst,Name = "nofairTCM_ClientInit"});
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
    local server = self:getServerSideStorage();
    return server.__installer:FindFirstChild(name);
end

-- check update
function module:checkUpdate(name)
    local thing = self:getThing(name);
    local status = self:isInstalled(name);
    if not status then
        error(("module/lib/plugin was not found! (got : %s)"):format(name));
    end
    return thing.publishVersion > status.Value;
end

-- uninstall
function module:uninstall(name,log)
    local elog = log or void;
    local indent = indent or "";
    local log = function(str)
        wait();
        elog(indent .. str);
    end

    log(("# try to uninstall %s\n"):format(tostring(name)));
    local server = self:getServerSideStorage();
    local client = self:getClientSideStorage();

    local isInstalled = self:isInstalled(name);
    if not isInstalled then
        log(("%s not installed! (or not found)"):format(name));
        return;
    end

    local installedClient = isInstalled:FindFirstChild("client");
    local installedServer = isInstalled:FindFirstChild("server");
    local installedClientInit = isInstalled:FindFirstChild("clientInit");
    local installedServerInit = isInstalled:FindFirstChild("serverInit");

    installedClient = installedClient and installedClient.Value;
    installedServer = installedServer and installedServer.Value;
    installedClientInit = installedClientInit and installedClientInit.Value;
    installedServerInit = installedServerInit and installedServerInit.Value;

    remove(client.this,installedClient,log);
    remove(server.this,installedServer,log);
    remove(client.init,installedClientInit,log);
    remove(server.init,installedServerInit,log);

    log("remove meta data . . .\n");
    isInstalled:Destroy();
    log(("Remove %s ended!\n"):format(name));
end

-- install item
function module:install(name,log,indent,force)
    local elog = log or void;
    local indent = indent or "";
    local log = function(str)
        wait();
        elog(indent .. str);
    end

    log(("# try to install %s\n"):format(tostring(name)));
    log("find object from database . . .\n")
    local thing = self:getThing(name);

    log("init server/client storage . . .\n");
    local server = self:getServerSideStorage();
    local client = self:getClientSideStorage();

    local thisName = thing.name;
    local isInstalled = self:isInstalled(thisName) ~= nil;

    -- 하위 모듈들을 받아온다
    log("install submodules . . .\n");
    local import = thing.import;
    if import then
        for _,name in pairs(import) do
            self:install(name,elog,indent .. string.rep("\32",2),force);
        end
    end

    log("try to install objects . . .\n");
    -- 이미 있으면 지움
    if isInstalled and (not force) then
        if not self:checkUpdate(thisName) then-- 이미 업데이트됨
            log("is latest version already!\n")
            return;
        end
        self:uninstall(name,elog);
    end

    -- 오브젝트 가져오기
    log("get objects from rblx asset . . .\n");
    local obj = game:GetObjects(thing.toolboxID)[1];
    if not obj then
        log("object not found");
        return;
    end

    -- 버전 파일 확인
    log("checking version . . .\n");
    local versionObj = obj:FindFirstChild("version");
    if not versionObj then
        error("version file was not found from asset");
    end
    version = HTTP:JSONDecode(versionObj.Value);
    if version.publishVersion ~= thing.publishVersion then
        error("asset publish version and github publish version does not match!, please wait for github user content refreshing");
    end

    -- setup 이 있으면 실행
    log("execute __setup script (before install) . . .\n");
    local __setup = obj:FindFirstChild("__setup");
    if __setup then
        local before = require(__setup).before;
        if before then
            before(server,client,self);
        end
    end

    local clientObj = obj:FindFirstChild("client");
    local serverObj = obj:FindFirstChild("server");
    local serverInitObj = obj:FindFirstChild("serverInit");
    local clientInitObj = obj:FindFirstChild("clientInit");

    -- 설치 상태 저장소 만들기
    log("init status objects . . .\n");
    local status = new("IntValue",{
        Name = thisName;
        Parent = server.__installer;
        Value = thing.publishVersion;
    });

    -- 클라이언트 오브젝트 인스톨
    log("move client objects . . .\n");
    if clientObj then
        new("StringValue",{
            Parent = status;
            Name = "client";
            Value = replace(client.this,clientObj:GetChildren());
        });
    end

    -- 서버 오브젝트 인스톨
    log("move server objects . . .\n");
    if serverObj then
        new("StringValue",{
            Parent = status;
            Name = "server";
            Value = replace(server.this,serverObj:GetChildren());
        });
    end

    -- 클라이언트 초기화기 인스톨
    log("move client init script . . .\n");
    if clientInitObj then
        new("StringValue",{
            Parent = status;
            Name = "clientInit";
            Value = replace(client.init,clientInitObj:GetChildren());
        });
    end

    -- 서버 초기화기 인스톨
    log("move server init script . . .\n");
    if serverInitObj then
        new("StringValue",{
            Parent = status;
            Name = "serverInit";
            Value = replace(server.init,serverInitObj:GetChildren());
        });
    end

    -- 임포트 해온거 기록해두기
    log("saving import list . . .\n");
    local importStr = "";
    if import then
        for _,v in pairs(import) do
            importStr = i .. ";";
        end
    end
    new("StringValue",{
        Parent = status;
        Name = "import";
        Value = importStr;
    });

    -- 지울때 쓰이는 __uninstall 저장하기
    log("saving __uninstall script . . .\n");
    local __uninstall = obj:FindFirstChild("__uninstall");
    if __uninstall then
        __uninstall.Parent = status;
    end

    -- version 파일 이동
    versionObj.Parent = status;

    -- setup 이 있으면 실행
    log("execute __setup script (after install) . . .\n");
    if __setup then
        local after = require(__setup).after;
        if after then
            after(server,client,self);
        end
    end

    log(("Install '%s' ended!\n"):format(thisName));
end

-- init
function module:init()
    local server = self:getServerSideStorage();
    local client = self:getClientSideStorage();
    return {server = server,client = client};
end;

-- get installed object
function module:getInstalledObjs()
    return self.db;
end

return module;
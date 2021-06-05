
--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-11 18:57:26
    # Modified by   : Qwreey
    # Modified time : 2021-06-05 17:42:41
    # Description   : |
        Time format = yyy-mm-dd hh:mm:ss
        Time zone = GMT+9

        모듈 다운로더 / 관리자입니다
        짅자ㅣ안ㄶ희ㅣㄴㄱ깃ㅅ헙브 넘뭏흐ㄴ네
        ㄷ돋덷ㅊ채 몇ㅊㅊ벊흘ㄹㄹ실ㄿ펱ㅌ뜬ㄴㄴㄷㄴ냑ㄱㄱ오
  ]]

local function main(plugin)
--#region [전체바탕/베이스] 플러그인 기본 베이스 가져옴 / 로블 기본 서비스를 가져옴

    -- 플러그인 베이스
    local pluginID = "nofairTCM.plugin.installerCLI"; -- 플러그인 ID
    local pluginIcon = "http://www.roblox.com/asset/?id=6031302931"; -- 플러그인 아이콘 (다크 테마를 위한)
    local pluginIconBlack = "http://www.roblox.com/asset/?id=6790472987"; -- 플러그인 아이콘 (라이트 테마를 위한)

    -- 로블록스 서비스
    local HTTP = game:GetService("HttpService"); -- HTTP 접근 서비스 / json 인코더-디코더

    -- 이 플러그인 버전 가져오기
    local verInfo = HTTP:JSONDecode(script.version.Value);
    local version = verInfo.version; -- 플러그인 버전 (x.xxx.x)
    local publishVersion = verInfo.publishVersion; -- 퍼블리시 버전

--#endregion
--#region [모듈 임포팅] 플러그인 모듈들을 불러옴 / 기초 설정을 만듬

    -- 플러그인 모듈들을 가져옴
    local commandArg = require(script.commandArg) --[[자동완성]] if not true then commandArg = require("src.commandArg"); end
    local toolbar = require(script.Parent.libs.ToolbarCombiner); --[[자동완성]] if not true then toolbar = require("libs.ToolbarCombiner.src"); end
    local installer = require(script.installer); --[[자동완성]] if not true then installer = require("src.installer"); end
    local termRBLX = require(script.Parent.libs.termRBLX); --[[자동완성]] if not true then termRBLX = require("libs.termRBLX"); end
    local commands = require(script.commands); --[[자동완성]] if not true then commands = require("scr.commands"); end

    -- 터미널 셋업
    local termTCM = termRBLX.init { -- 터미널을 하나 만듬
        runtimeType = "screen";
        holder = plugin;
        disableBlock = false;
        prompt = "$termTCM | ";
        path = plugin;
    };
    termTCM.output( -- 정보를 stdout 에 띄워줌
        ("type \"tcmi help\" for get information of tcm installer\ntcm 설치기에 대한 설명을 얻으려면 \"tcmi help\" 를 입력하세요\nTCM INSTALLER VERSION : %s\n\n-----------------Setup!-----------------\n")
        :format(version)
    );
    for _,command in pairs(commands(commandArg.decode)) do -- 커맨드를 불러와서 레지스터에 등록해둠
        termTCM.loadCmd(command);
    end

--#endregion
--#region [플러그인 바탕] 플러그인 UI / 플러그인 마우스 / 플러그인 탭 / 플러그인 버튼을 만듬

    -- 플러그인 창을 만듬
    local uiHolder = plugin:CreateDockWidgetPluginGui( -- 창을 만듬
        pluginID,
        DockWidgetPluginGuiInfo.new(
            Enum.InitialDockState.Float,
            true,
            false,
            280,
            300,
            280,
            300
        )
    );
    uiHolder.Name = pluginID; -- 플러그인 창 이름 정하기
    uiHolder.Title = "nofairTCM Installer CLI"; -- 플러그인 창 이름(실제로 표시 되는) 정하기

    -- 툴바/버튼
    local sharedToolbar = toolbar:CreateToolbar("nofairTCM",pluginID); -- 툴바를 만듬
    local thisButton = sharedToolbar:CreateButton( -- 버튼을 만듬
        pluginID .. ".openWindow",
        "open installer",
        (tostring(settings().Studio.Theme) == "Dark") and
            pluginIcon or pluginIconBlack, -- 테마에 맞게 아이콘 수정
        "Installer CLI"
    );
    thisButton.ClickableWhenViewportHidden = true; -- 창이 가려져 있어도 버튼을 누를 수 있음
    thisButton.Click:Connect(function () -- 버튼의 클릭 이벤트를 받아서 창의 열림 상태를 편집
        uiHolder.Enabled = not uiHolder.Enabled;
    end)
    local function setButtonStatus() -- 버튼 켜짐 꺼짐 상태 지정
        thisButton:SetActive(uiHolder.Enabled);
    end
    uiHolder:GetPropertyChangedSignal("Enabled"):Connect(setButtonStatus);
    setButtonStatus();

--#endregion
--#region [데이터 로드] 데이터 불러오기 / 유저 기다리기

    if not uiHolder.Enabled then -- 창이 열릴 때 까지 기다림
        uiHolder:GetPropertyChangedSignal("Enabled"):Wait();
    end

    -- 모듈 정보를 깃허브에서 읽어옴
    local moduleData,isPass;
    local reloadList;
    local function fetch()
        isPass,moduleData = pcall(HTTP.GetAsync,HTTP,"https://raw.githubusercontent.com/nofairTCM/Package/master/packageList.json");
        if not isPass then
            termTCM.output("an error occurred on fetching database, type 'tcmi fetch' for retry");
            return;
        end
        moduleData = HTTP:JSONDecode(moduleData);
        installer:setDB(moduleData);
        termTCM.moduleData = moduleData;
        if reloadList then
            reloadList();
        end
        return moduleData;
    end;
    termTCM.fetchDB = fetch;
    termTCM.installer = installer;
    fetch();

    local showUpdateDialog = moduleData and (moduleData.InstallerPlugin.publishVersion > publishVersion); -- 플러그인이 업데이트가 필요한지 확인하기 위함
    if showUpdateDialog then
        termTCM.output("new installer plugin version found, you can update it now!\n");
    end

--#endregion
--#region 터미널 랜더

    termTCM.uiHost.holder.Parent = uiHolder;
    termTCM.uiHost.holder.BackgroundTransparency = 0;
    termTCM.uiHost.holder.BackgroundColor3 = Color3.fromRGB(38,38,38);

--#endregion
end

return {
    run = main;
};
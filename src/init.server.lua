
-- 모듈 다운로더 / 관리자입니다

-- 플러그인 개체 가져옴
local plugin = plugin;
local pluginID = "nofairTCM.plugin.installer";

-- 로블 기본 서비스를 가져옵니다
local HTTP = game:GetService("HttpService");

-- 플러그인 모듈들을 가져옵니다
local getModulesData = require(script.getModulesData);
local toolbar = require(script.Parent.libs.ToolbarCombiner);

local function main()
    local uiHolder = plugin:CreateDockWidgetPluginGui(
        pluginID,
        DockWidgetPluginGuiInfo.new(
			Enum.InitialDockState.Float,
			true,
			false,
			200,
			300,
			180,
			200
		)
    );

    -- 툴바를 만들고 버튼을 만들어옴
    local sharedToolbar = toolbar:CreateToolbar(
        "nofairTCM",
        pluginID
    );
    local thisButton = sharedToolbar:CreateButton(
        pluginID .. ".openWindow",
        "open installer",
        "http://www.roblox.com/asset/?id=6031302931",
        "Installer"
    );

    -- 버튼의 클릭 이벤트를 받아서 창의 보이기를 편집
    thisButton.Click:Connect(function ()
        uiHolder.Enabled = not uiHolder.Enabled;
    end)

    -- 버튼 켜짐 꺼짐 상태 지정
    local function setButtonStatus()
        thisButton:SetActive(uiHolder.Enabled);
    end
    uiHolder:GetPropertyChangedSignal("Enabled"):Connect(setButtonStatus);
    setButtonStatus();

    -- 모듈 정보를 깃허브에서 읽어옴
    local moduleData = getModulesData(script,uiHolder,"https://raw.githubusercontent.com/nofairTCM/Plugin/main/modules.json");
end

return main();
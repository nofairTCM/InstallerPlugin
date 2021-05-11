
-- 모듈 다운로더 / 관리자입니다

-- 플러그인 개체 가져옴
local plugin = plugin;
local version = "1.11.1";
local pluginID = "nofairTCM.plugin.installer";
local pluginIcon = "http://www.roblox.com/asset/?id=6031302931";
local pluginIconBlack = "http://www.roblox.com/asset/?id=6790472987";

-- 로블 기본 서비스를 가져옵니다
local HTTP = game:GetService("HttpService");

-- 플러그인 모듈들을 가져옵니다
local getModulesData = require(script.getModulesData);
local splashScreen = require(script.splashScreen);
local toolbar = require(script.Parent.libs.ToolbarCombiner);

-- 플러그인 불러오기 부분
local function main()
    -- UI 를 만듬
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
    uiHolder.Name = pluginID;
    uiHolder.Title = "nofairTCM Installer";

    -- 툴바를 만들고 버튼을 만들어옴
    local sharedToolbar = toolbar:CreateToolbar(
        "nofairTCM",
        pluginID
    );
    local thisButton = sharedToolbar:CreateButton(
        pluginID .. ".openWindow",
        "open installer",
        (tostring(settings().Studio.Theme) == "Dark") and
            pluginIcon or pluginIconBlack, -- 테마에 맞게 아이콘 수정
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

    -- 창이 열릴 때 까지 기다림
    if not uiHolder.Enabled then
        uiHolder:GetPropertyChangedSignal("Enabled"):Wait();
    end

    -- 로딩 스크린 만듬
    local closeSlashScreen = splashScreen(uiHolder,pluginIcon,version);

    -- 모듈 정보를 깃허브에서 읽어옴
    local moduleData = getModulesData(uiHolder,"https://raw.githubusercontent.com/nofairTCM/InstallerPlugin/master/modules.json");
    moduleData = HTTP:JSONDecode(moduleData);

    -- 메인 렌더 부분
    local function render()
        local AdvancedTween = require(script.Parent.libs.AdvancedTween);
        local MaterialUI = require(script.Parent.libs.MaterialUI);
        local new = MaterialUI.Create;

        MaterialUI:CleanUp(); -- 한번 싹 클린업함
        MaterialUI.CurrentTheme = tostring(settings().Studio.Theme); -- 테마 설정함
        MaterialUI:UseDockWidget(Interface,plugin:GetMouse()); -- 위젯 등록함

        local store = {};
        new("Frame",{ -- 보더 부분은 알아서 없어집니다 (MaterialUI 기본 처리)
            BackgroundColor3 = MaterialUI:GetColor("Background");
            Name = "main";
            Size = UDim2.new(1,0,1,0);
            WhenCreated = function (this)
                store.this = this;
            end;
        },{
            topbar = new("Frame",{
                BackgroundColor3 = MaterialUI:GetColor("TopBar");
                Size = UDim2.new(1,0,0,42);
                ZIndex = 80;
            },{
                shadow = new("Shadow",{
                    ZIndex = 80;
                });
                icon = new("ImageLabel",{
                    AnchorPoint = Vector2.new(0, 0.5);
                    Position = UDim2.new(0, 8, 0.5, 0);
                    Size = UDim2.new(0, 28, 0, 28);
                    ZIndex = 80;
                    BackgroundTransparency = 1;
                    Image = pluginIcon;
                    ImageColor3 = MaterialUI:GetColor("TextColor");
                });
                title = new("TextLabel",{
                    BackgroundTransparency = 1;
                    Position = UDim2.new(0, 42, 0, 0);
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 80;
                    Font = Enum.Font.SourceSans;
                    Text = "TCM 설치기";
                    TextColor3 = MaterialUI:GetColor("TextColor");
                    TextSize = 18;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    NotTagging = true;
                });
            });
            holder = new("ScrollingFrame",{
                BackgroundTransparency = 1;
                Size = UDim2.new(1,0,1,-42);
                Position = UDim2.fromOffset(0,42);
                WhenCreated = function (this)
                    store.holder = this;
                end;
            },{
                list = new("UIListLayout",{
                    WhenCreated = function (this)
                        this:GetPropertyChangedSignal("ContentSize"):Connect(function ()
                            store.holder.CanvasSize = UDim2.new(0,0,0,this.ContentSize.Y);
                        end);
                    end;
                });
            });
        });

        store.this.Parent = uiHolder;

        --store.holder

        delay(0.4,function () -- 로블이 알아서 잘 그리고 처리하도록 좀 시간을 줌
            closeSlashScreen();
        end);
    end
    render(); -- 렌더를 한번 돌림

    -- 테마 변경됨
    settings().Studio.ThemeChanged:Connect(function ()
        -- 다시 렌더 돌림
        render();

        -- 툴바 아이콘 리컬러링
        thisButton.Icon = ""; wait();
        thisButton.Icon = (tostring(settings().Studio.Theme) == "Dark") and
            pluginIcon or pluginIconBlack; -- 테마에 맞게 아이콘 수정  
    end);
end

return main();
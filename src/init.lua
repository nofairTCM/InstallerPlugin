---@diagnostic disable:undefined-global
-- 모듈 다운로더 / 관리자입니다

-- 플러그인 불러오기 부분
local function main(plugin)
    -- 플러그인 개체 가져옴
    local version = "1.11.1";
    local pluginID = "nofairTCM.plugin.installer";
    local pluginIcon = "http://www.roblox.com/asset/?id=6031302931";
    local pluginIconBlack = "http://www.roblox.com/asset/?id=6790472987";
    local assets = {
        "http://www.roblox.com/asset/?id=6804828747",
        "http://www.roblox.com/asset/?id=6804829062",
        "http://www.roblox.com/asset/?id=6804829958",
        "http://www.roblox.com/asset/?id=6031302931",
        "http://www.roblox.com/asset/?id=6031104648",
        "http://www.roblox.com/asset/?id=6031302931",
        "http://www.roblox.com/asset/?id=4668069300",
        "rbxassetid://1316045217",
    };

    -- 로블 기본 서비스를 가져옴
    local HTTP = game:GetService("HttpService");

    -- 플러그인 모듈들을 가져옴
    local getModulesData = require(script.getModulesData); --[[자동완성]] if not true then getModulesData = require("src.getModulesData") end
    local splashScreenRender = require(script.splashScreen); --[[자동완성]] if not true then splashScreen = require("src.splashScreen") end
    local toolbar = require(script.Parent.libs.ToolbarCombiner); --[[자동완성]] if not true then toolbar = require("libs.ToolbarCombiner.src") end
    local installer = require(script.installer); --[[자동완성]] if not true then installer = require("src.installer") end
    local termRBLX = require(script.Parent.libs.termRBLX); --[[자동완성]] if not true then installer = require("libs.termRBLX") end

    -- 설정
    local globalFont = Enum.Font.Gotham;
    local tobBarSizeY = 42;
    local tabSizeY = 64;
    local white = Color3.fromRGB(255,255,255);
    local menuSize = UDim2.fromOffset(140,180);
    local menuCloseSize = UDim2.fromOffset(70,70);
    local termTCM = termRBLX.init { -- 터미널을 불러서 init 넘김
        runtimeType = "screen";
        holder = nil;
        disableBlock = false;
        prompt = "$termTCM | ";
        path = plugin;
    };
    termTCM.output(
        ("type \"tcmi --help\" for get information of tcm installer\ntcm 설치기에 대한 설명을 얻으려면 \"tcmi --help\" 를 입력하세요\nTCM INSTALLER VERSION : %s\n\n")
        :format(version)
    );

    local lastMouse; -- 마우스 저장

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
    uiHolder.Name = pluginID;
    uiHolder.Title = "nofairTCM Installer";

    local sharedToolbar = toolbar:CreateToolbar( -- 툴바를 만듬
        "nofairTCM",
        pluginID
    );
    local thisButton = sharedToolbar:CreateButton( -- 버튼을 만듬
        pluginID .. ".openWindow",
        "open installer",
        (tostring(settings().Studio.Theme) == "Dark") and
            pluginIcon or pluginIconBlack, -- 테마에 맞게 아이콘 수정
        "Installer"
    );
    thisButton.ClickableWhenViewportHidden = true;
    thisButton.Click:Connect(function () -- 버튼의 클릭 이벤트를 받아서 창의 열림 상태를 편집
        uiHolder.Enabled = not uiHolder.Enabled;
    end)
    local function setButtonStatus() -- 버튼 켜짐 꺼짐 상태 지정
        thisButton:SetActive(uiHolder.Enabled);
    end
    uiHolder:GetPropertyChangedSignal("Enabled"):Connect(setButtonStatus);
    setButtonStatus();

    if not uiHolder.Enabled then -- 창이 열릴 때 까지 기다림
        uiHolder:GetPropertyChangedSignal("Enabled"):Wait();
    end
    local slashScreen = splashScreenRender(uiHolder,pluginIcon,version,termTCM); -- 로딩 스크린 만듬
    slashScreen:setStatus("initialize ...");

    -- 모듈 정보를 깃허브에서 읽어옴
    slashScreen:setStatus("fetch data from github ...");
    local moduleData = getModulesData(uiHolder,"https://raw.githubusercontent.com/nofairTCM/InstallerPlugin/master/data/main.json");
    moduleData = HTTP:JSONDecode(moduleData);
    installer:setDB(moduleData);

    --termTCM.addCommand

    -- 메인 렌더 부분
    local function render()
        slashScreen = slashScreen or (splashScreenRender(uiHolder,pluginIcon,version,termTCM));

        slashScreen:setStatus("load plugin assets ...");
        game.ContentProvider:PreloadAsync(assets)

        slashScreen:setStatus("startup rendering ...");
        local AdvancedTween = require(script.Parent.libs.AdvancedTween) --[[자동완성]] if not true then AdvancedTween = require("libs.AdvancedTween.src.client.AdvancedTween") end
        local MaterialUI = require(script.Parent.libs.MaterialUI) --[[자동완성]] if not true then MaterialUI = require("libs.MaterialUI.src.client.MaterialUI") end
        local new = MaterialUI.Create;
        termTCM.uiHost.holder.Parent = plugin;

        MaterialUI:CleanUp(); -- 한번 싹 클린업함
        MaterialUI.CurrentTheme = tostring(settings().Studio.Theme); -- 테마 설정함
        if lastMouse and lastMouse.Obj then
            lastMouse.Obj:Destroy();
        end
        local mouse = MaterialUI:UseDockWidget(uiHolder,plugin:GetMouse()); -- 위젯 등록함 (마우스 가져옴)
        lastMouse = mouse;

        slashScreen:setStatus("rendering ui ...");
        -- 컬러 생성
        local tabColor = MaterialUI.CurrentTheme == "Dark"
            and Color3.fromRGB(65,150,255) or Color3.fromRGB(255,255,255);

        local store = {tabButtons = {}};

        local tabButtonOn = {TextTransparency = 0};
        local tabButtonOff = {TextTransparency = 0.4};
        local tabIconOn = {ImageTransparency = 0};
        local tabIconOff = {ImageTransparency = 0.4};
        local tabTrans = {
            Time = 0.52;
            Easing = AdvancedTween.EasingFunctions.Exp2;
            Direction = AdvancedTween.EasingDirection.Out;
        };
        local menuTrans = {
            Time = 0.32;
            Easing = AdvancedTween.EasingFunctions.Exp2;
            Direction = AdvancedTween.EasingDirection.Out;
        };

        local function newTabButton(prop)
            return new("TextButton",{
                TextTransparency = prop.Enabled
                    and tabButtonOn.TextTransparency
                    or tabButtonOff.TextTransparency;
                Name = prop.Name;
                Text = prop.Name;
                TextSize = 14;
                Font = globalFont;
                TextColor3 = tabColor;
                ZIndex = 82;
                Size = UDim2.fromScale(prop.SizeX,1);
                Position = UDim2.fromScale(prop.PositionX,0);
                BackgroundTransparency = 1;
                TextYAlignment = Enum.TextYAlignment.Bottom;
                WhenCreated = function (this)
                    store.tabButtons[prop.Name] = this;
                    this.MouseButton1Click:Connect(function ()
                        for _,item in pairs(store.tabButtons) do
                            AdvancedTween:StopTween(item.icon);
                            AdvancedTween:StopTween(item);
                            AdvancedTween:RunTween(item,tabTrans,(item == this) and tabButtonOn or tabButtonOff);
                            AdvancedTween:RunTween(item.icon,tabTrans,(item == this) and tabIconOn or tabIconOff);
                        end
                        AdvancedTween:StopTween(store.tabPointer);
                        AdvancedTween:RunTween(store.tabPointer,tabTrans,{
                            Position = UDim2.fromScale(prop.PositionX,1);
                        });

                        AdvancedTween:StopTween(store.holder);
                        AdvancedTween:RunTween(store.holder,tabTrans,{
                            Position = UDim2.new(prop.PagePositionX,0,0,tobBarSizeY + tabSizeY);
                        });
                    end);
                end;
            },{
                icon = new("ImageLabel",{
                    Position = UDim2.new(0.5,0,0,2);
                    AnchorPoint = Vector2.new(0.5,0);
                    ImageTransparency = prop.Enabled
                        and tabIconOn.ImageTransparency
                        or tabIconOff.ImageTransparency;
                    BackgroundTransparency = 1;
                    ImageColor3 = tabColor;
                    ZIndex = 82;
                    Image = prop.Image;
                    Size = UDim2.fromOffset(32,32);
                });
                new("UIPadding",{
                    PaddingBottom = UDim.new(0,10);
                });
                new("Rippler",{
                    ZIndex = 82;
                    Size = UDim2.new(1,0,1,10)
                });
            });
        end

        local function closeMenu()
            if AdvancedTween:IsTweening(store.menu) then
                return;
            end
            store.menu.shadow.Visible = false;
            store.menuBG.Visible = false;
            store.menu.Size = menuSize;
            store.menu.ImageTransparency = 0;
            AdvancedTween:RunTween(store.menu,menuTrans,{
                Size = menuCloseSize;
                ImageTransparency = 1;
            },function ()
                store.menu.Visible = false;
            end);
        end

        local function openMenu()
            if AdvancedTween:IsTweening(store.menu) then
                return;
            end
            store.menu.shadow.Visible = true;
            store.menu.Visible = true;
            store.menuBG.Visible = true;
            store.menu.Size = menuCloseSize;
            store.menu.ImageTransparency = 1;
            AdvancedTween:RunTween(store.menu,menuTrans,{
                Size = menuSize;
                ImageTransparency = 0;
            });
        end

        local function menuMouseCheck()
            if store.menu.Visible and (not store.menuMouseEnter) then
                closeMenu();
            end
        end

        local listItems = {};
        local function listItem(data)
            --data.id : id of item
            --data.icon : icon of item
            --data.title : title of item
            --data.
            local item = listItem[data.id] or new({

            });

        end

        new("Frame",{ -- 보더 부분은 알아서 없어집니다 (MaterialUI 기본 처리)
            Parent = uiHolder;
            BackgroundColor3 = MaterialUI:GetColor("Background");
            Name = "main";
            Size = UDim2.new(1,0,1,0);
            WhenCreated = function (this)
                store.this = this;
            end;
        },{
            menu = new("ImageLabel",{
                BackgroundTransparency = 1;
                ImageColor3 = MaterialUI:GetColor("Background");
                WhenCreated = function (this)
                    MaterialUI:SetRound(this,12);
                    store.menu = this;
                end;
                AnchorPoint = Vector2.new(1,0);
                Position = UDim2.new(1,-6,0,6);
                Size = UDim2.fromOffset(140,180);
                ZIndex = 801;
                MouseLeave = function ()
                    store.menuMouseEnter = false;
                end;
                MouseEnter = function ()
                    store.menuMouseEnter = true;
                end;
                Visible = false;
            },{
                shadow = new("ImageLabel",{
                    AnchorPoint = Vector2.new(0.5, 0);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    Position = UDim2.new(0.5, 0, 0, -3);
                    Size = UDim2.new(1, 18, 1, 18);
                    ZIndex = 800;
                    Image = "rbxassetid://1316045217";
                    ImageColor3 = Color3.fromRGB(0, 0, 0);
                    ImageTransparency = 0.71;
                });
            });
            topbar = new("Frame",{
                BackgroundColor3 = MaterialUI:GetColor("TopBar");
                Size = UDim2.new(1,0,0,tobBarSizeY + tabSizeY);
                ZIndex = 80;
            },{
                shadow = new("Shadow",{
                    ZIndex = 80;
                });
                icon = new("ImageLabel",{
                    Position = UDim2.fromOffset((tobBarSizeY - 28)/2, (tobBarSizeY - 28)/2);
                    Size = UDim2.new(0, 28, 0, 28);
                    ZIndex = 80;
                    BackgroundTransparency = 1;
                    Image = pluginIcon;
                    ImageColor3 = white;
                });
                title = new("TextLabel",{
                    BackgroundTransparency = 1;
                    Position = UDim2.new(0, 42, 0, 0);
                    Size = UDim2.new(1, 0, 0, tobBarSizeY);
                    ZIndex = 80;
                    Font = Enum.Font.SourceSans;
                    Text = "TCM 설치기";
                    TextColor3 = white;
                    TextSize = 18;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    NotTagging = true;
                });
                openMenu = new("IconButton",{
                    Style = MaterialUI.CEnum.IconButtonStyle.WithOutBackground;
                    ZIndex = 81;
                    Icon = "http://www.roblox.com/asset/?id=6031104648";
                    Position = UDim2.new(1,-4,0,4);
                    AnchorPoint = Vector2.new(1,0);
                    Size = UDim2.fromOffset(tobBarSizeY-8,tobBarSizeY-8);
                    MouseButton1Click = function ()
                        store.menuMouseEnter = true;
                        openMenu();
                    end;
                    IconColor3 = white;
                });
            });
            menuBG = new("TextButton",{
                Visible = false;
                Size = UDim2.fromScale(1,1);
                ZIndex = 85;
                BackgroundTransparency = 1;
                WhenCreated = function (this)
                    store.menuBG = this;
                end;
                MouseButton1Down = menuMouseCheck;
                MouseButton2Down = menuMouseCheck;
            });
            tabHolder = new("Frame",{
                BackgroundTransparency = 1;
                Size = UDim2.new(1,0,0,tabSizeY);
                Position = UDim2.fromOffset(0,tobBarSizeY);
            },{
                tabPointer = new("Frame",{
                    ZIndex = 85;
                    BackgroundColor3 = tabColor;
                    Position = UDim2.fromScale(0,1);
                    Size = UDim2.new(0.3333,0,0,3);
                    AnchorPoint = Vector2.new(0,1);
                    WhenCreated = function (this)
                        store.tabPointer = this;
                    end;
                });
                newTabButton({
                    Name = "modules";
                    SizeX = 0.3333;
                    PositionX = 0;
                    PagePositionX = 0;
                    Image = "http://www.roblox.com/asset/?id=6804829062";
                    Enabled = true;
                });
                newTabButton({
                    Name = "libs";
                    SizeX = 0.3333;
                    PositionX = 0.3333;
                    PagePositionX = -1;
                    Image = "http://www.roblox.com/asset/?id=6804829958";
                    Enabled = false;
                });
                newTabButton({
                    Name = "terminal";
                    SizeX = 0.3333;
                    PositionX = 0.6666;
                    PagePositionX = -2;
                    Image = "http://www.roblox.com/asset/?id=6804828747";
                    Enabled = false;
                });
            });
            holder = new("Frame",{
                BackgroundTransparency = 1;
                Size = UDim2.new(3,0,1,-tobBarSizeY + -tabSizeY);
                Position = UDim2.fromOffset(0,tobBarSizeY + tabSizeY);
                WhenCreated = function (this)
                    store.holder = this;
                end;
            },{

            });
        });

        --store.this.Parent = uiHolder;
        termTCM.uiHost.holder.Parent = store.holder;
        termTCM.uiHost.holder.Position = UDim2.fromScale(0.6666,0);
        termTCM.uiHost.holder.Size = UDim2.fromScale(0.3,1);
        termTCM.uiHost.TextScreen.TextColor3 = MaterialUI:GetColor("TextColor");
        --store.holder

        slashScreen:setStatus("wait for rblx ...");
        delay(0.4,function () -- 로블이 알아서 잘 그리고 처리하도록 좀 시간을 줌
            if not slashScreen then
                return;
            end
            slashScreen:close();
            slashScreen = nil;
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

return {
    run = main;
};
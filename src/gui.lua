
--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-11 18:57:26
    # Modified by   : Qwreey
    # Modified time : 2021-06-13 01:49:33
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
    local pluginID = "nofairTCM.plugin.installer"; -- 플러그인 ID
    local pluginIcon = "http://www.roblox.com/asset/?id=6031302931"; -- 플러그인 아이콘 (다크 테마를 위한)
    local pluginIconBlack = "http://www.roblox.com/asset/?id=6790472987"; -- 플러그인 아이콘 (라이트 테마를 위한)
    local assets = { -- 프리로드를 위한 에셋 인덱싱
        "http://www.roblox.com/asset/?id=6804828747",
        "http://www.roblox.com/asset/?id=6804829062",
        "http://www.roblox.com/asset/?id=6804829958",
        "http://www.roblox.com/asset/?id=6031302931",
        "http://www.roblox.com/asset/?id=6031104648",
        "http://www.roblox.com/asset/?id=6031302931",
        "http://www.roblox.com/asset/?id=4668069300",
        "rbxassetid://1316045217",
    };

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
    local dialog = require(script.dialog); --[[자동완성]] if not true then dialog = require("scr.dialog"); end
    local getModulesData = require(script.getModulesData); --[[자동완성]] if not true then getModulesData = require("src.getModulesData"); end
    local splashScreenRender = require(script.splashScreen); --[[자동완성]] if not true then splashScreenRender = require("src.splashScreen"); end
    local toolbar = require(script.Parent.libs.ToolbarCombiner); --[[자동완성]] if not true then toolbar = require("libs.ToolbarCombiner.src"); end
    local installer = require(script.installer); --[[자동완성]] if not true then installer = require("src.installer"); end
    local termRBLX = require(script.Parent.libs.termRBLX); --[[자동완성]] if not true then termRBLX = require("libs.termRBLX"); end
    local commands = require(script.commands); --[[자동완성]] if not true then commands = require("scr.commands"); end
    local AdvancedTween = require(script.Parent.libs.AdvancedTween) --[[자동완성]] if not true then AdvancedTween = require("libs.AdvancedTween.src.client.AdvancedTween") end
    local MaterialUI = require(script.Parent.libs.MaterialUI) --[[자동완성]] if not true then MaterialUI = require("libs.MaterialUI.src.client.MaterialUI") end
    local pluginUpdateDialogRender = require(script.pluginUpdateDialog) --[[자동완성]] if not true then pluginUpdateDialogRender = require("src.pluginUpdateDialogRender") end
    local itemRender = require(script.item); --[[자동완성]] if not true then itemRender = require("scr.item"); end
    local lang = require(script.lang); --[[자동완성]] if not true then lang = require("src.lang.init"); end
    local new = MaterialUI.Create;

    -- 기초 설정
    local globalFont = Enum.Font.Gotham; -- 전체 폰트
    local tobBarSizeY = 42; -- 탑바 Y 높이
    local tabSizeY = 64; -- 탭 Y 높이
    local white = Color3.fromRGB(255,255,255); -- 흰색
    local menuSize = UDim2.fromOffset(140,180); -- 메뉴 열린 크기
    local menuCloseSize = UDim2.fromOffset(70,70); -- 매뉴 닫히는 크기

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
    local function exeCommand(str)
        termTCM.output(termTCM.stdioSimulate.prompt .. str .. "\n");
        return termTCM.exe(str);
    end
    local outputUpdated do
        local event = Instance.new("BindableEvent");
        termTCM.stdioSimulate.outputHook = function (output)
            event:Fire(output);
        end;
        outputUpdated = event.Event;
    end


    -- 모듈들이 필요로 하는것들 넘겨줌
    splashScreenRender
        :setAdvancedTween(AdvancedTween)
        :setMaterialUI(MaterialUI)
        :setPluginIcon(pluginIcon)
        :setPluginIcon(pluginIcon)
        :setVersion(version)
        :setTermTCM(termTCM);
    dialog
        :setAdvancedTween(AdvancedTween)
        :setMaterialUI(MaterialUI);
    pluginUpdateDialogRender
        :setDialog(dialog)
        :setMaterialUI(MaterialUI)
        :setAdvancedTween(AdvancedTween);

--#endregion
--#region [플러그인 바탕] 플러그인 UI / 플러그인 마우스 / 플러그인 탭 / 플러그인 버튼을 만듬

    -- 플러그인 창을 만듬
    local lastMouse; -- 마우스 저장을 위한 선언
    local uiHolder = plugin:CreateDockWidgetPluginGui( -- 창을 만듬
        pluginID,
        DockWidgetPluginGuiInfo.new(
            Enum.InitialDockState.Float,
            true,
            false,
            320,
            400,
            320,
            400
        )
    );
    uiHolder.Name = pluginID; -- 플러그인 창 이름 정하기
    uiHolder.Title = "nofairTCM Installer"; -- 플러그인 창 이름(실제로 표시 되는) 정하기

    -- 툴바/버튼
    local sharedToolbar = toolbar:CreateToolbar("nofairTCM",pluginID); -- 툴바를 만듬
    local thisButton = sharedToolbar:CreateButton( -- 버튼을 만듬
        pluginID .. ".openWindow",
        "open installer",
        (tostring(settings().Studio.Theme) == "Dark") and
            pluginIcon or pluginIconBlack, -- 테마에 맞게 아이콘 수정
        "Installer"
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

    -- uiHolder 를 모듈들에 넘겨줌
    splashScreenRender:setUIHolder(uiHolder);
    dialog:setUIHolder(uiHolder);

--#endregion
--#region [데이터 로드] 데이터 불러오기 / 유저 기다리기

    if not uiHolder.Enabled then -- 창이 열릴 때 까지 기다림
        uiHolder:GetPropertyChangedSignal("Enabled"):Wait();
    end
    local slashScreen = splashScreenRender:render(); -- 스플레시 스크린을 만듬 (로드중을 띄우기 위해)
    slashScreen:setStatus("initialize ...");

    -- 모듈 정보를 깃허브에서 읽어옴
    slashScreen:setStatus("fetch data from github ...");
    local moduleData;
    local reloadList;
    local function fetch()
        moduleData = getModulesData(uiHolder,"https://raw.githubusercontent.com/nofairTCM/Package/master/packageList.json");
        moduleData = HTTP:JSONDecode(moduleData);
        installer:setDB(moduleData);
        termTCM.moduleData = moduleData;
        if reloadList then
            reloadList(true);
        end
        return moduleData;
    end
    termTCM.fetchDB = fetch;
    termTCM.installer = installer;
    fetch();

    local showUpdateDialog = moduleData.InstallerPlugin.publishVersion > publishVersion; -- 플러그인이 업데이트가 필요한지 확인하기 위함

--#endregion
--#region [UI 렌더] ui 렌더하기 / 테마 변경 이밴트 캐칭

    local killRender;
    local function render() -- 메인 렌더 부분

        if killRender then -- 이전의 UI 가 있으면 지움
            killRender();
            killRender = nil;
        end

        MaterialUI.CurrentTheme = tostring(settings().Studio.Theme); -- 테마 설정함
        slashScreen = slashScreen or splashScreenRender:render(); -- 스플레시 스크린을 가져옴 (없으면 만듬)

        slashScreen:setStatus("load plugin assets ...");
        game.ContentProvider:PreloadAsync(assets) -- 에셋을 프리로드해옴
        slashScreen:setStatus("startup rendering ...");

        -- 마우스를 만듬
        local mouse = MaterialUI:UseDockWidget(uiHolder,plugin:GetMouse()); -- 위젯 등록함 (마우스 가져옴)
        lastMouse = mouse;

        slashScreen:setStatus("rendering ui ...");
        local store = {tabButtons = {}};

        -- 탭 설정 생성
        local tabColor = MaterialUI.CurrentTheme == "Dark"
            and Color3.fromRGB(65,150,255) or Color3.fromRGB(255,255,255);
        local tabButtonOn = {TextTransparency = 0}; -- 탭 버튼 켜져있을때 / 텍스트
        local tabButtonOff = {TextTransparency = 0.4}; -- 탭 버튼 꺼져있을때 / 텍스트
        local tabIconOn = {ImageTransparency = 0}; -- 탭 버튼 켜져있을때 / 이미지
        local tabIconOff = {ImageTransparency = 0.4}; -- 탭 버튼 꺼져있을때 / 이미지
        local tabTrans = { -- 탭 transition 데이터
            Time = 0.52;
            Easing = AdvancedTween.EasingFunctions.Exp2;
            Direction = AdvancedTween.EasingDirection.Out;
        };
        local menuTrans = { -- 매뉴 transition 데이터
            Time = 0.32;
            Easing = AdvancedTween.EasingFunctions.Exp2;
            Direction = AdvancedTween.EasingDirection.Out;
        };

        local function newTabButton(prop) -- 탭 버튼 클레싱
            return new("TextButton",{
                TextTransparency = prop.Enabled
                    and tabButtonOn.TextTransparency
                    or tabButtonOff.TextTransparency;
                Name = prop.Name;
                Text = prop.Name;
                TextSize = 15;
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

        -- 메뉴 함수 생성
        local function closeMenu() -- 메뉴 닫기 함수
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

        local function openMenu() -- 메뉴 열기 함수
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

        local function menuMouseCheck() -- 메뉴 마우스 확인
            if store.menu.Visible and (not store.menuMouseEnter) then
                closeMenu();
            end
        end

        local function openInstallWindow(openPos)
            AdvancedTween:StopTween(store.installScale);
            AdvancedTween:StopTween(store.installHolder);
            store.installLog.Text = "Waiting for process . . .";
            store.installScale.Scale = 0.01;
            store.installHolder.Position = UDim2.fromOffset(openPos.X,openPos.Y);
            store.installStatus.Disabled = false;
            store.installOkButton.Disabled = true;
            store.installOkButtonSetColor();
            store.installScreen.Visible = true;
            store.installScreen.BackgroundTransparency = 1;
            AdvancedTween:RunTween(store.installScale,{
                Time = 0.68;
                Easing = AdvancedTween.EasingFunctions.Exp2;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                Scale = 1;
            });
            AdvancedTween:RunTween(store.installHolder,{
                Time = 0.76;
                Easing = AdvancedTween.EasingFunctions.Exp2;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                Position = UDim2.fromScale(0.5,0.5);
            });
            AdvancedTween:RunTween(store.installScreen,{
                Time = 0.68;
                Easing = AdvancedTween.EasingFunctions.Linear;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                BackgroundTransparency = 0.595;
            });
        end

        local listItems = {};
        local function listItem(id,data)
            if data.visible == false then
                return;
            end
            local isInstalled = installer:isInstalled(id);
            local lastVersion = data.publishVersion;
            local item = listItems[id] or itemRender(id,data,MaterialUI,lang);
            if isInstalled and lastVersion == isInstalled.Value then
                item.InstallIcon.Visible = false;
                item.UpdateIcon.Visible = false;
                item.UninstallIcon.Visible = true;
                item.this.Parent = store.installed;
            elseif isInstalled then
                item.InstallIcon.Visible = false;
                item.UpdateIcon.Visible = true;
                item.UninstallIcon.Visible = true;
                item.this.Parent = store.outupdated;
            else
                item.InstallIcon.Visible = true;
                item.UpdateIcon.Visible = false;
                item.UninstallIcon.Visible = false;
                item.this.Parent = store.list;
            end

            if not listItems[id] then
                item.InstallIcon.MouseButton1Click:Connect(function ()
                    openInstallWindow(item.InstallIcon.AbsolutePosition);
                    store.installTitle.Text = lang("onInstalling");
                    wait(0.9);
                    exeCommand("cls");
                    exeCommand("tcmi install " .. id .. " -f");
                    store.installOkButton.Disabled = false;
                    store.installOkButtonSetColor();
                    store.installStatus.Disabled = true;
                    reloadList();
                end);
                item.UninstallIcon.MouseButton1Click:Connect(function ()
                    openInstallWindow(item.InstallIcon.AbsolutePosition);
                    store.installTitle.Text = lang("onUninstalling");
                    wait(0.9);
                    exeCommand("cls");
                    exeCommand("tcmi uninstall " .. id);
                    store.installOkButton.Disabled = false;
                    store.installOkButtonSetColor();
                    store.installStatus.Disabled = true;
                    reloadList();
                end);
                listItems[id] = item;
            end
        end

        reloadList = function(force)
            if force then
                for _,v in pairs(listItems) do
                    if v then
                        v.this:Destroy();
                    end
                end
                listItems = {};
            end
            for i,v in pairs(moduleData) do
                listItem(i,v);
            end
        end

        local function makeListPage(id,title,layoutOrder)
            return new("Frame",{
                LayoutOrder = layoutOrder;
                Size = UDim2.fromScale(1,0);
                BackgroundTransparency = 1;
                ClipsDescendants = true;
                WhenCreated = function (this)
                    store[id] = this;
                end;
            },{
                header = new("Frame",{
                    Size = UDim2.new(1,0,0,36);
                    BackgroundTransparency = 1;
                    LayoutOrder = -2147483647;
                },{
                    title = new("TextLabel",{
                        BackgroundTransparency = 1;
                        TextSize = 18;
                        Text = title;
                        Font = globalFont;
                        TextColor3 = MaterialUI:GetColor("TextColor");
                        Size = UDim2.new(1,0,1,0);
                        TextXAlignment = Enum.TextXAlignment.Left;
                        Position = UDim2.fromOffset(0,-2);
                    },{
                        new("UIPadding",{
                            PaddingLeft = UDim.new(0,8);
                        });
                    });
                    div = new("Frame",{
                        BackgroundTransparency = 0.18;
                        BackgroundColor3 = Color3.fromRGB(127,127,127);
                        Size = UDim2.new(1,-20,0,1);
                        Position = UDim2.new(0.5,0,1,-3);
                        AnchorPoint = Vector2.new(0.5,1);
                    });
                });
                listLayout = new("UIListLayout",{
                    SortOrder = Enum.SortOrder.LayoutOrder;
                    WhenCreated = function (this)
                        this:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function ()
                            AdvancedTween:RunTween(this.Parent,{
                                Time = 0.43;
                                Easing = AdvancedTween.EasingFunctions.Exp2;
                                Direction = AdvancedTween.EasingDirection.Out;
                            },{
                                Size = UDim2.new(
                                    1,0,
                                    0,(#this.Parent:GetChildren() == 2) and 0 or this.AbsoluteContentSize.Y
                                );
                            });
                        end);
                    end;    
                });
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
                Text = "";
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
                    Size = UDim2.new(0.5,0,0,3);
                    AnchorPoint = Vector2.new(0,1);
                    WhenCreated = function (this)
                        store.tabPointer = this;
                    end;
                });
                newTabButton({
                    Name = "modules";
                    SizeX = 0.5;
                    PositionX = 0;
                    PagePositionX = 0;
                    Image = "http://www.roblox.com/asset/?id=6804829062";
                    Enabled = true;
                });
--[[                 newTabButton({
                    Name = "libs";
                    SizeX = 0.3333;
                    PositionX = 0.3333;
                    PagePositionX = -1;
                    Image = "http://www.roblox.com/asset/?id=6804829958";
                    Enabled = false;
                }); ]]
                newTabButton({
                    Name = "terminal";
                    SizeX = 0.5;
                    PositionX = 0.5;
                    PagePositionX = -1;
                    Image = "http://www.roblox.com/asset/?id=6804828747";
                    Enabled = false;
                });
            });
            holder = new("Frame",{
                BackgroundTransparency = 1;
                Size = UDim2.new(2,0,1,-tobBarSizeY + -tabSizeY);
                Position = UDim2.fromOffset(0,tobBarSizeY + tabSizeY);
                WhenCreated = function (this)
                    store.holder = this;
                end;
            },{
                itemsHolder = new("ScrollingFrame",{
                    Size = UDim2.fromScale(0.5,1);
                    BackgroundTransparency = 1;
                    ScrollBarThickness = 4;
                },{
                    padding = new("UIPadding",{
                        PaddingRight = UDim.new(0,6);
                    });
                    listLayout = new("UIListLayout",{
                        SortOrder = Enum.SortOrder.LayoutOrder;
                        WhenCreated = function (this)
                            this:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function ()
                                this.Parent.CanvasSize = UDim2.fromOffset(0,this.AbsoluteContentSize.Y);
                            end);
                        end;
                    });
                    outdated = makeListPage("outdated","Outdated",0);
                    installed = makeListPage("installed","Installed",1);
                    list = makeListPage("list","Store",2);
                });
            });
            installScreen = new("TextButton",{
                WhenCreated = function (this)
                    store.installScreen = this;
                    local lastConnection;
                    this:GetPropertyChangedSignal("Visible"):Connect(function ()
                        if lastConnection then
                            lastConnection:Disconnect();
                            lastConnection = nil;
                        end
                        local log = this.holder.items.log;
                        if this.Visible then
                            lastConnection = outputUpdated:Connect(function (text)
                                log.Text = text;
                            end);
                        end
                    end);
                end;
                ZIndex = 200;
                AutoButtonColor = false;
                Text = "";
                Visible = false;
                Size = UDim2.fromScale(1,1);
                BackgroundTransparency = 0.595;
                BackgroundColor3 = Color3.fromRGB(0,0,0);
            },{
                holder = new("ImageLabel",{
                    ZIndex = 200;
                    WhenCreated = function (this)
                        store.installHolder = this;
                        MaterialUI:SetRound(this,8);
                    end;
                    Size = UDim2.fromOffset(280,340);
                    BackgroundTransparency = 1;
                    ImageColor3 = MaterialUI:GetColor("Background");
                    Position = UDim2.fromScale(0.5,0.5);
                    AnchorPoint = Vector2.new(0.5,0.5);
                },{
                    Scale = new("UIScale",{
                        Scale = 1;
                        WhenCreated = function (this)
                            store.installScale = this;
                        end;
                    });
                    items = new("Frame",{
                        BackgroundTransparency = 1;
                        ClipsDescendants = true;
                        Size = UDim2.fromScale(1,1);
                    },{
                        title = new("TextLabel",{
                            Text = "Installing . . .";
                            ZIndex = 200;
                            TextColor3 = MaterialUI:GetColor("TextColor");
                            Size = UDim2.new(1,0,0,50);
                            Position = UDim2.fromOffset(18,0);
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BackgroundTransparency = 1;
                            Font = globalFont;
                            TextSize = 16;
                            WhenCreated = function (this)
                                store.installTitle = this;
                            end;
                        });
                        log = new("TextBox",{
                            ClearTextOnFocus = false;
                            TextEditable = false;
                            Font = Enum.Font.Code;
                            TextSize = 14;
                            ZIndex = 200;
                            BackgroundColor3 = MaterialUI.CurrentTheme == "Dark" and Color3.fromRGB(52,52,52) or Color3.fromRGB(244,244,244);
                            TextYAlignment = Enum.TextYAlignment.Bottom;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            TextColor3 = MaterialUI:GetColor("TextColor");
                            Position = UDim2.new(0.5,0,0,50);
                            Size = UDim2.new(1,-28,1,-50 -60);
                            AnchorPoint = Vector2.new(0.5,0);
                            ClipsDescendants = true;
                            WhenCreated = function (this)
                                store.installLog = this;
                            end;
                        },{
                            padding = new("UIPadding",{
                                PaddingLeft = UDim.new(0,8);
                                PaddingRight = UDim.new(0,8);
                                PaddingBottom = UDim.new(0,8);
                                PaddingTop = UDim.new(0,8);
                            });
                        });
                        status = new("IndeterminateProgress",{
                            BackgroundColor3 = MaterialUI.CurrentTheme == "Dark" and Color3.fromRGB(32,32,32) or Color3.fromRGB(220,220,220);
                            ZIndex = 200;
                            Position = UDim2.new(0.5,0,1,-50-6);
                            AnchorPoint = Vector2.new(0.5,1);
                            Size = UDim2.new(1,-28,0,4);
                            Disabled = true;
                            WhenCreated = function (this)
                                store.installStatus = this;
                            end;
                        });
                        ok = new("Button",{
                            TextColor3 = Color3.fromRGB(127,127,127);
                            ZIndex = 200;
                            Style = MaterialUI.CEnum.ButtonStyle.Text;
                            Position = UDim2.new(1,-10,1,-10);
                            AnchorPoint = Vector2.new(1,1);
                            Disabled = true;
                            Text = "Done";
                            WhenCreated = function (this)
                                store.installOkButtonSetColor = function ()
                                    this.TextColor3 = this.Disabled and Color3.fromRGB(127,127,127) or Color3.fromRGB(150,0,255);
                                end;
                                store.installOkButton = this;
                                this.MouseButton1Click:Connect(function ()
                                    if this.Disabled then
                                        return;
                                    end
                                    AdvancedTween:RunTween(store.installHolder,{
                                        Time = 0.78;
                                        Easing = AdvancedTween.EasingFunctions.Exp2;
                                        Direction = AdvancedTween.EasingDirection.Out;
                                    },{
                                        Position = UDim2.new(0.5,0,1.5,26);
                                    },function ()
                                        store.installScreen.Visible = false;
                                    end);
                                    AdvancedTween:RunTween(store.installScale,{
                                        Time = 0.6;
                                        Easing = AdvancedTween.EasingFunctions.Exp2;
                                        Direction = AdvancedTween.EasingDirection.Out;
                                    },{
                                        Scale = 0.6;
                                    });
                                    AdvancedTween:RunTween(store.installScreen,{
                                        Time = 0.58;
                                        Easing = AdvancedTween.EasingFunctions.Linear;
                                        Direction = AdvancedTween.EasingDirection.Out;
                                    },{
                                        BackgroundTransparency = 1;
                                    });
                                end);
                            end
                        });
                    });
                    shadow = new("ImageLabel",{
                        AnchorPoint = Vector2.new(0.5, 0);
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        Position = UDim2.new(0.5, 0, 0, -3);
                        Size = UDim2.new(1, 18, 1, 18);
                        ZIndex = 199;
                        Image = "rbxassetid://1316045217";
                        ImageColor3 = Color3.fromRGB(0, 0, 0);
                        ImageTransparency = 0.71;
                    });
                });
            });
        });

        -- 터미널 창을 가져옴
        termTCM.uiHost.holder.Parent = store.holder;
        termTCM.uiHost.holder.Position = UDim2.fromScale(0.5,0);
        termTCM.uiHost.holder.Size = UDim2.fromScale(0.5,1);
        termTCM.uiHost.TextScreen.TextColor3 = MaterialUI:GetColor("TextColor");

        reloadList();
        slashScreen:setStatus("wait for rblx ...");
        delay(0.25,function () -- 로블이 알아서 잘 그리고 처리하도록 좀 시간을 줌
            if not slashScreen then
                return;
            end
            slashScreen:close();
            slashScreen = nil;
            termTCM.output("Plugin Core : loaded!\n----------------------------------------\n\n");

            -- 만약 플러그인이 업데이트가 필요하면 확인창을 띄워줌
            if showUpdateDialog then
                showUpdateDialog = false;
                pluginUpdateDialogRender:render(); -- 다이어로그 렌더러를 부름
            end
        end);

        killRender = function () -- 렌더 해제하는 함수 지정
            if mouse and mouse.Obj then -- 마우스가 있으면 지움
                mouse.Obj:Destroy();
            end
            termTCM.uiHost.holder.Parent = plugin; -- termTCM 을 옮김
            MaterialUI:CleanUp(); -- 한번 싹 클린업함
            termTCM.output("-----------------Reload-----------------");
        end;
    end

    render(); -- 렌더를 한번 돌림
    -- 테마 변경됨에 따라 다시 한번 리로드
    settings().Studio.ThemeChanged:Connect(function ()
        -- 다시 렌더 돌림
        render();

        -- 툴바 아이콘 리컬러링
        thisButton.Icon = ""; wait();
        thisButton.Icon = (tostring(settings().Studio.Theme) == "Dark") and
            pluginIcon or pluginIconBlack; -- 테마에 맞게 아이콘 수정
    end);
--#endregion
end

return {
    run = main;
};
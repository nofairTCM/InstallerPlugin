
--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-11 18:57:26
    # Modified by   : Qwreey
    # Modified time : 2021-06-20 19:46:11
    # Description   : |
        Time format = yyy-mm-dd hh:mm:ss
        Time zone = GMT+9

        TODO: 검색 기능 만들기
        TODO: 자동닫기 설정
        TODO: 어바웃/ 모듈 정보 완성
        TODO: 자동 업데이트 설정

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
        "rbxassetid://1316045217"
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
    local libs = script.Parent.libs;
    local commandArg = require(script.commandArg) --[[auto]] if not true then commandArg = require("src.commandArg"); end
    local dialog = require(script.dialog); --[[auto]] if not true then dialog = require("src.dialog"); end
    local getModulesData = require(script.getModulesData); --[[auto]] if not true then getModulesData = require("src.getModulesData"); end
    local splashScreenRender = require(script.splashScreen); --[[auto]] if not true then splashScreenRender = require("src.splashScreen"); end
    local toolbar = require(libs.toolbarCombiner); --[[auto]] if not true then toolbar = require("libs.toolbarCombiner"); end
    local installer = require(script.installer); --[[auto]] if not true then installer = require("src.installer"); end
    local termRBLX = require(libs.termRBLX); --[[auto]] if not true then termRBLX = require("libs.termRBLX"); end
    local commands = require(script.commands); --[[auto]] if not true then commands = require("src.commands"); end
    local AdvancedTween = require(libs.AdvancedTween) --[[auto]] if not true then AdvancedTween = require("libs.AdvancedTween.src.client.AdvancedTween") end
    local MaterialUI = require(libs.MaterialUI) --[[auto]] if not true then MaterialUI = require("libs.MaterialUI.src.client.MaterialUI") end
    local pluginData = require(libs.data) --[[auto]] if not true then pluginData = require("libs.Data.src.init") end
    local pluginUpdateDialogRender = require(script.pluginUpdateDialog) --[[auto]] if not true then pluginUpdateDialogRender = require("src.pluginUpdateDialog") end
    local getExampleDialogRender = require(script.getExampleDialog) --[[auto]] if not true then getExampleDialogRender = require("src.getExampleDialog") end
    local itemRender = require(script.item); --[[auto]] if not true then itemRender = require("src.item"); end
    local lang = require(script.lang); --[[auto]] if not true then lang = require("src.lang.init"); end
    local data = require(libs.data):SetUp(plugin); --[[auto]] if not true then data = require("libs.data"):SetUp(plugin); end
    local new = MaterialUI.Create;

    -- 기초 설정
    local globalFont = Enum.Font.Gotham; -- 전체 폰트
    local tobBarSizeY = 42; -- 탑바 Y 높이
    local tabSizeY = 64; -- 탭 Y 높이
    local white = Color3.fromRGB(255,255,255); -- 흰색
    --local menuCloseSize = UDim2.fromOffset(70,70); -- 매뉴 닫히는 크기
    local outupdatePromptSizeY = 48;

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
        :setAdvancedTween(AdvancedTween)
        :setLang(lang);
    getExampleDialogRender
        :setDialog(dialog)
        :setMaterialUI(MaterialUI)
        :setAdvancedTween(AdvancedTween)
        :setLang(lang);

    -- 데이터 셋업
    pluginData = pluginData:SetUp(plugin);

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
            420,
            320,
            420
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
    local splashScreen = splashScreenRender:render(); -- 스플레시 스크린을 만듬 (로드중을 띄우기 위해)
    splashScreen:setStatus("initialize ...");

    -- 모듈 정보를 깃허브에서 읽어옴
    splashScreen:setStatus("fetch data from github ...");
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
        splashScreen = splashScreen or splashScreenRender:render(); -- 스플레시 스크린을 가져옴 (없으면 만듬)

        splashScreen:setStatus("load plugin assets ...");
        game.ContentProvider:PreloadAsync(assets) -- 에셋을 프리로드해옴
        splashScreen:setStatus("startup rendering ...");

        -- 마우스를 만듬
        local mouse = MaterialUI:UseDockWidget(uiHolder,plugin:GetMouse()); -- 위젯 등록함 (마우스 가져옴)
        lastMouse = mouse;

        splashScreen:setStatus("rendering ui ...");
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

        -- local tabClosed = false;
        -- local tabTweening = false;
        -- local function showTabs()
        --     tabClosed = false;
        --     tabTweening = true;
        --     AdvancedTween:RunTween(store.header,{
        --         Time = 0.12;
        --         Easing = AdvancedTween.EasingFunctions.Exp2;
        --         Direction = AdvancedTween.EasingDirection.Out;
        --     },{
        --         Size = UDim2.new(1,0,0,tabSizeY + tobBarSizeY);
        --     });
        --     AdvancedTween:RunTween(store.tabHolder,{
        --         Time = 0.2;
        --         Easing = AdvancedTween.EasingFunctions.Exp2;
        --         Direction = AdvancedTween.EasingDirection.Out;
        --     },{
        --         Position = UDim2.new(0,0,0,tobBarSizeY);
        --     });
        --     AdvancedTween:RunTween(store.holder,{
        --         Time = 0.2;
        --         Easing = AdvancedTween.EasingFunctions.Exp2;
        --         Direction = AdvancedTween.EasingDirection.Out;
        --     },{
        --         Size = UDim2.new(store.holder.Size.X.Scale,0,1,-tobBarSizeY -tabSizeY);
        --         Position = UDim2.new(0,0,0,tobBarSizeY + tabSizeY);
        --     });
        --     delay(0.22,function()
        --         tabTweening = false;
        --     end);
        -- end

        -- local function hideTabs()
        --     if tobBarSizeY > (store.listItemHolder.CanvasSize.Y.Offset - store.listItemHolder.CanvasPosition.Y) then
        --         return;
        --     end
        --     tabClosed = true;
        --     tabTweening = true;
        --     AdvancedTween:RunTween(store.header,{
        --         Time = 0.12;
        --         Easing = AdvancedTween.EasingFunctions.Exp2;
        --         Direction = AdvancedTween.EasingDirection.Out;
        --     },{
        --         Size = UDim2.new(1,0,0,tobBarSizeY);
        --     });
        --     AdvancedTween:RunTween(store.tabHolder,{
        --         Time = 0.2;
        --         Easing = AdvancedTween.EasingFunctions.Exp2;
        --         Direction = AdvancedTween.EasingDirection.Out;
        --     },{
        --         Position = UDim2.new(0,0,0,tobBarSizeY - tabSizeY);
        --     });
        --     AdvancedTween:RunTween(store.holder,{
        --         Time = 0.2;
        --         Easing = AdvancedTween.EasingFunctions.Exp2;
        --         Direction = AdvancedTween.EasingDirection.Out;
        --     },{
        --         Size = UDim2.new(store.holder.Size.X.Scale,0,1,-tobBarSizeY);
        --         Position = UDim2.new(0,0,0,tobBarSizeY);
        --     });
        --     delay(0.22,function()
        --         tabTweening = false;
        --     end);
        -- end

        -- 인포 화면
        local closeInfo,moveInfo,getInfoPos,infoIsOpen,infoMouseDown;
        closeInfo = function()
            moveInfo(1,true);
            infoIsOpen = false;
            AdvancedTween:RunTween(store.infoScreen,{
                Time = 0.3;
                Easing = AdvancedTween.EasingFunctions.Linear;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                BackgroundTransparency = 1;
            },function ()
                store.infoScreen.Visible = false;
            end);
            store.listItemHolder.ScrollingEnabled = true;
            store.infoId = nil;
        end

        moveInfo = function(add,noClose)
            add = add or 0;
            if not infoIsOpen then
                return;
            end
            local to = store.infoHolder.Position.Y.Scale + add;
            if not infoMouseDown then
                if to < 0.3 then -- 완전히 열림
                    if add > 0 then
                        to = 0.3;
                    else
                        to = 0;
                    end
                elseif to > 0.7 then -- 완전히 닫힘
                    if add < 0 then
                        to = 0.7;
                    else
                        to = 1;
                    end
                end
            end

            store.infoScroll.ScrollingEnabled = to == 0;

            if add == 0 and (not (to == 1 or to == 0)) then
                return;
            end

            AdvancedTween:RunTween(store.infoHolder,{
                Time = 0.3;
                Easing = AdvancedTween.EasingFunctions.Exp2;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                Position = UDim2.new(0,0,to,to == 1 and 32 or -24);
            },function ()
                if to == 1 and (not noClose) then
                    closeInfo();
                end
            end);
        end

        getInfoPos = function()
            return store.infoHolder.Position.Y.Scale;
        end

        local function openInfo(id,data)
            local isInstalled = installer:isInstalled(id);
            local lastVersion = data.publishVersion;
            if isInstalled and lastVersion == isInstalled.Value then
                store.infoUninstall.Visible = true;
                store.infoInstall.Visible = false;
                store.infoUpdate.Visible = false;
            elseif isInstalled then
                store.infoUninstall.Visible = true;
                store.infoInstall.Visible = false;
                store.infoUpdate.Visible = true;
            else
                store.infoUninstall.Visible = false;
                store.infoInstall.Visible = true;
                store.infoUpdate.Visible = false;
            end
            store.infoTitle.Text = data.name or id;
            store.infoIcon.Image = data.icon or "";
            store.infoAuthor.Text = ("by " .. data.author) or "none";
            store.infoHolder.Position = UDim2.fromScale(0,1);
            infoIsOpen = true;
            store.infoScreen.Visible = true;
            moveInfo(0.5 - getInfoPos(),true);
            AdvancedTween:RunTween(store.infoScreen,{
                Time = 0.3;
                Easing = AdvancedTween.EasingFunctions.Linear;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                BackgroundTransparency = 0.68;
            });
            store.listItemHolder.ScrollingEnabled = false;
            store.infoId = id;
            store.infoText.Text = data.info .. "\n"
                .. (data.version and ("\n" .. lang("info.version") .. data.version) or "")
                .. (data.buildVersion and ("\n" .. lang("info.buildVersion") .. data.buildVersion) or "")
                .. (data.publishVersion and ("\n" .. lang("info.publishVersion") .. data.publishVersion) or "")
                .. (data.majorVersion and ("\n" .. lang("info.majorVersion") .. data.majorVersion) or "")
                .. (data.publishStatus and ("\n" .. lang("info.publishStatus") .. data.publishStatus) or "")
                .. (data.toolboxID and ("\n" .. lang("info.toolboxID") .. data.toolboxID) or "")
                .. (data.github and ("\n" .. lang("info.github") .. data.github) or "")
                .. (data.import and ("\n" .. lang("info.import") .. table.concat(data.import,", ")) or "")
                .. (data.license and ("\n" .. lang("info.license") .. data.license) or "");
            store.infoScroll.CanvasPosition = Vector2.new(0,0);
        end

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
                        -- if tabClosed then
                        --     return;
                        -- end
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
                    ZIndex = 83;
                    Size = UDim2.new(1,0,1,10)
                });
            });
        end

        local TweenService = game:GetService("TweenService");
        local function scrollInfoHolder(to)
            local infoScroll = store.infoScroll;
            local lastInfoScrollPos = store.lastInfoScrollPos or store.infoScroll.CanvasPosition.Y;
            local scrollPos = lastInfoScrollPos + (150*to);
            store.lastInfoScrollPos = scrollPos;
            AdvancedTween:RunTween(infoScroll,{
                Time = 0.45;
                Easing = function (index)
                    return TweenService:GetValue(index,Enum.EasingStyle.Quint,Enum.EasingDirection.Out);
                end;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                CanvasPosition = Vector2.new(0,scrollPos);
            },function ()
                store.lastInfoScrollPos = nil;
            end);
        end

        -- 메뉴 함수 생성
        local menuClicked = false;
        local function closeMenu() -- 메뉴 닫기 함수
            if (not store) or AdvancedTween:IsTweening(store.menu) then
                return;
            end
            store.menu.shadow.Visible = false;
            store.menuBG.Visible = false;
            store.menuScale.Scale = 1;
            store.menu.ImageTransparency = 0;
            AdvancedTween:RunTween(store.menuScale,menuTrans,{
                Scale = 0.25;
            });
            AdvancedTween:RunTween(store.menu,menuTrans,{
                ImageTransparency = 1;
            },function ()
                store.menu.Visible = false;
            end);
        end

        local function openMenu() -- 메뉴 열기 함수
            menuClicked = false;
            if AdvancedTween:IsTweening(store.menu) then
                return;
            end
            store.menu.shadow.Visible = true;
            store.menu.Visible = true;
            store.menuBG.Visible = true;
            store.menuScale.Scale = 0.25;
            store.menu.ImageTransparency = 1;
            AdvancedTween:RunTween(store.menuScale,menuTrans,{
                Scale = 1;
            });
            AdvancedTween:RunTween(store.menu,menuTrans,{
                ImageTransparency = 0;
            });
        end

        local function menuMouseCheck() -- 메뉴 마우스 확인
            if store.menu.Visible and (not store.menuMouseEnter) then
                closeMenu();
            end
        end

        local function menuItem(text,layout,func)
            return new("TextButton",{
                Text = "";
                Size = UDim2.new(1,0,0,32);
                Position = UDim2.fromOffset(0,14 + (layout * 32));
                BackgroundTransparency = 1;
                ZIndex = 801;
                MouseButton1Click = function ()
                    if menuClicked then
                        return
                    end
                    menuClicked = true;
                    delay(0.07,closeMenu);
                    func();
                end;
            },{
                new("TextLabel",{
                    TextColor3 = MaterialUI:GetColor("TextColor");
                    TextSize = 10;
                    Text = text;
                    Size = UDim2.fromScale(1,1);
                    Position = UDim2.fromOffset(10,0);
                    BackgroundTransparency = 1;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    ZIndex = 801;
                });
                new("Rippler",{
                    ZIndex = 801;
                });
            });
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

        local function install(id,popupPos,title)
            openInstallWindow(popupPos);
            store.installTitle.Text = title;
            wait(0.9);
            exeCommand("cls");
            local example;
            if type(id) == "table" then
                for _,v in pairs(id) do
                    exeCommand("cls");
                    exeCommand("tcmi install " .. v);
                end
            else
                example = exeCommand("tcmi install " .. id);
            end
            store.installOkButton.Disabled = false;
            store.installOkButton:Ripple(store.installOkButton.AbsolutePosition + (0.5 * store.installOkButton.AbsoluteSize));
            store.installOkButtonSetColor();
            store.installStatus.Disabled = true;
            reloadList();
            if example then
                getExampleDialogRender:render(function ()
                    exeCommand("tcmi getexample");
                end);
            end
        end

        local function uninstall(id,popupPos,title)
            openInstallWindow(popupPos);
            store.installTitle.Text = title;
            wait(0.9);
            exeCommand("cls");
            exeCommand("tcmi uninstall " .. id);
            store.installOkButton.Disabled = false;
            store.installOkButton:Ripple(store.installOkButton.AbsolutePosition + (0.5 * store.installOkButton.AbsoluteSize));
            store.installOkButtonSetColor();
            store.installStatus.Disabled = true;
            reloadList();
        end

        local listItems = {};
        local function listItem(id,data)
            if data.visible == false then
                return;
            end

            local isInstalled = installer:isInstalled(id);
            local lastVersion = data.publishVersion;
            local item = listItems[id] or itemRender(id,data,MaterialUI,lang);

            local function openThisInfo()
                openInfo(id,data);
            end
            if store.infoId == id then
                openThisInfo();
            end

            if isInstalled and lastVersion == isInstalled.Value then
                item.InstallIcon.Visible = false;
                item.UpdateIcon.Visible = false;
                item.UninstallIcon.Visible = true;
                item.this.Parent = store.installed;
            elseif isInstalled then
                item.InstallIcon.Visible = false;
                item.UpdateIcon.Visible = true;
                item.UninstallIcon.Visible = true;
                item.this.Parent = store.outdated;
            else
                item.InstallIcon.Visible = true;
                item.UpdateIcon.Visible = false;
                item.UninstallIcon.Visible = false;
                item.this.Parent = store.list;
            end

            if not listItems[id] then
                item.InstallIcon.MouseButton1Click:Connect(function ()
                    install(id,item.InstallIcon.AbsolutePosition,lang("onInstalling"));
                end);
                item.UninstallIcon.MouseButton1Click:Connect(function ()
                    uninstall(id,item.InstallIcon.AbsolutePosition,lang("onUninstalling"));
                end);
                item.UpdateIcon.MouseButton1Click:Connect(function ()
                    install(id,item.InstallIcon.AbsolutePosition,lang("onUpdateing"));
                end);
                item.InfoIcon.MouseButton1Click:Connect(openThisInfo);
                item.showMore.MouseButton1Click:Connect(openThisInfo);
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
            local outupdateList = {};
            store.outupdateList = outupdateList;
            for id,v in pairs(moduleData) do
                local isInstalled = installer:isInstalled(id);
                local lastVersion = v.publishVersion;
                if isInstalled and isInstalled.Value ~= lastVersion then
                    table.insert(outupdateList,id);
                end
            end

            local lenList = #outupdateList;
            if lenList ~= 0 then
                store.outupdatePromptText.Text = lang("outupdatePromptText",{count = tostring(lenList)});
                store.outupdatePrompt.ClipsDescendants = false;
                AdvancedTween:RunTween(store.outupdatePrompt,{
                    Time = 0.48;
                    Easing = AdvancedTween.EasingFunctions.Exp2;
                    Direction = AdvancedTween.EasingDirection.Out;
                },{
                    Size = UDim2.new(1,0,0,outupdatePromptSizeY);
                });
            else
                store.outupdatePrompt.ClipsDescendants = true;
                AdvancedTween:RunTween(store.outupdatePrompt,{
                    Time = 0.48;
                    Easing = AdvancedTween.EasingFunctions.Exp2;
                    Direction = AdvancedTween.EasingDirection.Out;
                },{
                    Size = UDim2.fromScale(1,0);
                });
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

        local function closeSettings()
            AdvancedTween:RunTween(store.settingsHolder,{
                Time = 0.4;
                Easing = AdvancedTween.EasingFunctions.Exp2;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                Position = UDim2.fromScale(0,1);
            });
            AdvancedTween:RunTween(store.settingsScreen,{
                Time = 0.5;
                Easing = AdvancedTween.EasingFunctions.Linear;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                BackgroundTransparency = 1;
            },function ()
                store.settingsScreen.Visible = false;
            end);
        end

        local function openSettings()
            AdvancedTween:StopTween(store.settingsHolder);
            store.settingsHolder.Size = UDim2.fromScale(1,0);
            store.settingsHolder.Position = UDim2.fromScale(0,1);
            AdvancedTween:RunTween(store.settingsHolder,{
                Time = 0.7;
                Easing = AdvancedTween.EasingFunctions.Exp2;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                Size = UDim2.fromScale(1,1);
            });
            AdvancedTween:RunTween(store.settingsHolder,{
                Time = 0.5;
                Easing = AdvancedTween.EasingFunctions.Exp2Max4;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                Position = UDim2.fromScale(0,0);
            });

            AdvancedTween:StopTween(store.settingsScreen);
            store.settingsScreen.BackgroundTransparency = 1;
            store.settingsScreen.Visible = true;
            AdvancedTween:RunTween(store.settingsScreen,{
                Time = 0.2;
                Easing = AdvancedTween.EasingFunctions.Linear;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                BackgroundTransparency = 0.68;
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
                    this:GetPropertyChangedSignal("ImageTransparency"):Connect(function ()
                        local trans = this.ImageTransparency;
                        for _,v in pairs(this:GetChildren()) do
                            if v:IsA("TextButton") then
                                v.TextLabel.TextTransparency = trans;
                            end
                        end
                    end);
                end;
                Size = UDim2.fromOffset(160,(14*2) + (32*5));
                AnchorPoint = Vector2.new(1,0);
                Position = UDim2.new(1,-6,0,6);
                ZIndex = 801;
                MouseLeave = function ()
                    store.menuMouseEnter = false;
                end;
                MouseEnter = function ()
                    store.menuMouseEnter = true;
                end;
                Visible = false;
            },{
                about = menuItem(lang("aboutButton"),0,function ()
                    openInfo("InstallerPlugin",{
                        info = lang("about",{version = verInfo.version or "unknown"});
                        icon = "";
                        author = "Qwreey";
                    });
                end);
                fetch = menuItem(lang("fetchButton"),1,fetch);
                reload = menuItem(lang("reloadButton"),2,reloadList);
                reloadPlugin = menuItem(lang("reloadPluginButton"),3,render);
                settings = menuItem(lang("settingsButton"),4,openSettings);
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
                    WhenCreated = function (this)
                        store.menuShadow = this;
                    end;
                });
                scale = new("UIScale",{
                    Scale = 1;
                    WhenCreated = function (this)
                        store.menuScale = this;
                    end;
                });
            });
            topbar = new("Frame",{
                BackgroundColor3 = MaterialUI:GetColor("TopBar");
                Size = UDim2.new(1,0,0,tobBarSizeY + tabSizeY);
                ZIndex = 80;
                WhenCreated = function (this)
                    store.header = this;
                end
            },{
                background = new("TextButton",{
                    Text = "";
                    AutoButtonColor = false;
                    BackgroundColor3 = MaterialUI:GetColor("TopBar");
                    ZIndex = 89;
                    Size = UDim2.new(1,0,0,tobBarSizeY);
                });
                shadow = new("ImageLabel",{
                    Image = "rbxassetid://2715137474";
                    Size = UDim2.new(1,0,0,8);
                    Position = UDim2.fromScale(0,1);
                    BackgroundTransparency = 1;
                    ImageColor3 = Color3.fromRGB(0,0,0);
                    ImageTransparency = 0.65;
                });
                --shadow = new("Shadow",{
                --    ZIndex = 80;
                --});
                icon = new("ImageLabel",{
                    Position = UDim2.fromOffset((tobBarSizeY - 28)/2, (tobBarSizeY - 28)/2);
                    Size = UDim2.new(0, 28, 0, 28);
                    ZIndex = 90;
                    BackgroundTransparency = 1;
                    Image = pluginIcon;
                    ImageColor3 = white;
                });
                title = new("TextLabel",{
                    BackgroundTransparency = 1;
                    Position = UDim2.new(0, 42, 0, 0);
                    Size = UDim2.new(1, 0, 0, tobBarSizeY);
                    ZIndex = 90;
                    Font = Enum.Font.SourceSans;
                    Text = "TCM 설치기";
                    TextColor3 = white;
                    TextSize = 18;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    NotTagging = true;
                });
                openMenu = new("IconButton",{
                    Style = MaterialUI.CEnum.IconButtonStyle.WithOutBackground;
                    ZIndex = 90;
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
                ZIndex = 800;
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
                WhenCreated = function (this)
                    store.tabHolder = this;
                end;
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
                    ScrollBarThickness = 3;
                    WhenCreated = function (this)
                        store.listItemHolder = this;
                        -- this:GetPropertyChangedSignal("CanvasPosition"):Connect(function ()
                        --     local CanvasPosY = this.CanvasPosition.Y;
                        --     local lastCanvasPosY = store.lastCanvasPosY;
                        --     if lastCanvasPosY and (not tabTweening) then
                        --         local moved = CanvasPosY - lastCanvasPosY;
                        --         if moved > 0 and (not tabClosed) then
                        --             hideTabs();
                        --         elseif moved < 0 and tabClosed then
                        --             showTabs();
                        --         end
                        --     end
                        --     store.lastCanvasPosY = CanvasPosY;
                        -- end);
                    end;
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
                    outupdatePrompt = new("Frame",{
                        LayoutOrder = 1;
                        BackgroundTransparency = 1;
                        Size = UDim2.fromScale(1,0);
                        WhenCreated = function (this)
                            store.outupdatePrompt = this;
                        end;
                        ClipsDescendants = true;
                    },{
                        text = new("TextLabel",{
                            TextWrapped = true;
                            BackgroundTransparency = 1;
                            Size = UDim2.new(1,-92 -12,1,0);
                            Position = UDim2.fromOffset(12,0);
                            TextSize = 14;
                            TextXAlignment = Enum.TextXAlignment.Left;
                            WhenCreated = function (this)
                                store.outupdatePromptText = this;
                            end;
                            Text = "";
                            Font = globalFont;
                            TextColor3 = MaterialUI:GetColor("TextColor");
                        });
                        updateButton = new("Button",{
                            Icon = "http://www.roblox.com/asset/?id=6031302931";
                            IconVisible = true;
                            IconColor3 = MaterialUI:GetColor("TextColor");
                            TextColor3 = MaterialUI:GetColor("TextColor");
                            ToolTipText = lang("outupdatePromptButtonToolTip");
                            Style = "Outlined";
                            OutlineColor3 = MaterialUI:GetColor("TextColor");
                            ToolTipVisible = true;
                            Text = lang("outupdatePromptButton");
                            Size = UDim2.new(0,92,0,32);
                            Position = UDim2.fromScale(1,0.5);
                            AnchorPoint = Vector2.new(1,0.5);
                            ToolTipBackgroundColor3 = MaterialUI.CurrentTheme == "Dark" and Color3.fromRGB(255,255,255) or Color3.fromRGB(38,38,38);
                            ToolTipTextColor3 = MaterialUI.CurrentTheme == "Dark" and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255);
                            WhenCreated = function (this)
                                local ToolTip = this:GetRealInstance().ToolTip;
                                ToolTip.Position = UDim2.new(1,0,1,6);
                                ToolTip.AnchorPoint = Vector2.new(1,0);
                                ToolTip.ZIndex = 98;
                                ToolTip.TextLabel.ZIndex = 98;
                                this.MouseButton1Click:Connect(function ()
                                    install(store.outupdateList,this.AbsolutePosition + (this.AbsoluteSize * 0.5),lang("onUpdateing"));
                                end);
                            end;
                        });
                    });
                    outdated = makeListPage("outdated","Outdated",0);
                    installed = makeListPage("installed","Installed",2);
                    list = makeListPage("list","Store",3);
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
            infoScreen = new("TextButton",{
                Size = UDim2.fromScale(1,1);
                ZIndex = 100;
                BackgroundColor3 = Color3.fromRGB(0,0,0);
                BackgroundTransparency = 0.68;
                AutoButtonColor = false;
                Text = "";
                Visible = false;
                WhenCreated = function (this)
                    store.infoScreen = this;
                end;
                MouseWheelBackward = function()
                    if getInfoPos() < 0.01 then
                        return;
                    end
                    moveInfo(0.2);
                end;
                MouseWheelForward = function()
                    if getInfoPos() < 0.01 then
                        return;
                    end
                    moveInfo(-0.2);
                end;
                MouseButton1Down = function ()
                    closeInfo();
                end;
                MouseButton1Up = function ()
                    infoMouseDown = false;
                    moveInfo();
                end;
                MouseLeave = function ()
                    infoMouseDown = false;
                    moveInfo();
                end;
                MouseMoved = function (_,y)
                    local InfoPos = getInfoPos()
                    if infoMouseDown and infoIsOpen and InfoPos > 0.01 then
                        y = y / uiHolder.AbsoluteSize.Y;
                        moveInfo(y - InfoPos);
                    end
                end;
            },{
                infoHolder = new("ImageButton",{
                    Size = UDim2.new(1,0,1,44);
                    BackgroundTransparency = 1;
                    ImageColor3 = MaterialUI:GetColor("Background");
                    ZIndex = 100;
                    Position = UDim2.fromScale(0,0.5);
                    WhenCreated = function (this)
                        store.infoHolder = this;
                        MaterialUI:SetRound(this,24);
                    end;
                    MouseButton1Up = function ()
                        infoMouseDown = false;
                        moveInfo();
                    end;
                    MouseButton1Down = function ()
                        infoMouseDown = true;
                    end;
                },{
                    shadow = new("ImageLabel",{
                        AnchorPoint = Vector2.new(0.5, 0);
                        BackgroundTransparency = 1;
                        BorderSizePixel = 0;
                        Position = UDim2.new(0.5, 0, 0, -8);
                        Size = UDim2.new(1, 22, 0, 280);
                        ZIndex = 99;
                        Image = "rbxassetid://1316045217";
                        ImageColor3 = Color3.fromRGB(0, 0, 0);
                        ImageTransparency = 0.71;
                    });
                    bar = new("TextButton",{
                        Position = UDim2.fromOffset(0,12);
                        Size = UDim2.new(1,0,0,52);
                        BackgroundTransparency = 1;
                        ZIndex = 100;
                        AnchorPoint = Vector2.new(0,1);
                        Text = lang("scrollToOpen");
                        TextColor3 = Color3.fromRGB(255,255,255);
                        AutoButtonColor = false;
                        Font = globalFont;
                        TextSize = 16;
                        MouseButton1Up = function ()
                            infoMouseDown = false;
                            moveInfo();
                        end;
                        MouseButton1Down = function ()
                            infoMouseDown = true;
                        end;
                    },{
                        icon = new("ImageLabel",{
                            ZIndex = 100;
                            Size = UDim2.fromOffset(120,4);
                            Position = UDim2.fromScale(0.5,1);
                            AnchorPoint = Vector2.new(0.5,1);
                            BackgroundTransparency = 1;
                            ImageColor3 = MaterialUI:GetColor("TextColor");
                            WhenCreated = function (this)
                                MaterialUI:SetRound(this,128);
                            end;
                            ImageTransparency = 0.42;
                        });
                    });
                    header = new("Frame",{
                        Size = UDim2.new(1,0,0,42);
                        Position = UDim2.fromOffset(0,24);
                        ZIndex = 100;
                        BackgroundTransparency = 1;
                    },{
                        back = new("IconButton",{
                            Size = UDim2.fromOffset(36,36);
                            Icon = "http://www.roblox.com/asset/?id=6031091000";
                            Position = UDim2.new(0,(42-36)/2,0.5,0);
                            AnchorPoint = Vector2.new(0,0.5);
                            IconColor3 = MaterialUI:GetColor("TextColor");--Color3.fromRGB(255,255,255);
                            ZIndex = 100;
                            IconSizeScale = 0.82;
                            Style = "WithOutBackground";
                            MouseButton1Click = closeInfo;
                        });
                        title = new("TextLabel",{
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BackgroundTransparency = 1;
                            Font = globalFont;
                            TextSize = 17;
                            Text = lang("information");
                            Size = UDim2.fromScale(1,1);
                            Position = UDim2.new(0,36 + 8,0.5,0);
                            AnchorPoint = Vector2.new(0,0.5);
                            ZIndex = 100;
                            TextColor3 = MaterialUI:GetColor("TextColor");--Color3.fromRGB(255,255,255);
                        });
                        shadow = new("ImageLabel",{
                            ZIndex = 101;
                            Image = "rbxassetid://2715137474";
                            Size = UDim2.new(1,0,0,12);
                            Position = UDim2.fromScale(0,1);
                            BackgroundTransparency = 1;
                            ImageColor3 = Color3.fromRGB(0,0,0);
                            ImageTransparency = 1;
                            WhenCreated = function (this)
                                store.infoHeaderShadow = this;
                            end;
                        });
                    });
                    scroll = new("ScrollingFrame",{
                        Size = UDim2.new(1,0,1,-68-24);
                        Position = UDim2.fromOffset(0,68);
                        BackgroundTransparency = 1;
                        ScrollingEnabled = false;
                        ZIndex = 100;
                        ScrollBarThickness = 3;
                        ScrollBarImageColor3 = MaterialUI:GetColor("TextColor3");
                        WhenCreated = function (this)
                            store.infoScroll = this;
                        end;
                    },{
                        head = new("Frame",{
                            Size = UDim2.new(1,0,0,130);
                            BackgroundTransparency = 1;
                            ZIndex = 100;
                        },{
                            text = new("TextLabel",{
                                ZIndex = 100;
                                BackgroundTransparency = 1;
                                TextSize = 18;
                                Font = Enum.Font.GothamBold;
                                Text = "Title";
                                TextXAlignment = Enum.TextXAlignment.Left;
                                Size = UDim2.new(1,-132,0,38);
                                Position = UDim2.fromOffset(132,6);
                                TextColor3 = MaterialUI:GetColor("TextColor");
                                WhenCreated = function (this)
                                    store.infoTitle = this;
                                end;
                            });
                            author = new("TextLabel",{
                                ZIndex = 100;
                                BackgroundTransparency = 1;
                                TextSize = 15;
                                Font = globalFont;
                                Text = "by ";
                                TextXAlignment = Enum.TextXAlignment.Left;
                                Size = UDim2.new(1,-132,0,38);
                                Position = UDim2.fromOffset(132,34);
                                TextColor3 = MaterialUI:GetColor("TextColor");
                                TextTransparency = 0.62;
                                WhenCreated = function (this)
                                    store.infoAuthor = this;
                                end;
                            });
                            install = new("Button",{
                                TextColor3 = MaterialUI:GetColor("TextColor");
                                ZIndex = 100;
                                Style = "Outlined";
                                OutlineColor3 = MaterialUI:GetColor("TextColor");
                                Size = UDim2.new(0,58,0,32);
                                Text = lang("infoInstall");
                                Position = UDim2.fromOffset(132,76);
                                WhenCreated = function(this)
                                    store.infoInstall = this;
                                    this.MouseButton1Click:Connect(function ()
                                        install(store.infoId,this.AbsolutePosition + (this.AbsoluteSize * 0.5),lang("onInstalling"));
                                    end);
                                end;
                            });
                            uninstall = new("Button",{
                                TextColor3 = MaterialUI:GetColor("TextColor");
                                ZIndex = 100;
                                Style = "Outlined";
                                OutlineColor3 = MaterialUI:GetColor("TextColor");
                                Size = UDim2.new(0,58,0,32);
                                Text = lang("infoUninstall");
                                Position = UDim2.fromOffset(132,76);
                                WhenCreated = function(this)
                                    store.infoUninstall = this;
                                    this.MouseButton1Click:Connect(function ()
                                        uninstall(store.infoId,this.AbsolutePosition + (this.AbsoluteSize * 0.5),lang("onUninstalling"));
                                    end);
                                end;
                            });
                            update = new("Button",{
                                TextColor3 = MaterialUI:GetColor("TextColor");
                                ZIndex = 100;
                                Style = "Outlined";
                                OutlineColor3 = MaterialUI:GetColor("TextColor");
                                Size = UDim2.new(0,58,0,32);
                                Text = lang("infoUpdate");
                                Position = UDim2.fromOffset(132 + 58 + 6,76);
                                WhenCreated = function(this)
                                    store.infoUpdate = this;
                                    this.MouseButton1Click:Connect(function ()
                                        install(store.infoId,this.AbsolutePosition + (this.AbsoluteSize * 0.5),lang("onUpdateing"));
                                    end);
                                end;
                            });
                            icon = new("ImageLabel",{
                                Position = UDim2.fromOffset(5,5);
                                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                                Size = UDim2.new(0, 110, 0, 110);
                                ZIndex = 101;
                                WhenCreated = function (this)
                                    store.infoIcon = this;
                                end;
                            },{
                                round = new("UICorner",{
                                });
                                shadow = new("ImageLabel",{
                                    AnchorPoint = Vector2.new(0.5, 0);
                                    ZIndex = 100;
                                    BackgroundTransparency = 1;
                                    BorderSizePixel = 0;
                                    Position = UDim2.new(0.5, 0, 0, -3);
                                    Size = UDim2.new(1, 8, 1, 10);
                                    Image = "rbxassetid://1316045217";
                                    ImageColor3 = Color3.fromRGB(0, 0, 0);
                                    ImageTransparency = MaterialUI.CurrentTheme == "Dark" and 0.8 or 0.92;
                                });
                            });
                        });
                        info = new("TextBox",{
                            Size = UDim2.new(1,0,0,15+16+12+2);
                            TextEditable = false;
                            ClearTextOnFocus = false;
                            LayoutOrder = 1;
                            ZIndex = 100;
                            Text = "";
                            TextXAlignment = Enum.TextXAlignment.Left;
                            TextYAlignment = Enum.TextYAlignment.Top;
                            TextSize = 15;
                            TextWrapped = true;
                            Font = globalFont;
                            BackgroundTransparency = 1;
                            TextColor3 = MaterialUI:GetColor("TextColor");
                            WhenCreated = function (this)
                                this.MouseWheelForward:Connect(function ()
                                    if this:IsFocused() then
                                        scrollInfoHolder(-1);
                                    end
                                end);
                                this.MouseWheelBackward:Connect(function ()
                                    if this:IsFocused() then
                                        scrollInfoHolder(1);
                                    end
                                end);
                                store.infoText = this;
                                this:GetPropertyChangedSignal("TextBounds"):Connect(function ()
                                    this.Size = UDim2.new(1,0,0,this.TextBounds.Y+16+12+2);
                                end);
                            end;
                        },{
                            new("UIPadding",{
                                PaddingLeft = UDim.new(0,12);
                                PaddingRight = UDim.new(0,12);
                                PaddingTop = UDim.new(0,12);
                            });
                        });
                        new("UIListLayout",{
                            WhenCreated = function (this)
                                this:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function ()
                                    this.Parent.CanvasSize = UDim2.fromOffset(0,this.AbsoluteContentSize.Y);
                                end);
                            end;
                        });
                    });
                });
            });
            settingsScreen = new("TextButton",{
                Size = UDim2.fromScale(1,1);
                Visible = false;
                Text = "";
                AutoButtonColor = true;
                BackgroundTransparency = 0.68;
                BackgroundColor3 = Color3.fromRGB(0,0,0);
                ZIndex = 1200;
                WhenCreated = function (this)
                    store.settingsScreen = this;
                end;
            },{
                settingsHolder = new("Frame",{
                    BackgroundColor3 = MaterialUI:GetColor("Background");
                    Size = UDim2.fromScale(1,0);
                    WhenCreated = function (this)
                        store.settingsHolder = this;
                    end;
                    ZIndex = 1200;
                },{
                    header = new("Frame",{
                        Size = UDim2.new(1,0,0,42);
                        ZIndex = 1200;
                        BackgroundColor3 = MaterialUI:GetColor("TopBar");
                    },{
                        shadow = new("ImageLabel",{
                            Image = "rbxassetid://2715137474";
                            Size = UDim2.new(1,0,0,8);
                            Position = UDim2.fromScale(0,1);
                            BackgroundTransparency = 1;
                            ImageColor3 = Color3.fromRGB(0,0,0);
                            ImageTransparency = 0.65;
                            ZIndex = 1200;
                        });
                        back = new("IconButton",{
                            Size = UDim2.fromOffset(36,36);
                            Icon = "http://www.roblox.com/asset/?id=6031091000";
                            Position = UDim2.new(0,(42-36)/2,0.5,0);
                            AnchorPoint = Vector2.new(0,0.5);
                            IconColor3 = MaterialUI:GetColor("TextColor");--Color3.fromRGB(255,255,255);
                            ZIndex = 1200;
                            IconSizeScale = 0.82;
                            Style = "WithOutBackground";
                            MouseButton1Click = closeSettings;
                        });
                        title = new("TextLabel",{
                            TextXAlignment = Enum.TextXAlignment.Left;
                            BackgroundTransparency = 1;
                            Font = globalFont;
                            TextSize = 17;
                            Text = lang("settings");
                            Size = UDim2.fromScale(1,1);
                            Position = UDim2.new(0,36 + 8,0.5,0);
                            AnchorPoint = Vector2.new(0,0.5);
                            ZIndex = 1200;
                            TextColor3 = MaterialUI:GetColor("TextColor");--Color3.fromRGB(255,255,255);
                        });
                    });
                    shadow = new("Shadow");
                });
            });
            search = new("Frame",{
                
            });
        });

        local infoHeaderShadowTransparency = MaterialUI.CurrentTheme == "Dark" and 0.66 or 0.75;
        store.infoScroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function ()
            AdvancedTween:RunTween(store.infoHeaderShadow,{
                Time = 0.2;
                Easing = AdvancedTween.EasingFunctions.Exp2;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                ImageTransparency = store.infoScroll.CanvasPosition.Y <= 10 and 1 or infoHeaderShadowTransparency;
            });
        end);

        -- 터미널 창을 가져옴
        termTCM.uiHost.holder.Parent = store.holder;
        termTCM.uiHost.holder.Position = UDim2.fromScale(0.5,0);
        termTCM.uiHost.holder.Size = UDim2.fromScale(0.5,1);
        termTCM.uiHost.TextScreen.TextColor3 = MaterialUI:GetColor("TextColor");

        local saveConnection;
        killRender = function () -- 렌더 해제하는 함수 지정
            saveConnection:Disconnect();
            data:Save("listItemHolder_scrollPos",store.listItemHolder.CanvasPosition.Y);
            data:Save("lastInfoId",infoIsOpen and store.infoId);
            pcall(function ()
                if mouse and mouse.Obj then -- 마우스가 있으면 지움
                    mouse.Obj:Destroy();
                end
                termTCM.uiHost.holder.Parent = plugin; -- termTCM 을 옮김
                MaterialUI:CleanUp(); -- 한번 싹 클린업함
                termTCM.output("-----------------Reload-----------------");
            end);
            store = nil;
        end;
        saveConnection = plugin.Unloading:Connect(killRender);

        if (not game:GetService("ServerStorage"):FindFirstChild("nofairTCM_Server"))
        or (not game:GetService("ServerScriptService"):FindFirstChild("nofairTCM_ServerInit"))
        or (not game:GetService("ReplicatedStorage"):FindFirstChild("nofairTCM_Client"))
        or (not game:GetService("ReplicatedFirst"):FindFirstChild("nofairTCM_ClientInit")) then
            local initButton;
            local frame = new("Frame",{
                Parent = store.holder;
                BackgroundTransparency = 1;
                Size = UDim2.fromScale(0.5,1);
            },{
                text = new("TextLabel",{
                    TextWrapped = true;
                    Text = lang("initYet");
                    BackgroundTransparency = 1;
                    TextColor3 = MaterialUI:GetColor("TextColor");
                    Size = UDim2.new(1,0,0,50);
                    Position = UDim2.new(0.5,0,0.5,-34);
                    AnchorPoint = Vector2.new(0.5,0.5);
                    TextSize = 16;
                    Font = globalFont;
                });
                initButton = new("Button",{
                    Style = "Outlined";
                    Position = UDim2.new(0.5,0,0.5,18);
                    AnchorPoint = Vector2.new(0.5,0.5);
                    Size = UDim2.fromOffset(82,38);
                    Text = lang("init");
                    OutlineColor3 = MaterialUI:GetColor("TextColor");
                    TextColor3 = MaterialUI:GetColor("TextColor");
                    WhenCreated = function (this)
                        initButton = this;
                    end;
                });
            });
            initButton.MouseButton1Click:Wait();
            exeCommand("tcmi init");
            initButton:Destroy();
            frame:Destroy();
        end
        reloadList();
        delay(0.22,function ()
            AdvancedTween:RunTween(store.listItemHolder,{
                Time = 0.18;
                Easing = AdvancedTween.EasingFunctions.Exp2;
                Direction = AdvancedTween.EasingDirection.Out;
            },{
                CanvasPosition = Vector2.new(0,data:ForceLoad("listItemHolder_scrollPos") or 0);
            });

            local lastInfoId = data:ForceLoad("lastInfoId");
            local lastInfoData = moduleData and moduleData[lastInfoId];
            if lastInfoId and lastInfoData and lastInfoId ~= "InstallerPlugin" then
                openInfo(lastInfoId,lastInfoData);
            end
            if splashScreen then
                splashScreen:setStatus("load plugin data");
                wait(0.12);
                splashScreen:close();
                splashScreen = nil;
                termTCM.output("Plugin Core : loaded!\n----------------------------------------\n\n");
                -- 만약 플러그인이 업데이트가 필요하면 확인창을 띄워줌
                if showUpdateDialog then
                    showUpdateDialog = false;
                    pluginUpdateDialogRender:render(); -- 다이어로그 렌더러를 부름
                end
            end
        end);
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
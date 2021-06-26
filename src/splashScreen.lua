
--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-11 18:57:26
    # Modified by   : Qwreey
    # Modified time : 2021-06-26 18:44:53
    # Description   : |
        Time format = yyy-mm-dd hh:mm:ss
        Time zone = GMT+9

        스플레시 스크린을 구성합니다
  ]]

local module = {};

function module:setMaterialUI(MaterialUI)
    self.MaterialUI = MaterialUI;
    return self;
end

function module:setAdvancedTween(AdvancedTween)
    self.AdvancedTween = AdvancedTween;
    return self;
end

function module:setUIHolder(UIHolder)
    self.UIHolder = UIHolder;
    return self;
end

function module:setPluginIcon(pluginIcon)
    self.pluginIcon = pluginIcon;
    return self;
end

function module:setVersion(version)
    self.version = version;
    return self;
end

function module:setTermTCM(termTCM)
    self.termTCM = termTCM;
    return self;
end

local time = 0.28;
function module:render()
    local UIHolder,pluginIcon,version,termTCM,MaterialUI,AdvancedTween = self.UIHolder,self.pluginIcon,self.version,self.termTCM,self.MaterialUI,self.AdvancedTween;
    local new = MaterialUI.Create;
    MaterialUI.CurrentTheme = tostring(settings().Studio.Theme);

    local tweenData = {
        Easing = AdvancedTween.EasingFunctions.Linear;
        Direction = AdvancedTween.EasingDirection.Out;
        Time = time;
    };

    local store = {};
    new("TextButton",{
        AutoButtonColor = false;
        Text = "";
        WhenCreated = function (this)
            store.this = this;
        end;
        Parent = UIHolder;
        BackgroundColor3 = MaterialUI:GetColor("Background");
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 7000;
        NotTagging = true;
        Name = "splashScreen";
    },{
        icon = new("ImageLabel",{
            AnchorPoint = Vector2.new(0.5, 0.5);
            BackgroundTransparency = 1;
            Position = UDim2.fromScale(0.5,0.5);
            Size = UDim2.fromOffset(52,52);
            Image = pluginIcon;
            ImageColor3 = MaterialUI:GetColor("TextColor");
            ZIndex = 7000;
            NotTagging = true;
            WhenCreated = function (this)
                store.icon = this;
            end;
        });
        verInfo = new("TextLabel",{
            AnchorPoint = Vector2.new(0, 1);
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 2, 1, 0);
            Size = UDim2.new(1, 0, 0, 20);
            Font = Enum.Font.Code;
            Text = tostring(version);
            TextColor3 = Color3.fromRGB(93, 93, 93);
            TextSize = 14;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 7000;
            NotTagging = true;
            WhenCreated = function (this)
                store.ver = this;
            end;
        });
        info = new("TextLabel",{
            Text = "";
            Size = UDim2.new(1,0,0,18);
            WhenCreated = function (this)
                store.info = this;
            end;
            TextColor3 = Color3.fromRGB(93, 93, 93);
            BackgroundTransparency = 1;
            NotTagging = true;
            ZIndex = 7001;
            TextSize = 9;
            AnchorPoint = Vector2.new(0,1);
            Position = UDim2.fromScale(0,1);
        });
    });

    local this = {};
    function this:close()
        if (not store.this) or (not store.this.Parent) then
            return;
        end
        AdvancedTween:RunTween(store.this,tweenData,{
            BackgroundTransparency = 1;
        });
        AdvancedTween:RunTweens({store.info,store.ver},tweenData,{
            TextTransparency = 1;
        });
        AdvancedTween:RunTween(store.icon,tweenData,{
            ImageTransparency = 1;
        });
        delay(time+0.1,function ()
            store.this:Destroy();
        end);
    end

    function this:setStatus(str)
        local info = store.info;
        if (not info) or (not info.Parent) then
            return;
        end
        info.Text = str;
        termTCM.output("Plugin Core : " .. str .. "\n");
        wait();
    end

    return this;
end

return module;

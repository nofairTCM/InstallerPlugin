---@diagnostic disable:undefined-global
local time = 0.28;
return function (UIHolder,pluginIcon,version,termTCM)
    local MaterialUI = require(script.Parent.Parent.libs.MaterialUI);
    local AdvancedTween = require(script.Parent.Parent.libs.AdvancedTween);
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
            Position = UDim2.new(0.5, 0, 0.5, -30);
            Size = UDim2.new(0, 60, 0, 60);
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
        infoHolder = new("Frame",{
            Size = UDim2.new(1,0,0,32);
            BackgroundTransparency = 1;
            Position = UDim2.new(0,0,0.5,32);
            AnchorPoint = Vector2.new(0,0.5);
            NotTagging = true;
            ZIndex = 7001;
        },{
            ls = new("UIListLayout",{
                FillDirection = Enum.FillDirection.Horizontal;
                HorizontalAlignment = Enum.HorizontalAlignment.Center;
                VerticalAlignment = Enum.VerticalAlignment.Center;
                NotTagging = true;
                Padding = UDim.new(0,8);
            });
            circle = new("IndeterminateCircle",{
                Disabled = false;
                Size = UDim2.fromOffset(22,22);
                Position = UDim2.new(0.5,0,0.5,32);
                AnchorPoint = Vector2.new(0.5,0.5);
                ZIndex = 7001;
                NotTagging = true;
                WhenCreated = function (this)
                    store.circle = this;
                end;
            });
            info = new("TextLabel",{
                Text = "";
                Size = UDim2.new(0,0,1,0);
                TextColor3 = MaterialUI:GetColor("TextColor");
                TextTransparency = 0.2;
                WhenCreated = function (this)
                    store.info = this;
                end;
                BackgroundTransparency = 1;
                NotTagging = true;
                ZIndex = 7001;
            });
        });
    });

    local this = {};
    function this:close()
        if (not store.this) or (not store.this.Parent) then
            return;
        end
        store.circle.Disabled = true;
        AdvancedTween:RunTween(store.this,tweenData,{
            BackgroundTransparency = 1;
        });
        AdvancedTween:RunTweens({store.info,store.ver},tweenData,{
            TextTransparency = 1;
        });
        AdvancedTween:RunTweens({store.icon,store.circle:GetRealInstance().Holder},tweenData,{
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
        info.Size = UDim2.new(0,info.TextBounds.X,1,0);
        termTCM.output("Plugin Core : " .. str .. "\n");
        wait();
    end

    return this;
end;
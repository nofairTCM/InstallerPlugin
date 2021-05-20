
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

function module:render()
    local UIHolder,MaterialUI,AdvancedTween = self.UIHolder,self.MaterialUI,self.MaterialUI;
    local new = MaterialUI.Create;

    local openScale  = 1;
    local closeScale = 0.75;

    local openPosition = UDim2.fromScale(0.5,0.5);
    local closePosition = UDim2.fromScale(0.5,1);

    local closeAnchorPoint = Vector2.new(0.5,0);
    local openAnchorPoint = Vector2.new(0.5,0.5);

    local openBackgroundTransparency = 0.6;
    local closeBackgroundTransparency = 1;

    local store = {};

    local backgroundTrans = {
        Time = 0.48;
        Easing = AdvancedTween.EasingFunctions.Linear;
        Direction = AdvancedTween.EasingDirection.Out;
    };
    local popupTrans = {
        Time = 0.6;
        Easing = AdvancedTween.EasingFunctions.Exp2;
        Direction = AdvancedTween.EasingDirection.Out;
    };

    local function open()
        AdvancedTween:StopTween(store.this);
        AdvancedTween:StopTween(store.popup);
        AdvancedTween:StopTween(store.scale);
        store.this.BackgroundTransparency = closeBackgroundTransparency;
        AdvancedTween:RunTween(store.this,backgroundTrans,{
            BackgroundTransparency = openBackgroundTransparency;
        });
        store.popup.Position = closePosition;
        store.popup.AnchorPoint = closeAnchorPoint;
        AdvancedTween:RunTween(store.popup,popupTrans,{
            Position = openPosition;
            AnchorPoint = openAnchorPoint;
        });
        store.scale.Scale = closeScale;
        AdvancedTween:RunTween(store.scale,popupTrans,{
            Scale = openScale;
        });
    end

    local function close()
        AdvancedTween:StopTween(store.this);
        AdvancedTween:StopTween(store.popup);
        AdvancedTween:StopTween(store.scale);
        store.this.BackgroundTransparency = openBackgroundTransparency;
        AdvancedTween:RunTween(store.this,backgroundTrans,{
            BackgroundTransparency = closeBackgroundTransparency;
        });
        store.popup.Position = openPosition;
        store.popup.AnchorPoint = openAnchorPoint;
        AdvancedTween:RunTween(store.popup,popupTrans,{
            Position = closePosition;
            AnchorPoint = closeAnchorPoint;
        });
        store.scale.Scale = openScale;
        AdvancedTween:RunTween(store.scale,popupTrans,{
            Scale = closeScale;
        });
        delay(0.7,function()
            store.this:Destroy();
        end);
    end

    new("Frame",{
        Parent = UIHolder;
        Name = "UpdatePluginPopup";
        Size = UDim2.fromScale(1,1);
        ZIndex = 10000;
        BackgroundColor3 = Color3.fromRGB(0,0,0);
        BackgroundTransparency = closeBackgroundTransparency;
        WhenCreated = function (this)
            store.this = this;
        end;
    },{
        popup = new("ImageLabel",{
            AnchorPoint = closeAnchorPoint;
            Position = closePosition;
            ImageColor3 = MaterialUI:GetColor("Background");
            WhenCreated = function (this)
                MaterialUI:SetRound(this,8);
                store.popup = this;
            end;
            Size = UDim2.fromOffset(246,158);
        },{
            scale = new("UIScale",{
                Scale = closeScale;
                WhenCreated = function (this)
                    store.scale = this;
                end;
            });
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
    });

    return {
        open = open;
        close = close;
    };
end

return module;

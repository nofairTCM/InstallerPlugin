
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

    local closeScale = 0.75;
    local openScale  = 1;

    local openPosition = UDim2.fromScale(0.5,0.5);
    local closePosition = UDim2.fromScale(0.5,1);

    local closeAnchorPoint = Vector2.new(0.5,0);
    local openAnchorPoint = Vector2.new(0.5,0.5);

    local openBackgroundTransparency = 0.6;
    local closeBackgroundTransparency = 1;

    local store = {};

    local function open()
        store.this.BackgroundTransparency = closeBackgroundTransparency;
        AdvancedTween:RunTween(store.this,{
            Time = 0.6;
            Easing = AdvancedTween.EasingFunctions.Linear;
            Direction = AdvancedTween.EasingDirection.Out;
        },{
            BackgroundTransparency = openBackgroundTransparency;
        });
    end

    local function close()

    end

    new("Frame",{
        Name = "UpdatePluginPopup";
        Size = UDim2.fromScale(1,1);
        ZIndex = 10000;
        BackgroundColor3 = Color3.fromRGB(0,0,0);
        BackgroundTransparency = 0.6;
        WhenCreated = function (this)
            store.this = this;
        end;
    },{
        popup = new("ImageLabel",{
            AnchorPoint = Vector2.new(0.5,0.5);
            Position = UDim2.fromScale(0.5,0.5);
            ImageColor3 = MaterialUI:GetColor("Background");
            WhenCreated = function (this)
                MaterialUI:SetRound(this,8);
            end;
            Size = UDim2.fromOffset(246,158);
        },{
            scale = new("UIScale",{
                Scale = 0.75;
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
end

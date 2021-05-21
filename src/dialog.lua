
--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-21 19:34:57
    # Modified by   : Qwreey
    # Modified time : 2021-05-21 21:36:56
    # Description   : |
        Time format = yyy-mm-dd hh:mm:ss
        Time zone = GMT+9

        다이어로그를 위한 기틀을 만듭니다
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

-- data
--  |- openPosition : 열리는 위치
--  |- closePosition : 닫히는 위치
--  |
--  |- openAnchorPoint : 열리는 앵커 포인트
--  |- closeAnchorPoint : 닫히는 앵커 포인트
--  |
--  |- openBackgroundTransparency : 열리는 투명도
--  |- closeBackgroundTransparency : 닫히는 투명도
--  |
--  |- openScale : 열리는 크기 스캐일
--  |- closeScale : 닫히는 크기 스캐일
--  |
--  |- size : 팝업 크기
--
-- return :
--    {
--        open = open; -- 여는 함수
--        close = close; -- 닫는 함수 (닫고 난 뒤 자동 폐기)
--        holder = store.popup; -- 팝업 아이템 들어가는곳
--    };
function module:render(data)
    local data = data or {};
    local UIHolder,MaterialUI,AdvancedTween = self.UIHolder,self.MaterialUI,self.AdvancedTween;
    local new = MaterialUI.Create;

    local openScale  = data.openScale or 1;
    local closeScale = data.closeScale or 0.75;

    local openPosition = data.openPosition or UDim2.fromScale(0.5,0.5);
    local closePosition = data.closePosition or UDim2.fromScale(0.5,1);

    local closeAnchorPoint = data.closeAnchorPoint or Vector2.new(0.5,0);
    local openAnchorPoint = data.openAnchorPoint or Vector2.new(0.5,0.5);

    local openBackgroundTransparency = data.openBackgroundTransparency or 0.7;
    local closeBackgroundTransparency = data.closeBackgroundTransparency or 1;

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

    new("TextButton",{
        Parent = UIHolder;
        Name = "UpdatePluginPopup";
        Size = UDim2.fromScale(1,1);
        ZIndex = 799;
        BackgroundColor3 = Color3.fromRGB(0,0,0);
        BackgroundTransparency = closeBackgroundTransparency;
        Text = "";
        AutoButtonColor = false;
        WhenCreated = function (this)
            store.this = this;
        end;
    },{
        popup = new("ImageLabel",{
            AnchorPoint = closeAnchorPoint;
            BackgroundTransparency = 1;
            Position = closePosition;
            ImageColor3 = MaterialUI:GetColor("Background");
            WhenCreated = function (this)
                MaterialUI:SetRound(this,8);
                store.popup = this;
            end;
            Size = data.size or UDim2.fromOffset(246,158);
            ZIndex = 800;
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
                ZIndex = 799;
                Image = "rbxassetid://1316045217";
                ImageColor3 = Color3.fromRGB(0, 0, 0);
                ImageTransparency = 0.71;
            });
        });
    });

    return {
        open = open;
        close = close;
        holder = store.popup;
        background = store.this;
    };
end

return module;

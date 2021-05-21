
--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-18 18:59:18
    # Modified by   : Qwreey
    # Modified time : 2021-05-21 21:42:03
    # Description   : |
        Time format = yyy-mm-dd hh:mm:ss
        Time zone = GMT+9

        플러그인 업데이트가 있을 때 뜨는 다이어로그를 만듭니다
        * 이스터에그 : 여러분은 git 플로우 쓸 때 브런치 확인 똑바로 하고 에딧 합시다,,, 그림 그릴 때 배경 레이어에서 색칠중인거랑 똑같은짓
  ]]

local module = {};

function module:setDialog(dialog)
    self.dialog = dialog;
    return self;
end

function module:setMaterialUI(MaterialUI)
    self.MaterialUI = MaterialUI;
    return self;
end

function module:setAdvancedTween(AdvancedTween)
    self.AdvancedTween = AdvancedTween;
    return self;
end

local padding = UDim.new();
local globalFont = Enum.Font.Gotham;

function module:render()
    local dialog,MaterialUI,AdvancedTween = self.dialog,self.MaterialUI,self.AdvancedTween;
    local new = MaterialUI.Create;

    local thisDialog = dialog:render {
        size = UDim2.fromOffset(246,158);
    };
    thisDialog.open();
    local holder = thisDialog.holder;

    local padding = UDim.new(0,10);
    new("UIPadding",{ -- 내부 padding
        Name = "padding";
        Parent = holder;
        PaddingBottom = padding;
        PaddingLeft = padding;
        PaddingRight = padding;
        PaddingTop = padding;
    });

    new("Button",{ -- 무시 버튼
        Name = "ignoreButton";
        Parent = holder;
        Style = MaterialUI.CEnum.ButtonStyle.Text;
        AnchorPoint = Vector2.new(1,1);
        Position = UDim2.fromScale(1,1);
        Text = "IGNORE";
        Size = UDim2.fromOffset(82,32);
        MouseButton1Click = thisDialog.close;
        ZIndex = 801
    });

    new("TextLabel",{
        Size = UDim2.fromScale(1,1);
        Position = UDim2.fromOffset(10,10);
        BackgroundTransparency = 1;
        Name = "title";
        Text = "Update";
        TextSize = 18;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Top;
        TextColor3 = MaterialUI:GetColor("TextColor");
        Font = globalFont;
        Parent = holder;
        ZIndex = 801
    });

    new("TextLabel",{
        Size = UDim2.new(1,-32,1,-70);
        Position = UDim2.fromOffset(16,38);
        BackgroundTransparency = 1;
        Name = "title";
        Text = "설치기 플러그인의 새로운 버전이 감지되었습니다\n플러그인 관리자에서 플러그인을 업데이트 할 수 있습니다";
        TextWrapped = true;
        TextSize = 15;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Top;
        TextColor3 = MaterialUI:GetColor("TextColor");
        Font = globalFont;
        Parent = holder;
        ZIndex = 801
    });

    return dialog;
end

return module;

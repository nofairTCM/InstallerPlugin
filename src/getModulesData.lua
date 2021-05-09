local HTTP = game:GetService("HttpService");
local Selection = game:GetService("Selection");

return function (ROOT,UIHolder,url)
    local MaterialUI = require(ROOT.Parent.libs.MaterialUI);
    local AdvancedTween = require(ROOT.Parent.libs.AdvancedTween);
    local new = MaterialUI.Create;

    -- 이미 HTTP 서비스가 켜져 있다면 리턴
    local pass,data;
    local function newTry()
            pass,data = pcall(
            HTTP.GetAsync,
            HTTP, -- self 값을 추가해줌
            url
        );
    end
    newTry();

    if pass then
    --    return data;
    end

    local function report()
        local new = new("Frame",{
            Name = "HaveErrorHTTPMain";
            BackgroundColor3 = Color3.fromRGB(45, 45, 45);
            BorderSizePixel = 0;
            Position = UDim2.new(1, 20, 0, 0);
            Size = UDim2.new(1, 0, 1, 0);
            ZIndex = 8100;
        },{
            new("Frame",{
                Name = "topbar";
                BackgroundColor3 = Color3.fromRGB(26, 26, 26);
                BorderSizePixel = 0;
                Size = UDim2.new(1, 0, 0, 46);
                ZIndex = 8109;
            },{
                new("TextLabel",{
                    Name = "title";
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1;
                    Position = UDim2.new(0, 48, 0, 0);
                    Size = UDim2.new(1, 0, 1, 0);
                    ZIndex = 8109;
                    Font = Enum.Font.SourceSans;
                    Text = "오류 신고하기";
                    TextColor3 = Color3.fromRGB(255, 255, 255);
                    TextSize = 18;
                    TextXAlignment = Enum.TextXAlignment.Left;
                });
                new("ImageLabel",{
                    AnchorPoint = Vector2.new(0, 0.5);
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                    BackgroundTransparency = 1;
                    Position = UDim2.new(0, 10, 0.5, 0);
                    Size = UDim2.new(0, 28, 0, 28);
                    ZIndex = 8109;
                    Image = "http://www.roblox.com/asset/?id=6031071057";
                });
            });
            new("TextBox",{
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1;
                BorderColor3 = Color3.fromRGB(27, 42, 53);
                Position = UDim2.new(0, 0, 0, 46);
                Size = UDim2.new(1, 0, 1, -46);
                ZIndex = 8101;
                ClearTextOnFocus = false;
                Font = Enum.Font.Code;
                Text = (
                    "아래의 오류를 복사해서 관리자 이메일로 제보하거나\n" ..
                    "깃허브를 통해서 이 오류를 제보해주세요\n" ..
                    "(또는 카페를 통해서 제보해주세요)\n\n" ..
                    "깃허브 링크 : https://github.com/nofairTCM/Plugin/issues/new\n\n"  ..
                    "=============== 오류 시작 ===============\n\n" ..
                    "error : \n" .. (data or "")
                );
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextEditable = false;
                TextSize = 14;
                TextXAlignment = Enum.TextXAlignment.Left;
                TextYAlignment = Enum.TextYAlignment.Top;
            },{
                new("UIPadding",{
                    PaddingLeft = UDim.new(0, 4);
                    PaddingTop = UDim.new(0, 4);
                });
            });
        });
        AdvancedTween:RunTween(new,{
            Time = 0.62;
            Easing = AdvancedTween.EasingFunctions.Exp2;
            Direction = AdvancedTween.EasingDirection.Out;
        },{
            Position = UDim2.new(0,0,0,0);
        });
    end

    -- 경고창을 띄운다
    local store = {};
    local screen = new("Frame",{
        Name = "CheckHTTPMain";
        BackgroundColor3 = Color3.fromRGB(65, 65, 65);
        BorderSizePixel = 0;
        Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 8000;
        WhenCreated = function (this)
            store.this = this;
        end;
    },{
        new("ImageLabel",{
            AnchorPoint = Vector2.new(0.5, 0.5);
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(0.5, 0, 0.5, 40);
            Size = UDim2.new(0, 200, 0, 49);
            ZIndex = 8002;
            Image = "http://www.roblox.com/asset/?id=6789811908";
        },{
            new("UICorner",{
            });
            new("ImageLabel",{
                Name = "Shadow";
                AnchorPoint = Vector2.new(0.5, 0);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Position = UDim2.new(0.5, 0, 0, -3);
                Size = UDim2.new(1, 12, 1, 8);
                ZIndex = 8001;
                Image = "rbxassetid://1316045217";
                ImageColor3 = Color3.fromRGB(0, 0, 0);
                ImageTransparency = 0.80000001192093;
            });
            new("TextLabel",{
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1;
                Position = UDim2.new(0, 40, 0, 0);
                Size = UDim2.new(1, 0, 1, 0);
                ZIndex = 8002;
                Font = Enum.Font.Code;
                Text = "raw.githubusercontent.com";
                TextColor3 = Color3.fromRGB(255, 255, 255);
                TextSize = 12;
                TextXAlignment = Enum.TextXAlignment.Left;
            });
        });
        new("TextLabel",{
            Name = "info";
            AnchorPoint = Vector2.new(0.5, 0.5);
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(0.5, 0, 0.5, -30);
            Size = UDim2.new(1, -40, 0, 88);
            ZIndex = 8001;
            Font = Enum.Font.Gotham;
            Text = (
                "플러그인 관리 (Plugin Management) =>\n" ..
                "nofairTCM-Installer =>\n" ..
                "HTTP 요청 (Requests) / raw.githubusercontent.com 이 체크되어 있는지 확인해 주세요\n"
            );
            TextColor3 = Color3.fromRGB(255, 255, 255);
            TextSize = 16;
            TextWrapped = true;
        });
        new("TextLabel",{
            Name = "footer";
            AnchorPoint = Vector2.new(0.5, 1);
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(0.5, 0, 1, -8);
            Size = UDim2.new(1, -6, 0, 50);
            ZIndex = 8001;
            Font = Enum.Font.Gotham;
            Text = "이 플러그인은 모듈 상태 확인을 위해 HTTP 서비스를 사용합니다";
            TextColor3 = Color3.fromRGB(255, 255, 255);
            TextSize = 14;
            TextWrapped = true;
            TextYAlignment = Enum.TextYAlignment.Bottom;
        });
        new("TextButton",{
            Name = "error";
            AnchorPoint = Vector2.new(0.5, 0.5);
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(0.5, 0, 0.5, 80);
            Size = UDim2.new(0, 100, 0, 20);
            ZIndex = 8001;
            Font = Enum.Font.Gotham;
            Text = "이미 켜져 있나요?";
            TextColor3 = Color3.fromRGB(0, 166, 255);
            TextSize = 16;
            MouseButton1Click = function ()
                -- 다른 창 하나 더 드로잉
                local new = report();
                new.Parent = store.this;
            end;
        });
    });
    screen.Parent = UIHolder;

    Selection:Set({HTTP}); -- 프로퍼티 창에 HTTP 서비스가 뜨도록 선택 해준다
    while true do
        -- 바뀔 때 까지 기다림
        wait(2);
        newTry();

        if pass then
        --    return data;
        end
    end
end
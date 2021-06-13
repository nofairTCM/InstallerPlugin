
--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-11 19:24:06
    # Modified by   : Qwreey
    # Modified time : 2021-06-13 21:58:58
    # Description   : |
        Time format = yyy-mm-dd hh:mm:ss
        Time zone = GMT+9

        리스트 아이템을 렌더링합니다, init 에 의해서 호출됩니다
  ]]

---@diagnostic disable:undefined-global
local module = {};

local UpdateIcon = "http://www.roblox.com/asset/?id=6031225810";
local InfoIcon = "http://www.roblox.com/asset/?id=6026568210"
local UninstallIcon = "http://www.roblox.com/asset/?id=6022668939";
local InstallIcon = "http://www.roblox.com/asset/?id=6031302931";

local IconButtonSize = 28;

return function (id,inData,MaterialUI,lang)
    local new = MaterialUI.Create;
    local outData = {};

    local function makeIcon(name,icon,tooltip)
        return new("IconButton",{
            Name = name;
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Size = UDim2.new(0, IconButtonSize, 0, IconButtonSize);
            Icon = icon;
            Style = "WithOutBackground";
            ToolTipText = tooltip;
            ToolTipVisible = true;
            ToolTipBackgroundColor3 = MaterialUI.CurrentTheme == "Dark" and Color3.fromRGB(255,255,255) or Color3.fromRGB(38,38,38);
            ToolTipTextColor3 = MaterialUI.CurrentTheme == "Dark" and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255);
            WhenCreated = function (this)
                outData[name] = this;
                local ToolTip = this:GetRealInstance().ToolTip;
                ToolTip.Position = UDim2.new(1,0,1,6);
                ToolTip.AnchorPoint = Vector2.new(1,0);
                ToolTip.ZIndex = 98;
                ToolTip.TextLabel.ZIndex = 98;
            end;
        });
    end

    outData.this = new("ImageLabel",{
        LayoutOrder = inData.index;
        Name = id;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1;
        Size = UDim2.new(1, 0, 0, 116 + 4);
    },{
        icon = new("ImageLabel",{
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            Size = UDim2.new(0, 80, 0, 80);
            ZIndex = 2;
            Image = inData.icon;
        },{
            round = new("UICorner",{
            });
            shadow = new("ImageLabel",{
                AnchorPoint = Vector2.new(0.5, 0);
                BackgroundTransparency = 1;
                BorderSizePixel = 0;
                Position = UDim2.new(0.5, 0, 0, -3);
                Size = UDim2.new(1, 8, 1, 10);
                Image = "rbxassetid://1316045217";
                ImageColor3 = Color3.fromRGB(0, 0, 0);
                ImageTransparency = MaterialUI.CurrentTheme == "Dark" and 0.8 or 0.92;
            });
        });
        new("UIPadding",{
            PaddingLeft = UDim.new(0, 10);
            PaddingRight = UDim.new(0, 10);
            PaddingTop = UDim.new(0, 10);
            PaddingBottom = UDim.new(0,4);
        });
        version = new("TextLabel",{
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 0, 0, 80);
            Size = UDim2.new(0, 80, 0, 20);
            Font = Enum.Font.SourceSans;
            Text = tostring(inData.version);
            TextColor3 = Color3.fromRGB(124, 124, 124);
            TextSize = 14;
        });
        title = new("TextLabel",{
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 88, 0, 0);
            Size = UDim2.new(1, -124, 0, 20);
            Font = Enum.Font.GothamBold;
            Text = inData.name .. (inData.name == id and "" or ("(" .. id .. ")"));
            TextColor3 = MaterialUI:GetColor("TextColor");
            TextSize = 16;
            TextTruncate = Enum.TextTruncate.AtEnd;
            TextXAlignment = Enum.TextXAlignment.Left;
        });
        info = new("TextLabel",{
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 88, 0, 22);
            Size = UDim2.new(1, -124, 0, 57);
            Font = Enum.Font.Gotham;
            Text = inData.info;
            TextColor3 = MaterialUI:GetColor("TextColor");
            TextSize = 14;
            TextTruncate = Enum.TextTruncate.AtEnd;
            TextWrapped = true;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextYAlignment = Enum.TextYAlignment.Top;
            ClipsDescendants = true;
        });
        showMore = new("TextButton",{
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 88, 0, 80);
            Size = UDim2.new(0, 86, 0, 16);
            Font = Enum.Font.Gotham;
            Text = lang("showMore");
            TextColor3 = Color3.fromRGB(0, 174, 255);
            TextSize = 14;
            TextXAlignment = Enum.TextXAlignment.Left;
            WhenCreated = function (this)
                outData.showMore = this;
            end;
        });
        new("Frame",{
            Name = "leftSide";
            AnchorPoint = Vector2.new(1, 0);
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(1, 0, 0, 4);
            Size = UDim2.new(0, 26, 1, -14);
        },{
            makeIcon("UpdateIcon",UpdateIcon,lang("updateHoverTip"));
            makeIcon("UninstallIcon",UninstallIcon,lang("uninstallHoverTip"));
            makeIcon("InfoIcon",InfoIcon,lang("infoHoverTip"));
            makeIcon("InstallIcon",InstallIcon,lang("installHoverTip"));
            new("UIListLayout",{
                SortOrder = Enum.SortOrder.LayoutOrder;
                VerticalAlignment = Enum.VerticalAlignment.Center;
                Padding = UDim.new(0, 4);
            });
        });
    });

    return outData;
end;
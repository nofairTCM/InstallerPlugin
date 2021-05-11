---@diagnostic disable:undefined-global
local module = {};

local UpdateIcon = "http://www.roblox.com/asset/?id=6031225810";
local InfoIcon = "http://www.roblox.com/asset/?id=6026568210"
local UnInstallIcon = "http://www.roblox.com/asset/?id=6022668939";
local InstallIcon = "http://www.roblox.com/asset/?id=6031302931";

local function buttonItem(Icon,LayoutOrder)

end

function draw(inData,new)
    local outData = {};

    outData.this = new("Frame",{
        LayoutOrder = inData.index;
        Name = inData.Name;
        BackgroundColor3 = Color3.fromRGB(255, 255, 255);
        BackgroundTransparency = 1;
        Size = UDim2.new(1, 0, 0, 116);
    },{
        icon = new("ImageLabel",{
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            Size = UDim2.new(0, 80, 0, 80);
            ZIndex = 2;
            Image = inData.Icon;
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
                ImageTransparency = 0.80000001192093;
            });
        });
        new("UIPadding",{
            PaddingLeft = UDim.new(0, 10);
            PaddingRight = UDim.new(0, 10);
            PaddingTop = UDim.new(0, 10);
        });
        version = new("TextLabel",{
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 0, 0, 80);
            Size = UDim2.new(0, 80, 0, 20);
            Font = Enum.Font.SourceSans;
            Text = tostring(inData.Version);
            TextColor3 = Color3.fromRGB(124, 124, 124);
            TextSize = 14;
        });
        div = new("Frame",{
            AnchorPoint = Vector2.new(0, 1);
            BackgroundColor3 = Color3.fromRGB(127, 127, 127);
            BorderSizePixel = 0;
            Position = UDim2.new(0, 0, 1, 0);
            Size = UDim2.new(1, 0, 0, 1);
        });
        title = new("TextLabel",{
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 88, 0, 0);
            Size = UDim2.new(1, -124, 0, 20);
            Font = Enum.Font.GothamBold;
            Text = inData.Name;
            TextColor3 = Color3.fromRGB(255, 255, 255);
            TextSize = 16;
            TextTruncate = Enum.TextTruncate.AtEnd;
            TextXAlignment = Enum.TextXAlignment.Left;
        });
        info = new("TextLabel",{
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 88, 0, 22);
            Size = UDim2.new(1, -124, 0, 60);
            Font = Enum.Font.Gotham;
            Text = inData.info;
            TextColor3 = Color3.fromRGB(255, 255, 255);
            TextSize = 14;
            TextTruncate = Enum.TextTruncate.AtEnd;
            TextWrapped = true;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextYAlignment = Enum.TextYAlignment.Top;
        });
        showMore = new("TextButton",{
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BackgroundTransparency = 1;
            Position = UDim2.new(0, 88, 0, 80);
            Size = UDim2.new(0, 86, 0, 16);
            Font = Enum.Font.Gotham;
            Text = "더보기 ...";
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
            UpdateIcon = new("IconButton",{
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1;
                Size = UDim2.new(0, 26, 0, 26);
                Image = UpdateIcon;
                WhenCreated = function (this)
                    outData.UpdateIcon = this;
                end;
            });
            UnInstallIcon = new("IconButton",{
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1;
                Size = UDim2.new(0, 26, 0, 26);
                Image = UnInstallIcon;
                WhenCreated = function (this)
                    outData.UnInstall = this;
                end;
            });
            InfoIcon = new("IconButton",{
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1;
                Size = UDim2.new(0, 26, 0, 26);
                Image = InfoIcon;
                WhenCreated = function (this)
                    outData.Info = this;
                end;
            });
            InstallIcon = new("IconButton",{
                BackgroundColor3 = Color3.fromRGB(255, 255, 255);
                BackgroundTransparency = 1;
                Size = UDim2.new(0, 26, 0, 26);
                Image = InstallIcon;
                WhenCreated = function (this)
                    outData.InstallIcon = this;
                end;
            });
            new("UIListLayout",{
                SortOrder = Enum.SortOrder.LayoutOrder;
                VerticalAlignment = Enum.VerticalAlignment.Center;
                Padding = UDim.new(0, 4);
            });
        });
    });

    return outData;
end
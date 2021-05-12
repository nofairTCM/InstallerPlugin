---@diagnostic disable:undefined-global

local render = require(script.Parent.render);
if not true then render = require("src.render.term.render"); end

local FrameEl = render.Import("Frame");
local TextBoxEl = render.Import("TextBox");
local UIPaddingEl = render.Import("UIPadding");

return function(Parent)
    return FrameEl {
        BackgroundColor3 = Color3.fromRGB(18,18,18);
        BorderSizePixel = 0;
        Parent = Parent or script;
        Name = "Background";
        ZIndex = 1;
        Size = UDim2.fromScale(1,1);
        TextBoxEl ("TextScreen") {
            BorderSizePixel = 0;
            BackgroundTransparency = 1;
            Size = UDim2.new(1,0,1,300);
            ClearTextOnFocus = false;
            ZIndex = 4;
            TextSize = 16;
            TextWrapped = true;
            Font = Enum.Font.Code;
            TextColor3 = Color3.fromRGB(230,230,230);
            TextXAlignment = Enum.TextXAlignment.Left;
            TextYAlignment = Enum.TextYAlignment.Top;
            UIPaddingEl ("Padding") {
                PaddingLeft = UDim.new(0,8);
                PaddingRight = UDim.new(0,8);
                PaddingTop = UDim.new(0,8);
            };
        };
    };
end;
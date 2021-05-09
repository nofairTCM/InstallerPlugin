return function (UIHolder,pluginIcon,version)
    local MaterialUI = require(script.Parent.Parent.libs.MaterialUI);
    local AdvancedTween = require(script.Parent.Parent.libs.AdvancedTween);
    local new = MaterialUI.Create;

    new("Frame",{
        Parent = UIHolder;
		BackgroundColor3 = MaterialUI:GetColor("Background");
		Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 7000;
	},{
		icon = new("ImageLabel",{
			AnchorPoint = Vector2.new(0.5, 0.5);
			BackgroundTransparency = 1;
			Position = UDim2.new(0.5, 0, 0.5, -30);
			Size = UDim2.new(0, 60, 0, 60);
			Image = pluginIcon;
            ImageColor3 = MaterialUI:GetColor("TextColor");
            ZIndex = 7000;
		});
		text = new("TextLabel",{
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
		});
        circle = new("IndeterminateCircle",{
            Disabled = false;
            Size = UDim2.fromOffset(32,32);
            Position = UDim2.new(0.5,0,0.5,32);
            AnchorPoint = Vector2.new(0.5,0.5);
            ZIndex = 7001;
        });
	});

    return function ()
        
    end;
end;
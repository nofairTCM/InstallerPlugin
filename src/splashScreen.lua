---@diagnostic disable:undefined-global
local time = 0.28;
return function (UIHolder,pluginIcon,version)
    local MaterialUI = require(script.Parent.Parent.libs.MaterialUI);
    local AdvancedTween = require(script.Parent.Parent.libs.AdvancedTween);
    local new = MaterialUI.Create;

	local tweenData = {
		Easing = AdvancedTween.EasingFunctions.Linear;
		Direction = AdvancedTween.EasingDirection.Out;
		Time = time;
	};

	local store = {};
    new("Frame",{
		WhenCreated = function (this)
			store.this = this;
		end;
        Parent = UIHolder;
		BackgroundColor3 = MaterialUI:GetColor("Background");
		Size = UDim2.new(1, 0, 1, 0);
        ZIndex = 7000;
		NotTagging = true;
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
			NotTagging = true;
			WhenCreated = function (this)
				store.text = this;
			end;
		});
        circle = new("IndeterminateCircle",{
            Disabled = false;
            Size = UDim2.fromOffset(32,32);
            Position = UDim2.new(0.5,0,0.5,32);
            AnchorPoint = Vector2.new(0.5,0.5);
            ZIndex = 7001;
			NotTagging = true;
			WhenCreated = function (this)
				store.circle = this;
			end;
        });
	});

    return function ()
		if (not store.this) or (not store.this.Parent) then
			return;
		end
		store.circle.Disabled = true;
        AdvancedTween:RunTween(store.this,tweenData,{
			BackgroundTransparency = 1;
		});
		AdvancedTween:RunTween(store.text,tweenData,{
			TextTransparency = 1;
		});
		AdvancedTween:RunTweens({store.icon,store.circle:GetRealInstance().Holder},tweenData,{
			ImageTransparency = 1;
		});
		delay(time+0.1,function ()
			store.this:Destroy();
		end);
    end;
end;
---@diagnostic disable:undefined-global

return function (env)
    -- make scroll
    local holder,customScroll = require(script.Parent.CustomScroll).new {
        DragToScrollDisabled = true;
    };
    holder.Parent = env.holder;
    holder.Holder.Size = UDim2.fromScale(1,1);

    -- make term screen
    local termScreen = require(script.Parent.term.screen)(holder.Holder);
    termScreen.BackgroundTransparency = 1;

    -- scroll input
    termScreen.TextScreen.MouseWheelBackward:Connect(function ()
        if termScreen.TextScreen:IsFocused() then
            customScroll.WheelBackward();
        end
    end);
    termScreen.TextScreen.MouseWheelForward:Connect(function ()
        if termScreen.TextScreen:IsFocused() then
            customScroll.WheelForward();
        end
    end);

    -- set texts size
    local lastWinsizeY = math.huge;
    local function refreshScrollSize()
        local winHolderSize = holder.AbsoluteSize.Y;
        local textScreenSize = termScreen.TextScreen.TextBounds.Y + 8 + termScreen.TextScreen.TextSize;
        local winsizeY = math.max(winHolderSize,textScreenSize);
        holder.Holder.Size = UDim2.new(1,0,0,winsizeY);

        -- set scroll pos
        if winHolderSize ~= winsizeY then
            local change = winsizeY - lastWinsizeY;
            if change > 0 then
                customScroll.Scroll(0,-change -6);
            end
            lastWinsizeY = winsizeY;
        end
    end
    termScreen.TextScreen:GetPropertyChangedSignal("TextBounds"):Connect(refreshScrollSize);
    holder:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshScrollSize);

    return {
        TextScreen = termScreen.TextScreen;
        holder = holder;
    };
end;

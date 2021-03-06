local colors = {};

local clear = "\27[0\109";
colors.clear = clear;

local cache = {};
function colors.new(colorInt)
    local cached = cache[colorInt];
    if cached then
        return cached;
    end

	local colorStr = ("\27[%d\109"):format(colorInt);
	local new = function(text)
		return colorStr .. text .. clear;
	end
	return new;
end

colors.names = {
    -- attributes
    clear = 0;
    bright = 1;
    dim = 2;
    underscore = 4;
    blink = 5;
    reverse = 7;
    hidden = 8;

    -- foreground
    black = 30;
    red = 31;
    green = 32;
    yellow = 33;
    blue = 34;
    magenta = 35;
    cyan = 36;
    white = 37;

    -- background
    onblack = 40;
    onred = 41;
    ongreen = 42;
    onyellow = 43;
    onblue = 44;
    onmagenta = 45;
    oncyan = 46;
    onwhite = 47;
};

return colors;
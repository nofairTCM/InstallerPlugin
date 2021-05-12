---@diagnostic disable:undefined-global

-- modules, class, etc
local stdioMeta = {}; stdioMeta.__index = stdioMeta;
local void = (function() end);
local emptyStr = "";
local strLen = string.len;--utf8.len;
local module = {};

-- update / buffer / screen / line handle
function stdioMeta:lineCheck() -- check lines and clear old lines
end
function stdioMeta:updateScreen() -- update screen
    local withoutInput = self.output .. (self.lockInput and emptyStr or self.prompt)
    self.withoutInput = withoutInput;
    local new = withoutInput .. self.input;
    self.lastScreen = new;
    self.updateFunc(new);
end
function stdioMeta:updateBuffer(screenBuffer) -- update in buffer by screen buffer (read screen and catches input)
    local screenBufferLen = strLen(screenBuffer);
    local outputPrompt = self.output .. self.prompt;
    local lenNoInput = strLen(outputPrompt);

    if self.lockInput then -- locked
        self:clearInput();
        return;
    elseif screenBuffer == self.lastScreen then -- nothing changed
        return;
    elseif screenBuffer == outputPrompt then -- no input
        self.input = emptyStr;
        self.lastScreen = screenBuffer;
        self.inputHook(emptyStr);
        return;
    elseif screenBufferLen < lenNoInput then -- overflow input to output
        self:clearInput();
        self.setCurPos(lenNoInput + 1);
        return;
    elseif string.sub(screenBuffer,1,lenNoInput) ~= outputPrompt then -- input and output is mixed
        local changedLen = screenBufferLen - strLen(self.lastScreen);
        if changedLen < 0 then -- remove on output
            local ninput = string.sub(screenBuffer,lenNoInput + changedLen + 1,-1);
            self.input = ninput;
            self.inputHook(ninput);
        end
        self:updateScreen();
        self.setCurPos(lenNoInput + 1);
        return;
    end

    -- set input
    local input = string.sub(screenBuffer,lenNoInput + 1,-1);
    if input == emptyStr then -- nothing found
        return self:clearInput();
    end
    self.input = input;
    self.inputHook(input);
    self.lastScreen = screenBuffer;
end

-- input handle
function stdioMeta:setInput(input) -- set input
    self.input = input;
    self:updateScreen();
    self.inputHook(input);
end
function stdioMeta:getInput()
    return self.input or emptyStr;
end
function stdioMeta:clearInput() -- clear input
    self.input = emptyStr;
    self:updateScreen();
    self.inputHook(emptyStr);
end
function stdioMeta:returnInput() -- enter key function, return input and clear input and eat line
    if self.lockInput then return end
    local lastInput = self.input;
    self.output = self.lastScreen .. "\n";
    self.input = emptyStr;
    self:updateScreen();
    self.inputHook(emptyStr);
    return lastInput;
end
function stdioMeta:setLockInput(lock) -- set input lock
    if self.lockInput == lock then
        return;
    end
    self.lockInput = lock;
    self.addCurPos(#self.prompt * (lock and -1 or 0));
    self:updateScreen();
    self.addCurPos(#self.prompt * (lock and 0 or 1));
end

-- output add /set
function stdioMeta:addOutput(str) -- add output
    --self:stackLine(str);
    local output = self.output .. str;
    self.output = output;
    self:updateScreen();
    self.addCurPos(#str);
    self.outputHook(output);
end
function stdioMeta:setOutput(str) -- set output
    self.outputAddHook(str);
    local cur = #str - #self.output;
    self.output = str;
    if cur < 0 then
        self.addCurPos(cur);
    end
    self:updateScreen();
    if cur > 0 then
        self.addCurPos(cur);
    end
    self.outputHook(str);
end
function stdioMeta:getOutput() -- get output
    return self.output or emptyStr;
end
function stdioMeta:clearOutput() -- clear output
    self.output = emptyStr;
    self:updateScreen();
    self.setCurPos(#self.lastScreen);
    self.outputHook(emptyStr);
end

function module.new(option)
    local class = {};

    -- screen, input, output
    class.output = option.output or emptyStr; ---@deprecated -- output string
    class.input = option.input or emptyStr; ---@deprecated -- input string
    class.lastScreen = option.lastScreen or emptyStr; ---@deprecated -- save last screen
    class.withoutInput = emptyStr; ---@deprecated -- save last screen without input
    class.prompt = option.prompt or emptyStr; ---@deprecated -- prompt

    -- hook
    --class.addOutputHook = option.addOutputHook or void; ---@deprecated -- output function hook
    class.outputHook = option.outputHook or void ---@deprecated -- output hook
    class.outputAddHook = option.outputAddHook or void ---@deprecated -- output hook
    class.inputHook = option.inputHook or void ---@deprecated -- input hook

    -- func, settings, ...
    --class.maxLines = option.maxLines or 255; ---@deprecated -- max lines
    --class.lineBuffer = option.lineBuffer or {}; ---@deprecated -- for handle lines
    class.lockInput = option.lockInput or false; ---@deprecated -- input is locked?
    class.updateFunc = option.updateFunc or void; ---@deprecated -- when updated, call this func
    class.setCurPos = option.setCurPos or void; ---@deprecated -- update cursor pos func
    class.addCurPos = option.addCurPos or void; ---@deprecated -- update cursor with relative pos func

    setmetatable(class,stdioMeta);
    return class;
end

return module;

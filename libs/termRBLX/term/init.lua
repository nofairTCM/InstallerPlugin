---@diagnostic disable:undefined-global

local module = {};

function module.new(settings)
    local TextScreen = settings.TextScreen;
    local info = settings.info;
    settings.sysDebug = "";
    settings.sysDebugHook = settings.sysDebugHook;
    settings.path = settings.env.path or game;
    settings.NULL = {};
    settings.VAR = {};
    settings.toPath = require(script.Parent.utils.instanceToPath)(settings);
    settings.toInstance = require(script.Parent.utils.pathToInstance)(settings);
    settings.splitDirOpt = require(script.Parent.utils.splitDirOpt);
    settings.makeSeed = require(script.Parent.utils.makeSeed);
    settings.makeId = require(script.Parent.utils.makeId);
    settings.nullHandle = require(script.Parent.utils.nullHandle)(settings);

    -- new stdio simulate
    settings.stdioSimulate = settings.stdioSimulate.new {
        -- screen updater / screen init
        output = ("termRBLX (Version %s)\nmore info for : https://github.com/qwreey75/RbxTermi\n\n"):format(
            info.version
        );
        prompt = settings.env.prompt or "@termRBLX $ ";
        updateFunc = function (text)
            TextScreen.Text = text;
        end;

        -- cursor handle
        setCurPos = function (curPos)
            TextScreen.CursorPosition = curPos;
            TextScreen.SelectionStart = -1;
        end;
        addCurPos = function (move)
            TextScreen.CursorPosition = TextScreen.CursorPosition + move;
            TextScreen.SelectionStart = -1;
        end
    };
    local stdioSimulate = settings.stdioSimulate;
    local block = (not settings.env.disableBlock) and require(script.blockInput).new(settings.TextScreen,stdioSimulate);
    settings.output = function (text)
        stdioSimulate:addOutput(text);
    end;

    -- catch text changed
    local function update()
        stdioSimulate:updateBuffer(TextScreen.Text);
    end
    TextScreen:GetPropertyChangedSignal("Text"):Connect(update);
    update();

    -- load commands
    local cmds = {};
    local function loadCmd(t)
        for _,name in pairs(t.names) do
            cmds[name] = t;
        end
    end
    local customCmds = settings.cmds;
    if customCmds then
        for _,v in pairs(customCmds) do
            loadCmd(v);
        end
    end
    for _,cmdModule in pairs(script.Parent.cmds:GetChildren()) do
        local pass,cmd = pcall(require,cmdModule);
        if pass then
            loadCmd(cmd);
        else
            settings.output(
                ("loading command '%s' was failed, please check command module/script/path is exist and make sure command have no errors\nError Info : %s\n\n"):format(
                    cmdModule.Name,cmd
                )
            );
        end
    end
    settings.loadCmd = loadCmd;
    settings.cmds = cmds;

    -- execute input
    local exe = require(script.exe).init(settings);
    settings.exe = function (str)
        exe:run(str);
    end

    -- catch enter
    TextScreen.FocusLost:Connect(function (enter)
        if not enter then
            return;
        end

        local input = stdioSimulate:returnInput();
        wait(); TextScreen:CaptureFocus();
        exe:run(input); return;
    end);

    return settings;
end

return module;
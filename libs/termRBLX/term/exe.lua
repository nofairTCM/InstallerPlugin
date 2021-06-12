---@diagnostic disable:undefined-global

local module = {};

function module.init(data)
    local this = {
        global = {};
    };
    local cmds = data.cmds;
    local termColor = require(script.Parent.Parent.utils.termColor);
    local red = termColor.new(termColor.names.red);

    data.error = function (str)
        data.output((red "termRBLX Error : %s"):format(
            tostring(str)
        ) .. "\n\n");
    end

    function this:run(str)
        if not str then
            return; -- locked, error etc
        end
        local cmd = string.match(str,"^[^%s]+") or "";
        local cmdObj = cmds[cmd];

        if cmdObj then
            data.global = self.global;
            data.nullHandle(data.path);
            data.stdioSimulate:setLockInput(true);
            wait();
            local pass,errmsg = pcall(cmdObj.exe,string.sub(str,#cmd + 2,-1),data,cmdObj,cmd);
            if not pass then
                data.output((red "termRBLX Error : run error occur on running command/script/program!\nerror info : %s"):format(
                    tostring(errmsg)
                ) .. "\n\n");
            end
            data.stdioSimulate:setLockInput(false);
            return errmsg;
        elseif cmd == "" then
            return;
        else
            data.output(
                (red "termRBLX Error : '%s' is not a command or script or program or path, make sure that name correct and try again!"):format(cmd)
                .. "\n\n"
            );
        end
    end

    return this;
end

return module;

--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-16 17:12:32
    # Modified by   : Qwreey
    # Modified time : 2021-06-05 20:51:53
    # Description   : |
        Time format = yyy-mm-dd hh:mm:ss
        Time zone = GMT+9

        터미널에서 installer 에 접근 할 수 있도록 command 를 만듭니다
  ]]

--[[
    tcmi install <module/libs/plugin Name>
      install object from rblx asset / github repo
      THIS ACTION IS CALL FETCHING DATABASE!

    tcmi update <module/libs/plugin Name>
      same to install, but is update only installed objects
      THIS ACTION IS CALL FETCHING DATABASE!

    tcmi isInstalled <module/libs/plugin Name>
      check object is installed on this map

    tcmi checkUpdate <module/libs/plugin Name> [option]
      check object is need to update

      option :
        -f : fetch and check version

    tcmi updateAll
      update all objects
      THIS ACTION IS CALL FETCHING DATABASE!
      same to 'tcmi update *'

    tcmi search <q> [option]
      search object from db

      option :
        -f : fetch and check version

    tcmi ls [option]
      show list of objects

      option :
        -f : fetch and show list
        -i : show installed modules
        -a : show advanced information

    tcmi info <module/libs/plugin Name> [option]
      show object's information

      option :
        -f : fetch and show info

    tcmi help [command]
      show is msg

]]

local runService = game:GetService("RunService");
local function waitHeart()
    runService.Heartbeat:Wait();
end

local props = {
    "author";
    "info";
    "version";
    "publishVersion";
    "publishStatus";
    "buildVersion";
    "majorVersion";
    "import";
    "github";
    "lic";
    "toolboxID";
    "index";
};

local header = (
    "this is tcm installer command,\n" ..
    "you can install or manage tcm module/library\n\n" ..
    "이 커맨드는 tcm 설치기를 실행합니다\n" ..
    "이 커맨드를 이용하면 모듈/라이브러리를 설치하거나 관리 할 수 있습니다\n" ..
    "명령어에 대한 자세한 사항은 아래의 메시지를 참조해주세요\n\n" ..
    "tcmi help [commandName]\n" ..
    "show command info\n\n"
);

local cmds = {
    info = {
        info = (
            "tcmi info [objectId] [options]\n" ..
            "  show object info from database\n" ..
            "  options :\n" ..
            "    -f (--fetch) : fetch and show database, (http require)\n" ..
            "    -q (--quiet) : return data only, do not show info on stdout"
        );
        options = {
            ["-f"] = "fetch";
            ["--fetch"] = "fetch";
            ["-q"] = "quiet";
            ["--quiet"] = "quiet";
        };
        exe = function (args,options,content,self)
            if options.fetch then
                content.fetchDB();
            end

            -- module name in arg
            local id = args[1];
            if id then
                local object = content.moduleData[id];

                if not object then
                    content.output(("object '%s' was not found from database! please check command arg and try again!\n\n"):format(id));
                    return;
                end
                if options.quiet then
                    return object;
                end

                local isPass,isInstalled = pcall(content.installer.isInstalled,content.installer,id);
                if not isPass then
                    content.output(("ERROR : %s\nan error occurred; ignore and continue . . .\n"):format(isInstalled));
                end
                isInstalled = isInstalled ~= nil;

                content.output("\n" .. object.name .. (" (id : %s)"):format(id)); waitHeart();
                content.output("\n  isInstalled : " .. tostring(isInstalled));
                for _,index in pairs(props) do
                    content.output("\n  " .. index .. " : " .. tostring(object[index])); waitHeart();
                end
                content.output("\n\n");

                return object;
            else
                content.output("arg 1 [objectId] is missing! please check command arg and try again!\n\n");
                return;
            end
        end;
    };
    ls = {
        info = (
            "tcmi ls [options]\n" ..
            "  show list of objects from database\n" ..
            "  options :\n" ..
            "    -f (--fetch) : fetch and show database, (http require)\n" ..
            "    -b : show name only\n" ..
            "    -q (--quiet) : return data only, do not show list on stdout\n" ..
            "    -i (--installed) : show installed objects only"
        );
        options = {
            ["-f"] = "fetch";
            ["--fetch"] = "fetch";
            ["-b"] = "nameOnly";
            ["-q"] = "quiet";
            ["--quiet"] = "quiet";
            ["-i"] = "installed";
            ["--installed"] = "installed";
        };
        exe = function (args,options,content,self)
            if options.fetch then
              content.fetchDB();
            end

            -- not module name in arg
            local nameOnly = options.nameOnly;
            local moduleData = content.moduleData;
            local installedOnly = options.installed;

            if not options.quiet then
                for id,object in pairs(moduleData) do
                    local isPass,isInstalled = pcall(content.installer.isInstalled,content.installer,id);
                    if not isPass then
                        content.output(("ERROR : %s\nan error occurred; ignore and continue . . .\n"):format(isInstalled));
                    end
                    isInstalled = isInstalled ~= nil;

                    if (not installedOnly) or isInstalled then
                        content.output("\n" .. object.name .. (" (id : %s)"):format(id));
                        if not nameOnly then
                            content.output("\n  isInstalled : " .. tostring(isInstalled));
                            for _,index in pairs(props) do
                                content.output("\n  " .. index .. " : " .. tostring(object[index]));
                            end
                            content.output("\n");
                        end
                    end
                end

                if nameOnly then
                    content.output("\n");
                end
            end
            content.output("\n");
            return moduleData;
        end;
    };
    fetch = {
        info = (
            "tcmi fetch [options]\n" ..
            "  fetch database from github\n" ..
            "  options :\n" ..
            "    -b (--background) : fetch database in background mode (coroutine)"
        );
        options = {
            ["-b"] = "background";
            ["--background"] = "background";
        };
        exe = function (args,options,content,self)
            if options.background then
                coroutine.resume(coroutine.create(function ()
                    content.fetchDB();
                end))
                return;
            end
            return content.fetchDB();
        end;
    };
    install = {
        info = (
            "tcmi install [objectId] [options]\n" ..
            "  install object from rblx asset / github repo\n" ..
            "  THIS ACTION IS CALL FETCHING DATABASE!\n" ..
            "  options :\n" ..
            "    -q (--quiet) : return data only, do not show info on stdout\n" ..
            "    -f (--force) : ignore version data and force to install objects"
        );
        options = {
            ["-q"] = "quiet";
            ["--quiet"] = "quiet";
            ["-f"] = "force";
            ["--force"] = "force";
        };
        exe = function (args,options,content,self)
            content.fetchDB();
            -- module name in arg
            local moduleName = args[1];
            local quiet = options.quiet;
            if moduleName then
                local object = content.moduleData[moduleName];

                if not object then
                    content.output(("object '%s' was not found from database! please check command arg and try again!\n\n"):format(moduleName));
                    return;
                end

                local isPass,errmsg = pcall(content.installer.install,content.installer,moduleName,(not quiet) and content.output,nil,options.force);
                if not isPass then
                    content.output("ERROR : " .. errmsg .. "\n");
                end
                if not quiet then
                    content.output("\n");
                end

                return object;
            else
                content.output("arg 1 [objectId] is missing! please check command arg and try again!\n\n");
                return;
            end
        end;
    };
    uninstall = {
        info = (
            "tcmi uninstall [objectId] [options]\n" ..
            "  uninstall object from this place\n" ..
            "  options :\n" ..
            "    -q (--quiet) : return data only, do not show info on stdout"
        );
        options = {
            ["-q"] = "quiet";
            ["--quiet"] = "quiet";
        };
        exe = function (args,options,content,self)
            -- module name in arg
            local moduleName = args[1];
            local quiet = options.quiet;
            if moduleName then
                local object = content.moduleData[moduleName];

                if not object then
                    content.output(("object '%s' was not found from database! please check command arg and try again!\n\n"):format(moduleName));
                    return;
                end

                local isPass,errmsg = pcall(content.installer.uninstall,content.installer,moduleName,(not quiet) and content.output);
                if not isPass then
                    content.output("ERROR : " .. errmsg .. "\n");
                end
                if not quiet then
                    content.output("\n");
                end

                return object;
            else
                content.output("arg 1 [objectId] is missing! please check command arg and try again!\n\n");
                return;
            end
        end;
    };
    init = {
        info = (
            "tcmi init\n" ..
            "  init tcm object storage\n" ..
            "  this command is auto executing by other commands!"
        );
        options = {};
        exe = function (args,options,content,self)
            local isPass,errmsg = pcall(content.installer.init,content.installer);

            if not isPass then
                content.output("ERROR : " .. errmsg .. "\n");
                return false;
            end
            return true;
        end;
    };
}

local helpMSG = header;
for _,command in pairs(cmds) do
    helpMSG = helpMSG .. command.info .. "\n\n";
end

local helpCommand = {
    ["-h"] = true;
    ["--help"] = true;
    help = true;
};

return function (decode)
    return {
        {
            names = {"tcmi"};
            info = "nofairTCM installer command";
            use = "tcmi [command] ...";
            help = helpMSG;
            exe = function (str,content,self,cmdprefix)
                local commandName = string.match(str,"[^%s]+");

                if (not commandName) or commandName == "" then
                    content.output(helpMSG);
                    return;
                elseif helpCommand[commandName] then
                    local which = string.match(string.sub(str,#commandName+1,-1),"[^%s]+");
                    local cmd = which and cmds[which];
                    if cmd then
                        content.output("\n" .. cmd.info .. "\n\n");
                    else
                        content.output(helpMSG);
                    end
                    return;
                end

                local cmd = cmds[commandName];
                if not cmd then
                    content.output(("error : command '%s' does not exist, check help to get some information!\n"):format(commandName));
                    return
                end

                local argStr = string.sub(str,#commandName + 1,-1);
                local pass,arg,opt = pcall(decode,argStr,cmd.options);

                if not pass then
                    content.output(arg .. "\n");
                    return;
                end

                return cmd.exe(arg,opt,content,cmd);
            end;
        };
    };
end;

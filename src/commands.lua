
--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-16 17:12:32
    # Modified by   : Qwreey
    # Modified time : 2021-05-19 20:45:24
    # Description   : |
        Time format = yyy-mm-dd hh:mm:ss
        Time zone = GMT+9

        터미널에서 installer 에 접근 할 수 있도록 command 를 만듭니다
  ]]

local runService = game:GetService("RunService");
local function waitHeart()
    runService.Heartbeat:Wait()
end

local props = {
    "author";
    "type";
    "info";
    "version";
    "publishVersion";
    "publishStatus";
    "buildVersion";
    "import";
    "github";
    "lic";
    "toolboxID";
    "index";
};

local header = [[
this is tcm installer command,
you can install or manage tcm module/library

이 커맨드는 tcm 설치기를 실행합니다
이 커맨드를 이용하면 모듈/라이브러리를 설치하거나 관리 할 수 있습니다

명령어에 대한 자세한 사항은 아래의 메시지를 참조해주세요]] .. "\n\n";

local cmds = {
    showdb = {
        info = [[
tcmi showdb [option]
  show database

  option
    -f : fetch and show]];
        exe = function (args,content,self)
            local moduleData = content.moduleData;
            local minLine = 16;
            local nowLine = 1;
            local function checkLine()
                if minLine < nowLine then
                    
                end
                nowLine = nowLine + 1;
            end
            for _,object in pairs(moduleData) do
                checkLine() content.output("\n"); waitHeart();
                content.output(object.name); waitHeart();
                for _,index in pairs(props) do
                    checkLine() content.output("\n  "); waitHeart();
                    content.output(index .. " : " .. tostring(object[index])); waitHeart();
                end
                checkLine() content.output("\n"); waitHeart();
            end
        end;
    };
}

local function exe()

end

local helpMSG = header;
for _,command in pairs(cmds) do
    helpMSG = helpMSG .. command.info;
end

return function ()
    return {
        {
            names = {"tcmi"};
            info = "nofairTCM installer command";
            use = "tcmi [command] ...";
            help = helpMSG --[[

                
                tcmi fetchdb
                  fetch database from github

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

            ]];
            exe = function (str,content,self,cmdprefix)
                content.output(helpMSG .. "\n\n");
                --string.match("^")
                --cmds.showdb.exe(str,content,self);
            end;
        };
    };
end;

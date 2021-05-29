
--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-21 21:43:18
    # Modified by   : Qwreey
    # Modified time : 2021-05-29 12:48:25
    # Description   : |
        Time format = yyy-mm-dd hh:mm:ss
        Time zone = GMT+9

        커맨드 라인에서 구문을 분석하기 위해서 사용되는 모듈입니다
        -f , -a 같은 옵션자와 "" 로 묶은 옵션, \ 로 이스캐이핑한 따음표, 이외에 arg 를 처리합니다

        CLI option,arg decoder
  ]]

local module = {};

local function splitStr(str)
    local tmp = "";
    local spt = {};

    local quote = false;
    local squote = false;
    local escape = false;

    local function push()
        if tmp == "" then
            return;
        end
        table.insert(spt,tmp .. (escape and "\\" or ""));
        tmp = "";
        escape = false;
    end

    for part in string.gmatch(str,".") do
        if (not squote) and part == "\"" and (not escape) then
            quote = not quote;
            push();
        elseif (not quote) and part == "\'" and (not escape) then
            squote = not squote;
            push();
        elseif part == "\32" and (not quote) and (not squote) then
            push();
        else
            tmp = tmp .. ((escape and part == "\\") and "\\" or part);
        end
        escape = false;
        if part == "\\" then
            escape = true;
        end
    end

    if tmp ~= "" then
        table.insert(spt,tmp);
    end

    return spt;
end

function module.decode(str,optionList,optionNotFound)
    local option = {};
    local args = {};

    local split = splitStr(str);

    local lastOpt;

    local strSub = string.sub;
    local tableInsert = table.insert;
    for i,this in ipairs(split) do
        if i >= 1 then
            if lastOpt then -- set option
                option[lastOpt] = this;
                lastOpt = nil;
            elseif strSub(this,1,1) == "-" then -- this = option
                local optName = optionList[this];
                if not optName then
                    error((optionNotFound or "option %s was not found, -h for see info"):format(this));
                end
                option[optName] = true;
                lastOpt = optName;
            else
                tableInsert(args,this);
            end
        end
    end

    return args,option;
end

return module;

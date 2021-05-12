---@diagnostic disable:undefined-global
---@diagnostic disable:undefined-field
return function (content) return function (path,returnErr)
    local ins = nil;
    local deep = 0;
    local er;
    for str in string.gmatch(path,"[^\\]+") do
        deep = deep + 1;
        if deep == 1 then
            if string.upper(str) == "GAME" then
                ins = game;
            elseif string.upper(str) == "NULL" then
                ins = nil;
            end
        elseif deep == 2 and ins == nil then
            ins = table.find(content.NULL,str);
        else
            if ins == nil then
                break;
            elseif str == ".." then
                ins = ins.Parent;
            elseif str == "" then
                break;
            else
                local nins = ins:FindFirstChild(str);
                if nins then
                    ins = nins;
                else
                    er = str;
                    break;
                end
            end
        end
    end
    return ins,returnErr and er;
end end;
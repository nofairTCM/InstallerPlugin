---@diagnostic disable:undefined-global
return function (content) return function (ins)
    local path = "";
    local lins,lpath = "","";

    while true do
        if not ins then
            local nullId = content.NULL[lins];
            if nullId then
                path = "\\NULL\\" .. nullId .. lpath;
            else
                path = "\\NULL" .. path;
            end
            break;
        elseif ins == game then
            path = "\\GAME" .. path;
            break;
        end
        lins = ins;
        lpath = path;
        path = "\\" .. ins.Name .. path;
        ins = ins.Parent;
    end

    return path;
end end;
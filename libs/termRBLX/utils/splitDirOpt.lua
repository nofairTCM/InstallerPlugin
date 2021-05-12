-- split directory and option

return function (str)
    str = string.match(str,"^%s*(.+)") or str;
    local opt,sum = "",nil;
    for sp in string.gmatch(str,"[^%s]+") do
        if not sum then
            sum = sp;
        else
            local epos = string.find(sp,"\\");
            if epos then
                sum = sum .. opt .. sp;
                opt = "";
            else
                opt = opt .. "\32" .. sp;
            end
        end
    end
    return sum,opt;
end;
---@diagnostic disable:undefined-global

return {
    names = {"pnull"};
    info = "print null folder's items";
    exe = function (str,content,self,cmdprefix)
        for ins,id in pairs(content.NULL) do
            content.output(id .. " : " .. ins.Name .. "\n");
        end
        content.output("\n");
    end;
};

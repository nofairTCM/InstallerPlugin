---@diagnostic disable:undefined-global

return {
    names = {"echo","print","output"};
    info = "add str on output";
    use = "echo [str]";
    exe = function (str,content,self,cmdprefix)
        content.output(str .. "\n");
    end;
};

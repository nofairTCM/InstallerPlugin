---@diagnostic disable:undefined-global

return {
    names = {"pwd","pdir","pd"};
    info = "print working directory on screen";
    exe = function (str,content,self,cmdprefix)
        content.output(content.toPath(content.path) .. "\n\n");
    end;
};

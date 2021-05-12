---@diagnostic disable:undefined-global

return {
    names = {"clear","cls"};
    info = "clear screen (set stdout to \"\" and refresh screen)";
    use = "cd [dir] [option]";
    exe = function (str,content,self,cmdprefix)
        content.stdioSimulate:clearOutput();
    end;
};

---@diagnostic disable:undefined-global

return {
    names = {"cd","cdir","cwd","chdir","chd","chwd"};
    info = "change working directory (cwd)";
    use = "cd [dir] [option]";
    help = [[
        move to game directory : cd \game
        move to parent directory : cd ..
        move to child directory : cd childName
        move to directory that includeds space : cd .\ like this\
        move to Workspace : cd \game\Workspace
        move with var : cd %client%\PlayerGui
    ]];
    exe = function (str,content,self,cmdprefix)
        local str,opt = content.splitDirOpt(str);
        str = str or "";
        local path;
        if string.sub(str,1,2) == ".\\" then
            path = content.path;
            str = string.sub(str,3,-1);
        elseif string.upper(string.sub(str,1,5)) == "\\GAME" then
            path = game;
            str = string.sub(str,6,-1);
        elseif string.upper(string.sub(str,1,5)) == "\\NULL" then
            path = nil;
            str = string.sub(str,6,-1);
        elseif string.sub(str,1,1) == "\\" then
            path = nil;
            str = string.sub(str,2,-1);
        else
            path = content.path;
        end
        str = "\\" .. str;
        local npath,err = content.toInstance(content.toPath(path) .. str,true);
        content.path = err and content.path or npath;
        content.output(content.toPath(content.path) .. "\n\n");
        if err then
            content.error("could not be found path");
        end
    end;
};

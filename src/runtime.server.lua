
--[[
    # Author        : Qwreey / qwreey75@gmail.com / github:qwreey75
    # Create Time   : 2021-05-15 18:13:03
    # Modified by   : Qwreey
    # Modified time : 2021-05-16 17:58:03
    # Description   : |
        Time format = yyy-mm-dd hh:mm:ss
        Time zone = GMT+9

        init 를 호출하고 초기화 오류를 캐칭합니다
  ]]

---@diagnostic disable:undefined-global

local initPass,msg = pcall (function ()
    local app = require(script.Parent);
    app.run(plugin);

    app.status = "ENABLED";
end);

if not initPass then
    error (("플러그인 초기화중 오류가 발생하였습니다, 오류 내용은 다음과 같습니다 : %s"):format(msg))
end

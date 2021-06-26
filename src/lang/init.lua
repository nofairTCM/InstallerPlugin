
local LocalizationService = game:GetService("LocalizationService");
local lang;

local module = {};
setmetatable(module,{
    __call = function(self,key,format)
        local item = lang[key];
        if format then
            for i,v in pairs(format) do
                item = string.gsub(item,(":{{%s}}:"):format(i),v);
            end
        end
        return item;
    end;
});

function module.setLang(langCode)
    local obj = script:FindFirstChild(langCode == "default" and LocalizationService.SystemLocaleId or langCode);
    lang = require(obj or script:FindFirstChild("en-us"));
end

module.setLang("default");

return module;


local LocalizationService = game:GetService("LocalizationService");
local lang = require(script:FindFirstChild(LocalizationService.SystemLocaleId) or script:FindFirstChild("en-us"));

return function (key,format)
    local item = lang[key];
    if format then
        for i,v in pairs(format) do
            item = string.gsub(item,(":{{%s}}:").format(i),v);
        end
    end
    return item;
end

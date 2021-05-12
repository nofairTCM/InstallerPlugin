---@diagnostic disable:undefined-global

if not script then
    print ("THIS IS NOT ROBLOX LUA SANDBOX!");
    print ("this lua code must be running on rblx lua sandbox");
    error ("glboal 'script' was not found")
end

local module = {};

function module.init(env)
    local runtimeModule = script.runtime:FindFirstChild(env.runtimeType);
    if not runtimeModule then
        error(("Runtime %s was not found!"):format(tostring(env.runtimeType)));
    end
    local runtime = require(runtimeModule)(env);
    return runtime;
end

return module;
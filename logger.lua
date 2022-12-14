local ansicolors = require("ansicolors")
local logging = require("logging")
require("logging.console")

logging.defaultLogger(logging.console {
    destination = "stderr",
    timestampPattern = "!%y-%m-%dT%H:%M:%S.%qZ", -- ISO 8601 in UTC
    logPatterns = {
        [logging.DEBUG] = ansicolors("%{white}%date%{cyan} %level %message (%source)\n"),
        [logging.INFO]  = ansicolors("%{white}%date%{white} %level %message\n"),
        [logging.WARN]  = ansicolors("%{white}%date%{yellow} %level %message\n"),
        [logging.ERROR] = ansicolors("%{white}%date%{red bright} %level %message %{cyan}(%source)\n"),
        [logging.FATAL] = ansicolors("%{white}%date%{magenta bright} %level %message %{cyan}(%source)\n"),
    }
})

local ll = package.loaded.logging
if ll and type(ll) == "table" and ll.defaultLogger and
    tostring(ll._VERSION):find("LuaLogging") then
    -- default LuaLogging logger is available
    log = ll.defaultLogger()
else
    -- just use a stub logger with only no-op functions
    local nop = function() end
    log = setmetatable({}, {
        __index = function(self, key) self[key] = nop return nop end
    })
end

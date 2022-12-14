require("file_io")
require("logger")
local cjson = require("cjson")


config = {}


function config.new(file_name)
    local self = {
        board_width = 10,
        board_height = 10,
        chip_colors = {
            "A", "B", "C", "D", "E", "F"
        }
    }

    if file_exists(file_name) then
        log:debug("[config] Config file " .. file_name .. " found. Reading...")
        local data = read_all(file_name)
        self = cjson.decode(data)
    else
        log:debug("[config] Config file " .. file_name .. "not found. Falling back to defaults...")
    end

    return self
end

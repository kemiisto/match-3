require("board")
require('config')
require("input")
require("logger")


log:setLevel(log.WARN)

local config_file_name = "config/10x10x6.json"
if #arg > 0 then
    config_file_name = arg[1]
end

local game_config = config.new(config_file_name)
local game_board = board.new(game_config)

game_board.init()
game_board.dump()

local game_input = input.new(game_board)

while true do
    game_input.read_command()
    game_input.run_command()
    game_board.tick()
    game_board.dump()
end

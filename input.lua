input = {}


function input.new(b)
    local self = {}

    -- Private variables

    local game_board = b
    local args = {}

    -- Private methods

    -- m 3 0 r
    local function parse_move_args(args)
        local from = {args[2]+1, args[3]+1}
        local to = {args[2]+1, args[3]+1}

        local d = args[4]
        if d == "l" then
            to[2] = to[2] - 1
        elseif d == "r" then
            to[2] = to[2] + 1
        elseif d == "u" then
            to[1] = to[1] - 1
        elseif d == "d" then
            to[1] = to[1] + 1
        end

        return from, to
    end

    -- Public methods

    function self.read_command()
        local s = io.read()

        args = {}
        for arg in s:gmatch("%S+") do
            table.insert(args, arg)
        end
    end

    function self.run_command()
        if (args[1] == "q") then
            os.exit()
        elseif args[1] == "m" then
            local from, to = parse_move_args(args)
            game_board.move(from, to)
        end
    end

    return self
end

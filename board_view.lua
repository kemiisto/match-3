local ansicolors = require("ansicolors")


local ANSICOLORS = {
    A = "red",
    B = "green",
    C = "yellow",
    D = "blue",
    E = "magenta",
    F = "cyan"
}


board_view = {}


function board_view.new()
    local self = {}

    -- Private methods

    --[[
        Prints board header.
    ]]
    local function dump_header(width)
        io.write("    ")
        for i = 1, width do
            io.write(" ", i-1, " ")
        end
        io.write("\n")

        io.write("    ")
        for _ = 1, width do
            io.write("---")
        end
        io.write("\n")
    end

    -- Public methods

    function self.display(t)
        local width, height = #t[1], #t

        dump_header(width)

        for i = 1, height do
            io.write(string.format("%2d", i-1), " |")
            for j = 1, width do
                local color = t[i][j]
                if color ~= " " then
                    local s = string.format("%%{bright %s}%s", ANSICOLORS[color], color)
                    io.write(" " .. ansicolors(s) .. " ")
                else
                    io.write(" " .. color .. " ")
                end
                
            end
            io.write("\n")
        end

        io.write("\n")
    end

    return self
end

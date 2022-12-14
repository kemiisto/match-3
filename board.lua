require("board_view")
require("chip")
require('config')
require("logger")


board = {}


local DIRECTION = {
    HORIZONTAL = 1,
    VERTICAL = 2
}


function board.new(game_config)
    math.randomseed(os.time())

    local self = {}

    -- Private variables

    local WIDTH, HEIGHT = game_config.board_width, game_config.board_height
    local COLORS = game_config.chip_colors

    local CHIPS = {}
    for i = 1, #COLORS do
        local color = COLORS[i]
        CHIPS[color] = chip.new(color)
    end

    local MAX_SHUFFLE_ATTEMPTS = (WIDTH * HEIGHT)^2

    local chips = {}
    local matches = {}
    local view = board_view.new()

    -- Private methods

    --[[
        Directly access chips table; used primarily for unit testing.
    ]]
    local function get()
        local t = {}

        for i = 1, HEIGHT do
            t[i] = {}
            for j = 1, WIDTH do
                t[i][j] = chips[i][j] and chips[i][j].dump() or " "
            end
        end

        return t
    end

    local function set(m)
        for i = 1, HEIGHT do
            local row = {}
            chips[i] = row
            for j = 1, WIDTH do
                row[j] = CHIPS[m[i][j]]
            end
        end
    end

    local function add_match(direction, i, number_of_chips, last_chip_index)
        local match = {}
        for j = last_chip_index, last_chip_index - number_of_chips + 1, -1 do
            if direction == DIRECTION.HORIZONTAL then
                table.insert(match, {i, j})
            else
                table.insert(match, {j, i})
            end
        end
        table.insert(matches, match)
    end

    local function find_matches_for_dir(direction)
        local dir = direction == DIRECTION.HORIZONTAL and "horizontal" or "vertical"
        log:debug("[board] Searching for " .. dir .. " matches...")

        local n = direction == DIRECTION.HORIZONTAL and HEIGHT or WIDTH
        local m = direction == DIRECTION.HORIZONTAL and WIDTH or HEIGHT

        for i = 1, n do
            local chip_to_match = direction == DIRECTION.HORIZONTAL and chips[i][1] or chips[1][i]
            local number_of_matches = 1
            for j = 2, m do
                if (direction == DIRECTION.HORIZONTAL and chips[i][j] == chip_to_match)
                        or (direction == DIRECTION.VERTICAL and chips[j][i] == chip_to_match) then
                    number_of_matches = number_of_matches + 1
                else
                    chip_to_match = direction == DIRECTION.HORIZONTAL and chips[i][j] or chips[j][i]
                    if number_of_matches >= 3 then
                        add_match(direction, i, number_of_matches, j-1)
                    end
                    number_of_matches = 1
                end
            end

            if number_of_matches >= 3 then
                add_match(direction, i, number_of_matches, m)
            end
        end
    end

    local function find_matches()
        log:debug("[board] Calculating matches...")

        matches = {}
        find_matches_for_dir(DIRECTION.HORIZONTAL)
        find_matches_for_dir(DIRECTION.VERTICAL)
        -- Return matches table if #matches > 0, else return false.
        log:debug("[board] Total number of matches found: " .. #matches)
        return #matches > 0 and matches or false
    end

    local function remove_matches()
        log:debug("[board] Removing matches...")

        for _, match in ipairs(matches) do
            for _, grid_location in ipairs(match) do
                local i, j = table.unpack(grid_location)
                chips[i][j] = nil
            end
        end
        matches = {}
    end

    local function replace_spaces_with_falling_chips()
        log:debug("[board] Replacing spaces with falling chips...")

        -- For each column we go from the bottom up chip by chip until we hit the first space.
        for j = 1, WIDTH do
            local last_chip_was_space = false
            local lowest_space_i = 0

            local i = HEIGHT
            while i >= 1 do
                local chip = chips[i][j]
                -- if the last chip was already a space
                if last_chip_was_space then
                    -- if the current chip is not a space, bring it down to the lowest space
                    if chip then
                        -- put the chip in the correct spot & set its prior position to nil
                        chips[lowest_space_i][j] = chip
                        chips[i][j] = nil
                        -- then start back from here
                        last_chip_was_space = false
                        i = lowest_space_i
                        lowest_space_i = 0
                    end
                -- when we hit the first space, we save this fact as well as the first space position
                elseif chip == nil then
                    last_chip_was_space = true
                    if lowest_space_i == 0 then
                        lowest_space_i = i
                    end
                end

                i = i - 1
            end
        end
    end

    local function replace_spaces_with_random_chips()
        log:debug("[board] Replacing spaces with random chips...")
        for i = 1, WIDTH do
            for j = 1, HEIGHT do
                if not chips[i][j] then
                    local random_color = COLORS[math.random(#COLORS)]
                    chips[i][j] = CHIPS[random_color]
                end
            end
        end
    end

    local function swap(from, to)
        local from_i, from_j = table.unpack(from)
        local to_i, to_j = table.unpack(to)
        log:debug(string.format("[board] Swapping {%d, %d} with {%d, %d}...", from_i, from_j, to_i, to_j))
        chips[to_i][to_j], chips[from_i][from_j] = chips[from_i][from_j], chips[to_i][to_j]
    end

    local function shuffle()
        log:debug("[board] Shuffling chips...")
        -- Starting from the end swap a chip with one preceeding it picked at random
        math.randomseed(os.time())
        local size = WIDTH * HEIGHT
        for from_ij = size-1, 2, -1 do
            local from = {from_ij // WIDTH + 1, from_ij % WIDTH + 1}
            local to_ij = math.random(from_ij-1)
            local to = {to_ij // WIDTH + 1, to_ij % WIDTH + 1}
            swap(from, to)
        end
        -- swap last two
        swap({1, 2}, {1, 1})
    end


    local function move_exists_for_dir(direction)
        local n = direction == DIRECTION.HORIZONTAL and HEIGHT or WIDTH
        local m = direction == DIRECTION.HORIZONTAL and WIDTH or HEIGHT

        for i = 1, n do
            for j = 1, m-1 do
                if direction == DIRECTION.HORIZONTAL then
                    swap({i, j}, {i, j+1})
                else
                    swap({j, i}, {j+1, i})
                end
                if find_matches() then
                    if direction == DIRECTION.HORIZONTAL then
                        swap({i, j}, {i, j+1})
                    else
                        swap({j, i}, {j+1, i})
                    end
                    find_matches()
                    return true
                else
                    if direction == DIRECTION.HORIZONTAL then
                        swap({i, j}, {i, j+1})
                    else
                        swap({j, i}, {j+1, i})
                    end
                end
            end
        end

        find_matches()
        return false
    end

    --[[
        Returns true if there exist a move that results in a match.
        For a (relatively) small board, the following simple brute force algorithm will suffice:
        - Simply try all possible swaps.
        - For each swap check if the board contains 3 or more identical chips in a row/column.
    ]]
    local function move_exists()
        log:debug("[board] Checking for moves...")
        if move_exists_for_dir(DIRECTION.HORIZONTAL) then
            return true
        end
        if move_exists_for_dir(DIRECTION.VERTICAL) then
            return true
        end
        return false
    end

    -- Export locals for unit testing.

    if _TEST then
        self.get = get
        self.set = set
        self.find_matches = find_matches
        self.move_exists = move_exists
        self.remove_matches = remove_matches
        self.replace_spaces_with_falling_chips = replace_spaces_with_falling_chips
    end

    -- Public methods

    --[[
        Generates a random match-less board with at least one move that results in a match.
    ]]
    function self.init()
        log:info(string.format("[board] Generating a %dx%d board with chips of %d colors...", WIDTH, HEIGHT, #COLORS))
        chips = {}

        for i = 1, HEIGHT do
            local row = {}
            chips[i] = row
            for j = 1, WIDTH do
                local random_color = COLORS[math.random(#COLORS)]
                row[j] = CHIPS[random_color]
            end
        end

        self.mix()
    end

    --[[
        Performs actions on the board:
        - removes matches if there are any and then fills the resulting spaces;
        - if there is no any move that results in a match mixes the chips.
    ]]
    function self.tick()
        while find_matches() do
            log:info("[board] Matches found, moving chips...")
            remove_matches()
            replace_spaces_with_falling_chips()
            replace_spaces_with_random_chips()
        end
        log:info("[board] Done: no more matches.")

        while not move_exists() do
            log:info("[board] Found no moves, mixing...")
            self.mix()
        end
        log:info("[board] Done: move found.")
    end

    --[[
        Performs a user move by swaping two chips specified by their locations on the board.
        If there are no matches after swap, rolls back by repeating the swap.
    ]]
    function self.move(from, to)
        swap(from, to)
        if not find_matches() then
            log:info("[board] No matches found, thus restoring the board...")
            swap(from, to)
        end
    end

    --[[
        Tries to shuffles the chips to get a a match-less board with at least one move that results in a match.
        If can not achieve the goal in (w*h)^2 attempts, exits the app.
    ]]
    function self.mix()
        local attempts = 0
        while attempts < MAX_SHUFFLE_ATTEMPTS and (find_matches() or not move_exists()) do
            log:debug("[board] Found matches and/or no moves.")
            attempts = attempts + 1
            log:debug(string.format("[board] Shuffling (attempt %d of %d)...", attempts, MAX_SHUFFLE_ATTEMPTS))
            shuffle()
        end

        if attempts == MAX_SHUFFLE_ATTEMPTS then
            log:info("[board] Max mix attempts reached, exiting...")
            os.exit()
        else
            log:info(string.format("[board] Board generated successfully in %d attempts!", attempts))
        end
    end

    --[[
        Dumps a (colored) character representation of a table using the associated view.
    ]]
    function self.dump()
        local t = get()
        view.display(t)
    end

    return self
end

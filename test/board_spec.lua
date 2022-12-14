require("config")
require("logger")


log:setLevel(log.WARN)

local game_config_3x3x6 = config.new("config/3x3x6.json")
local game_config_4x4x6 = config.new("config/4x4x6.json")
local game_config_6x6x6 = config.new("config/6x6x6.json")

local A = "A"
local B = "B"
local C = "C"
local D = "D"
local E = "E"
local F = "F"
local _ = " "

local board_6x6_rows = {
    {A, A, A, A, A, A},
    {B, B, B, B, B, B},
    {C, C, C, C, C, C},
    {D, D, D, D, D, D},
    {E, E, E, E, E, E},
    {F, F, F, F, F, F}
}

local board_6x6_rows_macthes_removed = {
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {_, _, _, _, _, _}
}

local board_6x6_rows_macthes_replaced = {
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {_, _, _, _, _, _}
}

local board_6x6_half_rows = {
    {A, A, A, B, C, D},
    {C, D, E, B, B, B},
    {C, C, C, D, E, F},
    {E, F, A, D, D, D},
    {E, E, E, F, A, B},
    {A, B, C, F, F, F}
}

local board_6x6_half_rows_macthes_removed = {
    {_, _, _, B, C, D},
    {C, D, E, _, _, _},
    {_, _, _, D, E, F},
    {E, F, A, _, _, _},
    {_, _, _, F, A, B},
    {A, B, C, _, _, _}
}

local board_6x6_half_rows_macthes_replaced = {
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {C, D, E, B, C, D},
    {E, F, A, D, E, F},
    {A, B, C, F, A, B}
}

local board_6x6_cols = {
    {A, B, C, D, E, F},
    {A, B, C, D, E, F},
    {A, B, C, D, E, F},
    {A, B, C, D, E, F},
    {A, B, C, D, E, F},
    {A, B, C, D, E, F}
}

local board_6x6_half_cols = {
    {A, C, C, E, E, A},
    {A, D, C, F, E, B},
    {A, E, C, A, E, C},
    {B, B, D, D, F, F},
    {C, B, E, D, A, F},
    {D, B, F, D, B, F}
}

local board_6x6_half_cols_macthes_removed = {
    {_, C, _, E, _, A},
    {_, D, _, F, _, B},
    {_, E, _, A, _, C},
    {B, _, D, _, F, _},
    {C, _, E, _, A, _},
    {D, _, F, _, B, _}
}

local board_6x6_half_cols_macthes_replaced = {
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {B, C, D, E, F, A},
    {C, D, E, F, A, B},
    {D, E, F, A, B, C}
}

local board_6x6_cross = {
    {A, B, C, D, E, F},
    {A, B, C, D, E, F},
    {C, C, C, D, D, D},
    {C, C, C, D, D, D},
    {A, B, C, D, E, F},
    {A, B, C, D, E, F}
}

local board_6x6_cross_macthes_removed = {
    {A, B, _, _, E, F},
    {A, B, _, _, E, F},
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {A, B, _, _, E, F},
    {A, B, _, _, E, F}
}

local board_6x6_cross_macthes_replaced = {
    {_, _, _, _, _, _},
    {_, _, _, _, _, _},
    {A, B, _, _, E, F},
    {A, B, _, _, E, F},
    {A, B, _, _, E, F},
    {A, B, _, _, E, F}
}

local board_6x6_rows_matches = {
    { {1, 6}, {1, 5}, {1, 4}, {1, 3}, {1, 2}, {1, 1} },
    { {2, 6}, {2, 5}, {2, 4}, {2, 3}, {2, 2}, {2, 1} },
    { {3, 6}, {3, 5}, {3, 4}, {3, 3}, {3, 2}, {3, 1} },
    { {4, 6}, {4, 5}, {4, 4}, {4, 3}, {4, 2}, {4, 1} },
    { {5, 6}, {5, 5}, {5, 4}, {5, 3}, {5, 2}, {5, 1} },
    { {6, 6}, {6, 5}, {6, 4}, {6, 3}, {6, 2}, {6, 1} }
}

local board_6x6_half_rows_matches = {
    { {1, 3}, {1, 2}, {1, 1} },
    { {2, 6}, {2, 5}, {2, 4} },
    { {3, 3}, {3, 2}, {3, 1} },
    { {4, 6}, {4, 5}, {4, 4} },
    { {5, 3}, {5, 2}, {5, 1} },
    { {6, 6}, {6, 5}, {6, 4} }
}

local board_6x6_cols_matches = {
    { {6, 1}, {5, 1}, {4, 1}, {3, 1}, {2, 1}, {1, 1} },
    { {6, 2}, {5, 2}, {4, 2}, {3, 2}, {2, 2}, {1, 2} },
    { {6, 3}, {5, 3}, {4, 3}, {3, 3}, {2, 3}, {1, 3} },
    { {6, 4}, {5, 4}, {4, 4}, {3, 4}, {2, 4}, {1, 4} },
    { {6, 5}, {5, 5}, {4, 5}, {3, 5}, {2, 5}, {1, 5} },
    { {6, 6}, {5, 6}, {4, 6}, {3, 6}, {2, 6}, {1, 6} },
}

local board_6x6_half_cols_matches = {
    { {3, 1}, {2, 1}, {1, 1} },
    { {6, 2}, {5, 2}, {4, 2} },
    { {3, 3}, {2, 3}, {1, 3} },
    { {6, 4}, {5, 4}, {4, 4} },
    { {3, 5}, {2, 5}, {1, 5} },
    { {6, 6}, {5, 6}, {4, 6} }
}

local board_6x6_cross_matches = {
    { {3, 3}, {3, 2}, {3, 1} },
    { {3, 6}, {3, 5}, {3, 4} },
    { {4, 3}, {4, 2}, {4, 1} },
    { {4, 6}, {4, 5}, {4, 4} },
    { {6, 3}, {5, 3}, {4, 3}, {3, 3}, {2, 3}, {1, 3} },
    { {6, 4}, {5, 4}, {4, 4}, {3, 4}, {2, 4}, {1, 4} }
}

local board_3x3_moves_1 = {
    {E, C, A},
    {E, D, A},
    {D, E, E}
}

local board_3x3_moves_2 = {
    {A, C, F},
    {C, D, E},
    {D, E, D}
}

local board_3x3_moves_3 = {
    {E, F, B},
    {D, F, C},
    {F, E, C}
}

local board_3x3_no_moves_1 = {
    {B, D, E},
    {A, A, E},
    {A, D, F}
}

local board_3x3_no_moves_2 = {
    {C, B, C},
    {A, D, F},
    {C, A, B}
}

local board_3x3_no_moves_3 = {
    {E, E, C},
    {B, F, D},
    {D, B, C}
}

local board_4x4_moves_1 = {
    {D, E, F, A},
    {D, B, E, F},
    {A, E, B, C},
    {B, D, D, B}
}

local board_4x4_moves_2 = {
    {E, B, C, C},
    {F, D, B, A},
    {E, B, F, B},
    {E, F, F, D}
}

local board_4x4_moves_3 = {
    {D, F, D, A},
    {D, A, E, A},
    {E, A, D, C},
    {A, F, E, B}
}

local board_4x4_no_moves_1 = {
    {D, D, A, F},
    {D, A, E, B},
    {B, E, D, C},
    {B, F, B, F}
}

local board_4x4_no_moves_2 = {
    {B, F, D, A},
    {C, D, F, B},
    {C, E, A, D},
    {D, B, C, B}
}

local board_4x4_no_moves_3 = {
    {C, E, B, E},
    {C, F, F, D},
    {A, D, A, C},
    {F, C, D, E}
}


describe("board unit tests", function ()
    setup(function()
        _G._TEST = true
        require("board")
    end)

    teardown(function()
        _G._TEST = _
    end)

    describe("board matches unit tests", function ()

        describe("board 6x6 with all rows containing 6 chips of the same color", function ()
            it("checks that matches are correct", function ()
                local b = board.new(game_config_6x6x6)
                b.set(board_6x6_rows)

                local matches = b.find_matches()
                assert.is.same(board_6x6_rows_matches, matches)

                b.remove_matches()
                assert.is.same(board_6x6_rows_macthes_removed, b.get())

                b.replace_spaces_with_falling_chips()
                assert.is.same(board_6x6_rows_macthes_replaced, b.get())
            end)
        end)

        describe("board 6x6 with all rows containing 3 chips of the same color", function ()
            it("checks that matches are correct", function ()
                local b = board.new(game_config_6x6x6)
                b.set(board_6x6_half_rows)

                local matches = b.find_matches()
                assert.is.same(board_6x6_half_rows_matches, matches)

                b.remove_matches()
                assert.is.same(board_6x6_half_rows_macthes_removed, b.get())

                b.replace_spaces_with_falling_chips()
                assert.is.same(board_6x6_half_rows_macthes_replaced, b.get())
            end)
        end)

        describe("board 6x6 with all cols containing 6 chips of the same color", function ()
            it("checks that matches are correct", function ()
                local b = board.new(game_config_6x6x6)
                b.set(board_6x6_cols)

                local matches = b.find_matches()
                assert.is.same(board_6x6_cols_matches, matches)

                b.remove_matches()
                assert.is.same(board_6x6_rows_macthes_removed, b.get())

                b.replace_spaces_with_falling_chips()
                assert.is.same(board_6x6_rows_macthes_replaced, b.get())
            end)
        end)

        describe("board 6x6 with all cols containing 3 chips of the same color", function ()
            it("checks that matches are correct", function ()
                local b = board.new(game_config_6x6x6)
                b.set(board_6x6_half_cols)

                local matches = b.find_matches()
                assert.is.same(board_6x6_half_cols_matches, matches)

                b.remove_matches()
                assert.is.same(board_6x6_half_cols_macthes_removed, b.get())

                b.replace_spaces_with_falling_chips()
                assert.is.same(board_6x6_half_cols_macthes_replaced, b.get())
            end)
        end)

        describe("board 6x6 with cross pattern", function ()
            it("checks that matches are correct", function ()
                local b = board.new(game_config_6x6x6)
                b.set(board_6x6_cross)

                local matches = b.find_matches()
                assert.is.same(board_6x6_cross_matches, matches)

                b.remove_matches()
                assert.is.same(board_6x6_cross_macthes_removed, b.get())

                b.replace_spaces_with_falling_chips()
                assert.is.same(board_6x6_cross_macthes_replaced, b.get())
            end)
        end)

    end)

    describe("board.move_exists() tests", function ()

        describe("board 3x3 with moves (1)", function ()
            it("checks that there are moves", function ()
                local b = board.new(game_config_3x3x6)
                b.set(board_3x3_moves_1)
                assert.is_true(b.move_exists())
            end)
        end)

        describe("board 3x3 with moves (2)", function ()
            it("checks that there are moves", function ()
                local b = board.new(game_config_3x3x6)
                b.set(board_3x3_moves_2)
                assert.is_true(b.move_exists())
            end)
        end)

        describe("board 3x3 with moves (3)", function ()
            it("checks that there are moves", function ()
                local b = board.new(game_config_3x3x6)
                b.set(board_3x3_moves_3)
                assert.is_true(b.move_exists())
            end)
        end)

        describe("board 3x3 with no moves (1)", function ()
            it("checks that there are no moves", function ()
                local b = board.new(game_config_3x3x6)
                b.set(board_3x3_no_moves_1)
                assert.is_false(b.move_exists())
            end)
        end)

        describe("board 3x3 with no moves (2)", function ()
            it("checks that there are no moves", function ()
                local b = board.new(game_config_3x3x6)
                b.set(board_3x3_no_moves_2)
                assert.is_false(b.move_exists())
            end)
        end)

        describe("board 3x3 with no moves (3)", function ()
            it("checks that there are no moves", function ()
                local b = board.new(game_config_3x3x6)
                b.set(board_3x3_no_moves_3)
                assert.is_false(b.move_exists())
            end)
        end)

        describe("board 4x4 with moves (1)", function ()
            it("checks that there are moves", function ()
                local b = board.new(game_config_4x4x6)
                b.set(board_4x4_moves_1)
                assert.is_true(b.move_exists())
            end)
        end)

        describe("board 4x4 with moves (2)", function ()
            it("checks that there are moves", function ()
                local b = board.new(game_config_4x4x6)
                b.set(board_4x4_moves_2)
                assert.is_true(b.move_exists())
            end)
        end)

        describe("board 4x4 with moves (3)", function ()
            it("checks that there are moves", function ()
                local b = board.new(game_config_4x4x6)
                b.set(board_4x4_moves_3)
                assert.is_true(b.move_exists())
            end)
        end)

        describe("board 4x4 with no moves (1)", function ()
            it("checks that there are mo moves", function ()
                local b = board.new(game_config_4x4x6)
                b.set(board_4x4_no_moves_1)
                assert.is_false(b.move_exists())
            end)
        end)

        describe("board 4x4 with no moves (2)", function ()
            it("checks that there are mo moves", function ()
                local b = board.new(game_config_4x4x6)
                b.set(board_4x4_no_moves_2)
                assert.is_false(b.move_exists())
            end)
        end)

        describe("board 4x4 with no moves (3)", function ()
            it("checks that there are mo moves", function ()
                local b = board.new(game_config_4x4x6)
                b.set(board_4x4_no_moves_3)
                assert.is_false(b.move_exists())
            end)
        end)

    end)
end)

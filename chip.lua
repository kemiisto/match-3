chip = {}


function chip.new(chip_color, chip_shape)
    local self = {}

    -- Private variables:

    local color = chip_color
    local shape = chip_shape or "default"

    -- Public methods:

    function self.dump()
        return color
    end

    return self
end

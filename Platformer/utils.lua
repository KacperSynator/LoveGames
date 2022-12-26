local anim8 = require "libraries/anim8/anim8"

function LoadAnimation(strip_path, frames, width, height, row, duration, onLoop)
    duration = duration or 0.1
    local strip = love.graphics.newImage(strip_path)
    local grid = anim8.newGrid(width, height, strip:getWidth(), strip:getHeight())

    return { animation = anim8.newAnimation(grid(frames, row), duration, onLoop),
             image = strip }
end

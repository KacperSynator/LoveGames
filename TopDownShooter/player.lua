local anim8 = require "libraries/anim8/anim8"
local Enemy = require "enemy"


function LoadAnimation(strip_path, frames, size_x, size_y, row, interval)
    interval = interval or 0.1
    local strip = love.graphics.newImage(strip_path)
    local grid = anim8.newGrid(size_x, size_y, strip:getWidth(), strip:getHeight())
    local result = {}
    result.animation = anim8.newAnimation(grid(frames, row), interval)
    result.image = strip
    return result
end

function MovePlayer(player, dt, map_corners)
    player.moving = true

        if love.keyboard.isDown("w") and player.y > map_corners.top_left_y then
            player.y = player.y - player.speed * dt
        elseif love.keyboard.isDown("a") and player.x > map_corners.top_left_x then
            player.x = player.x - player.speed * dt
        elseif love.keyboard.isDown("s") and player.y < map_corners.bot_right_y then
            player.y = player.y + player.speed * dt
        elseif love.keyboard.isDown("d") and player.x < map_corners.bot_right_x then
            player.x = player.x + player.speed * dt
        else
            player.moving = false
        end
end

local speed = 200
local animation_idle = LoadAnimation("Assets/sPlayerIdle_strip4.png", '1-4', 40, 40, 1)
local animation_run = LoadAnimation("Assets/sPlayerRun_strip7.png", '1-7', 40, 40, 1)

local Player = Enemy:new()
    function Player:new(o, x, y, rotation, scale_x, scale_y)
        o = o or Enemy:new(o, x, y, rotation, scale_x, scale_y)
        setmetatable(o, self)

        self.__index = self
        o.moving = false
        o.speed = speed
        o.image = animation_idle.image
        o.animation = animation_idle.animation
        return o
    end

    function Player:update(dt, map_corners)
        MovePlayer(self, dt, map_corners)

        if self.moving then
            self.animation = animation_run.animation
            self.image = animation_run.image
        else
            self.animation = animation_idle.animation
            self.image = animation_idle.image
        end

        self.animation:update(dt)
    end

return Player

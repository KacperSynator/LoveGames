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

    function Player:move(dt)
        self.moving = true
        
        if love.keyboard.isDown("w") then
            self.y = self.y - speed * dt
        elseif love.keyboard.isDown("a") then
            self.x = self.x - speed * dt
        elseif love.keyboard.isDown("s") then
            self.y = self.y + speed * dt
        elseif love.keyboard.isDown("d") then
            self.x = self.x + speed * dt
        else
            self.moving = false
        end

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
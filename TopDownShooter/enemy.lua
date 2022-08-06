local anim8 = require "libraries/anim8/anim8"
local GameObject = require "game_object"


function LoadAnimation(strip_path, frames, size_x, size_y, row, interval)
    interval = interval or 0.1
    local strip = love.graphics.newImage(strip_path)
    local grid = anim8.newGrid(size_x, size_y, strip:getWidth(), strip:getHeight())
    local result = {}
    result.animation = anim8.newAnimation(grid(frames, row), interval)
    result.image = strip
    return result
end

local speed = 600
local animation = LoadAnimation("Assets/sEnemy_strip7.png", '1-7', 40, 40, 1)
local image_dead = love.graphics.newImage("Assets/sEnemyDead.png")
local death_sound = love.audio.newSource("Assets/aDeath.wav", "static")

local Enemy = GameObject:new()
    function Enemy:new(o, x, y, rotation, scale_x, scale_y)
        o = o or GameObject:new(o, x, y, rotation, scale_x, scale_y)
        setmetatable(o, self)

        self.__index = self
        o.speed = speed
        o.image = animation.image
        o.animation = animation.animation
        o.dead = false

        return o
    end

    function Enemy:move(dt)
        self.animation:update(dt)
    end

    function Enemy:draw()
        if self.dead then
            love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale_x, self.scale_y)
        else
            self.animation:draw(self.image, self.x, self.y, self.rotation, self.scale_x, self.scale_y)
        end
    end

    function Enemy:isDead()
        return self.dead
    end

    function Enemy:die()
        self.image = image_dead
        self.dead = true
        death_sound:play()
    end

return Enemy
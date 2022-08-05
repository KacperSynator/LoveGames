local anim8 = require "libraries/anim8/anim8"
local GameObject = require "game_object"

local speed = 600
local animation = love.graphics.newImage("Assets/sEnemy_strip7.png")
local image_dead = love.graphics.newImage("Assets/sEnemyDead.png")
local death_sound = love.audio.newSource("Assets/aDeath.wav", "static")

local Enemy = GameObject:new()
    function Enemy:new(o, x, y, rotation, scale_x, scale_y)
        o = o or GameObject:new(o, x, y, rotation, scale_x, scale_y)
        setmetatable(o, self)

        self.__index = self
        o.speed = speed
        o.image = animation
        o.dead = false

        local grid = anim8.newGrid(40, 40, animation:getWidth(),
                                           animation:getHeight())

        o.animation = anim8.newAnimation(grid('1-7', 1), 0.1)

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

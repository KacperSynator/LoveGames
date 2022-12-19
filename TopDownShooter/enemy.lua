local anim8 = require "libraries/anim8/anim8"
local GameObject = require "game_object"


function LoadAnimation(strip_path, frames, size_x, size_y, row, interval)
    interval = interval or 0.1
    local strip = love.graphics.newImage(strip_path)
    local grid = anim8.newGrid(size_x, size_y, strip:getWidth(), strip:getHeight())

    return { animation = anim8.newAnimation(grid(frames, row), interval),
             image = strip }
end

local speed = 100
local strip_frame_size = { x = 40, y = 40 }
local image_dead = love.graphics.newImage("Assets/sEnemyDead.png")
local death_sound = love.audio.newSource("Assets/aDeath.wav", "static")
local radius_offset = -5

local Enemy = GameObject:new()
    function Enemy:new(o, x, y, rotation, scale)
        o = o or GameObject:new(o, x, y, rotation, scale)
        setmetatable(o, self)

        local animation = LoadAnimation("Assets/sEnemy_strip7.png", '1-7', strip_frame_size.x, strip_frame_size.y, 1)

        self.__index = self
        o.speed = speed
        o.image = animation.image
        o.animation = animation.animation
        o.dead = false
        o.death_sound = death_sound

        return o
    end

    function Enemy:update(dt, player_position)
        if not self.dead then
            local distance_to_player = math.sqrt( (self.x - player_position.x)^2 + (self.y - player_position.y)^2 )
            self.x = self.x + (player_position.x - self.x) / distance_to_player * self.speed * dt
            self.y = self.y + (player_position.y - self.y) / distance_to_player * self.speed * dt

            self.animation:update(dt)
        end
    end

    function Enemy:draw()
        if self.dead then
            love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale)
        else
            self.animation:draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale)
        end
    end

    function Enemy:isDead()
        return self.dead
    end

    function Enemy:die()
        self.image = image_dead
        self.dead = true
        self.death_sound:play()
    end

    function Enemy:getCenter()
        return { x = self.x + strip_frame_size.x * self.scale / 2,
                 y = self.y + strip_frame_size.y * self.scale / 2 }
    end

    function Enemy:getRadius()
        return self.image:getHeight() * self.scale / 2 + radius_offset
    end

return Enemy

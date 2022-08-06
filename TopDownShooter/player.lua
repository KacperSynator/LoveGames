local anim8 = require "libraries/anim8/anim8"
local GameObject = require "game_object"
local Gun = require "gun"
local strip_frame_size = { x = 40, y = 40 }


function LoadAnimation(strip_path, frames, size_x, size_y, row, interval)
    interval = interval or 0.1
    local strip = love.graphics.newImage(strip_path)
    local grid = anim8.newGrid(size_x, size_y, strip:getWidth(), strip:getHeight())

    return { animation = anim8.newAnimation(grid(frames, row), interval),
             image = strip }
end

function MovePlayer(player, dt, map_corners)
    player.moving = true
        local pos = player:getCenter()
        if love.keyboard.isDown("w") and pos.y > map_corners.top_left_y then
            player.y = player.y - player.speed * dt
        elseif love.keyboard.isDown("a") and pos.x > map_corners.top_left_x then
            player.x = player.x - player.speed * dt
        elseif love.keyboard.isDown("s") and pos.y < map_corners.bot_right_y then
            player.y = player.y + player.speed * dt
        elseif love.keyboard.isDown("d") and pos.x < map_corners.bot_right_x then
            player.x = player.x + player.speed * dt
        else
            player.moving = false
        end
end

local speed = 200
local animation_idle = LoadAnimation("Assets/sPlayerIdle_strip4.png", '1-4', strip_frame_size.x, strip_frame_size.y, 1)
local animation_run = LoadAnimation("Assets/sPlayerRun_strip7.png", '1-7', strip_frame_size.x, strip_frame_size.y, 1)

local Player = GameObject:new()
    function Player:new(o, x, y, rotation, scale)
        o = o or GameObject:new(o, x, y, rotation, scale)
        setmetatable(o, self)

        self.__index = self
        o.moving = false
        o.speed = speed
        o.image = animation_idle.image
        o.animation = animation_idle.animation
        local center = o:getCenter()
        o.gun = Gun:new(nil, center.x, center.y, rotation, 0.9)
        return o
    end

    function Player:update(dt, map_corners)
        MovePlayer(self, dt, map_corners)
        self.gun.x = self:getCenter().x
        self.gun.y = self:getCenter().y
        self.gun:update(dt, map_corners)

        if self.moving then
            self.animation = animation_run.animation
            self.image = animation_run.image
        else
            self.animation = animation_idle.animation
            self.image = animation_idle.image
        end

        self.animation:update(dt)
    end

    function Player:draw()
        self.animation:draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale)
        self.gun:draw()
    end

    function Player:getCenter()
        return { x = self.x + strip_frame_size.x * self.scale / 2,
                 y = self.y + strip_frame_size.y * self.scale / 2 }
    end

    function Player:shoot(x, y)
        self.gun:shoot(x, y)
    end

return Player

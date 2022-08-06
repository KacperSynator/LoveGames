local GameObject = require "game_object"
local Bullet = require "bullet"


local image = love.graphics.newImage("Assets/sGun.png")
local fire_delay = 1

local Gun = GameObject:new()
    function Gun:new(o, x, y, rotation, scale)
        o = o or GameObject:new(o, x, y, rotation, scale)
        setmetatable(o, self)

        self.__index = self
        self.image = image
        self.bullets = {}

        return o
    end

    function Gun:update(dt, map_corners)
        local mouse_x = love.mouse.getX()
        local mouse_y = love.mouse.getY()
        local vec = { x = mouse_x - self.x, y = mouse_y - self.y }
        self.rotation = -math.acos(vec.x / math.sqrt(vec.x^2 + vec.y^2))
        if mouse_y > self.y then
            self.rotation = -self.rotation
        end

        for pos, bullet in pairs(self.bullets) do
            bullet:update(dt)
            if bullet.x < map_corners.top_left_x or bullet.x > map_corners.bot_right_x or
               bullet.y < map_corners.top_left_y or bullet.y > map_corners.bot_right_y then

                table.remove(self.bullets, pos)
            end
        end
    end

    function Gun:draw()
        for _, bullet in pairs(self.bullets) do
            bullet:draw()
        end
        love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale)
    end

    function Gun:shoot(x, y)
        table.insert(self.bullets, Bullet:new(nil, self.x, self.y, x, y))
    end

return Gun
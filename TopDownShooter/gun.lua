local GameObject = require "game_object"
local Bullet = require "bullet"


local image = love.graphics.newImage("Assets/sGun.png")
local fire_delay = 0.5

local Gun = GameObject:new()
    function Gun:new(o, x, y, rotation, scale)
        o = o or GameObject:new(o, x, y, rotation, scale)
        setmetatable(o, self)

        self.__index = self
        self.image = image
        self.fire_timer = 0
        self.bullets = {}

        return o
    end

    function Gun:update(dt, map_corners)
        self.rotation = math.atan2( love.mouse.getY() - self.y, love.mouse.getX() - self.x )

        if self.fire_timer > 0 then
            self.fire_timer = self.fire_timer - dt
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
        if self.fire_timer <= 0 then
            table.insert(self.bullets, Bullet:new(nil, self.x, self.y, x, y))
            self.fire_timer = fire_delay
        end
    end

return Gun

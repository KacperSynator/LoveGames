local GameObject = require "game_object"


local Sprites = {}
Sprites.map = love.graphics.newImage("Assets/sMap.png")
Sprites.wall = love.graphics.newImage("Assets/sWall.png")
Sprites.bg = love.graphics.newImage("Assets/sBg.png")


local Map = GameObject:new()
    local Wall = GameObject:new()
        function Wall:new(o, x, y, rotation, scale)
            local offset = -15 * scale

            o = o or GameObject:new(o, x , y, rotation, scale)
            setmetatable(o, self)

            o.x = o.x + offset
            o.y = o.y + offset

            self.__index = self
            o.image = Sprites.wall
            return o
        end

    local Background = GameObject:new()
        function Background:new(o, x , y, rotation, scale)
            o = o or GameObject:new(o, x , y, rotation, scale)
            setmetatable(o, self)

            self.__index = self
            o.image = Sprites.bg
            return o
        end

    function Map:new(o, scale)
        scale = scale or 1
        o = o or GameObject:new(o, 0, 0, 0, scale)
        setmetatable(o, self)

        self.__index = self
        o.image = Sprites.map
        o.x = (love.graphics.getWidth() - o.image:getWidth() * scale) / 2
        o.y = (love.graphics.getHeight() - o.image:getHeight() * scale) / 2
        o.wall = Wall:new(nil, o.x, o.y, o.rotation, o.scale)
        o.bgs = { Background:new(nil, 0, 0, 0, scale) }

        local bg_width = o.bgs[1].image:getWidth() * scale
        local bg_height = o.bgs[1].image:getHeight() * scale
        for x = 0, love.graphics.getWidth(), bg_width do
            for y = 0,  love.graphics.getHeight(), bg_height do
                table.insert(o.bgs, Background:new(nil, x, y, 0, scale))
            end
        end
        return o
    end

    function Map:draw()
        for _, bg in pairs(self.bgs) do
            bg:draw()
        end

        love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale)
        self.wall:draw()
    end

    function Map:corners()
        local x_bot_r = self.x + self.image:getWidth() * self.scale
        local y_bot_r = self.y + self.image:getHeight() * self.scale

        return { top_left_x = self.x, top_left_y = self.y,
                 bot_right_x = x_bot_r, bot_right_y = y_bot_r }
    end


return Map


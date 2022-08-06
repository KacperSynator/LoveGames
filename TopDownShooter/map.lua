local GameObject = require "game_object"


local Sprites = {}
Sprites.map = love.graphics.newImage("Assets/sMap.png")
Sprites.wall = love.graphics.newImage("Assets/sWall.png")
Sprites.bg = love.graphics.newImage("Assets/sBg.png")


local Map = GameObject:new()
    local Wall = GameObject:new()
        function Wall:new(o, x, y, rotation, scale_x, scale_y)
            local offset = -15
            local offset_x =  offset * scale_x
            local offset_y  = offset * scale_y

            o = o or GameObject:new(o, x , y, rotation, scale_x, scale_y)
            setmetatable(o, self)

            o.x = o.x + offset_x
            o.y = o.y + offset_y

            self.__index = self
            o.image = Sprites.wall
            return o
        end

    local Background = GameObject:new()
        function Background:new(o, x , y, rotation, scale_x, scale_y)
            o = o or GameObject:new(o, x , y, rotation, scale_x, scale_y)
            setmetatable(o, self)

            self.__index = self
            o.image = Sprites.bg
            return o
        end

    function Map:new(o, scale)
        scale = scale or 1
        o = o or GameObject:new(o, 0, 0, 0, scale, scale)
        setmetatable(o, self)

        self.__index = self
        o.image = Sprites.map
        o.x = (love.graphics.getWidth() - o.image:getWidth() * scale) / 2
        o.y = (love.graphics.getHeight() - o.image:getHeight() * scale) / 2
        o.wall = Wall:new(nil, o.x, o.y, o.rotation, o.scale_x, o.scale_y)
        o.bgs = { Background:new(nil, 0, 0, 0, scale, scale) }

        local bg_width = o.bgs[1].image:getWidth() * scale
        local bg_height = o.bgs[1].image:getHeight() * scale
        for x = 0, love.graphics.getWidth(), bg_width do
            for y = 0,  love.graphics.getHeight(), bg_height do
                table.insert(o.bgs, Background:new(nil, x, y, 0, scale, scale))
            end
        end
        return o
    end

    function Map:draw()
        for _, bg in pairs(self.bgs) do
            bg:draw()
        end

        love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale_x, self.scale_y)
        self.wall:draw()
    end

    function Map:corners()
        local x_bot_r = self.x + self.image:getWidth()
        local y_bot_r = self.y + self.image:getHeight()

        local result = {}
        result.top_left_x = self.x
        result.top_left_y = self.y
        result.bot_right_x = x_bot_r
        result.bot_right_y = y_bot_r
        return result
    end


return Map


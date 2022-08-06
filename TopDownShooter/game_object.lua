local GameObject = { x = 0, y = 0, rotation = 0, scale_x = 1, scale_y = 1, image = nil }

    function GameObject:new(o, x, y, rotation, scale_x, scale_y)
        o = o or {}
        setmetatable(o, self)
        
        self.__index = self
        o.x = x or 0
        o.y = y or 0
        o.rotation = rotation or 0
        o.scale_x = scale_x or 1
        o.scale_y = scale_y or 1

        return o
    end

    function  GameObject:draw()
        if self.image then
            love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale_x, self.scale_y)
        end
    end

    function GameObject:getPosition()
        return { x = self.x, y = self.y }
    end

return GameObject
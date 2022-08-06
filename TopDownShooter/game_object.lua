local GameObject = { x = 0, y = 0, rotation = 0, scale = 1, image = nil }

    function GameObject:new(o, x, y, rotation, scale)
        o = o or {}
        setmetatable(o, self)
        
        self.__index = self
        o.x = x or 0
        o.y = y or 0
        o.rotation = rotation or 0
        o.scale = scale or 1
        return o
    end

    function  GameObject:draw()
        if self.image then
            love.graphics.draw(self.image, self.x, self.y, self.rotation, self.scale, self.scale)
        end
    end

    function GameObject:getPosition()
        return { x = self.x, y = self.y }
    end

    function GameObject:getCenter()
        return { x = self.x + self.image:getWidth() * self.scale / 2,
                 y = self.y + self.image:getHeight() * self.scale / 2 }
    end

return GameObject
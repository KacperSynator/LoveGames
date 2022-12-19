local Platform = {x = 0, y = 0, size_x = 10, size_y = 10}
    function Platform:new(o, world, x, y, size_x, size_y)
        o = o or {}
        setmetatable(o, self)

        self.__index = self
        o.collider = world:newRectangleCollider(x, y, size_x, size_y, {collision_class = "Platform"})
        o.collider:setType("static")

        return o
    end

return Platform

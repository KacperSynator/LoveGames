local DangerZone = {x, y, size_x, size_y}
    function DangerZone:new(o, x, y, size_x, size_y)
        o = o or {}
        setmetatable(o, self)

        self.__index = self
        o.collider = world:newRectangleCollider(x, y, size_x, size_y, {collision_class = "Danger"})
        o.collider:setType("static")

        return o
    end

return DangerZone

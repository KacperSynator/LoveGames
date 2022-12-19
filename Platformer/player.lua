local speed = 150


local Player = {x = 0, y = 0}
    function Player:new(o, world, x, y)
        o = o or {}
        setmetatable(o, self)

        self.__index = self
        o.collider = world:newRectangleCollider(x, y, 80, 80, {collision_class = "Player"})
        o.collider:setFixedRotation(true)

        return o
    end

    function Player:jump(world)
        if not self.collider.body then
            return
        end
        
        local x, y = self.collider:getPosition()
        local colliders = world:queryRectangleArea(x - 40, y + 40, 80, 2, {"Platform"})

        if #colliders > 0 then
            self.collider:applyLinearImpulse(0, -7000)
        end
        
    end

    function Player:update(dt)
        if not self.collider.body then
          return
        end
       
        local x, y = self.collider:getPosition()

        if love.keyboard.isDown("d") then
            self.collider:setX(x + speed * dt)
        end

        if love.keyboard.isDown("a") then
            self.collider:setX(x - speed * dt)
        end

        if self.collider:enter("Danger") then
            self.collider:destroy()
        end
    end

return Player

require "utils"
require "player_states"

local speed = 150
local speed_modifier = 1.5
local jump_force = -3000
local attack_force = 500
local image_offset = {x = -55, y = -50}
local collider_size = {width = 24, height = 45}
local attack_query = {x = 20, y = -10, radius = 18}
local scale = 2

local Direction = {
    LEFT = -1,
    RIGHT = 1,
}

local Player = {}
    function Player:new(o, x, y)
        o = o or {}
        setmetatable(o, self)

        self.__index = self
        o.scale = scale
        o.rotation = 0
        o.speed = speed
        o.speed_modifier = speed_modifier
        o.jump_force = jump_force
        o.attack_force = attack_force
        o.image = Idle.animation.image
        o.animation = Idle.animation.animation
        o.state = Idle
        o.direction = Direction.RIGHT
        o.collider = world:newRectangleCollider(x, y, collider_size.width * o.scale, collider_size.height * o.scale, {collision_class = "Player"})
        o.collider:setFixedRotation(true)
        o.attack_index = 0

        return o
    end

    function Player:is_grounded()
        local x, y = self.collider:getPosition()
        local colliders = world:queryRectangleArea(x - collider_size.width / 2 * self.scale,
                                                   y + collider_size.height / 2 * self.scale,
                                                   collider_size.width * self.scale,
                                                   2,
                                                   {"Platform"})
        return #colliders > 0
    end

    function Player:jump()
        self.state.jump(self)
    end

    function Player:attack()
        self.state.attack(self)
    end

    function Player:do_attack()
        local x, y = self.collider:getPosition()
        local enemies = world:queryCircleArea(x + attack_query.x * self.direction * scale,
                                                y + attack_query.y * scale,
                                                attack_query.radius * scale,
                                                {"Enemy"})
    end

    function Player:update(dt)
        self.state.update(dt, self)
        self.animation = self.state.animation.animation
        self.image = self.state.animation.image

        if self.collider:enter("Danger") then
            self.state = Dead
        end

        self.animation:update(dt)
    end

    function Player:draw()
        self.animation:draw(self.image,
                            self.collider:getX() + image_offset.x * self.scale * self.direction,
                            self.collider:getY() + image_offset.y * self.scale,
                            self.rotation,
                            self.scale * self.direction,
                            self.scale)
    end

return Player

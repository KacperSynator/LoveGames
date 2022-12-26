local utils = require "utils"

local speed = 150
local speed_modifier = 1.5
local jump_force = -3000
local sprite_size = {width = 115, height = 84}
local image_offset = {x = -55, y = -50}
local collider_size = {width = 24, height = 45}
local scale = 2

local PlayerState = {
    IDLE = 1,
    WALK = 2,
    RUN = 3,
    JUMP = 4,
    FALL = 5,
    ATTACK = 6,
    DEAD = 7,
}

local Animations = {
    [PlayerState.IDLE] = LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-8", sprite_size.width, sprite_size.height, 1),
    [PlayerState.WALK] = LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-8", sprite_size.width, sprite_size.height, 2),
    [PlayerState.RUN] = LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-8", sprite_size.width, sprite_size.height, 3),
    [PlayerState.JUMP] = LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-1", sprite_size.width, sprite_size.height, 6),
    [PlayerState.FALL] = LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-1", sprite_size.width, sprite_size.height, 8),
    [PlayerState.ATTACK] = {
        LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-4", sprite_size.width, sprite_size.height, 9),
        LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-4", sprite_size.width, sprite_size.height, 10),
        LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-4", sprite_size.width, sprite_size.height, 11),
    },
}

local anim = Animations[PlayerState.IDLE]

local Direction = {
    LEFT = -1,
    RIGHT = 1,
}


local function animation(player)
    if player.state == PlayerState.ATTACK then
        return Animations[player.state][player.attack_index].animation, Animations[player.state][player.attack_index].image
    end

    return Animations[player.state].animation, Animations[player.state].image
end

local function state(player, next_state)
    if player.state == PlayerState.ATTACK then
        if player.animation.position == 4 then
            player.animation:gotoFrame(1)
            return next_state
        end

        return PlayerState.ATTACK
    end

    local _, velocity_y = player.collider:getLinearVelocity()
    if not player:is_grounded() and velocity_y < 0 then
        return PlayerState.JUMP
    end

    if not player:is_grounded() and velocity_y > 0 then
        return PlayerState.FALL
    end

    return next_state
end

local Player = {}
    function Player:new(o, x, y)
        o = o or {}
        setmetatable(o, self)

        self.__index = self
        o.scale = scale
        o.rotation = 0
        o.image = Animations[PlayerState.IDLE].image
        o.animation = Animations[PlayerState.IDLE].animation
        o.playar_state = PlayerState.IDLE
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
        if not self.collider.body then
            return
        end

        if self:is_grounded() then
            self.collider:applyLinearImpulse(0, jump_force)
        end
    end

    function Player:attack()
        if self.state ~= PlayerState.ATTACK then
            self.state = PlayerState.ATTACK
            self.attack_index = self.attack_index + 1
            self.collider:applyLinearImpulse(500 * self.direction, 0)

            if self.attack_index == 4 then
                self.attack_index = 1
            end
        end
    end

    function Player:update(dt)
        if not self.collider.body then
          return
        end

        local x = self.collider:getX()
        local speed_mod = love.keyboard.isDown("lshift") and speed_modifier or 1
        local next_state = PlayerState.IDLE

        if love.keyboard.isDown("d") then
            self.collider:setX(x + speed * dt * speed_mod)
            self.direction = Direction.RIGHT
            next_state = love.keyboard.isDown("lshift") and PlayerState.RUN or PlayerState.WALK
        end

        if love.keyboard.isDown("a") then
            self.collider:setX(x - speed * dt * speed_mod)
            self.direction = Direction.LEFT
            next_state = love.keyboard.isDown("lshift") and PlayerState.RUN or PlayerState.WALK
        end

        if self.collider:enter("Danger") then
            self.collider:destroy()
        end

        self.state = state(self, next_state)
        self.animation, self.image = animation(self)

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

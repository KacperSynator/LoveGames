local GameObject = require "game_object"


local speed = 300
local image = love.graphics.newImage("Assets/sBullet.png")
local sound = love.audio.newSource("Assets/aBullet.wav", "static")

local Bullet = GameObject:new()
    function Bullet:new(o, spawn_x, spawn_y, mouse_x, mouse_y, scale)
        o = o or GameObject:new(o, spawn_x, spawn_y, 0, scale)
        setmetatable(o, self)

        self.__index = self
        o.speed = speed
        o.image = image
        o.sound = sound

        local distance_to_mouse = math.sqrt( (o.x - mouse_x)^2 + (o.y - mouse_y)^2 )
        o.move_vec = { x = (mouse_x - o.x) / distance_to_mouse,
                       y = (mouse_y - o.y) / distance_to_mouse}

         o.sound:play()

        return o
    end

    function Bullet:update(dt)
        self.x = self.x + self.move_vec.x * speed * dt
        self.y = self.y + self.move_vec.y * speed * dt
    end

return Bullet
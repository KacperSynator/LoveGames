require "utils"

local sprite_size = {width = 115, height = 84}

local Direction = {
    LEFT = -1,
    RIGHT = 1,
}

local function move(player, dt, is_speed_modified)
    local x = player.collider:getX()
    local speed = player.speed

    if is_speed_modified then
        speed = speed * player.speed_modifier
    end

    if love.keyboard.isDown("d") then
        player.collider:setX(x + speed * dt)
        player.direction = Direction.RIGHT
    end

    if love.keyboard.isDown("a") then
        player.collider:setX(x - speed * dt)
        player.direction = Direction.LEFT
    end
end

Idle = {
    animation = LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-8", sprite_size.width, sprite_size.height, 1),
    update = function (dt, player)
        if love.keyboard.isDown("d") or love.keyboard.isDown("a") then
            player:update_state(Walk)
        end
    end
}

Walk = {
    animation = LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-8", sprite_size.width, sprite_size.height, 2),
    update = function (dt, player)
        move(player, dt, false)

        if love.keyboard.isDown("lshift") then
            player:update_state(Run)
        end

        if not love.keyboard.isDown("d") and not love.keyboard.isDown("a") then
            player:update_state(Idle)
        end
    end
}

Jump = {
    animation = LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-1", sprite_size.width, sprite_size.height, 6),
    update = function (dt, player)
        local _, velocity_y = player.collider:getLinearVelocity()

        move(player, dt, false)

        if not player:is_grounded() and velocity_y > 0 then
            player:update_state(Fall)
        end
    end
}

Fall = {
    animation = LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-1", sprite_size.width, sprite_size.height, 8),
    update = function (dt, player)
        move(player, dt, false)

        if player:is_grounded() then
            player:update_state(Idle)
        end
    end
}

Run = {
    animation = LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-8", sprite_size.width, sprite_size.height, 3),
    update = function (dt, player)
        move(player, dt, true)

        if not love.keyboard.isDown("lshift") then
            player:update_state(Walk)
        end

        if not love.keyboard.isDown("d") and not love.keyboard.isDown("a") then
            player:update_state(Idle)
        end
    end
}

Dead = {
    animation = LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-12", sprite_size.width, sprite_size.height, 5, nil, "pauseAtEnd"),
    update = function (dt, player)
        return
    end
}


local attack_animations

Attack = {
    animation = nil,
    animation_index = 0,
    animation_started = false,
    animation_ended = false,

    update = function (dt, player)
        if Attack.animation_ended then
            Attack.animation_ended = false
            Attack.animation_started = false
            player.state = Idle
            return
        end

        if not Attack.animation_started then
            Attack.animation_started = true
            Attack.animation_index = Attack.animation_index + 1

            if Attack.animation_index == 4 then
                Attack.animation_index = 1
            end

            Attack.animation = attack_animations[Attack.animation_index]
        end
    end,

    on_animation_end = function (_, _)
        Attack.animation_ended = true
    end,
}

attack_animations = {
    LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-4", sprite_size.width, sprite_size.height, 9, nil, Attack.on_animation_end),
    LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-4", sprite_size.width, sprite_size.height, 10, nil, Attack.on_animation_end),
    LoadAnimation("assets/player/Viking/Viking-Sheet.png", "1-4", sprite_size.width, sprite_size.height, 11, nil, Attack.on_animation_end),
}

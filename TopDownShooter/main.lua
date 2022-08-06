local anim8 = require "libraries/anim8/anim8"
local Map = require "map"
local Enemy = require "enemy"
local Player = require "player"
local Bullet = require "bullet"

local map, player
local enemies = {}

local MapScale = 1.2

function love.load()
    love.window.setTitle("TopDownShooter")

    map = Map:new(nil, MapScale)

    player = Player:new(nil, 300, 200)

    table.insert(enemies, Enemy:new(nil, 30, 30))
end

function love.update(dt)
    player:update(dt, map:corners())
    for _, enemy in pairs(enemies) do
        enemy:update(dt, player:getPosition())
    end
    CheckCollisons()
end

function love.draw()
    map:draw()
    player:draw()
    for _, enemy in pairs(enemies) do
        enemy:draw()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        player:shoot(x, y)
    end
end

function Distance(x1, y1, x2, y2)
    return math.sqrt( (x1 - x2)^2 + (y1 - y2)^2 )
end

function CheckCollision(ob1, ob2)
    local ob1_c = ob1:getCenter()
    local ob2_c = ob2:getCenter()
    return Distance(ob1_c.x, ob1_c.y, ob2_c.x, ob2_c.y) < ob1:getRadius() + ob2:getRadius()
end

function CheckCollisons()
    for _, enemy in pairs(enemies) do
        if not enemy:isDead() and CheckCollision(player, enemy) then
            print("Game_Over")
            break
        end

        for _, bullet in pairs(player.gun.bullets) do
            if not enemy:isDead() and CheckCollision(enemy, bullet) then
                enemy:die()
                bullet.x = -1
            end
        end
    end
end

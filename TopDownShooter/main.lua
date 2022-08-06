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

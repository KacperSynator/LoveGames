local anim8 = require "libraries/anim8/anim8"
local map = require "map"
local enemy = require "enemy"
local player = require "player"

local Map, Player
local Enemies = {}

local MapScale = 1.2

function love.load()
    love.window.setTitle("TopDownShooter")

    Map = map:new(nil, MapScale)

    Player = player:new(nil, 100, 100)

    table.insert(Enemies, enemy:new(nil, 30, 30))
end

function love.update(dt)
    Player:move(dt)
    for _, en in pairs(Enemies) do
        en:move(dt)
    end
end

function love.draw()
    Map:draw()
    Player:draw()
    for _, en in pairs(Enemies) do
        en:draw()
    end
end

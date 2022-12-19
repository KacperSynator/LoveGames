local wf = require "windfield"
local Player = require "player"
local Platfom = require "platform"
local DangerZone = require "danger_zone"


local player, world, platform, danger_zone

function love.load()
    world = wf.newWorld(0, 800, false)
    world:addCollisionClass("Player")
    world:addCollisionClass("Platform")
    world:addCollisionClass("Danger")
    world:setQueryDebugDrawing(true)


    player = Player:new(nil, world, 360, 100)
    platform = Platfom:new(nil, world, 250, 400, 300, 100)
    danger_zone = DangerZone:new(nil, world, 0, 550, 800, 50)
end

function love.update(dt)
    world:update(dt)
    player:update(dt)
end

function love.draw()
    world:draw()
end

function love.keypressed(key)
    if key == 'w' then
        player:jump(world)
    end
end

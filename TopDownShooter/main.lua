local anim8 = require "libraries/anim8/anim8"
local map = require "map"
local enemy = require "enemy"

local Map
local Enemies = {}

local MapScale = 1.2

function love.load()
    love.window.setTitle("TopDownShooter")

    Map = map:new(nil, MapScale)

    table.insert(Enemies, enemy:new(nil, 30, 30))
    LoadSprites()
    SetupAnimations()
end

function love.update(dt)
    for _, en in pairs(Enemies) do
        en:move(dt)
    end
end

function love.draw()
    Map:draw()
    for _, en in pairs(Enemies) do
        en:draw()
    end
end

function LoadSprites()
    Sprites = {}

    Sprites.player_run_sheet = love.graphics.newImage("Assets/sPlayerRun_strip7.png")
    Sprites.player_idle_sheet = love.graphics.newImage("Assets/sPlayerIdle_strip4.png")
    Sprites.enemy_sheet = love.graphics.newImage("Assets/sEnemy_strip7.png")
    Sprites.enemy_dead = love.graphics.newImage("Assets/sEnemyDead.png")
    Sprites.bullet = love.graphics.newImage("Assets/sBullet.png")
    Sprites.gun = love.graphics.newImage("Assets/sGun.png")
end


function SetupAnimations()
    local player_run_grid = anim8.newGrid(40, 40, Sprites.player_run_sheet:getWidth(),
                                                  Sprites.player_run_sheet:getHeight())
    local player_idle_grid = anim8.newGrid(40, 40, Sprites.player_idle_sheet:getWidth(),
                                                   Sprites.player_idle_sheet:getHeight())
    local enemy_grid = anim8.newGrid(40, 40, Sprites.enemy_sheet:getWidth(),
                                             Sprites.enemy_sheet:getHeight())
    Animations = {}
    Animations.player_run = anim8.newAnimation(player_run_grid('1-7', 1), 0.1)
    Animations.player_idle = anim8.newAnimation(player_idle_grid('1-4', 1), 0.1)
    Animations.enemy = anim8.newAnimation(enemy_grid('1-7', 1), 0.1)
end


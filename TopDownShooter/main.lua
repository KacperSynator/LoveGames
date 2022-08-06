local Map = require "map"
local Enemy = require "enemy"
local Player = require "player"


local map, player, enemies, game_paused, game_over, kills, spawn_timer

local kMapScale = 1.2
local kEnemiesAtStart = 5
local kEnemySpawnInterval = 1
local kFont = love.graphics.newFont("Assets/Games.ttf", 40)

function love.load()
    love.window.setTitle("TopDownShooter")
    love.graphics.setFont(kFont)

    ResetGame()
end

function love.update(dt)
    if not game_paused then
        player:update(dt, map:corners())
        for _, enemy in pairs(enemies) do
            enemy:update(dt, player:getPosition())
        end
        CheckCollisons()
        UpdateEnemySpawner(dt)
    end
end

function love.draw()
    map:draw()

    for _, enemy in pairs(enemies) do
        enemy:draw()
    end

    player:draw()

    love.graphics.printf("Kills: " .. kills, 0, 0, love.graphics.getWidth(), "left")
    if game_over then
        love.graphics.printf("Game Over", 0, love.graphics.getHeight() / 8, love.graphics.getWidth(), "center")
    elseif game_paused then
        love.graphics.printf("Click to start!", 0, love.graphics.getHeight() / 8, love.graphics.getWidth(), "center")
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if game_over then
        ResetGame()
    elseif game_paused then
        game_paused = false
    elseif button == 1 then
        player:shoot(x, y)
    end
end

function ResetGame()
    enemies = {}
    game_over = false
    game_paused = true
    kills = 0
    spawn_timer = kEnemySpawnInterval

    map = Map:new(nil, kMapScale)

    player = Player:new(nil, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

    SpawnEnemies(kEnemiesAtStart)
end

function UpdateEnemySpawner(dt)
    spawn_timer = spawn_timer - dt
    if spawn_timer < 0 then
        spawn_timer = kEnemySpawnInterval
        SpawnEnemies(math.ceil(kills / 10))
    end
end

function SpawnEnemy()
    local x, y
    local map_corners = map:corners()
    local fixed_coord = math.random(4)
    if fixed_coord == 1 then
        x = math.random(map_corners.top_left_x + 20, map_corners.bot_right_x - 20)
        y = map_corners.top_left_y + 20
    elseif fixed_coord == 2 then
        x = math.random(map_corners.top_left_x + 20, map_corners.bot_right_x - 20)
        y = map_corners.bot_right_y - 20
    elseif fixed_coord == 3 then
        x = map_corners.top_left_x + 20
        y = math.random(map_corners.top_left_y + 20, map_corners.bot_right_y - 20)
    else
        x = map_corners.bot_right_x - 20
        y = math.random(map_corners.top_left_y + 20, map_corners.bot_right_y - 20)
    end

    return Enemy:new(nil, x, y)
end

function SpawnEnemies(n)
    for i = 1, n do
        table.insert(enemies, SpawnEnemy())
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
            game_paused = true
            game_over = true
            break
        end

        for _, bullet in pairs(player.gun.bullets) do
            if not enemy:isDead() and CheckCollision(enemy, bullet) then
                kills = kills + 1
                enemy:die()
                bullet.x = -50
            end
        end
    end
end

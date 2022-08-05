function love.load()
    GamePaused = true

    Target = {}
    Target.x = 0
    Target.y = 0
    Target.radius = 64

    MoveTargetToRandomPosition()
    love.window.setTitle("Shooting Gallery")

    Score = 0
    Timer = 0

    Game_Font = love.graphics.newFont(40)

    Sprites = {}
    Sprites.background = love.graphics.newImage("Assets/Background_800x600.jpg")
    Sprites.crosshair = love.graphics.newImage("Assets/crosshair.png")
    Sprites.target = love.graphics.newImage("Assets/bullseye.png")

    love.mouse.setVisible(false)
end

function love.update(dt)
    if Timer > 0 and not GamePaused then
        Timer = Timer - dt
    end

    if Timer < 0 then
        Timer = 0
        GamePaused = true
    end
end

function love.draw()
    love.graphics.draw(Sprites.background, 0, 0)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(Game_Font)
    love.graphics.printf("Score: " .. Score, 5, 5, love.graphics.getWidth(), "left")
    love.graphics.printf("Time: " .. math.ceil(Timer), -5, 5, love.graphics.getWidth(), "right")

    if GamePaused then
        love.graphics.printf("Click to begin!", 0, 250, love.graphics.getWidth(), "center")
    end

    if not GamePaused then
        love.graphics.draw(Sprites.target, Target.x - Target.radius, Target.y - Target.radius)
    end

    love.graphics.draw(Sprites.crosshair, love.mouse.getX() - 16, love.mouse.getY() - 16)
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and not GamePaused then
        if DistanceBetween(x, y, Target.x, Target.y) <= Target.radius then
            Score = Score + 1
            MoveTargetToRandomPosition()
        else
            Score = math.max(0, Score - 1)
        end
    elseif button == 1 and GamePaused then
        GamePaused = false
        Timer = 10
        Score = 0
    end
end

function DistanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function MoveTargetToRandomPosition()
    Target.x = math.random(Target.radius, love.graphics.getWidth() - Target.radius)
    Target.y = math.random(Target.radius, love.graphics.getHeight() - Target.radius)
end

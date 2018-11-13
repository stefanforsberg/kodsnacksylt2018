local bump = require 'libs.bump'

world = nil -- storage place for bump

player = { 
    x = 10, 
    y =  10, xVelocity = 0, 
    yVelocity = 0, 
    gravity = 120, 
    friction = 20
}

ground_0 = {}
ground_1 = {}

function love.load()
    love.window.setMode(1024, 768)

    world = bump.newWorld(16)

    world:add(player, 10, 10, 16, 16)

    world:add(ground_0, 120, 360, 640, 16)
    world:add(ground_1, 0, 448, 640, 32)
end

function love.update(dt)

    if love.keyboard.isDown("right") then
        player.xVelocity = 10;
    end

    if love.keyboard.isDown("left") then
        player.xVelocity = -10;
    end

    if love.keyboard.isDown("up") then
        player.yVelocity = -20;
    end

    print("asd")

    player.yVelocity = player.yVelocity * (1 - math.min(dt * player.friction, 1))
    player.xVelocity = player.xVelocity * (1 - math.min(dt * player.friction, 1))

    player.yVelocity = player.yVelocity + player.gravity * dt

    local goalX = player.x + player.xVelocity
    local goalY = player.y + player.yVelocity

    player.x, player.y, collisions = world:move(player, goalX, goalY)

    
end

function love.draw()



    

    love.graphics.print('Hello World!', 400, 300)

    love.graphics.rectangle('fill', world:getRect(player))

    love.graphics.rectangle('fill', world:getRect(ground_0))
    love.graphics.rectangle('fill', world:getRect(ground_1))

    

    
end
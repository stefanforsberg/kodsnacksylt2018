local bump = require 'libs.bump'
local player = require 'player'

world = nil

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

    player:update(dt);

    
end

function love.draw()

    love.graphics.print('Hello World!', 400, 300)

    player:draw();

    love.graphics.rectangle('fill', world:getRect(ground_0))
    love.graphics.rectangle('fill', world:getRect(ground_1))
end
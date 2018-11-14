local bump = require 'libs.bump'
local player = require 'player'

world = nil

ground_0 = {}
ground_1 = {}

local img = love.graphics.newImage("Paper.Spelsylt.1.png")

function love.load()
    love.window.setMode(1024, 768)

    world = bump.newWorld(16)

    world:add(player, 10, 10, 16, 16)

    world:add(ground_0, 120, 700, 640, 16)
    world:add(ground_1, 0, 752, 1024, 16)
end

function love.update(dt)

    player:update(dt);

    
end

function love.draw()
    love.graphics.setColor(255, 255, 255, 1)

    love.graphics.draw(img, 0, 0)

    player:draw();

    love.graphics.setColor(0,0,0, 0.8)
    love.graphics.rectangle('fill', world:getRect(ground_0))
    love.graphics.rectangle('fill', world:getRect(ground_1))
end
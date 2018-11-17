local bump = require 'libs.bump'
local player = require 'player'
local boss = require 'boss'
local things = require 'things'

world = nil

ground_0 = {}
ground_1 = {}

local img = love.graphics.newImage("Paper.Spelsylt.1.png")

function love.load()
    love.window.setTitle("???")
    love.window.setMode(1024, 768)

    world = bump.newWorld(32)

    world:add(player, 10, 10, 32, 32)

    world:add(ground_0, 120, 640, 640, 32)
    world:add(ground_1, 0, 736, 1024, 32)

    boss:init();
end

function love.update(dt)

    boss:update(dt)
    player:update(dt)

    things:update(dt)
end

function love.draw()
    love.graphics.setColor(255, 255, 255, 1)

    love.graphics.draw(img, 0, 0)

    boss:draw();
    player:draw();
    
    things:draw(dt)

    love.graphics.setColor(0,0,0, 0.8)
    love.graphics.rectangle('fill', world:getRect(ground_0))
    love.graphics.rectangle('fill', world:getRect(ground_1))
end
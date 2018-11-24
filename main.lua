local bump = require 'libs.bump'
player = require 'player'
boss = require 'boss'
things = require 'things'
local platforms = require 'platforms'
world = nil
local gameState = "intro"

local img = love.graphics.newImage("Paper.Spelsylt.3.png")

function love.load()
    love.window.setTitle("???")
    love.window.setMode(1024, 768)

    world = bump.newWorld(8)

    things:init()

    player:init()

    platforms:load()

    
    
    boss:init();
end

function love.update(dt)
    if gameState == "intro" then
        function love.keypressed(key)
            gameState = "game"
        end
    elseif gameState == "game" then
        boss:update(dt)
        player:update(dt)
        things:update(dt)
    end
end

function love.draw()

    if gameState == "intro" then
        love.graphics.setColor(255, 255, 255, 1)
        love.graphics.print("Intro", 10, 30)
    elseif gameState == "game" then
        love.graphics.setColor(255, 255, 255, 1)
        love.graphics.draw(img, 0, 0)
        love.graphics.setColor(0, 0, 0, 0.8)
        
        boss:draw();
        player:draw();
        things:draw()

        if player.health == 0 then
            love.load()
        end

        love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 30)
    end 
end
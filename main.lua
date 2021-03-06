local bump = require 'libs.bump'
player = require 'player'
boss = require 'boss'
things = require 'things'
local platforms = require 'platforms'
local enemies = require 'enemies'
world = nil
gameState = "intro"

local img = love.graphics.newImage("Paper.Spelsylt.3.png")
local intro = love.graphics.newImage("intro.png")

music = love.audio.newSource("spelsylt01.mp3", "stream")
music:setLooping(true)
music:play()

function love.load()
    love.window.setTitle("you vs boss")
    love.window.setMode(1024, 768)

    world = bump.newWorld(8)

    things:init()

    player:init()

    platforms:load()
    
    boss:init();

    enemies:init();
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
        enemies:update(dt);
    elseif gameState == "death" or gameState == "victory" then
        function love.keypressed(key)
            if key == "return" then
                gameState = "game"  
                love.load()
            end
        end        
    end
end

function love.draw()

    if gameState == "intro" then
        love.graphics.draw(intro, 0, 0)
    elseif gameState == "game" then
        love.graphics.setColor(255, 255, 255, 1)
        love.graphics.draw(img, 0, 0)
        love.graphics.setColor(0, 0, 0, 0.8)
        
        boss:draw();
        player:draw();
        things:draw()

        if player.health <= 0 then
            gameState = "death"
        end

        if boss.health <= 0 then
            gameState = "victory"
        end

        love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 30)

    elseif gameState == "death" then
        love.graphics.print("Death. Press enter key to try again", 300, 300)
    elseif gameState == "victory" then
        love.graphics.print("Victory. Press enter key to try again", 300, 300)
    end     
end

function outline(x, y, w, h)
    love.graphics.line(x, y, x+w, y)
    love.graphics.line(x+w, y, x+w, y+h)
    love.graphics.line(x+w, y+h, x, y+h)
    love.graphics.line(x, y+h, x, y)
end
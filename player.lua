local player = {
    x = 10, 
    y =  10, 
    xVelocity = 0, 
    yVelocity = 0, 
    gravity = 190, 
    friction = 20,
    jumping = false,
    name='player',
    animation = {
        currentTime = 0,
        sprite = 1,
        img = 1,
        rotation = 1,
        translate = 0
    },
    img1 = love.graphics.newImage("p01.png"),
    img2 = love.graphics.newImage("p02.png"),
    img3 = love.graphics.newImage("p01.png"),
    img4 = love.graphics.newImage("p04.png"),
    imgAir = love.graphics.newImage("pair.png")
}

function player:update(dt) 

    function love.keypressed(key)
        if key == "d" then
            things:add(bullet:create(self.x+12, self.y+12, 10, 0))
        elseif key == "w" then
            things:add(bullet:create(self.x+12, self.y+12, 0, -10))
        end

        if key == "up" then
            if(not self.jumping) then
                self.jumping = true;
                self.yVelocity = -110;
                
            end
        end
     end

    if love.keyboard.isDown("right") then
        self.xVelocity = 10;
    end

    if love.keyboard.isDown("left") then
        self.xVelocity = -10;
    end


    self.yVelocity = self.yVelocity * (1 - math.min(dt * self.friction, 1))
    self.xVelocity = self.xVelocity * (1 - math.min(dt * self.friction, 1))

    if math.abs(self.xVelocity) < 0.01 then
        self.xVelocity = 0
    end

    self.yVelocity = self.yVelocity + self.gravity * dt

    local goalX = self.x + self.xVelocity
    local goalY = self.y + self.yVelocity

    self.x, self.y, collisions = world:move(self, goalX, goalY, self.filter)

    for i, coll in ipairs(collisions) do

        if coll.touch.y > goalY then
        
        elseif coll.normal.y < 0 then
        
            self.jumping = false
            self.yVelocity = 0
        end
    end

    if self.yVelocity == 0 then
        if(self.xVelocity == 0) then
            self.animation.img = self.img1
        else

            if self.xVelocity > 0 then
                self.animation.rotation = 1
                self.animation.translate = 0
            else
                self.animation.rotation = -1
                self.animation.translate = 32
            end

            self.animation.img = self["img" .. self.animation.sprite]

            self.animation.currentTime = self.animation.currentTime + dt
    
            if self.animation.currentTime > 0.2 then
                self.animation.sprite = self.animation.sprite + 1
    
                if self.animation.sprite > 4 then
                    self.animation.sprite = 1
                end
    
                self.animation.currentTime = 0
            end
        end
        
    else
        self.animation.img = self.imgAir
    end
end

function player:draw()
    local x,y,w,h = world:getRect(player);
    
    love.graphics.setColor(255, 255, 255, 1)
    
    love.graphics.draw(self.animation.img, x, y, 0, self.animation.rotation, 1, self.animation.translate, 0)
    -- if self.xVelocity > 0 then
        
    -- else
    --     love.graphics.draw(self.animation.img, x, y, 0, 1, 1, width, 0)
    -- end

    
    

    -- love.graphics.rectangle('fill', world:getRect(player))
    
    -- love.graphics.setColor(0, 0, 0, 0.5)

    -- love.graphics.line(x, y, x+w,y)
    -- love.graphics.line(x+w, y, x+w,y+h)
    -- love.graphics.line(x+w, y+h, x,y+h)
    -- love.graphics.line(x, y+h, x,y)
end

player.filter = function(item, other)
    if other.name == "playerBullet" then
        return nil;
    end

    local x, y, w, h = world:getRect(other)
    local px, py, pw, ph = world:getRect(item)
    local playerBottom = py + ph
    local otherBottom = y + h

    if playerBottom <= y then
        return 'slide'
    else 
        return 'slide'
    end
end

bullet = {};
bullet.__index = bullet

function bullet:create(x,y, vx, vy)
    local b = { x = x, y = y, vx = vx, vy = vy, name = "playerBullet"}
    world:add(b, b.x, b.y, 8, 8)
    
    function b:update()
        local goalX = self.x + self.vx;
        local goalY = self.y + self.vy;
        self.x, self.y, collisions = world:move(self, goalX, goalY, self.filter)

        for i, bullet in ipairs(collisions) do
            boss:hit()
            b.remove = true
        end
    end

    function b:draw()
        love.graphics.rectangle('fill', world:getRect(self))
    end

    function b:filter(other)

        if other.name == "player" or other.name == "playerBullet" or other.name == "platform" then
            return nil;
        end


        return "touch";
    end
    
    return b;


end

return player;
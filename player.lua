local player = {}

function player:init()
    self.x = 10
    self.y =  700
    self.xVelocity = 0
    self.yVelocity = 0
    self.gravity = 190
    self.friction = 20
    self.jumping = false
    self.name='player'
    self.animation = {
        currentTime = 0,
        sprite = 1,
        img = 1,
        rotation = 1,
        translate = 0
    }
    self.img1 = love.graphics.newImage("p01.png")
    self.img2 = love.graphics.newImage("p02.png")
    self.img3 = love.graphics.newImage("p01.png")
    self.img4 = love.graphics.newImage("p04.png")
    self.imgAir = love.graphics.newImage("pair.png")
    self.health = 100

    world:add(self, 10, 10, 64, 64)
end

function player:update(dt) 

    function love.keypressed(key)
        if key == "d" then
            things:add(bullet:create(self.x+24, self.y+24, 10, 0))
        elseif key == "w" then
            things:add(bullet:create(self.x+24, self.y+24, 0, -10))
        elseif key == "a" then
            things:add(bullet:create(self.x+24, self.y+24, -10, 0))            
        elseif key == "s" then
            things:add(bullet:create(self.x+24, self.y+24, 0, 10))            
        end

        if key == "up" then
            if(not self.jumping) then
                self.jumping = true;
                self.yVelocity = -120;
                
            end
        end
     end

    if love.keyboard.isDown("right") then
        self.xVelocity = 9;
    end

    if love.keyboard.isDown("left") then
        self.xVelocity = -9;
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

    self:animate(dt)
end

function player:hit()
    self.health = self.health - 20
end

function player:animate(dt)
    if self.yVelocity == 0 then
        if(self.xVelocity == 0) then
            self.animation.img = self.img1
        else

            if self.xVelocity > 0 then
                self.animation.rotation = 1
                self.animation.translate = 0
            else
                self.animation.rotation = -1
                self.animation.translate = 64
            end

            self.animation.img = self["img" .. self.animation.sprite]

            self.animation.currentTime = self.animation.currentTime + dt
    
            if self.animation.currentTime > 0.1 then
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

    love.graphics.setColor(0.65, 0.6, 0.79, 1)
    love.graphics.rectangle('fill', 10, 20, 10*self.health, 8)
    love.graphics.setColor(0.47, 0.36, 0.73, 0.5)
    outline(10, 20, 1000, 8)
end

player.filter = function(item, other)
    if other.name == "playerBullet" then
        return nil;
    end

    if other.name == "bossFlame" and not other.added then
        return nil;
    end

    if other.name == "boss" or (other.name == "bossFlame" and other.added) then
        item.health = 0
        return nil;
    end

    return "slide"
end

bullet = {
    img = love.graphics.newImage("pShot.png")
};
bullet.__index = bullet

function bullet:create(x,y, vx, vy)
    local b = { x = x, y = y, vx = vx, vy = vy, name = "playerBullet", img = bullet.img}
    world:add(b, b.x, b.y, 16, 16)
    
    function b:update()
        local goalX = self.x + self.vx;
        local goalY = self.y + self.vy;
        self.x, self.y, collisions = world:move(self, goalX, goalY, self.filter)
    end

    function b:draw()
        love.graphics.draw(self.img, self.x, self.y)
    end

    function b:filter(other)

        if other.name == "enemy" then
            other:hit()
            self.remove = true
        end

        if other.name == "boss" then
            other:hit()
            self.remove = true
        end

        if other.name == "wall" then
            self.remove = true
        end

        return nil;
    end
    
    return b;


end

return player;
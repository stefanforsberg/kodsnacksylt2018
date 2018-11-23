local boss = {}

function boss:init()
    self.x = 960
    self.y = 100
    self.yVelocity = 4
    self.yMin = (32*3)
    self.yMax = (768 - 32*7)
    self.name='boss'
    self.img1 = love.graphics.newImage("boss01.png")
    self.img2 = love.graphics.newImage("boss02.png")
    self.img3 = love.graphics.newImage("boss03.png")
    self.img4 = love.graphics.newImage("boss04.png")
    self.health = 100
    self.hitThisCycle = false
    self.shootTimer = 0
    self.shootThreashold = 2
    self.phace = {
        one = {
            shootThreashold = 2,
            flameProbability = 0.2
        }
    }
    self.currentPhace = self.phace["one"]
    self.hasFlame = false
    

    world:add(self, self.x, self.y, 47, 32*4)
end

function boss:hit()
    self.hitThisCycle = true;
end

function boss:update(dt) 
    
    if not self.hasFlame then

        local goalX = self.x
        local goalY = self.y + self.yVelocity
    
        self.x, self.y = world:move(self, goalX, goalY, self.filter)
    
        if(self.y >= self.yMax and self.yVelocity > 0) then
            self.yVelocity = -1 * self.yVelocity;
        elseif(self.y <= self.yMin and self.yVelocity < 0) then
            self.yVelocity = -1 * self.yVelocity;
        end

        if self.shootTimer > self.currentPhace.shootThreashold then
        
            if love.math.random() < self.currentPhace.flameProbability then
                things:add(bossFlame:create(10, self.y-32))
                self.hasFlame = true
            else
                things:add(bossBullet:create(self.x-8, self.y+28, player.x+12, player.y+12))
            end

            self.shootTimer = 0
            
        end

        self.shootTimer = self.shootTimer + dt
    end
end

function boss:draw()
    
    local x,y,w,h = world:getRect(self);
    
    love.graphics.setColor(255, 255, 255, 1)

    love.graphics.draw(self.img1, x, y)
    
    love.graphics.setColor(255, 255, 255, 1)

    love.graphics.rectangle('fill', 10, 10, 10*self.health, 10)

    if self.hitThisCycle then
        self.health = self.health - 0.1
        self.hitThisCycle = false
    end
end

function boss:filter(other)
    return nil;
end

bossFlame = {
    
};

bossFlame.__index = bossFlame

function bossFlame:create(x, y)
    local f = { x = x, y = y, name = "bossFlame", timer = 0, animation = {sprite = 1, timer = 0, img = 1}}
    

    f.img1 = love.graphics.newImage("flame01.png")
    f.img2 = love.graphics.newImage("flame02.png")
    f.img3 = love.graphics.newImage("flame03.png")

    function f:update(dt)
        self.timer = self.timer + 1
        
        if self.timer == 100 then
            self.added = true
            world:add(f, f.x, f.y, 933, 213)
        end

        if not self.added then
            return
        end
        
        self.animation.timer = self.animation.timer + dt

        if self.animation.timer > 0.05 then
            self.animation.sprite = self.animation.sprite + 1
    
            if self.animation.sprite > 3 then
                self.animation.sprite = 1
            end

            self.animation.timer = 0
        end

        self.animation.img = self["img" .. self.animation.sprite]

        self.x, self.y, collisions = world:move(self, self.x, self.y, self.filter)

        
        if self.timer > 300 then
            boss.hasFlame = false
            self.remove = true
        end
    end

    function f:draw()
        if self.added then
            love.graphics.draw(self.animation.img, self.x, self.y)
        else
            love.graphics.setColor(0,0,0, self.timer / 100)
            love.graphics.draw(self.img1, self.x, self.y)
            love.graphics.setColor(255,255,255,100)
            
        end
    end

    function f:filter(other)

        if other.name == "player" then
            --self.remove = true
            return "touch"
        end
        
        return nil;
    end
    
    return f;
end

bossBullet = {};
bossBullet.__index = bossBulletw



function bossBullet:create(x, y, px, py)
    local vx = (px-x)/100
    local vy = (py-y)/100
    
    local b = { x = x, y = y, vx = vx, vy = vy, name = "bossBullet"}
    world:add(b, b.x, b.y, 8, 8)
    
    function b:update()
        
        local goalX = self.x + self.vx;
        local goalY = self.y + self.vy;
        self.x, self.y, collisions = world:move(self, goalX, goalY, self.filter)
    end

    function b:draw()
        love.graphics.rectangle('fill', world:getRect(self))
    end

    function b:filter(other)

        if other.name == "wall" then
            self.remove = true
            boss.b = false
            return "touch"
        end

        if other.name == "player" then
            self.remove = true
            boss.b = false
            return "touch"
        end
        
        return nil;
    end
    
    return b;
end

return boss;
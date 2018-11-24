local boss = {}

function boss:init()
    self.x = 960
    self.y = 100
    self.yVelocity = 4
    self.yMin = (32)
    self.yMax = (768 - 32*4)
    self.name='boss'
    self.img1 = love.graphics.newImage("boss01.png")
    self.img2 = love.graphics.newImage("boss02.png")
    self.img3 = love.graphics.newImage("boss03.png")
    self.img4 = love.graphics.newImage("boss04.png")
    self.currentImg = self.img1;
    self.health = 100
    self.hitThisCycle = false
    self.shootTimer = 0
    self.ballTimer = 0
    self.shootThreashold = 2
    self.phase = {
        one = {
            name = "one",
            shootThreashold = 3,
            ballThreashold = 4,
            flameProbability = 0.1,
            ballProbability = 1,
            hitDamage = 1,
            enemyHealth = 1,
            enemyThreashold = 5,
            healthColor = {r = 1, g = 223/255, b = 216/255}
        },
        two = {
            name = "two",
            shootThreashold = 2,
            ballThreashold = 3,
            flameProbability = 0.3,
            ballProbability = 0.4,
            hitDamage = 1,
            enemyHealth = 3,
            enemyThreashold = 4,
            healthColor = {r = 1, g = 157/255, b = 135/255}
        },
        three = {
            name = "three",
            shootThreashold = 1,
            ballThreashold = 2,
            flameProbability = 0.4,
            ballProbability = 0.7,
            hitDamage = 0.5,
            enemyHealth = 5,
            enemyThreashold = 3,
            healthColor = {r = 1, g = 113/255, b = 81/255}
        }
    }
    self.currentPhase = self.phase["one"]
    self.hasFlame = false
    

    world:add(self, self.x, self.y, 47, 32*4)
end

function boss:hit()
    self.hitThisCycle = true;
end

function boss:update(dt) 

    if self.ballTimer > self.currentPhase.ballThreashold then
        if love.math.random() < self.currentPhase.ballProbability then
            things:add(bossBall:create())
        end

        self.ballTimer = 0
    end

    if not self.hasFlame then

        self.shootTimer = self.shootTimer + dt

        local goalX = self.x
        local goalY = self.y + self.yVelocity
    
        self.x, self.y = world:move(self, goalX, goalY, self.filter)
    
        if(self.y >= self.yMax and self.yVelocity > 0) then
            self.yVelocity = -1 * self.yVelocity;
        elseif(self.y <= self.yMin and self.yVelocity < 0) then
            self.yVelocity = -1 * self.yVelocity;
        end

        if self.shootTimer > self.currentPhase.shootThreashold then
        
            if love.math.random() < self.currentPhase.flameProbability then
                things:add(bossFlame:create(10, self.y-32))
                self.hasFlame = true
                self.currentImg = self.img2
            else
                things:add(bossBullet:create(self.x-8, self.y+28, player.x+12, player.y+12))
            end

            self.shootTimer = 0
        end
    end

    self.ballTimer = self.ballTimer + dt
    
end

function boss:draw()
    
    local x,y,w,h = world:getRect(self);
    
    love.graphics.setColor(255, 255, 255, 1)

    love.graphics.draw(self.currentImg, x, y)
    
    love.graphics.setColor(self.currentPhase.healthColor.r, self.currentPhase.healthColor.g, self.currentPhase.healthColor.b, 1)
    love.graphics.rectangle('fill', 10, 10, 10*self.health, 8)
    love.graphics.setColor(1, 0.27, 0.1, 0.5)
    outline(10, 10, 1000, 8)

    if self.hitThisCycle then
        self.health = self.health - self.currentPhase.hitDamage
        self.hitThisCycle = false
        if(self.health < 75 and self.currentPhase.name == "one") then
            self.currentPhase = self.phase["two"]
        end

        if(self.health == 50 and self.currentPhase.name == "two") then
            self.currentPhase = self.phase["three"]
        end
    end
end

function boss:filter(other)
    return nil;
end

bossFlame = {};
bossFlame.__index = bossFlame

function bossFlame:create(x, y)
    local f = { x = x, y = y, name = "bossFlame", timer = 0, animation = {sprite = 1, timer = 0, img = 1}}
    
    f.img1 = love.graphics.newImage("flame01.png")
    f.img2 = love.graphics.newImage("flame02.png")
    f.img3 = love.graphics.newImage("flame03.png")

    world:add(f, f.x, f.y, 933, 178)

    function f:update(dt)
        self.timer = self.timer + 1
        
        if self.timer == 100 then
            self.added = true
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
        
        if self.timer > 200 then
            boss.hasFlame = false
            boss.currentImg = boss.img1
            self.remove = true
        end
    end

    function f:draw()
        if self.added then
            love.graphics.draw(self.animation.img, self.x, self.y-20)
        else
            love.graphics.setColor(0,0,0, self.timer / 100)
            love.graphics.draw(self.img1, self.x, self.y-20)
            love.graphics.setColor(255,255,255,1)
        end
    end

    function f:filter(other)
        return nil;
    end
    
    return f;
end

bossBall = {
    img = love.graphics.newImage("bBall.png")
}
bossBall.__index = bossBall

function bossBall:create()
    local x = 192 + math.floor(love.math.random()* (1024-192*2))
    local b = { x = x, y = -192, vy = 0.1, name = "bossBall", img = bossBall.img}

    world:add(b, b.x, b.y, 192, 192)

    function b:update(dt)
        self.vy = self.vy + 5 * dt;
        local goalY = self.y + self.vy;
        self.x, self.y, collisions = world:move(self, self.x, goalY, self.filter)

    end

    function b:draw()
        love.graphics.draw(self.img, self.x, self.y)
    end

    function b:filter(other)

        if other.name == "player" then
            self.remove = true
            other:hit(60)
            return "touch"
        end
        
        return nil;
    end

    return b;
end

bossBullet = {
    img = love.graphics.newImage("bShot.png")
};
bossBullet.__index = bossBullet

function bossBullet:create(x, y, px, py)
    local vx = (px-x)/100
    local vy = (py-y)/100
    
    local b = { x = x, y = y, vx = vx, vy = vy, name = "bossBullet", img = bossBullet.img}
    world:add(b, b.x, b.y, 8, 8)
    
    function b:update()
        
        local goalX = self.x + self.vx;
        local goalY = self.y + self.vy;
        self.x, self.y, collisions = world:move(self, goalX, goalY, self.filter)
    end

    function b:draw()
        love.graphics.draw(self.img, self.x, self.y)
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
            player:hit(20)
            return "touch"
        end
        
        return nil;
    end
    
    return b;
end

return boss;
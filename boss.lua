local boss = {}

function boss:init()
    self.x = 960
    self.y = 100
    self.yVelocity = 2
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

    world:add(self, self.x, self.y, 47, 32*4)
end

function boss:hit()
    self.hitThisCycle = true;
end

function boss:update(dt) 
    
    local goalX = self.x
    local goalY = self.y + self.yVelocity

    self.x, self.y = world:move(self, goalX, goalY, self.filter)

    if(self.y >= self.yMax and self.yVelocity > 0) then
        self.yVelocity = -1 * self.yVelocity;
    elseif(self.y <= self.yMin and self.yVelocity < 0) then
        self.yVelocity = -1 * self.yVelocity;
    end

    self.shootTimer = self.shootTimer + dt

    if self.shootTimer > self.shootThreashold then
        self.shootTimer = 0
        things:add(bossBullet:create(self.x-8, self.y+28, player.x, player.y))
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
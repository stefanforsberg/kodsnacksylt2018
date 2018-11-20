local boss = {
    x = 960, 
    y = 100, 
    yVelocity = 2,
    yMin = (32*3),
    yMax = (768 - 32*7),
    name='boss',
    img1 = love.graphics.newImage("boss01.png"),
    img2 = love.graphics.newImage("boss02.png"),
    img3 = love.graphics.newImage("boss03.png"),
    img4 = love.graphics.newImage("boss04.png"),
    health = 100,
    hitThisCycle = false
}

function boss:init()
    world:add(self, self.x, self.y, 47, 32*4)
end

function boss:hit()
    self.hitThisCycle = true;
end

function boss:update(dt) 
    
    local goalX = self.x
    local goalY = self.y + self.yVelocity

    self.x, self.y = world:move(self, goalX, goalY)

    if(self.y >= self.yMax and self.yVelocity > 0) then
        self.yVelocity = -1 * self.yVelocity;
    elseif(self.y <= self.yMin and self.yVelocity < 0) then
        self.yVelocity = -1 * self.yVelocity;
    end
end

function boss:draw()
    
    local x,y,w,h = world:getRect(self);
    
    love.graphics.setColor(255, 255, 255, 1)

    love.graphics.draw(self.img1, x, y)
    
    -- love.graphics.rectangle('fill', world:getRect(self))
    
    -- love.graphics.setColor(0, 0, 0, 0.5)

    -- love.graphics.line(x, y, x+w,y)
    -- love.graphics.line(x+w, y, x+w,y+h)
    -- love.graphics.line(x+w, y+h, x,y+h)
    -- love.graphics.line(x, y+h, x,y)

    love.graphics.setColor(255, 255, 255, 1)

    love.graphics.rectangle('fill', 10, 10, 10*self.health, 10)

    if self.hitThisCycle then
        self.health = self.health - 0.1
        self.hitThisCycle = false
    end
end

return boss;
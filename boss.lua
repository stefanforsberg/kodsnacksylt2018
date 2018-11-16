local boss = {
    x = 960, 
    y = 100, 
    yVelocity = 2,
    yMin = (32*3),
    yMax = (768 - 32*7),
    name='boss'
}

function boss:init()
    world:add(self, self.x, self.y, 32, 32*4)
end

function boss:update(dt) 
    
    local goalX = self.x
    local goalY = self.y + self.yVelocity

    self.x, self.y, collisions = world:move(self, goalX, goalY, self.filter)

    for i, coll in ipairs(collisions) do
        -- player bullets check
    end

    if(self.y >= self.yMax and self.yVelocity > 0) then
        self.yVelocity = -1 * self.yVelocity;
    elseif(self.y <= self.yMin and self.yVelocity < 0) then
        self.yVelocity = -1 * self.yVelocity;
    end
end

function boss:draw()
    local x,y,w,h = world:getRect(self);
    
    love.graphics.setColor(255, 255, 255, 1)

    love.graphics.rectangle('fill', world:getRect(self))
    
    love.graphics.setColor(0, 0, 0, 0.5)

    love.graphics.line(x, y, x+w,y)
    love.graphics.line(x+w, y, x+w,y+h)
    love.graphics.line(x+w, y+h, x,y+h)
    love.graphics.line(x, y+h, x,y)
    
end

boss.filter = function(item, other)
    
    -- local x, y, w, h = world:getRect(other)
    -- local bossx, bossy, bossw, bossh = world:getRect(item)
    -- local playerBottom = py + ph
    -- local otherBottom = y + h

    -- if playerBottom <= y then
    --     return 'touch'
    -- else 
    --     return 'slide'
    -- end
end

return boss;
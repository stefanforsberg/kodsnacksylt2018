local player = {
    x = 10, 
    y =  10, xVelocity = 0, 
    yVelocity = 0, 
    gravity = 120, 
    friction = 20
}

function player:update(dt) 
    if love.keyboard.isDown("right") then
        self.xVelocity = 10;
    end

    if love.keyboard.isDown("left") then
        self.xVelocity = -10;
    end

    if love.keyboard.isDown("up") then
        self.yVelocity = -20;
    end

    self.yVelocity = self.yVelocity * (1 - math.min(dt * self.friction, 1))
    self.xVelocity = self.xVelocity * (1 - math.min(dt * self.friction, 1))

    self.yVelocity = self.yVelocity + self.gravity * dt

    local goalX = self.x + self.xVelocity
    local goalY = self.y + self.yVelocity

    self.x, self.y, collisions = world:move(self, goalX, goalY)
end

function player:draw()
    love.graphics.rectangle('fill', world:getRect(player))
end

return player;
local player = {
    x = 10, 
    y =  10, xVelocity = 0, 
    yVelocity = 0, 
    gravity = 120, 
    friction = 20,
    jumping = false,
}

function player:update(dt) 
    if love.keyboard.isDown("right") then
        self.xVelocity = 10;
    end

    if love.keyboard.isDown("left") then
        self.xVelocity = -10;
    end

    if love.keyboard.isDown("up") then
        if(not self.jumping) then
            self.jumping = true;
            self.yVelocity = -80;
            
        end

        
    end

    self.yVelocity = self.yVelocity * (1 - math.min(dt * self.friction, 1))
    self.xVelocity = self.xVelocity * (1 - math.min(dt * self.friction, 1))

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
end

function player:draw()
    love.graphics.rectangle('fill', world:getRect(player))
end

player.filter = function(item, other)
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

return player;
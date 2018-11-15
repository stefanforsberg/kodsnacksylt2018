local player = {
    x = 10, 
    y =  10, 
    xVelocity = 0, 
    yVelocity = 0, 
    gravity = 120, 
    friction = 20,
    jumping = false,
    name='player',
    bullets = {}
}

function player:update(dt) 

    if(love.keyboard.isDown("a")) then
        table.insert(self.bullets, bullet(self.x, self.y, 1, 0))
    end

    if love.keyboard.isDown("right") then
        self.xVelocity = 8;
    end

    if love.keyboard.isDown("left") then
        self.xVelocity = -8;
    end

    if love.keyboard.isDown("up") then
        if(not self.jumping) then
            self.jumping = true;
            self.yVelocity = -90;
            
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
    local x,y,w,h = world:getRect(player);
    
    love.graphics.setColor(255, 255, 255, 1)

    love.graphics.rectangle('fill', world:getRect(player))
    
    love.graphics.setColor(0, 0, 0, 0.5)

    love.graphics.line(x, y, x+w,y)
    love.graphics.line(x+w, y, x+w,y+h)
    love.graphics.line(x+w, y+h, x,y+h)
    love.graphics.line(x, y+h, x,y)

    for i, bullet in ipairs(self.bullets) do
        love.graphics.rectangle('fill', world:getRect(bullet))
    end
    
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

function bullet(x,y, vx, vy)
    local b = { x = x, y = y, name = "playerBullet"}
    world:add(b, b.x, b.y, 8, 8)
    return b;
end

return player;
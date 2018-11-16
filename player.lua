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

    function love.keypressed( key )
        if key == "d" then
            table.insert(self.bullets, bullet:create(self.x, self.y, 10, 0))
        end
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

    for i, bullet in ipairs(self.bullets) do
        bullet:update();
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
    
    for i=#self.bullets,1,-1 do 
        local v = self.bullets[i] 
        if not v.isAlive then 
            world:remove(v)
            table.remove(self.bullets, i) 
        end 
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

bullet = {};
bullet.__index = bullet

function bullet:create(x,y, vx, vy)
    local b = { x = x, y = y, vx = vx, vy = vy, name = "playerBullet", isAlive = true}
    world:add(b, b.x, b.y, 8, 8)
    
    function b:update()
        local goalX = self.x + self.vx;
        local goalY = self.y + self.vy;
        self.x, self.y, collisions = world:move(self, goalX, goalY, self.filter)

        if self.x < 0 or self.x > 1032 then
            b.isAlive = false
        end

        for i, bullet in ipairs(collisions) do
            b.isAlive = false
        end
    end

    function b:filter(other)
        if other.name == "player" or other.name == "playerBullet" then
            return nil;
        end

        return "touch";
    end
    
    return b;


end

-- function bullet:update()
--     local goalX = self.x + self.vx;
--     local goalY = self.y + self.vy;
--     self.x, self.y = world:move(self, goalX, goalY)
-- end

function bulletUpdate() 
    -- self.x, self.y, collisions = world:move(self, goalX, goalY, self.filter)
    
end

return player;
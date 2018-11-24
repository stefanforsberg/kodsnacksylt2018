local enemies = {}
local img = love.graphics.newImage("enemy.png")

function enemies:init()
    self.timer = 0
end

function enemies:update(dt) 

    if self.timer > boss.currentPhase.enemyThreashold then
        things:add(enemy:create())
        self.timer = 0
    end

    self.timer = self.timer + dt
    
end

enemy = {};
enemy.__index = enemy

function enemy:create()
    
    local e = { 
        x = 32 + 32*math.floor(love.math.random() * 30), 
        y = 32 + 32*math.floor(love.math.random() * 19), 
        name = "enemy", 
        timer = 0, 
        img = img, 
        health = boss.currentPhase.enemyHealth
    }
    
    world:add(e, e.x, e.y, 64, 64)

    function e:hit()
        self.health = self.health -1
    end

    function e:update(dt)
        self.timer = self.timer + 1
        
        if self.timer == 100 then
            things:add(bossBullet:create(self.x+12, self.y+12, player.x+12, player.y+12))
            self.timer = 0
        end

        self.x, self.y, collisions = world:move(self, self.x, self.y, self.filter)
        
        if self.health <= 0 then
            self.remove = true
        end
    end

    function e:draw()
        love.graphics.draw(self.img, self.x, self.y)
    end

    function e:filter(other)
      
        return nil;
    end
    
    return e;
end

return enemies
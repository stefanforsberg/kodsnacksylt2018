platforms = {}

function platforms:load()
    
    things:add(platform:create(-1, 0, 1, 768, "wall"))
    things:add(platform:create(1024, 0, 1, 768, "wall"))
    things:add(platform:create(-1, -1, 1, 768, "wall"))
    things:add(platform:create(0, 768, 1024, 1, "wall"))

    things:add(platform:create(32*10, 768-32*4, 1024-32*20, 16, "platform"))

    things:add(platform:create(32*3, 768-32*8, 32*5, 16, "platform"))
    things:add(platform:create(1024-32*8, 768-32*8, 32*5, 16, "platform"))

    things:add(platform:create(32*10, 768-32*12, 1024-32*20, 16, "platform"))

    things:add(platform:create(32*3, 768-32*16, 32*5, 16, "platform"))
    things:add(platform:create(1024-32*8, 768-32*16, 32*5, 16, "platform"))

    things:add(platform:create(32*10, 768-32*20, 1024-32*20, 16, "platform"))
end

platform = {};
platform.__index = platform

function platform:create(x, y, w, h, name)
    local p = { x = x, y = y, w = w, h = h, name = name}
    world:add(p, p.x, p.y, p.w, p.h)

    function p:draw()
        outline(self.x, self.y, self.w, self.h)
        love.graphics.setColor(255,255,255,0.3)
        love.graphics.rectangle('fill', world:getRect(self))
        love.graphics.setColor(255,255,255,1)
    end

    return p;
end

return platforms;
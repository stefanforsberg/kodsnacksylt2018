platforms = {}

function platforms:load()
    
    things:add(platform:create(-1, 0, 1, 768))
    things:add(platform:create(1024, 0, 1, 768))
    things:add(platform:create(-1, -1, 1, 768))

    things:add(platform:create(0, 768-32, 1024, 32))

    things:add(platform:create(32*10, 768-32*5, 1024-32*20, 32))

    things:add(platform:create(32*5, 768-32*9, 32*5, 32))
end

platform = {};
platform.__index = platform

function platform:create(x, y, w, h)
    local p = { x = x, y = y, w = w, h = h, name = "platform"}
    world:add(p, p.x, p.y, p.w, p.h)

    function p:draw()
        love.graphics.rectangle('fill', world:getRect(self))
    end

    return p;
end

return platforms;
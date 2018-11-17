things = {
    items = {}
}
local items = {}
function things:add(item)
    table.insert(self.items, item)
end

function things:update(dt)
    for i, item in ipairs(self.items) do
        item:update()
    end

    for i=#self.items,1,-1 do 
        local v = self.items[i] 
        if not v.isAlive then 
            world:remove(v)
            table.remove(self.items, i) 
        end 
    end 
end

function things:draw()
    for i, item in ipairs(self.items) do
        item:draw()
    end
end

return things;
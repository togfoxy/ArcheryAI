draw = {}

function draw.range()

    -- draw person
    -- draw bow
    -- draw arrow
    -- draw target
    -- draw target legs

    -- draw the stick man
    -- head
    local drawx = 5 * BOX2D_SCALE
    local drawy = 42 * BOX2D_SCALE
    local radius = 1 * BOX2D_SCALE
    love.graphics.setColor(0,1,1,1)
    love.graphics.circle("fill", drawx, drawy, radius)
    -- body
    drawy2 = drawy + 100
    love.graphics.line(drawx, drawy, drawx, drawy2)
    -- legs
    love.graphics.line(drawx, drawy2, drawx - 50, drawy2 + 50)
    love.graphics.line(drawx, drawy2, drawx + 50, drawy2 + 50)

    -- draw physical objects
    for k, obj in pairs(PHYSICS_ENTITIES) do
        if obj.type == enum.physObjGround then
    		local body = obj.body
    		for _, fixture in pairs(body:getFixtures()) do
    			local shape = fixture:getShape()
    			local points = {body:getWorldPoints(shape:getPoints())}
    			for i = 1, #points do
    				points[i] = points[i] * BOX2D_SCALE
    			end
                love.graphics.setColor(0,1,0,1)
                love.graphics.polygon("fill", points)
            end
        elseif obj.type == enum.physObjTarget then
            local body = obj.body
            for _, fixture in pairs(body:getFixtures()) do
                local shape = fixture:getShape()
                local points = {body:getWorldPoints(shape:getPoints())}
                for i = 1, #points do
                    points[i] = points[i] * BOX2D_SCALE
                end
                love.graphics.setColor(0,0,1,1)
                love.graphics.polygon("fill", points)
            end
        end
    end

    --             love.graphics.circle("fill", obj.body:getX(), obj.body:getY(), obj.shape:getRadius())
end

return draw

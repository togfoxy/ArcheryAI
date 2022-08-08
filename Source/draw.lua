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
            local points = {}
    		for _, fixture in pairs(body:getFixtures()) do
    			local shape = fixture:getShape()
    			points = {body:getWorldPoints(shape:getPoints())}
    			for i = 1, #points do
    				points[i] = points[i] * BOX2D_SCALE
    			end

            end
            love.graphics.setColor(0,1,0,1)
            love.graphics.polygon("fill", points)
        elseif obj.type == enum.physObjTarget then
            local body = obj.body
            local points = {}
            for _, fixture in pairs(body:getFixtures()) do
                local shape = fixture:getShape()
                points = {body:getWorldPoints(shape:getPoints())}
                for i = 1, #points do
                    points[i] = points[i] * BOX2D_SCALE
                end
            end
            love.graphics.setColor(0,0,1,1)
            love.graphics.polygon("fill", points)
        elseif obj.type == enum.physObjArrow then
            local body = obj.body
            local points = {}
            for _, fixture in pairs(body:getFixtures()) do
                local shape = fixture:getShape()
                 points = {body:getWorldPoints(shape:getPoints())}
                for i = 1, #points do
                    points[i] = points[i] * BOX2D_SCALE
                end
            end

            local dx, dy = body:getLinearVelocity()
            local compassangle = cf.getBearing(0,0,dx, dy)
            local radangle = math.rad(compassangle)
            body:setAngle(radangle)
            -- love.graphics.setColor(1,0,1,1)
            -- love.graphics.polygon("fill", points)

            local x1, y1 = body:getPosition()
            x1 = x1 * BOX2D_SCALE
            y1 = y1 * BOX2D_SCALE
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(IMAGES[enum.imagesArrow], x1, y1, radangle, 0.5, 0.5, 50, 40)


        end
    end

    -- draw arrow images
    for k, arrow in pairs(ARROWS) do
        local drawx = arrow.x * BOX2D_SCALE
        local drawy = arrow.y * BOX2D_SCALE
        local radangle = arrow.angle

        love.graphics.draw(IMAGES[enum.imagesArrow], drawx, drawy, radangle, 0.5, 0.5, 50, 40)

    end



    --             love.graphics.circle("fill", obj.body:getX(), obj.body:getY(), obj.shape:getRadius())
end

return draw

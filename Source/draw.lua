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
        elseif obj.type == enum.physObjWall then
            local body = obj.body
            local points = {}
            for _, fixture in pairs(body:getFixtures()) do
                local shape = fixture:getShape()
                points = {body:getWorldPoints(shape:getPoints())}
                for i = 1, #points do
                    points[i] = points[i] * BOX2D_SCALE
                end
            end
            love.graphics.setColor(1,1,0,1)
            love.graphics.polygon("fill", points)
        end
    end

    -- draw arrow images
    for k, arrow in pairs(ARROWS) do
        local drawx = arrow.x * BOX2D_SCALE
        local drawy = arrow.y * BOX2D_SCALE
        local radangle = arrow.angle

        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(IMAGES[enum.imagesArrow], drawx, drawy, radangle, 0.5, 0.5, 50, 40)

    end
    -- love.graphics.circle("fill", obj.body:getX(), obj.body:getY(), obj.shape:getRadius())
end

function draw.hud()

    -- draw the last 10 results

    GRAPH = {}
    local max = #RESULTS
    local min = max - 10    -- min could be a negative number so fix in next line
    local min = math.max(min, 0)
    love.graphics.setColor(1,1,1,1)
    local drawx = SCREEN_WIDTH - 75
    local drawy = 50
    for i = max, min, -1 do
        if RESULTS[i] ~= nil then
            love.graphics.print(RESULTS[i], drawx, drawy)
            drawy = drawy + 20
        end
    end

    -- calculate the average
    local avg = 0
    local sum = 0
    local total = 0
    for i = 1, #RESULTS do
        sum = sum + RESULTS[i]
        total = total + 1
        avg = cf.round(sum/total, 1)
        table.insert(GRAPH, avg)
        if #GRAPH > 100 then table.remove(GRAPH, 1) end
    end

    -- draw the graph
    local drawx = SCREEN_WIDTH - 250
    local drawy = 125
    love.graphics.line(drawx, drawy, drawx, drawy - 50)
    love.graphics.line(drawx, drawy, drawx + 100, drawy)
    for i = #GRAPH, 1, -1 do
        local x = drawx + i
        local y = (drawy - (GRAPH[i] * 2))
        love.graphics.circle("fill", x, y, 2)
    end
    -- draw the 'random' benchmark line
    local drawx1 = drawx        -- from above
    local drawy1 = drawy - 30   -- from above
    local drawx2 = drawx1 + 100
    local drawy2 = drawy1
    love.graphics.setColor(0, 1, 1, 0.75)
    love.graphics.line(drawx1, drawy1, drawx2, drawy2)
    -- print the average
    local avg = "Average: " .. (GRAPH[#GRAPH] or 0)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(avg, drawx, drawy + 20)
    love.graphics.print("Arrows launched: " .. ARROW_COUNT, drawx, drawy + 40 )
    -- time since learned
    local txt = "Time since learning: " .. cf.round(TIME_SINCE_LEARN, 1)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(txt, drawx, drawy + 60)

    -- draw AI mode
    love.graphics.setColor(1, 1, 1, 1)
    if AI_ON then
        love.graphics.print("(a) AI active", 25, 20)
    else
        love.graphics.print("(a) AI off", 25, 20)
    end
    -- draw exploit mode
    if AI_EXPLOIT_ON then
        love.graphics.print("(r) AI is not random", 25, 40)
    else
        love.graphics.print("(r) AI is random", 25, 40)
    end
    -- draw the learn mode
    if AI_LEARN_ON then
        love.graphics.print("(e) AI is learning", 25, 60)
    else
        love.graphics.print("(e) AI has learnt", 25, 60)
    end
    love.graphics.print("(w) Add wall", 25, 80)
    -- draw fidelity
    love.graphics.print("Learning fidelity: " .. QTABLE_RESOLUTION, 125, 20)

end

function draw.graph()
    -- draw the qtable on the screen

    local boxborder = 150
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill", boxborder, boxborder, SCREEN_WIDTH - (boxborder * 2), SCREEN_HEIGHT - (boxborder * 2))

    -- origin is bottom left corner
    local originx = boxborder + 50
    local originy = boxborder + SCREEN_HEIGHT - (boxborder * 2) - 50
    love.graphics.setColor(1,1,1,1)
    love.graphics.circle("fill", originx, originy, 5)

    -- these are maximum vectors permissible when exploring
    -- i is the y vector which is negative
    local imin = -1000
    local imax = 10
    -- j is the x vector which is positive
    local jmin = 0
    local jmax = 2000

    for i = imin, imax do
        if BIG_GRAPH[i] == nil then
            -- skip
        else
            for j = jmin, jmax do
                if BIG_GRAPH[i][j] == nil then
                    -- skip
                else
                    -- print(i, j, BIG_GRAPH[i][j])

                    -- scale the vector back to normal 1:1 scale
                    local yvector = i * QTABLE_RESOLUTION
                    local xvector = j * QTABLE_RESOLUTION

                    local graphscale = 4
                    yvector = yvector / graphscale
                    xvector = xvector / graphscale

                    -- inverted graph
                    local drawx = originx + (xvector)         -- larger numbers bring the dots closer to the origin
                    local drawy = originy + (yvector)

                    love.graphics.circle("fill", drawx, drawy, 1)

                    -- error()
                end
            end
        end
    end

    -- draw axis
    local x1 = originx
    local y1 = originy
    local x2 = originx + 700
    local y2 = y1
    love.graphics.line(x1, y1, x2, y2)

    local x1 = originx
    local y1 = originy
    local x2 = x1
    local y2 = originy - 500
    love.graphics.line(x1, y1, x2, y2)

end

return draw

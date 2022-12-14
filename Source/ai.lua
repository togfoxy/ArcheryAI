ai = {}

function ai.initialiseQTable()

    QTABLE = {}

end

function ai.updateQTable(arrow, distance)
    -- receive an arrow object
    -- receive the "score" (distance)
    -- calculate reward
    -- update Q Table

    -- QTable structure: QTABLE[y][x] = delta y , delta x
    local xvector = arrow.xvector / QTABLE_RESOLUTION
    local yvector = arrow.yvector / QTABLE_RESOLUTION

    xvector = cf.round(xvector)
    yvector = cf.round(yvector)

    if QTABLE[yvector] == nil then
        QTABLE[yvector] = {}
        QTABLE[yvector][xvector] = {}
        QTABLE[yvector][xvector].score = 0
        QTABLE[yvector][xvector].count = 0
        QTABLE[yvector][xvector].avg = 0
        TIME_SINCE_LEARN = 0
    elseif QTABLE[yvector][xvector] == nil then
        QTABLE[yvector][xvector] = {}
        QTABLE[yvector][xvector].score = 0
        QTABLE[yvector][xvector].count = 0
        QTABLE[yvector][xvector].avg = 0
        TIME_SINCE_LEARN = 0
    end

    QTABLE[yvector][xvector].score = QTABLE[yvector][xvector].score + distance
    QTABLE[yvector][xvector].count = QTABLE[yvector][xvector].count + 1
    QTABLE[yvector][xvector].avg = cf.round(QTABLE[yvector][xvector].score / QTABLE[yvector][xvector].count, 1)

    -- update the big graph if AI has found a good solution
    if BIG_GRAPH[yvector] == nil then
        BIG_GRAPH[yvector] = {}
    end
    if BIG_GRAPH[yvector][xvector] == nil then
        BIG_GRAPH[yvector][xvector] = {}
    end

    if QTABLE[yvector][xvector].avg <= 1 then
        BIG_GRAPH[yvector][xvector] = QTABLE[yvector][xvector].avg
    end
end

function ai.getXVector(yvector)
    -- receive the yvector
    -- return back the best xvector (power) for the provided yvector

    local xvector

    yvector = yvector / QTABLE_RESOLUTION
    yvector = cf.round(yvector)

    if not AI_EXPLOIT_ON then
        -- random
        xvector = love.math.random(200, 2000)
    else
        -- AI can use Q Table
        -- explore or exploit?
        if AI_LEARN_ON and love.math.random(1, 100) <= 10 then
            -- do random
            xvector = love.math.random(200, 2000)
        else
            -- exploit
            if QTABLE[yvector] == nil then
                -- no value. Just explore
                xvector = love.math.random(200, 2000)
            else
                -- there is at least one xvector available for the provided yvector. Determine which xvector is best
                local bestscore = 999
                local bestxvector = nil
                -- print("yvector is: " .. yvector)
                for k, v in pairs(QTABLE[yvector]) do
                    -- print(k, inspect(v))
                    if v.avg < bestscore or bestxvector == nil then
                        -- this is the best option so far
                        bestscore = v.avg
                        bestxvector = k
                    end
                end
                if bestscore > 10 then
                    -- this is not a viable solution.
                    if AI_LEARN_ON then
                        -- switch to explore
                        xvector = love.math.random(200, 2000)
                    else
                        -- don't take the shot
                    end
                else
                    -- winner
                    xvector = bestxvector * QTABLE_RESOLUTION
                end
            end
        end
    end
    return xvector
end

function ai.update(dt)
    -- called from love.update()

    AI_SHOOT_TIMER = AI_SHOOT_TIMER - dt
    if AI_SHOOT_TIMER <= 0 then
        -- shoot
        AI_SHOOT_TIMER = AI_SHOOT_TIMER_DEFAULT

        -- for a given x delta, determine the correct angle
        local ydelta = love.math.random(10, -1000)
        local xdelta = ai.getXVector(ydelta)            -- provide the x and get back the y

        if xdelta ~= nil then
            fun.launchArrow(xdelta, ydelta)
        end
    end
end

function ai.loadQTable()
    QTABLE = {}
    local savedir = love.filesystem.getSourceBaseDirectory( )
    if love.filesystem.isFused() then
        savedir = savedir .. "\\savedata\\"
    else
        savedir = savedir .. "/Source/savedata/"
    end
    local savefile = savedir .. "qtable.dat"
    if nativefs.getInfo(savefile) then
        contents, size = nativefs.read(savefile)
        QTABLE = bitser.loads(contents)
        print("QTABLE file found.")
    else
        print("QTABLE file not found.")
    end
    if QTABLE == nil then
        print("QTABLE is empty.")
    else
        print("QTABLE is loaded.")
    end
end

function ai.saveQTable()
    local savedir = love.filesystem.getSourceBaseDirectory( )
    if love.filesystem.isFused() then
        savedir = savedir .. "\\savedata\\"
    else
        savedir = savedir .. "/Source/savedata/"
    end
    local savefile = savedir .. "qtable.dat"
    local serialisedString = bitser.dumps(QTABLE)
    local success, message = nativefs.write(savefile, serialisedString)
    if success then
        print("QTABLE saved to file")
    else
        print("Save error: " .. message)
    end
end

return ai

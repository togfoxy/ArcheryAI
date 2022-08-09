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
    local xvector = arrow.xvector
    local yvector = arrow.yvector
    if QTABLE[yvector] == nil then
        QTABLE[yvector] = {}
        QTABLE[yvector][xvector] = {}
        QTABLE[yvector][xvector].score = 0
        QTABLE[yvector][xvector].count = 0
        QTABLE[yvector][xvector].avg = 0
    elseif QTABLE[yvector][xvector] == nil then
        QTABLE[yvector][xvector] = {}
        QTABLE[yvector][xvector].score = 0
        QTABLE[yvector][xvector].count = 0
        QTABLE[yvector][xvector].avg = 0
    end

    QTABLE[yvector][xvector].score = QTABLE[yvector][xvector].score + distance
    QTABLE[yvector][xvector].count = QTABLE[yvector][xvector].count + 1
    QTABLE[yvector][xvector].avg = cf.round(QTABLE[yvector][xvector].score / QTABLE[yvector][xvector].count, 1)

    -- print("*******************************")
    -- print(inspect(QTABLE))

end

function ai.getXVector(yvector)
    -- receive the yvector
    -- return back the best xvector (power) for the provided yvector

    local xvector

    if not AI_EXPLOIT_ON then
        -- random
        xvector = love.math.random(200, 2000)
    else
        -- AI can use Q Table
        -- explore or exploit?
        if love.math.random(1, 100) <= 10 then
            -- explore
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
                print("best xvector is: " .. bestxvector .. ". Estimated distance is: " .. bestscore)
                xvector = bestxvector
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

        fun.launchArrow(xdelta, ydelta)
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

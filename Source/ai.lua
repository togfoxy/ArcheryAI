ai = {}

function ai.update(dt)
    -- called from love.update()

    AI_SHOOT_TIMER = AI_SHOOT_TIMER - dt
    if AI_SHOOT_TIMER <= 0 then
        -- shoot
        AI_SHOOT_TIMER = AI_SHOOT_TIMER_DEFAULT

        fun.launchArrow(800,-200)
    end

end

return ai

functions = {}

function functions.loadImages()

    IMAGES[enum.imagesArrow] = love.graphics.newImage("assets/images/arrow.png")

end

function functions.loadFonts()
    -- FONT[enum.fontHeavyMetalLarge] = love.graphics.newFont("assets/fonts/Heavy Metal Box.ttf")
    -- FONT[enum.fontHeavyMetalSmall] = love.graphics.newFont("assets/fonts/Heavy Metal Box.ttf",10)
    FONT[enum.fontDefault] = love.graphics.newFont("assets/fonts/Vera.ttf", 12)
	-- FONT[enum.fontTech36] = love.graphics.newFont("assets/fonts/CorporateGothicNbpRegular-YJJ2.ttf", 36)
	-- FONT[enum.fontTech18] = love.graphics.newFont("assets/fonts/CorporateGothicNbpRegular-YJJ2.ttf", 24)
end

function functions.initialiseGame()

    love.physics.setMeter(1)
    PHYSICSWORLD = {}
    PHYSICSWORLD = love.physics.newWorld(0,9.81,false)
    PHYSICSWORLD:setCallbacks(_,_,_,postSolve)

    PHYSICS_ENTITIES = {}
end

function functions.createRangeItems()

    -- add the ground
    local x = 49        -- centre of the box
    local y = 50
    local width = 2000
    local height = 2

    local object = {}
    object.body = love.physics.newBody(PHYSICSWORLD, x, y, "static")
    object.shape = love.physics.newRectangleShape(width, height)        -- will put x/y in centre of rectangle
    object.fixture = love.physics.newFixture(object.body, object.shape)
    object.fixture:setRestitution(0)
    object.fixture:setGroupIndex( -1 )
    object.fixture:setFriction( 1 )
    object.type = enum.physObjGround
    table.insert(PHYSICS_ENTITIES, object)

    -- add the target
    local x = 75        -- centre of the box
    local y = 46
    local width = 0.5
    local height = 4
    angle = 30          -- compass degrees

    object = {}
    object.body = love.physics.newBody(PHYSICSWORLD, x, y, "static")
    object.shape = love.physics.newRectangleShape(0, 0, width, height, cf.convCompassToRad(angle))        -- will put x/y in centre of rectangle
    object.fixture = love.physics.newFixture(object.body, object.shape)
    object.fixture:setRestitution(0)
    object.fixture:setGroupIndex( -2)
    object.type = enum.physObjTarget
    table.insert(PHYSICS_ENTITIES, object)
end

function functions.createWall()

    -- add a vertical wall
    local x = 43        -- centre of the box
    local y = 42
    local width = 1
    local height = 15

    local object = {}
    object.body = love.physics.newBody(PHYSICSWORLD, x, y, "static")
    object.shape = love.physics.newRectangleShape(width, height)        -- will put x/y in centre of rectangle
    object.fixture = love.physics.newFixture(object.body, object.shape)
    object.fixture:setRestitution(0)
    object.fixture:setGroupIndex( -1 )
    object.fixture:setFriction( 1 )
    object.type = enum.physObjWall
    table.insert(PHYSICS_ENTITIES, object)

end

function functions.launchArrow(xdelta,ydelta)
    -- xdelta is how far left
    -- ydelta is how far down
    -- will need to convert that to a physics delta

    -- qtable requires integers so do some defensive coding here
    xdelta = cf.round(xdelta)
    ydelta = cf.round(ydelta)

    -- create the arrow
    local x = 7       -- centre of the box
    local y = 42
    local width = 0.5
    local height = 1
    local points = {0, -0.25, 0.25, 0, 0, 2, -0.25, 0}

    local object = {}
    object.body = love.physics.newBody(PHYSICSWORLD, x, y, "dynamic")
    object.shape = love.physics.newPolygonShape(points)
    object.fixture = love.physics.newFixture(object.body, object.shape)
    object.fixture:setRestitution(0)
    object.fixture:setGroupIndex( -3)
    object.type = enum.physObjArrow
    object.xvector = xdelta
    object.yvector = ydelta
    table.insert(PHYSICS_ENTITIES, object)

    local compassangle = cf.getBearing(0,0, xdelta, ydelta)
    local radangle = math.rad(compassangle)
    object.body:setAngle(radangle)
    object.body:applyForce(xdelta, ydelta)		-- the amount of force = vector distance
    ARROW_COUNT = ARROW_COUNT + 1

    -- print(xdelta, ydelta)
end

function functions.killPhysObject(mybody)
    -- receives a body and kills it

    for i = 1, #PHYSICS_ENTITIES do
        if PHYSICS_ENTITIES[i].body == mybody then
            -- kill
            PHYSICS_ENTITIES[i].body:destroy()
            table.remove(PHYSICS_ENTITIES, i)
            break
        end
    end
end

return functions

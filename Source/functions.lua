functions = {}

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
    -- PHYSICSWORLD:setCallbacks(_,_,_,postSolve)

    PHYSICS_ENTITIES = {}
end

function functions.createRangeItems()

    -- add the ground
    local x = 49        -- centre of the box
    local y = 50
    local width = 100
    local height = 2

    local object = {}
    object.body = love.physics.newBody(PHYSICSWORLD, x, y, "static")
    object.shape = love.physics.newRectangleShape(width, height)        -- will put x/y in centre of rectangle
    object.fixture = love.physics.newFixture(object.body, object.shape)
    object.type = enum.physObjGround
    table.insert(PHYSICS_ENTITIES, object)

    -- add the target
    local x = 75        -- centre of the box
    local y = 46
    local width = 1
    local height = 2
    angle = 30          -- compass degrees

    object = {}
    object.body = love.physics.newBody(PHYSICSWORLD, x, y, "static")
    object.shape = love.physics.newRectangleShape(0, 0, width, height, cf.convCompassToRad(angle))        -- will put x/y in centre of rectangle
    object.fixture = love.physics.newFixture(object.body, object.shape)
    object.type = enum.physObjTarget
    table.insert(PHYSICS_ENTITIES, object)
end


return functions

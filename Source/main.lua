GAME_VERSION = "0.01"

inspect = require 'lib.inspect'
-- https://github.com/kikito/inspect.lua

res = require 'lib.resolution_solution'
-- https://github.com/Vovkiv/resolution_solution

cf = require 'lib.commonfunctions'
buttons = require 'buttons'
constants = require 'constants'
fun = require 'functions'
draw = require 'draw'

SCREEN_WIDTH = 1920
SCREEN_HEIGHT = 1080
SCREEN_STACK = {}

function postSolve(a, b, coll, normalimpulse, tangentimpulse)
	-- a and be are fixtures
	local obj1, obj2
	local body1 = a:getBody()
	local body2 = b:getBody()

	local target

	-- get a handle on the objects
	for k, object in pairs(PHYSICS_ENTITIES) do
		if object.body == body1 then
			obj1 = object
		end
		if object.body == body2 then
			obj2 = object
		end
		if object.type == enum.physObjTarget then
			target = object		-- this is NOT the body.
		end
	end

	if obj1 ~= nil and obj2 ~= nil then
		if obj1.type == enum.physObjArrow then
			body1:setLinearVelocity(0,0)
			if obj2.type == enum.physObjTarget then
				print("Whoot!")
			end

			-- capture the score (distance to target)
			local targetx, targety = target.body:getPosition()
			local arrowx, arrowy = obj1.body:getPosition()
			local distance = cf.GetDistance(arrowx, arrowy, targetx, targety)			-- physics meters
			distance = cf.round(distance, 1)
			-- print(distance)
			table.insert(RESULTS, distance)
			if #RESULTS > 100 then table.remove(RESULTS, 1) end

			local myarrow = {}
			-- these are physics numbers
			myarrow.x, myarrow.y = body1:getPosition()
			myarrow.angle = body1:getAngle()
			myarrow.timer = ARROW_TIMER
			table.insert(ARROWS, myarrow)
			fun.killPhysObject(body1)
		end
		if obj2.type == enum.physObjArrow then
			body2:setLinearVelocity(0,0)
			if obj1.type == enum.physObjTarget then
				print("Whoot!")
			end

			-- capture the score (distance to target)
			local targetx, targety = target.body:getPosition()
			local arrowx, arrowy = obj2.body:getPosition()
			local distance = cf.GetDistance(arrowx, arrowy, targetx, targety)			-- physics meters
			distance = cf.round(distance, 1)
			-- print(distance)
			table.insert(RESULTS, distance)
			if #RESULTS > 100 then table.remove(RESULTS, 1) end

			local myarrow = {}
			-- these are physics numbers
			myarrow.x, myarrow.y = body2:getPosition()
			myarrow.angle = body2:getAngle()
			myarrow.timer = ARROW_TIMER
			table.insert(ARROWS, myarrow)
			fun.killPhysObject(body2)
		end
	else
		print("Detected a nil body")
	end
end

function love.keyreleased( key, scancode )
	if key == "escape" then
		cf.RemoveScreen(SCREEN_STACK)
	end
end

function love.mousepressed( x, y, button, istouch, presses )
	MOUSEX = x
	MOUSEY = y
end

function love.mousemoved( x, y, dx, dy, istouch )
end

function love.mousereleased( x, y, button, istouch, presses )
	local wx, wy
	if cam == nil then
	else
		wx,wy = cam:toWorld(x, y)	-- converts screen x/y to world x/y
	end

	local currentScreen = cf.currentScreenName(SCREEN_STACK)
	local buttonID = buttons.getButtonClicked(x, y, currentScreen, GUI_BUTTONS)		-- could return nil

	if button == 1 then
		if currentScreen == enum.sceneMainMenu then
			if buttonID == enum.buttonStart then
				--! start game
				fun.initialiseGame()
				fun.createRangeItems()
				cf.AddScreen(enum.sceneRange, SCREEN_STACK)
			end
		elseif currentScreen == enum.sceneRange then
			-- see if pulling the bow
			local xdelta, ydelta
			if MOUSEX ~= nil then
				xdelta = MOUSEX - x
			end
			if MOUSEY ~= nil then
				ydelta = y - MOUSEY
			end
			if xdelta ~= nil and xdelta ~= 0 then
				local mousescaling = 3		-- mouse sensitivity
				xdelta = xdelta * mousescaling
				ydelta = ydelta * -1 * mousescaling
				fun.launchArrow(xdelta, ydelta)
			end
		end
	end
end

function love.load()

	res.setGame(SCREEN_WIDTH, SCREEN_HEIGHT)

    if love.filesystem.isFused( ) then
        void = love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT,{fullscreen=true,display=1,resizable=false, borderless=true})	-- display = monitor number (1 or 2)
    else
        void = love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT,{fullscreen=true,display=1,resizable=false, borderless=true})	-- display = monitor number (1 or 2)
    end

	love.window.setTitle("Archery AI " .. GAME_VERSION)

	constants.load()
	buttons.load()
	fun.loadFonts()
	fun.loadImages()

	cf.AddScreen(enum.sceneMainMenu, SCREEN_STACK)

end

function love.draw()
    res.start()

	love.graphics.setColor(1,1,1,1)
	love.graphics.rectangle("line", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

	local currentScreen = cf.currentScreenName(SCREEN_STACK)
	buttons.draw(currentScreen)

	if currentScreen == enum.sceneRange then
		draw.range()
		draw.hud()

		-- cf.printAllPhysicsObjects(PHYSICSWORLD, BOX2D_SCALE)
	end
    res.stop()
end

function love.update(dt)
	local currentScreen = cf.currentScreenName(SCREEN_STACK)
	if currentScreen == enum.sceneRange then
		PHYSICSWORLD:update(dt) -- this puts the world into motion

		-- update arrow timer
		for i = #ARROWS, 1, -1 do
			ARROWS[i].timer = ARROWS[i].timer - dt
			if ARROWS[i].timer <= 0 then
				-- delete it
				table.remove(ARROWS, i)
			end
		end
	end
	res.update()
end

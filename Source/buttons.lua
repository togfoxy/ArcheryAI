buttons = {}


function buttons.load()
	-- load the global GUI_BUTTONS table with buttons

	-- Main Menu
	local mybutton = {}
	mybutton.x = (SCREEN_WIDTH / 2) - 50
	mybutton.y = (SCREEN_HEIGHT / 3)
	mybutton.width = 100
	mybutton.height = 40
	mybutton.drawOutline = true
	mybutton.label = "Start"
	mybutton.image = nil
	mybutton.labeloffcolour = {1,1,1,1}
	mybutton.labeloncolour = {1,1,1,1}
	mybutton.bgcolour = {1,1,1,1}
	-- mybutton.state = "on"
	mybutton.visible = true
	mybutton.scene = enum.sceneMainMenu
	mybutton.identifier = enum.buttonStart
	table.insert(GUI_BUTTONS, mybutton)
end

function buttons.draw(scene)
    for k, button in pairs(GUI_BUTTONS) do
        if button.scene == scene and button.visible then
            -- draw the button
            love.graphics.setColor(button.bgcolour)
            if button.image ~= nil then
                love.graphics.draw(button.image, button.x, button.y)
            else
                if button.drawOutline then
                    love.graphics.rectangle("line", button.x, button.y, button.width, button.height)
                end
            end
            love.graphics.setColor(button.labeloncolour)
            local labelxoffset = button.labelxoffset or 0
            love.graphics.setFont(FONT[enum.fontDefault])
            -- love.graphics.print(button.label, button.x + labelxoffset, button.y + 5)
            love.graphics.printf(button.label, button.x, button.y + (button.height / 2) - 10, button.width, "center")
        end
    end
end

function buttons.getButtonClicked(mx, my, scene, buttontable)
	-- the button table is a global table
	-- check if mouse click is inside any button
	-- mx, my = mouse click X/Y
    -- scene is the current scene
	-- button is from the global table
	-- returns the identifier of the button (enum) or nil

    for k, button in pairs(buttontable) do
        if button.scene == scene then
        	if mx >= button.x and mx <= button.x + button.width and
        		my >= button.y and my <= button.y + button.height then
                return button.identifier
        	end
        end
    end
    return nil
end

return buttons


local composer = require ("composer")
local scene = composer.newScene ()
------------------- DECALRE ----------------------------------------------------------------------

local fCenterX = display.contentWidth / 2
local fCenterY = display.contentHeight / 2

local iFixCount = 15

---------------------------------------------------------------------------------------
-- create()
function scene:create (event)

	local sceneGroup = self.view

	-------------------- ASSET ---------------------------------

	local buttonAvari = display.newCircle (sceneGroup, 0, 0, 50)
	buttonAvari:setFillColor (1, 0, 0)

	local textAvari = display.newText (sceneGroup, tostring (iFixCount) .. " Fixs", 0, 0, "Arial", 16)

	--------------------- GROUP --------------------------------

	local groupAvari = display.newGroup ()

	groupAvari:insert (buttonAvari)
	groupAvari:insert (textAvari)

	groupAvari.x = fCenterX
	groupAvari.y = fCenterY

	----------------------------------------------------------------
	------------------ EVENT --------------------------------------------------------------------------
	local function avariFixOnTap (event)
		iFixCount = iFixCount - 1
		textAvari.text = tostring (iFixCount) .. " Fixs"

		if iFixCount <= 0 then
			buttonAvari:setFillColor (0, 1, 0)
		end
		return true
	end
	buttonAvari:addEventListener ("tap", avariFixOnTap)

end
---------------------------------------------------------------------------------------
-- show()
function scene:show (event)

	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
	-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif (phase == "did") then
	-- Code here runs when the scene is entirely on screen

	end
end

---------------------------------------------------------------------------------------
-- hide()
function scene:hide (event)

	local sceneGroup = self.view
	local phase = event.phase

	if (phase == "will") then
	-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif (phase == "did") then
	-- Code here runs immediately after the scene goes entirely off screen

	end
end

---------------------------------------------------------------------------------------
-- destroy()
function scene:destroy (event)

	local sceneGroup = self.view
-- Code here runs prior to the removal of scene's view

end

-------------------------------------------------------------------------------------
-- Scene event function listeners
-------------------------------------------------------------------------------------
scene:addEventListener ("create", scene)
scene:addEventListener ("show", scene)
scene:addEventListener ("hide", scene)
scene:addEventListener ("destroy", scene)
-------------------------------------------------------------------------------------
return scene

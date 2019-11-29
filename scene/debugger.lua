local composer = require ("composer")
local scene    = composer.newScene ()

----------------------------------------------------------------------------------------- create()
function scene:create (event)

  local sceneGroup = self.view
  local bgShip = display.newImageRect(sceneGroup, "assets/ship_deck_bg.png", 1152, 1280)
  bgShip.anchorX, bgShip.anchorY = 0.5, 0.25
  bgShip.x, bgShip.y = fCenterX, fCenterY - 640

  function placementHelper( event )
        --if event.isPrimaryButtonDown then
  	       print( "CLICK: ".. tostring(math.round(event.x)) .. "," .. tostring(math.round(event.y)) )
        --end
  end
  Runtime:addEventListener("tap", placementHelper)
end
----------------------------------------------------------------------------------------- show()
function scene:show (event)

	local sceneGroup = self.view
	local phase      = event.phase

	if (phase == "will") then
	-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif (phase == "did") then
	-- Code here runs when the scene is entirely on screen

	end

end
----------------------------------------------------------------------------------------- hide()
function scene:hide (event)

	local sceneGroup = self.view
	local phase      = event.phase

	if (phase == "will") then
	-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif (phase == "did") then
	-- Code here runs immediately after the scene goes entirely off screen

	end

end
----------------------------------------------------------------------------------------- destroy()
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

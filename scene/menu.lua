local composer = require ("composer")
local scene    = composer.newScene ()
print("MENU")
----------------------------------------------------------------------------------------- create()
function scene:create (event)

  local sceneGroup = self.view
  local btGoToGame = display.newRect( sceneGroup, 150, 150, 200, 50 )
  
  btGoToGame:setFillColor(0, 0, 1)
  function onTapGoToGame ( event )
      local options =
      {
          effect = "fade",
          time = 400,
      }
      composer.gotoScene( "scene.game", options )
      --composer.hideOverlay( "fade", "scene.menu")
      --composer.removeScene( "scene.menu" )
  end
  btGoToGame:addEventListener("tap", onTapGoToGame )
  print("Menu:create")

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

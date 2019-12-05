local composer = require ("composer")
local scene    = composer.newScene ()

----------------------------------------------------------------------------------------- create()
function scene:create (event)

    local sceneGroup = self.view
    local gameoverBG = display.newImageRect("assets_qrb/gameover.png",1136,640)
    gameoverBG.x, gameoverBG.y = fCenterX, fCenterY

    local btGoToGame = display.newImageRect( "assets/ui_frame.png", 256, 128)
    local txGoToGame = display.newText("START", 0, 0, "Comic Sans MS", 60)
    txGoToGame:setFillColor(1,1,0)
    local btGroup = display.newGroup()
    btGroup:insert(btGoToGame)
    btGroup:insert(txGoToGame)
    btGroup.x, btGroup.y = fWidth - 160 , fHeight - 90

    local function onTapRetry ()
        local options =
        {
            effect = "fade",
            time = 400
        }

        composer.gotoScene ("scene.menu")
    end
    btGoToGame:addEventListener("tap", onTapRetry)

    sceneGroup:insert(gameoverBG)
    sceneGroup:insert(btGroup)
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

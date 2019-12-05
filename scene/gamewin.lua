local composer = require ("composer")
local scene    = composer.newScene ()

----------------------------------------------------------------------------------------- create()
function scene:create (event)

    local sceneGroup = self.view
    local gameoverBG = display.newImageRect("assets_qrb/win_island.png",1136,640)
    gameoverBG.x, gameoverBG.y = fCenterX, fCenterY
    -------------------------------------------------
    local fifiSheet = graphics.newImageSheet( "assets_qrb/fifi.png", fifiSheepOptions )
	fifi = display.newSprite(sceneGroup, fifiSheet, fifiSqData )
    fifi:setSequence("stand")
    fifi:play()
    fifi.anchorX, fifi.anchorY = 0.5,1
    fifi.xScale, fifi.yScale = 0.6,0.6
    fifi.x, fifi.y = 1000, fHeight - 120

	-------------------------------------------------

    local captainDadSheet = graphics.newImageSheet( "assets_qrb/pirate_dad.png", captainDadSheepOptions )
	captainDad = display.newSprite(sceneGroup, captainDadSheet, captainDadSqData )
    captainDad:setSequence("smile")
    captainDad:play()
    captainDad.anchorX, captainDad.anchorY = 0.5,1.0
    captainDad.xScale, captainDad.yScale = 0.8,0.8
    captainDad.x, captainDad.y = 850, fHeight - 50
    transition.to(captainDad, {time=400, y=captainDad.y + 10, transition=easing.continuousLoop,iterations=0})
    -------------------------------------------------
    local ship = display.newImage("assets_qrb/ship_menu.png", 495,512)
    ship.anchorX, ship.anchorY = 0,1.0
    ship.xScale, ship.yScale = 0.8,0.8
    ship.x, ship.y = 100, fHeight -20
    transition.to(ship, {time=500, y=fHeight - 10, transition= easing.continuousLoop, iterations=0})
    -------------------------------------------------
    local btGoToGame = display.newImageRect( "assets/ui_frame.png", 350, 128)
    local txGoToGame = display.newText("REJOUER", 0, 0, "Comic Sans MS", 50)
    txGoToGame:setFillColor(1,1,0)
    local txWIN = display.newText("QUEL VOYAGE FANTASTIQUE", 0, 0, "Comic Sans MS", 60)
    txWIN:setFillColor(0.25,0.2,0)
    txWIN.y = -120

    local btGroup = display.newGroup()
    btGroup:insert(btGoToGame)
    btGroup:insert(txGoToGame)
    btGroup:insert(txWIN)
    btGroup.x, btGroup.y = fCenterX , fCenterY - 100

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
    sceneGroup:insert(ship)
    sceneGroup:insert(fifi)
    sceneGroup:insert(captainDad)
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

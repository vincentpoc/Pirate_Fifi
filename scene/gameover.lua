local composer = require ("composer")
local scene    = composer.newScene ()

----------------------------------------------------------------------------------------- create()
function scene:create (event)

    local sceneGroup = self.view
    local gameoverBG = display.newImageRect("assets_qrb/gameover.jpg",1136,640)
    gameoverBG.x, gameoverBG.y = fCenterX, fCenterY
    -------------------------------------------------
    mrMonkey = display.newImageRect(sceneGroup, "assets_qrb/mr_monkey.png",178,222)
    mrMonkey.anchorX, mrMonkey.anchorY = 0.5,1.0
    mrMonkey.xScale, mrMonkey.yScale = 0.6, 0.6
    mrMonkey.x, mrMonkey.y = 900, fHeight - 60
    -------------------------------------------------
    local fifiSheet = graphics.newImageSheet( "assets_qrb/fifi.png", fifiSheepOptions )
	fifi = display.newSprite(sceneGroup, fifiSheet, fifiSqData )
    fifi:setSequence("walk")
    fifi:play()
    fifi.anchorX, fifi.anchorY = 0.5,1
    fifi.xScale, fifi.yScale = 0.8,0.8
    fifi.x, fifi.y = 700,fHeight - 30

	-------------------------------------------------

    local captainDadSheet = graphics.newImageSheet( "assets_qrb/pirate_dad.png", captainDadSheepOptions )
	captainDad = display.newSprite(sceneGroup, captainDadSheet, captainDadSqData )
    captainDad:setSequence("jump")
    captainDad:play()
    captainDad.anchorX, captainDad.anchorY = 0.5,1.0
    captainDad.x, captainDad.y = 300,fHeight
    -------------------------------------------------
    local waveGroup = display.newGroup()
    for i=0, 4 do
      local bgWave = display.newImageRect("assets/env_wave_a.png", 512, 132)
      bgWave.anchorX, bgWave.anchorY = 0, 1
      bgWave.yScale = 1.5
      bgWave.x, bgWave.y = (512 * i)-512, 15
      waveGroup:insert(bgWave)
    end
    waveGroup.x, waveGroup.y = -256, fHeight

    -------------------------------------------------
    local btGoToGame = display.newImageRect( "assets/ui_frame.png", 300, 128)
    local txGoToGame = display.newText("REJOUER", 0, 0, "Comic Sans MS", 60)
    txGoToGame:setFillColor(1,1,0)
    local btGroup = display.newGroup()
    btGroup:insert(btGoToGame)
    btGroup:insert(txGoToGame)
    btGroup.x, btGroup.y = fCenterX , fCenterY

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
    sceneGroup:insert(mrMonkey)
    sceneGroup:insert(fifi)
    sceneGroup:insert(captainDad)
    sceneGroup:insert(waveGroup)
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

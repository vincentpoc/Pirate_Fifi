local composer = require ("composer")
local scene    = composer.newScene ()

----------------------------------------------------------------------------------------- create()
function scene:create (event)

    local sceneGroup = self.view
    local gameoverBG = display.newImageRect("assets_qrb/win_village.jpg",2272,640)
    gameoverBG.x, gameoverBG.y = fCenterX + 568 , fCenterY
    -------------------------------------------------
    local fifiSheet = graphics.newImageSheet( "assets_qrb/fifi.png", fifiSheepOptions )
	fifi = display.newSprite(sceneGroup, fifiSheet, fifiSqData )
    fifi:setSequence("stand")
    fifi:play()
    fifi.anchorX, fifi.anchorY = 0.5,1
    fifi.xScale, fifi.yScale = 0.6,0.6
    fifi.x, fifi.y = 1000, fHeight - 80
    -------------------------------------------------
    local mrMonkey = display.newImageRect(sceneGroup, "assets_qrb/mr_monkey.png",178,222)
    mrMonkey.anchorX, mrMonkey.anchorY = 0.5,1.0
    mrMonkey.xScale, mrMonkey.yScale = 0.6, 0.6
    mrMonkey.x, mrMonkey.y = 800, fHeight - 100
    transition.to(mrMonkey, {delay=150, time=400, y=mrMonkey.y + 10, transition=easing.continuousLoop,iterations=0})
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
    -----------------------------------------------------------------------------------------------------STAGE
    local stageGroup = display.newGroup()
    stageGroup:insert(gameoverBG)
    stageGroup:insert(ship)
    stageGroup:insert(mrMonkey)
    stageGroup:insert(fifi)
    stageGroup:insert(captainDad)
    -----------------------------------------------------------------------------------------UI
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
    btGroup.x, btGroup.y = fCenterX + 1136 , fCenterY - 100
    stageGroup:insert(btGroup)

    local function onTapRetry ()
        local options =
        {
            effect = "fade",
            time = 400
        }

        composer.gotoScene ("scene.menu")
    end
    btGoToGame:addEventListener("tap", onTapRetry)
    -----------------------------------------------------CANNIBALE
    local n = 0
    local cannibaleSheepOptions =
    {
    	numFrames = 4,
    	width = 140, height = 180,
    	sheetContentWidth = 280, sheetContentHeight = 360
    }
    --for i=0,9 do
    for i=0, 8 do

        local cannibaleSheet = graphics.newImageSheet( "assets_qrb/cannibale.png", cannibaleSheepOptions )
        local cannibale = display.newSprite(sceneGroup, cannibaleSheet, {name="cannibale", start=1, count=cannibaleSheepOptions.numFrames} )

        n = n + 1
        if n >= (cannibaleSheepOptions.numFrames+1) then n = 1 end
        cannibale:setFrame(n)
        

        cannibale.xScale, cannibale.yScale = 1.1,1.1
        cannibale.x, cannibale.y = 1200 + (i*120) + math.random(-25, 25), fHeight - 100 - (40 - (i * 5))
        if cannibale.x > 1600 and cannibale.x < 1780 then cannibale.x = cannibale.x + 250 end
        transition.to(cannibale, {delay= math.random(0,250), time=250, y=cannibale.y + 15, transition=easing.continuousLoop,iterations=0})
        stageGroup:insert(cannibale)

    end
    --------------------------------------

    sceneGroup:insert(stageGroup)
    transition.to(captainDad,{time=6000, delay=2000, x= captainDad.x + 800, transition = easing.inSine})
    transition.to(fifi,{time=4000, delay=4000, x= fifi.x + 750, transition = easing.inSine})
    transition.to(mrMonkey,{time=4000, delay=4000, x= mrMonkey.x + 800, transition = easing.inSine})
    transition.to(stageGroup,{time=6000, delay=1000, x = -1136, transition= easing.inOutSine})
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

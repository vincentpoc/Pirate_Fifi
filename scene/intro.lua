local composer = require ("composer")
local scene    = composer.newScene ()

local btSkip
local fifi
local captainDad
local philacter
local saidText
----------------------------------------------------------------------------------------- create()
function scene:create (event)

    local sceneGroup = self.view

    local ship = display.newImage(sceneGroup,"assets_qrb/ship_menu.png", 495,512)
    ship.anchorX, ship.anchorY = 0,1.0
    ship.xScale, ship.yScale = -0.8,0.8
    ship.x, ship.y = fWidth , fHeight -20
    ship.alpha = 0.8
    transition.to(ship, {time=1000, y=fHeight - 10, transition= easing.continuousLoop, iterations=0})

    local bgSet = display.newImageRect(sceneGroup,"assets_qrb/house.png",1136,640)
    --bgSet.anchorX, bgSet.anchorY = 0,1
    --bgSet.xScale,bgSet.yScale = 1.25, 1.25
    bgSet.x,bgSet.y = fCenterX,fCenterY

    local fifiSheet = graphics.newImageSheet( "assets_qrb/fifi.png", fifiSheepOptions )
	fifi = display.newSprite(sceneGroup, fifiSheet, fifiSqData )
    fifi:setSequence("walk")
    fifi:play()
    fifi.anchorX, fifi.anchorY = 0.5,1
    fifi.xScale, fifi.yScale = -0.8,0.8
    fifi.x, fifi.y = 1300,604
    -------------------------------------------------
    local captainDadSheet = graphics.newImageSheet( "assets_qrb/pirate_dad.png", captainDadSheepOptions )
	captainDad = display.newSprite(sceneGroup, captainDadSheet, captainDadSqData )
    captainDad:setSequence("stand")
    captainDad:play()
    captainDad.anchorX, captainDad.anchorY = 0.5,1.0
    captainDad.x, captainDad.y = 238,612
    captainDad.xScale,captainDad.yScale = -1,1
    -------------------------------------------------
    philacter = display.newImageRect(sceneGroup,"assets/philacter.png",650 ,256)
    philacter.anchorX, philacter.anchorY = 0,0
    philacter.isVisible = false
    -------------------------------------------------
    saidText = display.newText(sceneGroup,"", 500, 250, "Comic Sans MS", 40)
    saidText:setFillColor(0,0,0)
    saidText.isVisible = false

    btSkip = display.newImageRect( "assets/ui_frame.png", 206, 90)
    local txSkip = display.newText("Passer", 0, 0, "Comic Sans MS", 40)
    txSkip:setFillColor(1,1,0)
    btGroupSkip = display.newGroup()
    btGroupSkip:insert(btSkip)
    btGroupSkip:insert(txSkip)
    btGroupSkip.x, btGroupSkip.y = fWidth - 150 , 50
    sceneGroup:insert(btGroupSkip)

end

----------------------------------------------------------------------------------------- show()
function scene:show (event)

	local sceneGroup = self.view
	local phase      = event.phase
    local storyPhase = 0



    local tapStory
	if (phase == "will") then
        fifi.x, fifi.y = 1300,604
        captainDad.x, captainDad.y = 238,612
	elseif (phase == "did") then

        function fifiTalk ()
            philacter.xScale = -1
            philacter.x, philacter.y = 950, 150
            saidText.x,saidText.y = 600, 250
        end

        function dadTalk ()
            captainDad.xScale = 1
            philacter.xScale = 1
            philacter.x, philacter.y = 100, 100
            saidText.x,saidText.y = 340,208
        end
        storyPhase = 0
        function tapStory( event )
            if storyPhase == 0 then
                philacter.isVisible = true
                saidText.isVisible = true
                fifiTalk()
                saidText.text="Papa!"
                saidText.size = 80
            elseif storyPhase == 1 then
                --dady jump
                local captainDad_yPos = captainDad.y
                captainDad:setSequence("jump")
                captainDad:play()
                transition.to(captainDad, {y = captainDad_yPos - 100, time=100, transition= easing.outSine})
                transition.to(captainDad, {y = captainDad_yPos, time=150, delay=200, transition= easing.inSine})
                timer.performWithDelay( 250, function ()
                    captainDad:setSequence("stand")
                    captainDad:play()
                end)
                dadTalk ()
                saidText.text="AAAH! Oui, Fifi \nQu'y a-t-il?"
                saidText.size = 40
            elseif storyPhase == 2 then
                captainDad:setSequence("stand")
                captainDad:play()
                fifiTalk()
                saidText.text="Emène moi sur \nl'Ile des Cannibales!"
            elseif storyPhase == 3 then
                dadTalk ()
                saidText.text="C'est un voyage \ntres dangereux!"
            elseif storyPhase == 4 then
                dadTalk ()
                saidText.text="J'ai faillit mourrir \nnoyé par une vague geante"
                saidText.x,saidText.y = 440,208
            elseif storyPhase == 5 then
                fifiTalk()
                saidText.text="Avec moi cette vague ne nous\nrattrapera jamais!"
            elseif storyPhase == 6 then
                dadTalk ()
                saidText.text="D'accord, d'accord\nMais ne touche a rien\nsur le bateau!"
            elseif storyPhase == 5 then
                fifiTalk()
                saidText.text="Je te promets riem\n ALLONS-Y!"
            elseif storyPhase == 7 then
                philacter.isVisible = false
                saidText.isVisible = false
                Runtime:removeEventListener("tap", tapStory)
                transition.to( captainDad, {time=1200,x=1300})
                transition.to( fifi, {time=800,x=1300, onComplete = function ()
                    local options =
                    {
                        effect = "fade",
                        time = 1000
                    }
                    composer.gotoScene( "scene.game", options )
                end})
            end

            --if event.isPrimaryButtonDown then
            --   print( "CLICK: ".. tostring(math.round(event.x)) .. "," .. tostring(math.round(event.y)) )
            --end
            storyPhase = storyPhase + 1
            return true
        end
        --------------------------------------------------------------
        transition.to(fifi,{time=800,x=554, onComplete = function ()
        Runtime:addEventListener("tap", tapStory)
        fifi:setSequence("stand")
        fifi:play()

        local function onTapSkip ( )
            btSkip:removeEventListener("tap", onTapSkip )
            transition.to(btSkip, {xScale = 1.4, yScale = 1.4, time=200, transition= easing.continuousLoop})
            storyPhase = 7
            tapStory()

            return true

        end
        btSkip:addEventListener("tap", onTapSkip )

      end})

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

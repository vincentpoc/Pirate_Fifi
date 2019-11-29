local composer = require ("composer")
local scene    = composer.newScene ()

local fifi 
local captainDad
local philacter
local saidText
----------------------------------------------------------------------------------------- create()
function scene:create (event)

    local sceneGroup = self.view
    local bgSet = display.newImageRect(sceneGroup,"assets/house.png",1334,750)
    bgSet.x,bgSet.y = fCenterX,fCenterY

    local fifiSheepOptions =
	{
		numFrames =3,
		width = 160, height = 256,
		sheetContentWidth = 480,sheetContentHeight = 256
	}
	local fifiSheet = graphics.newImageSheet( "assets/fifi.png", fifiSheepOptions )
	fifi = display.newSprite(sceneGroup, fifiSheet, {name="fifi", start=1, count=fifiSheepOptions.numFrames} )
	fifi:setFrame(1)
    fifi.anchorX, fifi.anchorY = 0.5,1
    fifi.xScale, fifi.yScale = 0.8,0.8
    fifi.x, fifi.y = 1100,604
    -------------------------------------------------
    
	local captainDadSheepOptions =
	{
		numFrames =2,
		width = 256, height = 377,
		sheetContentWidth = 512,sheetContentHeight = 377
	}
	local captainDadSheet = graphics.newImageSheet( "assets/king.png", captainDadSheepOptions )
	captainDad = display.newSprite(sceneGroup, captainDadSheet, {name="fifi", start=1, count=captainDadSheepOptions.numFrames} )
	captainDad:setFrame(1)
    captainDad.anchorX, captainDad.anchorY = 0.5,1.0
    captainDad.x, captainDad.y = 238,612
    captainDad.xScale,captainDad.yScale = -0.75,0.75
    -------------------------------------------------
    philacter = display.newImageRect(sceneGroup,"assets/philacter.png",650 ,256)
    philacter.anchorX, philacter.anchorY = 0,0
    philacter.isVisible = false
    -------------------------------------------------
    saidText = display.newText(sceneGroup,"", 500, 250, "Comic Sans MS", 40)
    saidText:setFillColor(0,0,0)
    saidText.isVisible = false

end

----------------------------------------------------------------------------------------- show()
function scene:show (event)

	local sceneGroup = self.view
	local phase      = event.phase

	if (phase == "will") then
	-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif (phase == "did") then
        local storyPhase = 0
        function fifiTalk ()
            philacter.xScale = -1
            philacter.x, philacter.y = 950, 150
            saidText.x,saidText.y = 600, 250
        end
    
        function dadTalk ()
            captainDad.xScale = 0.75
            philacter.xScale = 1
            philacter.x, philacter.y = 100, 100
            saidText.x,saidText.y = 340,208
        end
    
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
                captainDad:setFrame(2)
                transition.to(captainDad, {y = captainDad_yPos - 100, time=100, transition= easing.outSine})
                transition.to(captainDad, {y = captainDad_yPos, time=150, delay=200, transition= easing.inSine})
                timer.performWithDelay( 250, function () captainDad:setFrame(1) end)
                dadTalk ()
                saidText.text="AAAH! Oui, Fifi \nQu'y a-t-il?"
                saidText.size = 40
            elseif storyPhase == 2 then
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
                saidText.text="D'accord, d'accord\nMais ne touche a rien\ndans le bateau!"
            elseif storyPhase == 5 then
                fifiTalk()
                saidText.text="Je te promets riem\n ALLONS-Y!"
            elseif storyPhase == 7 then
                philacter.isVisible = false
                saidText.isVisible = false
                Runtime:removeEventListener("tap", tapStory)
                transition.to( captainDad, {time=800,x=1100})
                transition.to( fifi, {time=400,x=1100, onComplete = function ()
                    local options =
                    {
                        effect = "fade",
                        time = 1000
                    }
                    composer.gotoScene( "scene.game", options )
                end})
            end
    
            --if event.isPrimaryButtonDown then
               print( "CLICK: ".. tostring(math.round(event.x)) .. "," .. tostring(math.round(event.y)) )
            --end
            storyPhase = storyPhase + 1
            return true
        end
    
        transition.to(fifi,{time=400,x=754, onComplete = function ()
        Runtime:addEventListener("tap", tapStory)
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

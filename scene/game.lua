------------------------------------------- MAIN GAME ------------------------------------------------
local composer = require ("composer")
local scene    = composer.newScene ()
local sceneGroup
---------------------------------------------------------------------------------------------------
local avariPick = 0
local level = 1
local waveLevel = 0
local levelProgression
local AvariState = {}
local captainDad
local swapStageOnTap
local swapStageState
local fifi
local fifiMove
local wave
local gameStage = display.newGroup()
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
local function increaseLevel ()
	print("------------ LEVEL: "..tostring(level).."/"..tostring(waveLevel).."------------------------")

	local avariCount = 0
	local shipSpeed = 0.3

	for i=#AvariState, 1, -1 do
		local vLife = AvariState[i].life
		local vObject = AvariState[i].object
		if vLife > 0 and vLife < gameCriticMaxLevel then ---if avari active ncreased avari state
			AvariState[i].life = AvariState[i].life + 0.5
			avariCount = avariCount + 1
			--print("increase avari: "..tostring(vLife))
		elseif vLife <= 0 and vLife > -1 then -- if avari fixed start cooldown
			AvariState[i].life = - 1
			--print("cooldown: "..tostring(vLife))
		elseif vLife <= -1 then --end of the cooldown fixed state
			if avariPick == i then
				--print("New avari: "..tostring(vLife))
				AvariState[i].life = 4 --set a new avari
			else
				--print("wait for pick: "..tostring(vLife))
				AvariState[i].life = -1 --hide fixed icon
			end
		end
		------

		if vLife >= gameCriticLevel then --warning
			transition.to(vObject, {xScale = 1.2, yScale = 1.2, time=150, transition= easing.continuousLoop})
			if vLife >= gameCriticMaxLevel then
				transition.to(vObject, {xScale = 1.2, yScale = 1.2, time=150, delay=150, transition= easing.continuousLoop})
			end
			if shipSpeed > 0 then shipSpeed = shipSpeed - 0.1 end
		end
		vObject:avariUpdate()
	end
	------------------------------------------------
	if (avariCount) < level then
		avariPick = math.floor( math.random(1, #AvariState) )
		print("avariPick: "..tostring(avariPick))
	else
		print("avariCount: " .. tostring(avariCount))
	end

	if shipSpeed > 0 then
		level = level + shipSpeed
		transition.to( levelProgression, {time=gameSpeed, x=50 + (100 * level) } )
	else
		transition.to(levelProgression, {xScale = 1.5, yScale = 1.5, time=100, delay=50, transition= easing.continuousLoop, iterations=2})
	end

	waveLevel = waveLevel + 0.15
	transition.to(wave,{time=gameSpeed, x=50 + (100 * waveLevel)})

	--------------------------------------------------------GAME OVER --------------------------
	local function resetGame ()
		level = 1
		waveLevel = 0
		wave.x,levelProgression.x = 0,0
		for i=#AvariState, 1, -1 do
			AvariState[i].life = -1
			AvariState[i].object:avariUpdate()
		end
	end

	if waveLevel > level then --LOSE CONDITION

		timer.cancel(gameloop)
		local swapDelay = 0
		if not(fifiMove == nil) then transition.cancel(fifiMove) end --stop animation
		if swapStageState == "DOWN" then
			swapStageOnTap ()
			swapDelay = 1000
		end

		local rollingWaveA = display.newImageRect("assets_qrb/rollingwave.png",425,650)
		rollingWaveA.x,rollingWaveA.y = -300, fCenterY
		local rollingWaveB = display.newImageRect("assets_qrb/rollingwave.png",425,650)
		rollingWaveB.x,rollingWaveB.y = -300,fCenterY
		gameStage:insert(rollingWaveA)
		gameStage:insert(rollingWaveB)

		captainDad:setSequence("jump")
		captainDad:play()
		timer.performWithDelay(swapDelay, function()

			transition.to(captainDad,{delay= 250, time=2000, rotation = 360,x=1380 })
			transition.to(fifi,{delay=500, time=2000, rotation = 360,x=1380})
			transition.to(rollingWaveA,{delay=10, time=2000, x = 1380})
			transition.to(rollingWaveB,
			{
				delay= 200, time=2000, x = 1380,
				onComplete = function ()
					resetGame()
					local options =
					{
						effect = "fade",
						time = 400
					}
					composer.gotoScene ("scene.gameover")
				end
			})

		end)

	elseif level > 10 then --WIN CONDITION

		timer.cancel(gameloop)
		if not(fifiMove == nil) then transition.cancel(fifiMove) end --stop animation

		transition.to(captainDad,{delay= 500, time=2000,x=1380 })
		transition.to(fifi,
		{
			delay=250, time=2000,x=1380,
			onComplete = function ()
				resetGame()
				local options =
				{
					effect = "fade",
					time = 400
				}
				composer.gotoScene ("scene.gamewin")
			end

		})
	end
end
-------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------- create()

function scene:create (event)

	sceneGroup = self.view
	gameStage = display.newGroup()
	-------------------------------------------------------------------------------------------------------------
	local function spawnAvari (id,px,py,isRope)

		AvariState[id] = {life = -1, object}
		local rope
		if isRope then
			-------------------------------- ROPE -----------------------------------------------
			local ropeSheepOptions = {
				width = 236,
				height = 430,
				numFrames = 3,
				sheetContentWidth = 708,
				sheetContentHeight = 430
			}
			local ropeAnchor = display.newImageRect("assets/rope_anchor.png",128,128)
			ropeAnchor.x, ropeAnchor.y = px-10, py-10
			local ropeSheet = graphics.newImageSheet( "assets/rope_state.png", ropeSheepOptions )
			rope = display.newSprite(ropeSheet, {name="rope", start=1, count=ropeSheepOptions.numFrames} )
			rope:setFrame(1)
			rope.anchorX, rope.anchorY = 1, 1
			rope.yScale = 1.25
			rope.x, rope.y = px, py
			gameStage:insert(ropeAnchor)
			gameStage:insert(rope)
		else
			local planks = display.newImageRect("assets/planks.png",128,128)
			planks.x, planks.y = px,py
			planks.rotation = math.random(0, 360)
			gameStage:insert(planks)
		end
		-------------------- ICON ---------------------------------
		local iconSheepOptions =
		{
			width = 128,
			height = 128,
			numFrames =3,
			sheetContentWidth = 384,
			sheetContentHeight = 128
		}
		local iconSheet = graphics.newImageSheet( "assets/avari_icon.png", iconSheepOptions )
		local buttonAvari = display.newSprite( iconSheet, {name="icon", start=1, count=iconSheepOptions.numFrames} )
		buttonAvari:setFrame(2)
		buttonAvari.isVisible  = false
		buttonAvari.x, buttonAvari.y = px, py
		gameStage:insert(buttonAvari)
		AvariState[id].object = buttonAvari
		---------------------------------------------------------------------------------------------------------------
		------------------ EVENT --------------------------------------------------------------------------------------
		function buttonAvari:avariUpdate ()
			local vLife = AvariState[id].life
			if vLife >= gameCriticLevel then
				buttonAvari:setFrame(3)
			elseif vLife > 0 then
				buttonAvari:setFrame(2)
			elseif vLife <= 0 then
				buttonAvari:setFrame(1)
			end
			----
			if isRope then
				if vLife >= gameCriticLevel - 2 then
					rope:setFrame(3)
				elseif vLife > 2 then
					rope:setFrame(2)
				elseif vLife <= 0 then
					rope:setFrame(1)
				end
			end
			----
			if vLife > -1 then buttonAvari.isVisible = true else buttonAvari.isVisible = false end
		end
		--------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------
		function avariOnTap (event)

			local vLife = math.floor(AvariState[id].life)
			if vLife >= 0 then
				if not(fifiMove == nil) then
					fifi:setSequence("walk")
					transition.cancel(fifiMove)
				else
					fifi:setSequence("stand")
				end
				-----
				local ropeOffset
				if isRope then
					ropeOffset = 50
					fifiMove = transition.to(fifi,
					{	time=500, x=buttonAvari.x - 50, y=buttonAvari.y + 50,
						transition= easing.intSine,
						onComplete = function ()
							fifi:setSequence("stand")
							fifi:play()
						end
					})
				else
					ropeOffset = 0
					fifiMove = transition.to(fifi,
					{
						time=500, x=buttonAvari.x, transition= easing.intSine,
						onComplete = function ()
							fifi:setSequence("stand")
							fifi:play()
						end
					})
				end
				print(tostring(math.floor((fifi.x + 50) * 0.01)) .." / ".. tostring(math.floor(buttonAvari.x * 0.01)))
				if (buttonAvari.x - fifi.x) > 0 then
					fifi.xScale = 0.8
				else
					fifi.xScale = -0.8
				end
				if math.floor((fifi.x + ropeOffset) * 0.01) == math.floor(buttonAvari.x * 0.01) then
					AvariState[id].life = AvariState[id].life - 1
					transition.to(buttonAvari, {xScale = 1.3, yScale = 1.3, time=100, transition= easing.continuousLoop})
					fifi.xScale = 0.8
					fifi:setSequence("fix")
					timer.performWithDelay(300,function ()
						fifi:setSequence("stand")
					end )
					buttonAvari:avariUpdate()
				else
					print("out of range")
				end
				fifi:play()
			end
			return true
		end
		-----------------------------------------------------------------------------------------------------------------------
		buttonAvari:addEventListener ("tap", avariOnTap)
	end
	----------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------
	local bgShip = display.newImageRect("assets_qrb/ship_deck.png", 1152, 1280)
    bgShip.anchorX, bgShip.anchorY = 0.5, 0.25
	bgShip.x, bgShip.y = fCenterX, fCenterY
	gameStage:insert(bgShip)
	-------------------------------------------------
	spawnAvari(5, 74,290+640, false)
	spawnAvari(6, 296,290+640, false)
	spawnAvari(7, 554,290+640, false)
	spawnAvari(8, 736,290+640, false)
	-------------------------------------------------
	spawnAvari(1,793, 343,true)
	spawnAvari(2,975, 423,true)
	-------------------------------------------------
	local fifiSheet = graphics.newImageSheet( "assets_qrb/fifi.png", fifiSheepOptions )
	fifi = display.newSprite(sceneGroup, fifiSheet, fifiSqData )
    fifi:setSequence("walk")
    fifi:play()
    fifi.anchorX, fifi.anchorY = 0.5,1
    fifi.xScale, fifi.yScale = 0.8,0.8
    fifi.x, fifi.y = 1200,504
	gameStage:insert(fifi)
	-------------------------------------------------
	-------------------------------------------------
    local captainDadSheet = graphics.newImageSheet( "assets_qrb/pirate_dad.png", captainDadSheepOptions )
	captainDad = display.newSprite(sceneGroup, captainDadSheet, captainDadSqData )
    captainDad:setSequence("stand")
    captainDad:play()
    captainDad.anchorX, captainDad.anchorY = 0.5,1.0
    captainDad.x, captainDad.y = 110,460
    --captainDad.xScale,captainDad.yScale = 0.75,0.75
	gameStage:insert(captainDad)
	-------------------------------------------------
    local shipWheel = display.newImageRect("assets/wheel.png",128,256)
    shipWheel.anchorX, shipWheel.anchorY = 0.5,1.0
    shipWheel.x,shipWheel.y = 232,488
	gameStage:insert(shipWheel)
	-------------------------------------------------
	spawnAvari(3,632,517,true)
	spawnAvari(4,365,492,true)

	-------------------------------------------------
	local UI = display.newGroup()

	local journeyIcon = display.newRect(15,70,1050,8)
	journeyIcon.anchorX = 0
	journeyIcon:setFillColor(0.1,0.5,1)
	UI:insert(journeyIcon)
	-------------------------------------------------
	local islandIcon = display.newImageRect("assets_qrb/island_icon.png",64,68)
	islandIcon.x,islandIcon.y = 1070, 40
	UI:insert(islandIcon)
	-------------------------------------------------
	levelProgression = display.newImageRect("assets/ship_icon.png",64,64)
	levelProgression.x, levelProgression.y = 0,40
	UI:insert(levelProgression)
	----------------------------------------------
	wave = display.newImageRect("assets_qrb/rollingwave_icon.png",42,64)
	wave.x,wave.y = -100, 40
	UI:insert(wave)
	-------------------------------------------------
 	local debugWaveA = display.newRect(10,600,50,50)
	 UI:insert(debugWaveA)
	 local function waveBoost ()
	 	waveLevel = level + 4
	 end
	 debugWaveA:addEventListener("tap", waveBoost)
	-------------------------------------------------
	local swapStage = display.newImageRect(sceneGroup,"assets/arrow.png", 128, 128)
	swapStage.x, swapStage.y = 50, 100
	UI:insert(swapStage)
	swapStageState = "UP"

	function swapStageOnTap ()
		--print(swapStageState)

		if swapStageState == "UP" then
			transition.to( swapStage, {time=400, rotation = 180, transition=easing.inOutElastic, onComplete = swapTransition})
			transition.to( gameStage, {time=400, y=-640})
			timer.performWithDelay(400,function ()
				fifi.x,fifi.y = 1100,1000
				fifi:setSequence("walk")
      			fifi:play()
				transition.to( fifi, {time = 500, x=852, y=1144, onComplete = function()
					fifi:setSequence("stand")
      				fifi:play()
				end})
			end)
			swapStageState = "goingDown"

		elseif swapStageState == "DOWN" then
			transition.to( swapStage, {time=400,rotation = 0, transition=easing.inOutElastic,  onComplete = swapTransition})
			transition.to( gameStage, {time=400,y=0})
			timer.performWithDelay(400,function ()
				fifi.x, fifi.y = 1100,504
				fifi:setSequence("walk")
				fifi:play()
				transition.to( fifi, {time = 500, x=752, y=504, onComplete = function()
					fifi:setSequence("stand")
      				fifi:play()
				end} )
			end)
			swapStageState = "goingUp"
		end
	end

	function swapTransition ()
		if swapStageState == "goingDown" then
			swapStageState = "DOWN"
		elseif swapStageState == "goingUp" then
			swapStageState = "UP"
		end
	end

	swapStage:addEventListener("tap", swapStageOnTap)

	------------------------------------------
	sceneGroup:insert(gameStage)
	sceneGroup:insert(UI)
	--gameStage.xScale, gameStage.yScale = 0.85, 0.85
	--gameStage.x, gameStage.y = 0,100
end
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
function scene:show (event)

	local sceneGroup = self.view
	local tapTutorial

	fifi.x, fifi.y = 1200,504
	captainDad.x, captainDad.y = 110,460
	captainDad:setSequence("stand")
	captainDad:play()

	fifi.rotation = 0
	captainDad.rotation = 0

	function tutorialRope ()
		if AvariState[1].life <= 0 then
			AvariState[1].life = -1
			AvariState[1].object:avariUpdate()
			gameloop = timer.performWithDelay( gameSpeed, increaseLevel,0)
			philacter.isVisible = false
			saidText.isVisible = false
		else
			timer.performWithDelay(gameSpeed * 0.5, tutorialRope)
		end
	end

	if (event.phase == "did") then

		-------------------------------------------------
		philacter = display.newImageRect(sceneGroup,"assets/philacter.png",650 ,256)
		philacter.anchorX, philacter.anchorY = 0,0

		-------------------------------------------------
		saidText = display.newText(sceneGroup,"", 500, 250, "Comic Sans MS", 30)
		saidText:setFillColor(0,0,0)
		philacter.x, philacter.y = 50,0
		saidText.x,saidText.y = 350, 100
		saidText.text = "AAAAH!\nLa vague est juste derriere nous!"
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

		fifi:setSequence("walk")
		fifi:play()

		local tapTutoPhase = 0
		function tapTutorial ()

			if tapTutoPhase == 0 then
				saidText.text = "S'il y a trop d'avari\n sur le bateau"
			elseif tapTutoPhase == 1 then
				saidText.text = "Le bateau s'arretera\net la vague nous rattrapera"
			elseif tapTutoPhase == 2 then
				saidText.text = "Heureusement je suis un loup de mer\nJe connais tous les noeuds marin"

			elseif tapTutoPhase == 3 then
				Runtime:removeEventListener("tap", tapStory)
				AvariState[1].life = 2
				AvariState[1].object:avariUpdate()
				philacter.isVisible = false
				saidText.isVisible = false
				timer.performWithDelay(500, function()
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
				end)
				timer.performWithDelay(1000, function()
					philacter.isVisible = true
					saidText.isVisible = true
					saidText.text = "Sauf celui-ci ..."
				end)
				timer.performWithDelay(2000, function()
					saidText.text = "Est-ce que tu pourrais refaire\nce noeud?"
					timer.performWithDelay(gameSpeed * 0.5, tutorialRope)
				end)
				timer.performWithDelay(4000, function()
					philacter.isVisible = false
					saidText.isVisible = false
				end)
			end
			tapTutoPhase = tapTutoPhase + 1

		end
		Runtime:addEventListener("tap", tapTutorial)
		-------------------------------------------------
		fifiMove = transition.to(fifi, {time=800, x=432, y=504, transition= easing.intSine,
			onComplete=function ()
				fifi:setSequence("stand")
				fifi:play()
			end})

		--
	end
end
-------------------------------------------------------------------------------------
-- Scene event function listeners
-------------------------------------------------------------------------------------
scene:addEventListener ("create", scene)
scene:addEventListener ("show", scene)
-------------------------------------------------------------------------------------
return scene

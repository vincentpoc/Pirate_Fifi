------------------------------------------- MAIN GAME ------------------------------------------------
local composer = require ("composer")
local scene    = composer.newScene ()
local sceneGroup
---------------------------------------------------------------------------------------------------
local avariPick = 0
local level = 0
local levelProgression
local AvariState = {}
local shipSpeed = 0.3
local shipDeckDamage = 0
local shipDeckDamageDebug
local captainDad
local fifi
local fifiMove
local gameStage = display.newGroup()
-------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------
local function increaseLevel ()
	print("------------ LEVEL: "..tostring(level).."------------------------")

	local avariCount = 0
	for i=#AvariState, 1, -1 do
		local vLife = AvariState[i].life
		local vObject = AvariState[i].object
		if vLife > 0 and vLife < gameCriticMaxLevel then ---if avari active ncreased avari state
			AvariState[i].life = AvariState[i].life + 1
			avariCount = avariCount + 1
			print("increase avari: "..tostring(vLife))
		elseif vLife <= 0 and vLife > -1 then -- if avari fixed start cooldown
			AvariState[i].life = - 1
			print("cooldown: "..tostring(vLife))
		elseif vLife <= -1 then --end of the cooldown fixed state
			if avariPick == i then
				print("New avari: "..tostring(vLife))
				AvariState[i].life = 2 --set a new avari
			else
				print("wait for pick: "..tostring(vLife))
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
		if level < 10 then level = level + shipSpeed end
		transition.to( levelProgression, {time=gameSpeed, x=50 + (100 * level) } )
	else
		transition.to(levelProgression, {xScale = 1.5, yScale = 1.5, time=100, delay=50, transition= easing.continuousLoop, iterations=2})
	end
end
-------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------- create()

function scene:create (event)

	sceneGroup = self.view
	-------------------------------------------------------------------------------------------------------------
	local function spawnAvari (id)

		AvariState[id] = {life = -1, object}
		local ropePos = {{793,343},{975, 423},{632,517},{265,492}}
		-------------------------------- ROPE -----------------------------------------------
		local ropeSheepOptions = {
	        width = 236,
	        height = 430,
	        numFrames = 3,
	        sheetContentWidth = 708,
	        sheetContentHeight = 430
	    }
        local ropeAnchor = display.newImageRect("assets/rope_anchor.png",128,128)
        ropeAnchor.x, ropeAnchor.y = ropePos[id][1]-10, ropePos[id][2]-10
        local ropeSheet = graphics.newImageSheet( "assets/rope_state.png", ropeSheepOptions )
        local rope = display.newSprite(ropeSheet, {name="rope", start=1, count=ropeSheepOptions.numFrames} )
        rope:setFrame(1)
        rope.anchorX, rope.anchorY = 1, 1
        rope.yScale = 1.25
        rope.x, rope.y = ropePos[id][1], ropePos[id][2]
		gameStage:insert(ropeAnchor)
		gameStage:insert(rope)
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
		buttonAvari.x, buttonAvari.y = ropePos[id][1], ropePos[id][2]
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
			if vLife >= gameCriticLevel - 2 then
				rope:setFrame(3)
			elseif vLife > 2 then
				rope:setFrame(2)
			elseif vLife <= 0 then
				rope:setFrame(1)
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
					fifi:setFrame(2)
					transition.cancel(fifiMove)
				else
					fifi:setFrame(1)
				end
				fifiMove = transition.to(fifi, {time=500, x=buttonAvari.x - 50, y=buttonAvari.y + 50, transition= easing.intSine})
				--print(tostring(math.floor((fifi.x + 50) * 0.01)) .." / ".. tostring(math.floor(buttonAvari.x * 0.01)))
				if (buttonAvari.x - fifi.x) > 0 then
					fifi.xScale = 0.8
				else
					fifi.xScale = -0.8
				end
				if math.floor((fifi.x + 50) * 0.01) == math.floor(buttonAvari.x * 0.01) then
					AvariState[id].life = AvariState[id].life - 1
					transition.to(buttonAvari, {xScale = 1.2, yScale = 1.2, time=100, transition= easing.continuousLoop})
					fifi.xScale = 0.8
					fifi:setFrame(3)
					timer.performWithDelay(300,function () fifi:setFrame(1) end )
					buttonAvari:avariUpdate()
				else
					print("out of range")
				end
			end
			return true
		end
		-----------------------------------------------------------------------------------------------------------------------
		buttonAvari:addEventListener ("tap", avariOnTap)
	end
	----------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------
	local bgShip = display.newImageRect("assets/ship_deck_bg.png", 1152, 1280)
    bgShip.anchorX, bgShip.anchorY = 0.5, 0.25
    bgShip.x, bgShip.y = fCenterX, fCenterY
	gameStage:insert(bgShip)
	-------------------------------------------------
	spawnAvari(1)
	spawnAvari(2)
	-------------------------------------------------
	local fifiSheepOptions =
	{
		numFrames =3,
		width = 160, height = 256,
		sheetContentWidth = 480,sheetContentHeight = 256
	}
	local fifiSheet = graphics.newImageSheet( "assets/fifi.png", fifiSheepOptions )
	fifi = display.newSprite( fifiSheet, {name="fifi", start=1, count=fifiSheepOptions.numFrames} )
	fifi:setFrame(1)
    fifi.anchorX, fifi.anchorY = 0.5,1
    fifi.xScale, fifi.yScale = 0.8,0.8
    fifi.x, fifi.y = 752,504
	gameStage:insert(fifi)
	-------------------------------------------------
	local captainDadSheepOptions =
	{
		numFrames =2,
		width = 256, height = 377,
		sheetContentWidth = 512,sheetContentHeight = 377
	}
	local captainDadSheet = graphics.newImageSheet( "assets/king.png", captainDadSheepOptions )
	captainDad = display.newSprite( captainDadSheet, {name="fifi", start=1, count=captainDadSheepOptions.numFrames} )
	captainDad:setFrame(1)
    captainDad.anchorX, captainDad.anchorY = 1.0,1.0
    captainDad.x, captainDad.y = 110,460
    captainDad.xScale,captainDad.yScale = 0.75,0.75
	gameStage:insert(captainDad)
	-------------------------------------------------
    local shipWheel = display.newImageRect("assets/wheel.png",128,256)
    shipWheel.anchorX, shipWheel.anchorY = 0.5,1.0
    shipWheel.x,shipWheel.y = 102,488
	gameStage:insert(shipWheel)
	-------------------------------------------------
	spawnAvari(3)
	spawnAvari(4)
	-------------------------------------------------need to display the wave
	local UI = display.newGroup()
	levelProgression = display.newCircle(sceneGroup,50,50,10)
	levelProgression:setFillColor(1,0,0)
	UI:insert(levelProgression)
	-------------------------------------------------
	local swapStage = display.newImageRect(sceneGroup,"assets/arrow.png", 128, 128)
	swapStage.x, swapStage.y = 0, 100
	UI:insert(swapStage)
	function swapStageOnTap ()
		if (math.round(gameStage.y)) == 0 then
			transition.to( swapStage, {time=500, rotation = 180, transition=easing.inOutElastic})
			transition.to( gameStage, {time=500, y=-650})
		else
			transition.to( swapStage, {time=500,rotation = 0, transition=easing.inOutElastic})
			transition.to( gameStage, {time=500,y=0})
		end
		--, onComplete= function () swapStage:addEventListener("tap", swapStageOnTap) end
		--swapStage:removeEventListener("tap",swapStageOnTap)
	end
	swapStage:addEventListener("tap", swapStageOnTap)

	------------------------------------------
	sceneGroup:insert(gameStage)
	sceneGroup:insert(UI)
end
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
function tutorialRope ()
	if AvariState[1].life <= 0 then
		AvariState[1].life = -1
		AvariState[1].object:avariUpdate()
		--dady jump
		local captainDad_yPos = captainDad.y
		captainDad:setFrame(2)
		transition.to(captainDad, {y = captainDad_yPos - 150, time=100, transition= easing.outSine})
		transition.to(captainDad, {y = captainDad_yPos, time=150, delay=200, transition= easing.inSine})
		captainDad:setFrame(1)
		timer.performWithDelay( gameSpeed, increaseLevel,0)
	else
		timer.performWithDelay(gameSpeed * 0.5, tutorialRope)
	end
end
function tutoCaptainSay ()
	local philacter = display.newImageRect("philacter.png")
end
-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------
function scene:show (event)
	local sceneGroup = self.view
	if (event.phase == "did") then
		AvariState[1].life = 2

		fifiMove = transition.to(fifi, {time=500, x=352, y=504, transition= easing.intSine})
		timer.performWithDelay(1000, function()
			AvariState[1].object:avariUpdate()
			timer.performWithDelay(gameSpeed * 0.5, tutorialRope)
		 end)
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

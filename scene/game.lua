------------------------------------------- MAIN GAME ------------------------------------------------
local composer = require ("composer")
local scene    = composer.newScene ()
local sceneGroup
---------------------------------------------------------------------------------------------------
local level = 0
local levelProgression
local AvariState = {}
local shipDeckDamage = 0
local shipDeckDamageDebug

---------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------- create()
function scene:create (event)

	sceneGroup = self.view
	avariPick = 0
	--------------------------------------------------------------------------------
	local function increaseLevel ()

		if level < 10 then level = level + shipSpeed end
		print("------------ LEVEL: "..tostring(level).."------------------------")
		transition.to( levelProgression, {time=gameSpeed, x=50 + (100 * level) } )
		--transition.to( shipSpeed, {time=gameSpeed, x=50 + (100 * level) } )

		local avariCount = 0
		for i=#AvariState, 1, -1 do
			local vLife = AvariState[i].life
			local vObject = AvariState[i].object
			if vLife > 0 and vLife < gameCriticMaxLevel then ---if avari active ncreased avari state
				AvariState[i].life = AvariState[i].life + 1
				avariCount = avariCount + 1
				print("increase avari: "..tostring(vLife))
			elseif vLife <= 0 and vLife > -1 then -- if avari fixed start cooldown
				AvariState[i].life = AvariState[i].life - 0.5
				vObject.alpha = 1 - vLife
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
				transition.to(vObject, {xScale = 1.2, yScale = 1.2, time=50, delay=0})
				transition.to(vObject, {xScale = 1.0, yScale = 1.0, time=50, delay=100})
				if vLife >= gameCriticMaxLevel then
					transition.to(vObject, {xScale = 1.2, yScale = 1.2, time=50, delay=200})
					transition.to(vObject, {xScale = 1.0, yScale = 1.0, time=50, delay=300})
				end
				if shipSpeed > 0 then shipSpeed = shipSpeed - 0.05 end
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
	end
	-----------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------
	-----------------------------------------------------------------------------------------
	local function spawnAvari (px, py, id)

		AvariState[id] = {life = -1, object}

		-------------------- ASSET ---------------------------------
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
		--------------------------------------------------------------
		local textAvari   = display.newText (tostring (AvariState[id].life) .. " Fixs", 0, 50, "Arial", 16)
		--------------------- GROUP --------------------------------
		local groupAvari = display.newGroup ()
		groupAvari:insert(buttonAvari)
		groupAvari:insert(textAvari)
		groupAvari.isVisible  = false
		groupAvari.x, groupAvari.y = px, py
		AvariState[id].object = groupAvari

		---------------------------------------------------------------------------------------------------------------
		------------------ EVENT -------------------------------------
		function groupAvari:avariUpdate ()
			local vLife = AvariState[id].life
			if vLife >= gameCriticLevel then
				textAvari.text = tostring (vLife) .. " !!!!"
				buttonAvari:setFrame(3)
			elseif vLife > 0 then
				textAvari.text = tostring (vLife) .. " Fixs"
				buttonAvari:setFrame(2)
			elseif vLife <= 0 then
				textAvari.text = "FIXED"
				buttonAvari:setFrame(1)
			end
			if vLife > -1 then groupAvari.isVisible = true else groupAvari.isVisible = false end
		end
		--------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------
		function avariOnTap (event)
			local vLife = math.floor(AvariState[id].life)
			if vLife >= 0 then
				AvariState[id].life = AvariState[id].life - 1
				transition.to(groupAvari, {xScale = 1.2, yScale = 1.2, time=25, delay=0})
				transition.to(groupAvari, {xScale = 1, yScale = 1, time=25, delay=50})
				groupAvari:avariUpdate()
			end
			return true
		end
		-----------------------------------------------------------------------------------------------------------------------
		sceneGroup:insert(groupAvari) --Staging
		buttonAvari:addEventListener ("tap", avariOnTap)
	end
	----------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------------------------------
	bgShip = display.newImageRect(sceneGroup, "assets/ship_deck_bg.png", 960, 640)
	bgShip.x, bgShip.y = fCenterX, fCenterY

	----- AVARI BUTTON--------
	spawnAvari(150,400,1)
	spawnAvari(380,600,2)
	spawnAvari(890,450,3)
	spawnAvari(650,380,4)

	-----ROPE FG---------
	local ropeSheepOptions =
	{
		width = 256,
		height = 320,
		numFrames = 2,
		sheetContentWidth = 512,
		sheetContentHeight = 320
	}
	for i,v in ipairs({{-100, 0},{fWidth - 150, 0}}) do --place FG element
		local ropeSheet = graphics.newImageSheet( "assets/ship_deck_fg.png", ropeSheepOptions )
		local ropeFg = display.newSprite( sceneGroup, ropeSheet, {name="rope", start=1, count=ropeSheepOptions.numFrames} ) --Scene element
		ropeFg:setFrame(i)
		ropeFg.anchorX, ropeFg.anchorY = 0, 0
		ropeFg.x, ropeFg.y = v[1], v[2]
	end
	------------------------------need to be replace by wheel
	shipDeckDamageDebug = display.newRect(50, 100, 50, 25)
	shipDeckDamageDebug.anchorX = 0
	-------------------------------------------------need to display the wave
	levelProgression = display.newCircle(50,50,10)
	levelProgression:setFillColor(1,0,0)
	------------------------------------------
	timer.performWithDelay( gameSpeed, increaseLevel,0)

end

----------------------------------------------------------------------------------------- show()
function scene:show (event)

	local sceneGroup = self.view
	local phase      = event.phase

	if (phase == "will") then

	elseif (phase == "did") then

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

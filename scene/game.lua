------------------------------------------- MAIN GAME ------------------------------------------------
local composer = require ("composer")
local scene    = composer.newScene ()
local sceneGroup
---------------------------------------------------------------------------------------------------
local level = 0
local levelProgression
local avariTimer = {}
local AvariState = {}
local shipDeckDamage = 0
local shipDeckDamageDebug

---------------------------------------------------------------------------------------------------
local function spawnAvari (px, py, id)

	-------------------- ASSET ---------------------------------
	local iconSheepOptions = {
		width = 128,
		height = 128,
		numFrames =3,
		sheetContentWidth = 384,
		sheetContentHeight = 128
	}
	local iconSheet = graphics.newImageSheet( "assets/avari_icon.png", iconSheepOptions )
	local buttonAvari = display.newSprite( iconSheet, {name="icon", start=1, count=iconSheepOptions.numFrames} )
	buttonAvari:setFrame(2)

	AvariState[id] = {life = 2, object = buttonAvari, object}
	local textAvari   = display.newText (tostring (AvariState[id].life) .. " Fixs", 0, 50, "Arial", 16)
	--AvariState[id].info = textAvari
	--------------------- GROUP --------------------------------
	local groupAvari = display.newGroup ()
	groupAvari:insert(buttonAvari)
	groupAvari:insert(textAvari)
	sceneGroup:insert(groupAvari)
	groupAvari.x, groupAvari.y = px, py
	AvariState[id].object = groupAvari
	------------------ EVENT -------------------------------------
	function groupAvari:avariUpdate ()

		local vLife = AvariState[id].life

		if vLife >= gameCriticLevel then
			textAvari.text = tostring (AvariState[id].life) .. " !!!!"
			buttonAvari:setFrame(3)
		elseif vLife > 0 then
			textAvari.text = tostring (AvariState[id].life) .. " Fixs"
			buttonAvari:setFrame(2)
		elseif vLife <= 0 then
			textAvari.text = "FIXED"
			buttonAvari:setFrame(1)
		end
	end

	function avariFixOnTap (event)

		if not(AvariState[id].life == -1) then
			if AvariState[id].life > 0 then
				print(AvariState[id].life)
				AvariState[id].life = AvariState[id].life - 1
				if AvariState[id].life == 0 then
					AvariState[id].life  = -1
					local myTimer = timer.performWithDelay( math.random(1, 2) * 1000, function ()
							AvariState[id].life = 2 + math.floor(level)
							groupAvari.isVisible  = true
							groupAvari:avariUpdate()
						end )
					timer.performWithDelay( 500, function ()
							groupAvari.isVisible = false
						end )
				end
			end
		end

		groupAvari:avariUpdate()
		return true
	end

	buttonAvari:addEventListener ("tap", avariFixOnTap)
end
--------------------------------------------------------------------------------
local function increaseLevel ()

	transition.to( levelProgression, {time=1000, x=50 + (10 * level) } )
	if level < 10 then level = level + 0.1 end

	shipDeckDamageDebug.xScale = 1.0 + (shipDeckDamage * 0.1)

	for i=#AvariState, 1, -1 do
		AvariState[i].object:avariUpdate()
		local vLife = AvariState[i].life
		if vLife > gameCriticLevel then
			print("WARNING")
		end
		---Ship Dammage with max limit
		if vLife > 0 and vLife < gameCriticMaxLevel then
			AvariState[i].life = AvariState[i].life + 1
		end
	end


	--for i,v in ipairs(avariTimer) do
		--print("timer: " .. tostring(i)..":" .. tostring(v))
	--end
	--print("Level: "..tostring(level))

end
----------------------------------------------------------------------------------------- create()
function scene:create (event)

	sceneGroup = self.view

	bgShip = display.newImageRect(sceneGroup, "assets/ship_deck_bg.png", 960, 640)
	bgShip.x, bgShip.y = fCenterX, fCenterY

	----- AVARI BUTTON--------
	spawnAvari(150,400,1)
	spawnAvari(380,600,2)
	spawnAvari(890,450,3)
	spawnAvari(650,380,4)

	-----ROPE FG---------
	local ropeSheepOptions = {
		width = 256,
		height = 320,
		numFrames = 2,
		sheetContentWidth = 512,
		sheetContentHeight = 320
	}
	for i,v in ipairs({{-100, 0},{fWidth - 150, 0}}) do
		local ropeSheet = graphics.newImageSheet( "assets/ship_deck_fg.png", ropeSheepOptions )
		local ropeFg = display.newSprite( ropeSheet, {name="rope", start=1, count=ropeSheepOptions.numFrames} )
		ropeFg:setFrame(i)
		ropeFg.anchorX, ropeFg.anchorY = 0, 0
		ropeFg.x, ropeFg.y = v[1], v[2]
	end
	------------------------------
	shipDeckDamageDebug = display.newRect(50, 100, 50, 25)
	shipDeckDamageDebug.anchorX = 0
	levelProgression = display.newCircle(50,50,10)
	levelProgression:setFillColor(1,0,0)
	timer.performWithDelay( 1000, increaseLevel,0)

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

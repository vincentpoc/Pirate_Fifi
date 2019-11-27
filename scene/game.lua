------------------------------------------- MAIN GAME ------------------------------------------------
local composer = require ("composer")
local scene    = composer.newScene ()
local sceneGroup
---------------------------------------------------------------------------------------------------
local level = 0
local levelProgression
local avariTimer = {}
local AvariState = {}
---------------------------------------------------------------------------------------------------
local function spawnAvari (px, py, id)

	AvariState[id] = true
	local iFixCount = 2
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
	local textAvari   = display.newText (tostring (iFixCount) .. " Fixs", 0, 50, "Arial", 12)
	--buttonAvari:setFillColor (1, 0, 0)
	--------------------- GROUP --------------------------------
	local groupAvari = display.newGroup ()
	groupAvari:insert(buttonAvari)
	groupAvari:insert(textAvari)
	sceneGroup:insert(groupAvari)
	groupAvari.x, groupAvari.y = fCenterX + px, fCenterY + py
	------------------ EVENT -------------------------------------
	local function avariFixOnTap (event)
		if iFixCount > 0 then

			iFixCount      = iFixCount - 1
			textAvari.text = tostring (iFixCount) .. " Fixs"

		elseif AvariState[id] then

			buttonAvari:setFrame(1)
			textAvari.text = "FIXED"
			AvariState[id]  = false

			avariTimer[id] = timer.performWithDelay( math.random(1, 2) * 1000, function ()

					iFixCount = 2 + level
					buttonAvari:setFrame(2)
					textAvari.text = tostring (iFixCount) .. " Fixs"

					groupAvari.isVisible  = true
					AvariState[id] = true
					avariTimer[id] = nil
				end )

			timer.performWithDelay( 500, function ()
					groupAvari.isVisible = false
				end )

		end
		return true
	end

	buttonAvari:addEventListener ("tap", avariFixOnTap)
end
--------------------------------------------------------------------------------
local function increaseLevel ()

	level = level + 1

	transition.to(levelProgression, {time=6000, x=50 + (100 * level)})

	for i,v in ipairs(AvariState) do
		--print("State: " .. tostring(i).. ":" .. tostring(v))
	end
	for i,v in ipairs(avariTimer) do
		--print("timer: " .. tostring(i)..":" .. tostring(v))
	end
	print("Level: "..tostring(level))
	
end
----------------------------------------------------------------------------------------- create()
function scene:create (event)

	sceneGroup = self.view
	bgShip = display.newImageRect(sceneGroup, "assets/ship_deck_bg.png", 960, 640)
	bgShip.x, bgShip.y = fCenterX, fCenterY
	levelProgression = display.newCircle(100,50,10)
	levelProgression:setFillColor(1,0,0)
	timer.performWithDelay( 6000, increaseLevel,0)


	spawnAvari(-300,0,1)
	spawnAvari(0,0,2)
	spawnAvari(300,0,3)
	Runtime:addEventListener("mouse", placementHelper)
end

function placementHelper( event )
	print("CLICK: ".. tostring(event.x) .. "," .. tostring(event.y))
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

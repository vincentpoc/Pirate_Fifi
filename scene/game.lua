------------------------------------------- MAIN GAME ------------------------------------------------
local composer = require ("composer")
local scene    = composer.newScene ()
local sceneGroup
---------------------------------------------------------------------------------------------------
local level = 1
local avariTimer = {}
local AvariState = {}
---------------------------------------------------------------------------------------------------
local function spawnAvari (px, py, id)

	--local AvariState = true
	AvariState[id] = true
	local iFixCount = 2
	local r = 150
	--local px, py = math.random(r*-1, r), math.random(r*-1, r)
	-------------------- ASSET ---------------------------------
	local buttonAvari = display.newCircle (sceneGroup, 0, 0, 25)
	local textAvari   = display.newText (sceneGroup, tostring (iFixCount) .. " Fixs", 0, 0, "Arial", 12)
	buttonAvari:setFillColor (1, 0, 0)

	--------------------- GROUP --------------------------------
	local groupAvari = display.newGroup ()
	groupAvari:insert (buttonAvari)
	groupAvari:insert (textAvari)
	groupAvari.x, groupAvari.y = fCenterX+px, fCenterY+py

	------------------ EVENT -------------------------------------
	local function avariFixOnTap (event)
		if iFixCount > 0 then

			iFixCount      = iFixCount - 1
			textAvari.text = tostring (iFixCount) .. " Fixs"

		elseif AvariState[id] then

			buttonAvari:setFillColor (0, 1, 0)
			textAvari.text = "FIXED"
			AvariState[id]  = false

			avariTimer[id] = timer.performWithDelay( math.random(1, 2) * 1000, function ()

					buttonAvari:setFillColor (1, 0, 0)

					iFixCount = 2 + level
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
	textLevel.text = "Level: "..tostring(level)
	timer.performWithDelay( 6000, increaseLevel)
	for i,v in ipairs(AvariState) do
		print("State: " .. tostring(i).. ":" .. tostring(v))
	end
	print("-----")
	for i,v in ipairs(avariTimer) do
		print("timer: " .. tostring(i)..":" .. tostring(v))
	end
	print("----------------------------------")
end
----------------------------------------------------------------------------------------- create()
function scene:create (event)

	sceneGroup = self.view

	textLevel = display.newText(sceneGroup, "Level: "..tostring(level), 50 , 50, "Arial", 16)
	timer.performWithDelay( 6000, increaseLevel)

	spawnAvari(-105,0,1)
	spawnAvari(-35,0,2)
	spawnAvari(35,0,3)

	print( "A:".. tostring(AvariA) )

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

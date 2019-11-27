local composer = require ("composer")
local scene    = composer.newScene ()

----------------------------------------------------------------------------------------- create()
function scene:create (event)

  local sceneGroup = self.view
  local bgShip = display.newImageRect(sceneGroup, "assets/ship_deck_bg.png", 960, 640)
  bgShip.x, bgShip.y = fCenterX, fCenterY

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

  function placementHelper( event )
        if event.isPrimaryButtonDown then
  	       print( "CLICK: ".. tostring(math.round(event.x)) .. "," .. tostring(math.round(event.y)) )
        end
  end
  Runtime:addEventListener("mouse", placementHelper)
  local test = {}
  test[1]= {test = "bob"}
   test[1]= {super = "super"}
  print(test[1].super)
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

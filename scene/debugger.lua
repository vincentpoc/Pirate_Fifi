local composer = require ("composer")
local scene    = composer.newScene ()

----------------------------------------------------------------------------------------- create()
function scene:create (event)

  local sceneGroup = self.view
  local bgShip = display.newImageRect(sceneGroup, "assets/ship_deck_bg.png", 1152, 1280)
  bgShip.anchorX, bgShip.anchorY = 0.5, 0.25
  bgShip.x, bgShip.y = fCenterX, fCenterY

  local fifi = display.newImageRect("assets/fifi.png",160,256)
  fifi.anchorX, fifi.anchorY = 0.5,1
  fifi.xScale, fifi.yScale = 0.8,0.8
  fifi.x, fifi.y = 352,504
  local ropeSheepOptions = {
      width = 236,
      height = 430,
      numFrames = 3,
      sheetContentWidth = 708,
      sheetContentHeight = 430
  }
  for i,v in ipairs({{975, 423},{0793,343},{632,517},{265,492}}) do
      local ropeAnchor = display.newImageRect("assets/rope_anchor.png",128,128)
      ropeAnchor.x, ropeAnchor.y = v[1]-10, v[2]-10
      local ropeSheet = graphics.newImageSheet( "assets/rope_state.png", ropeSheepOptions )
      local rope = display.newSprite( ropeSheet, {name="rope", start=1, count=ropeSheepOptions.numFrames} )
      rope:setFrame(1)
      rope.anchorX, rope.anchorY = 1, 1
      rope.yScale = 1.25
      rope.x, rope.y = v[1], v[2]
  end

  local captainDad = display.newImageRect("assets/king.png",256,377)
  captainDad.anchorX, captainDad.anchorY = 1,1
  captainDad.x, captainDad.y = 110,460
  captainDad.xScale,captainDad.yScale = 0.75,0.75

  local shipWheel = display.newImageRect("assets/wheel.png",128,256)
  shipWheel.anchorX, shipWheel.anchorY = 0.5,1
  shipWheel.x,shipWheel.y = 102,488


  function placementHelper( event )
        if event.isPrimaryButtonDown then
  	       print( "CLICK: ".. tostring(math.round(event.x)) .. "," .. tostring(math.round(event.y)) )
        end
  end
  Runtime:addEventListener("mouse", placementHelper)
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

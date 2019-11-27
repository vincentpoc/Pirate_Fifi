local composer = require ("composer")

local scene    = composer.newScene ()
local menuGroup = display.newGroup()

local function cycleTrans( object, factorX, factorY)
  transition.to( object, { time=(4000 * factorX), x= object.x - 128, y= object.y - (15 * factorY), onComplete=function ()
      if factorY < 0 then  factorY = 1.0 elseif factorY > 0 then factorY = -1.0 end
      print("TRANS")
      if object.x < -256 then object.x = 128 end
      cycleTrans(object, factorX, factorY)
    end } )
end

----------------------------------------------------------------------------------------- create()
function scene:create (event)

  local sceneGroup = self.view

  local skyGroup = display.newGroup()
  for i=0,3 do
    local bgSky = display.newImageRect(sceneGroup, "assets/env_sky_02.png", 1024, 684)
    bgSky.x = 1024 * i
    skyGroup:insert(bgSky)
  end
  skyGroup.x,skyGroup.y = 0, fCenterY - 65
  skyGroup:scale(0.5,0.5)
  cycleTrans(skyGroup,2.0,0)

  local waveGroup = display.newGroup()
  for i=0, 3 do
    local bgWave = display.newImageRect(sceneGroup, "assets/env_wave_a.png", 512, 132)
    bgWave.anchorX, bgWave.anchorY = 0, 1
    bgWave.x, bgWave.y = (512 * i)-256, 15
    waveGroup:insert(bgWave)
  end
  waveGroup.x, waveGroup.y = -256, fHeight
  cycleTrans(waveGroup,1.0,1.0)

  local btGoToGame = display.newImageRect( sceneGroup, "assets/ui_frame.png", 256, 128)
  btGoToGame.x, btGoToGame.y = fCenterX, fCenterY - 30
  local txGoToGame = display.newText(sceneGroup, "START", fCenterX, fCenterY - 30, "Comic Sans MS", 60)
  txGoToGame:setFillColor(1,1,0)
  
  menuGroup:insert(skyGroup)
  menuGroup:insert(waveGroup)
  menuGroup:insert(btGoToGame)
  menuGroup:insert(txGoToGame)


  function onTapGoToGame ( event )
      local options =
      {
          effect = "fade",
          time = 1000,
      }
      composer.gotoScene( "scene.game", options )
      --display.remove(menuGroup)
  end

  btGoToGame:addEventListener("tap", onTapGoToGame )
  
end
----------------------------------------------------------------------------------------- show()
function scene:show (event)

	local sceneGroup = self.view
	local phase      = event.phase
  print("show")
	if (phase == "will") then
	-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif (phase == "did") then
	-- Code here runs when the scene is entirely on screen

	end

end
----------------------------------------------------------------------------------------- hide()
function scene:hide (event)
  print("hide")
	local sceneGroup = self.view
	local phase      = event.phase

	if (phase == "will") then
	-- Code here runs when the scene is on screen (but is about to go off screen)

  elseif (phase == "did") then
    print("DONE")
	  display.remove(menuGroup)
    scene:destroy(sceneGroup)
	end

end
----------------------------------------------------------------------------------------- destroy()
function scene:destroy (event)

	local sceneGroup = self.view

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

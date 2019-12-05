local composer = require ("composer")

local scene    = composer.newScene ()
local menuGroup = display.newGroup()
local sceneIsActive = true

local function cycleTrans( object, factorX, factorY)
  transition.to( object, { time=(4000 * factorX), x= object.x - 256, y= object.y - (15 * factorY), onComplete=function ()
      if factorY < 0 then  factorY = 1.0 elseif factorY > 0 then factorY = -1.0 end
      if object.x < -512 then object.x = 256 end
      if sceneIsActive or factorY == 0 then cycleTrans(object, factorX, factorY) end
    end } )
    return true
end

----------------------------------------------------------------------------------------- create()
function scene:create (event)

  local sceneGroup = self.view
  sceneIsActive = true

  --SKY--
  local skyGroup = display.newGroup()
  for i=0,3 do
    local bgSky = display.newImageRect("assets/env_sky.png", 1024, 684)
    bgSky.x = 1024 * i
    skyGroup:insert(bgSky)
  end
  skyGroup.x,skyGroup.y = 0, fCenterY
  --skyGroup:scale(0.5,0.5)
  cycleTrans(skyGroup,3.0,0)

  --SHIP--
  local ship = display.newImageRect("assets_qrb/ship_menu.png",512,512)
  ship.anchorX, ship.anchorY = 0.75 , 1
  ship.x,ship.y = fCenterX + 100, fCenterY + 300
  ship.rotation = -5
  ship.alpha = 0.85
 transition.to(ship,{time = 2000, y= ship.y + 50, rotation=5, transition=easing.continuousLoop,iterations =0})
  --WAVE--
  local waveGroup = display.newGroup()
  for i=0, 4 do
    local bgWave = display.newImageRect("assets/env_wave_a.png", 512, 132)
    bgWave.anchorX, bgWave.anchorY = 0, 1
    bgWave.x, bgWave.y = (512 * i)-512, 15
    waveGroup:insert(bgWave)
  end
  waveGroup.x, waveGroup.y = -256, fHeight
  cycleTrans(waveGroup,0.5,1.0)

  ---START BUTTON --
  local uititle = display.newImageRect("assets/ui_title.png",512,327)
  uititle.x,uititle.y = fCenterX,fCenterY - 150

  local btGoToGame = display.newImageRect( "assets/ui_frame.png", 256, 128)
  local txGoToGame = display.newText("JOUER", 0, 0, "Comic Sans MS", 50)
  txGoToGame:setFillColor(1,1,0)
  local btGroup = display.newGroup()
  btGroup:insert(btGoToGame)
  btGroup:insert(txGoToGame)
  btGroup.x, btGroup.y = fCenterX , fHeight - 230

  --STAGE--
  --menuGroup:insert(skyGroup)
  skyGroup:toBack()
  sceneGroup:insert(ship)
  sceneGroup:insert(waveGroup)
  sceneGroup:insert(btGroup)
  --sceneGroup:insert(btGroupSkip)
  sceneGroup:insert(uititle)
  --sceneGroup:insert(menuGroup)

  --EVENT---
  function onTapGoToGame ( event )
      transition.to(btGroup, {xScale = 1.4, yScale = 1.4, time=200, transition= easing.continuousLoop})
      local options =
      {
          effect = "fade",
          time = 500
      }
      --composer.gotoScene( "scene.game", options )
      composer.gotoScene( "scene.intro", options )
      return true
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

	local sceneGroup = self.view
	local phase      = event.phase

	if (phase == "will") then

    elseif (phase == "did") then
        --print("DONE")
    	--display.remove(menuGroup)
        --scene:destroy(sceneGroup)
        sceneIsActive = false
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

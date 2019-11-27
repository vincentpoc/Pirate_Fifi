--------------------- INIT --------------------------------------------------------------------
local composer = require ("composer")

fCenterX, fCenterY  = display.contentCenterX, display.contentCenterY
fWidth, fHeight = display.contentWidth, display.contentHeight

gameCriticLevel = 8
gameCriticMaxLevel = 10
gameSpeed = 2000
-- Hide status bar
display.setStatusBar (display.HiddenStatusBar)

-- Seed the random number generator
math.randomseed (os.time () )

-- Go to
local options =
{
	effect = "fade",
	time = 400
}

composer.gotoScene ("scene.menu")
--composer.gotoScene ("scene.debugger")

--------------------- INIT --------------------------------------------------------------------
local composer = require ("composer")

fCenterX, fCenterY  = display.contentWidth  / 2, display.contentHeight / 2

-- Hide status bar
display.setStatusBar (display.HiddenStatusBar)

-- Seed the random number generator
math.randomseed (os.time () )

-- Go to
local options =
{
	effect = "fade",
	time = 400,
	params = {
		sampleVar1 = "my sample variable",
		sampleVar2 = "another sample variable"
	}
}

composer.gotoScene ("scene.menu")


-----------------------------------------------------------------------------------------

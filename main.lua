--------------------- INIT --------------------------------------------------------------------
local composer = require ("composer")

fCenterX, fCenterY  = display.contentCenterX, display.contentCenterY
fWidth, fHeight = display.contentWidth, display.contentHeight

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

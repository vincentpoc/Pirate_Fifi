--------------------- INIT --------------------------------------------------------------------
local composer = require ("composer")

fCenterX, fCenterY  = display.contentCenterX, display.contentCenterY
fWidth, fHeight = display.contentWidth, display.contentHeight

gameCriticLevel = 6
gameCriticMaxLevel = 8
gameSpeed = 2000
-- Hide status bar
display.setStatusBar (display.HiddenStatusBar)

-- Seed the random number generator
math.randomseed (os.time () )

---
fifiSheepOptions =
{
	numFrames =4,
	width = 186, height = 256,
	sheetContentWidth = 373,sheetContentHeight = 512
}

fifiSqData =
{
	{name = "stand", frames = {1,2}, time = 500, loopcount = 0},
	{name = "walk", frames = {3,1,3,2}, time = 600, loopcount = 0},
	{name = "fix", frames = {4,4,4,2}, time = 500, loopcount = 0}
}
----
captainDadSheepOptions =
{
	numFrames =4,
	width = 302, height = 350,
	sheetContentWidth = 604,sheetContentHeight = 700
}

captainDadSqData =
{
	{name = "stand", frames = {1,2}, time = 500, loopcount = 0},
	{name = "smile", frames = {3}, time = 600, loopcount = 1},
	{name = "jump", frames = {4,4,1}, time = 250, loopcount = 1}
}
-- Go to
local options =
{
	effect = "fade",
	time = 400
}

composer.gotoScene ("scene.gamewin")
--composer.gotoScene ("scene.debugger")

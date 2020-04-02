-- constants
local grey = { 0.7, 0.7, 0.7, 1 }
local white = { 1, 1, 1, 1 }
local blue = { 0, 0, 1, 1 }
local teal = { 0, 1, 1, 1 }
local red =  { 1, 0, 0, 1 }
local green = { 0, 1, 0, 1 }
local yellow = { 1, 1, 0, 1 }

-- General
config = {
	console = {
		x = 0.26,
		y = 0.18,
		w = 0.5,
		--fontFile = "LuaUI/fonts/dejavu-sans-mono/DejaVuSansMono.ttf",
	},
	suggestions = {
		h = 0.4,
		inverted = false, -- if set to true, it will appear above the console
		fontSize = 16,
		padding = 4,
		pageUpFactor = 10,
		pageDownFactor = 10,

		selectedColor = { 0, 1, 1, 0.4 },
		subsuggestionColor = { 0, 0, 0, 0 },
		suggestionColor = white,
		descriptionColor = grey,

		cheatEnabledColor = green,
		cheatDisabledColor = red,
		autoCheatColor = yellow,
	},
}

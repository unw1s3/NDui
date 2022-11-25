local _, ns = ...
local B, C, L, DB = unpack(ns)
local Bar = B:GetModule("Actionbar")

local keyButton = gsub(KEY_BUTTON4, "%d", "")
local keyNumpad = gsub(KEY_NUMPAD1, "%d", "")

local replaces = {
	{"("..keyButton..")", "M"},
	{"("..keyNumpad..")", "N"},
	{"(a%-)", "a"},
	{"(c%-)", "c"},
	{"(s%-)", "s"},
	{KEY_BUTTON3, "M3"},
	{KEY_MOUSEWHEELUP, "MU"},
	{KEY_MOUSEWHEELDOWN, "MD"},
	{KEY_SPACE, "Sp"},
	{"CAPSLOCK", "CL"},
	{"BUTTON", "M"},
	{"NUMPAD", "N"},
	{"(ALT%-)", "a"},
	{"(CTRL%-)", "c"},
	{"(SHIFT%-)", "s"},
	{"MOUSEWHEELUP", "MU"},
	{"MOUSEWHEELDOWN", "MD"},
	{"SPACE", "Sp"},
}

function Bar:UpdateHotKey()
	local text = self:GetText()
	if not text then return end

	if text == RANGE_INDICATOR then
		text = ""
	else
		for _, value in pairs(replaces) do
			text = gsub(text, value[1], value[2])
		end
	end
	self:SetFormattedText("%s", text)
end

function Bar:StyleActionButton(button)
	if not button then return end
	if button.__styled then return end

	local icon = button.icon
	local cooldown = button.cooldown
	local hotkey = button.HotKey
	local count = button.Count
	local name = button.Name
	local flash = button.Flash
	local border = button.Border
	local normal = button.NormalTexture
	local normal2 = button:GetNormalTexture()
	local slotbg = button.SlotBackground
	local pushed = button.PushedTexture
	local checked = button.CheckedTexture
	local highlight = button.HighlightTexture
	local NewActionTexture = button.NewActionTexture
	local spellHighlight = button.SpellHighlightTexture
	local iconMask = button.IconMask

	if normal then normal:SetAlpha(0) end
	if normal2 then normal2:SetAlpha(0) end
	if flash then flash:SetTexture(DB.textures.flash) end
	if NewActionTexture then NewActionTexture:SetTexture(nil) end
	if border then border:SetTexture(nil) end
	if iconMask then iconMask:Hide() end
	if button.style then button.style:SetAlpha(0) end

	if icon then
		icon:SetInside()
		icon:SetTexCoord(unpack(DB.TexCoord))
		button.__bg = B.SetBD(icon, .25)
	end
	if cooldown then
		cooldown:SetAllPoints()
	end
	if pushed then
		pushed:SetInside()
		pushed:SetTexture(DB.textures.pushed)
	end
	if checked then
		checked:SetInside()
		checked:SetColorTexture(1, .8, 0, .35)
	end
	if highlight then
		highlight:SetInside()
		highlight:SetColorTexture(1, 1, 1, .25)
	end
	if spellHighlight then
		spellHighlight:SetOutside()
	end
	if hotkey then
		Bar.UpdateHotKey(hotkey)
		hooksecurefunc(hotkey, "SetText", Bar.UpdateHotKey)
	end

	button.__styled = true
end

function Bar:ReskinBars()
	for i = 1, 8 do
		for j = 1, 12 do
			Bar:StyleActionButton(_G["NDui_ActionBar"..i.."Button"..j])
		end
	end
	--petbar buttons
	for i = 1, NUM_PET_ACTION_SLOTS do
		Bar:StyleActionButton(_G["PetActionButton"..i])
	end
	--stancebar buttons
	for i = 1, 10 do
		Bar:StyleActionButton(_G["StanceButton"..i])
	end
	--leave vehicle
	Bar:StyleActionButton(_G["NDui_LeaveVehicleButton"])
	--extra action button
	Bar:StyleActionButton(ExtraActionButton1)
end
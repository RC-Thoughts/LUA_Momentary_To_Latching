--[[
	---------------------------------------------------------
    Momentary application takes any switch as input
	(including voice commands!) and creates latching
	switches from momentary action.
	
	Example: 
	Switch 1 ON-OFF makes Momentary switch 1 to ON
	next time used it will be turned off:
	Switch 1 ON-OFF makes Momentary switch 1 to OFF
	
	Time between changes needs to be min. 2 seconds
	If activating switch is held in ON position app-switch
	will switch state every 2 seconds.
	
	All momentary switches are OFF when model is loaded.
	
	Localisation-file has to be as /Apps/Lang/RCT-Batt.jsn
    
    Requires DC/DS-14/16/24 firmware 4.22 or up
	
	French translation courtesy from Daniel Memim
	---------------------------------------------------------
	Momentary application is part of RC-Thoughts Jeti Tools.
	---------------------------------------------------------
	Released under MIT-license by Tero @ RC-Thoughts.com 2016
	---------------------------------------------------------
--]]
collectgarbage()
--------------------------------------------------------------------------------
-- Locals for the application
local switch1, switch2, switch3, switch4
local state1, state2, state3, state4= 0, 0, 0, 0
local tStamp1, tStamp2, tStamp3, tStamp4 = 0, 0, 0, 0
--------------------------------------------------------------------------------
-- Read translations
local function setLanguage()
    local lng=system.getLocale()
    local file = io.readall("Apps/Lang/RCT-Mome.jsn")
    local obj = json.decode(file)
    if(obj) then
        trans4 = obj[lng] or obj[obj.default]
    end
end
--------------------------------------------------------------------------------
-- Store changed switch selections
local function switch1Changed(value)
	switch1 = value
	system.pSave("switch1",value)
end

local function switch2Changed(value)
	switch2 = value
	system.pSave("switch2",value)
end

local function switch3Changed(value)
	switch3 = value
	system.pSave("switch3",value)
end

local function switch4Changed(value)
	switch4 = value
	system.pSave("switch4",value)
    end
--------------------------------------------------------------------------------
-- Draw the main form (Application inteface)
local function initForm()
	form.addRow(1)
	form.addLabel({label="---     RC-Thoughts Jeti Tools      ---",font=FONT_BIG})
	
	form.addRow(2)
	form.addLabel({label=trans4.swi1})
	form.addInputbox(switch1, true, switch1Changed) 
	
	form.addRow(2)
	form.addLabel({label=trans4.swi2})
	form.addInputbox(switch2, true, switch2Changed)
	
	form.addRow(2)
	form.addLabel({label=trans4.swi3})
	form.addInputbox(switch3, true, switch3Changed)
	
	form.addRow(2)
	form.addLabel({label=trans4.swi4})
	form.addInputbox(switch4, true, switch4Changed)
	
	form.addRow(1)
	form.addLabel({label="Powered by RC-Thoughts.com - v."..momeVersion.." ",font=FONT_MINI, alignRight=true})
end
--------------------------------------------------------------------------------
-- Draw latching statuses to application interface
local function printForm()
	lcd.drawText(105,32,trans4.latchSts,FONT_MINI)
	lcd.drawNumber(205,32, state1, FONT_MINI)
	
	lcd.drawText(105,54,trans4.latchSts,FONT_MINI)
	lcd.drawNumber(205,54, state2, FONT_MINI)
	
	lcd.drawText(105,76,trans4.latchSts,FONT_MINI)
	lcd.drawNumber(205,76, state3, FONT_MINI)
	
	lcd.drawText(105,98,trans4.latchSts,FONT_MINI)
	lcd.drawNumber(205,98, state4, FONT_MINI)
end
--------------------------------------------------------------------------------
-- Runtime functions, read switches, set latching status and control latching switches (outputs)
local function loop()
	local tStamp = system.getTimeCounter()
	local switch1, switch2, switch3, switch4  = system.getInputsVal(switch1, switch2, switch3, switch4)
	
	if (switch1 == 1 and state1 == 0 and tStamp > tStamp1) then
		tStamp1 = tStamp + 2000
		state1 = 1
		system.setControl(1, 1, 0, 0)
	end
	if (switch1 == 1 and state1 == 1 and tStamp > tStamp1) then
		tStamp1 = tStamp + 2000
		state1 = 0
		system.setControl(1, 0, 0, 0)
	end
	if (switch2 == 1 and state2 == 0 and tStamp > tStamp2) then
		tStamp2 = tStamp + 2000
		state2 = 1
		system.setControl(2, 1, 0, 0)
	end
	if (switch2 == 1 and state2 == 1 and tStamp > tStamp2) then
		tStamp2 = tStamp + 2000
		state2 = 0
		system.setControl(2, 0, 0, 0)
	end
	if (switch3 == 1 and state3 == 0 and tStamp > tStamp3) then
		tStamp3 = tStamp + 2000
		state3 = 1
		system.setControl(3, 1, 0, 0)
	end
	if (switch3 == 1 and state3 == 1 and tStamp > tStamp3) then
		tStamp3 = tStamp + 2000
		state3 = 0
		system.setControl(3, 0, 0, 0)
	end
	if (switch4 == 1 and state4 == 0 and tStamp > tStamp4) then
		tStamp4 = tStamp + 2000
		state4 = 1
		system.setControl(4, 1, 0, 0)
	end
	if (switch4 == 1 and state4 == 1 and tStamp > tStamp4) then
		tStamp4 = tStamp + 2000
		state4 = 0
		system.setControl(4, 0, 0, 0)
	end
    collectgarbage()
end
--------------------------------------------------------------------------------
-- Application initialization
local function init()
    local registerForm,registerControl = system.registerForm,system.registerControl
    local pLoad,setControl = system.pLoad, system.setControl
	registerForm(1,MENU_APPS, trans4.appName,initForm, nil,printForm)
	registerControl(1,trans4.latchSw1,trans4.swCntr1)
	registerControl(2,trans4.latchSw2,trans4.swCntr2)
	registerControl(3,trans4.latchSw3,trans4.swCntr3)
	registerControl(4,trans4.latchSw4,trans4.swCntr4)
	switch1 = pLoad("switch1")
	switch2 = pLoad("switch2")
	switch3 = pLoad("switch3")
	switch4 = pLoad("switch4")
	setControl(1, 0, 0, 0)
	setControl(2, 0, 0, 0)
	setControl(3, 0, 0, 0)
	setControl(4, 0, 0, 0)
    collectgarbage()
end
--------------------------------------------------------------------------------
momeVersion = "1.9"
setLanguage()
collectgarbage()
--------------------------------------------------------------------------------
return {init=init, loop=loop, author="RC-Thoughts", version=momeVersion, name=trans4.appName}
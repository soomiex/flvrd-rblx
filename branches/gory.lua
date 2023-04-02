-- New example script written by wally
-- You can suggest changes with a pull request or something

local repo = 'https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local StillLoaded = false 

local Window = Library:CreateWindow({
    -- Set Center to true if you want the menu to appear in the center
    -- Set AutoShow to true if you want the menu to appear when it is created
    -- Position and Size are also valid options here
    -- but you do not need to define them unless you are changing them :)

    Title = 'flavored.fun - gory sucks ass (fr)',
    Center = true, 
    AutoShow = true,
})

-- You do not have to set your tabs & groups up this way, just a prefrence.
local Tabs = {
    -- Creates a new tab titled Main
    Main = Window:AddTab('Exploits'), 
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

-- Groupbox and Tabbox inherit the same functions
-- except Tabboxes you have to call the functions on a tab (Tabbox:AddTab(name))
local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Main')

-- Tabboxes are a tiny bit different, but here's a basic example:
--[[

local TabBox = Tabs.Main:AddLeftTabbox() -- Add Tabbox on left side

local Tab1 = TabBox:AddTab('Tab 1')
local Tab2 = TabBox:AddTab('Tab 2')

-- You can now call AddToggle, etc on the tabs you added to the Tabbox
]]

-- Groupbox:AddToggle
-- Arguments: Index, Options
LeftGroupBox:AddToggle('InfiniteAmmo', {
    Text = 'Infinite Ammo',
    Default = false, -- Default value (true / false)
    Tooltip = 'Allows you to fire again without reloading.', -- Information shown when you hover over the toggle
})

LeftGroupBox:AddToggle("QuickPickup", {
    Text = "Quick Pickup",
    Default = false, 
    Tooltip = 'Allows you to more quickly pickup a flag or object.',  
})

-- Groupbox:AddSlider
-- Arguments: Idx, Options
LeftGroupBox:AddSlider('QuickPickupInt', {
    Text = 'Quick Pickup new speed',

    -- Text, Default, Min, Max, Rounding must be specified.
    -- Rounding is the number of decimal places for precision.

    -- Example:
    -- Rounding 0 - 5
    -- Rounding 1 - 5.1
    -- Rounding 2 - 5.15
    -- Rounding 3 - 5.155

    Default = 0.7,
    Min = 0,
    Max = 1,
    Rounding = 2,

    Compact = false, -- If set to true, then it will hide the label
})

-- Options is a table added to getgenv() by the library
-- You index Options with the specified index, in this case it is 'MySlider'
-- To get the value of the slider you do slider.Value

local Number = Options.QuickPickupInt.Value


-- Library functions
-- Sets the watermark visibility
Library:SetWatermarkVisibility(false)

Library.KeybindFrame.Visible = false; -- todo: add a function for this

Library:OnUnload(function()
    print('Unloaded!')
    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' }) 

Library.ToggleKeybind = Options.MenuKeybind -- Allows you to have a custom keybind for the menu

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager. 
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings() 

-- Adds our MenuKeybind to the ignore list 
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' }) 

-- use case for doing it this way: 
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder('flvrd')
SaveManager:SetFolder('flvrd/gory')

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['UI Settings']) 

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config 
-- which has been marked to be one that auto loads!

function SearchForModule(name, toValue) 
    for i,v in pairs(game:GetDescendants()) do 
        if v.Name == name then 
            toValue = require(v) 
        end
    end
end

local FireActionClient
SearchForModule("FireActionClient", FireActionClient) 

local SearchQueue = {} 
local SearchTick = 0 
local HitSearchTick = 5 -- technically every .5 seconds 

spawn(function()
    while wait(.1) do -- none of our features are that time-dependent to do a normal wait().  
        print("Hello?")
        if Toggles.InfiniteAmmo.Value then 
            if FireActionClient ~= nil then 
                FireActionClient.reloaded = true -- set our ammo value to true
                print("reloaded = true")
            else -- if our supposed module isn't real (or doesn't exist) add it to the queue to be searched.
                table.insert(SearchQueue, {"FireActionClient", FireActionClient}) -- table; {name, variable}
                print("trying to search")
            end
        end

        if (SearchTick >= 5) then 
            SearchTick = 0 
            for index, searchTable in pairs(SearchQueue) do 
                if searchTable[1] ~= nil and searchTable[2] ~= nil then -- make sure both variables we need are real and exist 
                    SearchForModule(searchTable[1], searchTable[2]) -- begin the search 
                end 
            end
        end

        SearchTick = SearchTick + 1 
        if Library.Unloaded then break end
    end 
end)

game:GetService("ProximityPromptService").PromptShown:Connect(function(Prompt)
    if Toggles.QuickPickup then 
        Prompt.HoldDuration = Options.QuickPickupInt.Value
    end
end)
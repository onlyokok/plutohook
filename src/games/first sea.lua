if getgenv().Loaded then return end
getgenv().Loaded = true

local Repository = "https://raw.githubusercontent.com/onlyokok/plutohook/main/src/"
local Library = loadstring(game:HttpGet(Repository.."linorias/source.lua"))()
local ThemeManager = loadstring(game:HttpGet(Repository.."linorias/thememanager.lua"))()
local SaveManager = loadstring(game:HttpGet(Repository.."linorias/savemanager.lua"))()

local Window = Library:CreateWindow({
    Title = 'Project Pluto',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

getgenv().ScriptOptions = {
    RifleFarm = false,
    SelectedEnemy = "a",
    SelectedHitbox = "Head",
    SelectedMethod = "Selected"
}

local Tabs = {
    Main = Window:AddTab('Grand Piece Online'),
    ['UI Settings'] = Window:AddTab('Settings')
}

local AutoFarmGroupBox = Tabs.Main:AddLeftGroupbox('Auto Farm')

local NPCs = workspace.NPCs

-- functions
local GetEnemies = function()
	local enemies = {}

	for _,enemy in next, NPCs:GetChildren() do
		if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid").Health > 0 and not enemy:FindFirstChild("ForceField") and not table.find(enemies, enemy.Name) then
			table.insert(enemies, enemy.Name)
		end
	end

	return enemies
end

AutoFarmGroupBox:AddToggle('MyToggle', {
    Text = 'Rifle Farm',
    Default = false,
    Tooltip = 'Rifle Farm',

    Callback = function(Value)
        getgenv().ScriptOptions.Rifle = Value
    end
})

AutoFarmGroupBox:AddDropdown('MyDropdown', {
    Values = {"Selected", "Closest"},
    Default = 1,
    Multi = false,

    Text = 'Select Method',
    Tooltip = 'Select Method',

    Callback = function(Value)
        getgenv().ScriptOptions.SelectedMethod = Value
    end
})

local SelectEnemyDropdown = AutoFarmGroupBox:AddDropdown('MyDropdown', {
    Values = GetEnemies(),
    Default = 1,
    Multi = false,

    Text = 'Select Enemy',
    Tooltip = 'Select Enemy',

    Callback = function(Value)
        getgenv().ScriptOptions.SelectedEnemy = Value
    end
})

AutoFarmGroupBox:AddButton({
    Text = 'Refresh Enemies',
    Func = function()
        SelectEnemyDropdown:SetValue(GetEnemies())
    end,
    DoubleClick = false,
    Tooltip = 'Refresh Enemies'
})

AutoFarmGroupBox:AddDropdown('MyDropdown', {
    Values = {"Head", "HumanoidRootPart"},
    Default = 1,
    Multi = false,

    Text = 'Select Hitbox',
    Tooltip = 'Select Hitbox',

    Callback = function(Value)
        getgenv().ScriptOptions.SelectedHitbox = Value
    end
})

-- Library functions
-- Sets the watermark visibility
Library:SetWatermarkVisibility(true)

-- Example of dynamically-updating watermark with common traits (fps and ping)
local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('Project Pluto | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library.KeybindFrame.Visible = true; -- todo: add a function for this

Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    -- making all of our booleans equal to false
    for _,value in next, getgenv().ScriptOptions do
        if type(value) == "boolean" then
            value = false
        end
    end

    print('Unloaded!')
    getgenv().Loaded = false
    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

-- I set NoUI so it does not show up in the keybinds menu
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'LeftBracket', NoUI = true, Text = 'Menu keybind' })

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
ThemeManager:SetFolder('Project Pluto')
SaveManager:SetFolder('Project Pluto/GrandPieceOnline')

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs['UI Settings'])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs['UI Settings'])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
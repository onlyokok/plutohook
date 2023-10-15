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
    ChestFarm = false,
    RifleFarm = false,
    SelectedEnemy = "Bandit",
    SelectedHitbox = "Head",
    SelectedMethod = "Selected",
    Tween =  nil,
    TweenOngoing = false,
    TweenSpeed = 50,
    AutoQuest = false,
    SelectedQuest = nil,
    Position = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
}

local Tabs = {
    Main = Window:AddTab('Grand Piece Online'),
    ['UI Settings'] = Window:AddTab('Settings')
}

local AutoFarmGroupBox = Tabs.Main:AddLeftGroupbox('Auto Farm')

local TweenTo = function(Cframe, Speed, Offset)
    if not getgenv().ScriptOptions.TweenOngoing then
        local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Cframe.Position).Magnitude
        local info = TweenInfo.new(distance / Speed, Enum.EasingStyle.Linear)

        getgenv().ScriptOptions.Tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, info, {CFrame = Cframe + Offset})
        getgenv().ScriptOptions.Tween:Play()
        getgenv().ScriptOptions.TweenOngoing = true

        getgenv().ScriptOptions.Tween.Completed:Connect(function()
            getgenv().ScriptOptions.Tween = nil
            getgenv().ScriptOptions.TweenOngoing = false
        end)
    end
end

local GetClosestChest = function()
    local closestChest
    local closestDistance = math.huge

    for _,part in next, workspace.Env:GetChildren() do
        if part:FindFirstChild("ClickDetector") then
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - part.Position).Magnitude

            if distance < closestDistance then
                closestChest = part
                closestDistance = distance
            end
        end
    end

    return closestChest
end

AutoFarmGroupBox:AddToggle('MyToggle', {
    Text = 'Chest Farm',
    Default = false,
    Tooltip = 'Chest Farm',

    Callback = function(Value)
        getgenv().ScriptOptions.ChestFarm = Value
        if getgenv().ScriptOptions.ChestFarm then
            while getgenv().ScriptOptions.ChestFarm do task.wait()
                TweenTo(GetClosestChest().CFrame, getgenv().ScriptOptions.TweenSpeed, Vector3.new(0, 5, 0))
                fireclickdetector(GetClosestChest().ClickDetector)
            end
        else
            task.wait()
            if getgenv().ScriptOptions.TweenOngoing then
                getgenv().ScriptOptions.Tween:Cancel()
            end
        end
    end
})

local NPCs = game.Workspace.NPCs

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

local GetClosestSelectedEnemy = function(EnemyName)
    local closestEnemy
    local closestDistance = math.huge

    for _,enemy in next, NPCs:GetChildren() do
        if enemy.Name == EnemyName then
            if enemy:FindFirstChild("Head") and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid").Health > 0 then
                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude

                if distance < closestDistance then
                    closestEnemy = enemy
                    closestDistance = distance
                end
            end
        end
    end

    return closestEnemy
end

local GetClosestEnemy = function()
    local closestEnemy
    local closestDistance = math.huge

    for _,enemy in next, NPCs:GetChildren() do
        if enemy:FindFirstChild("Head") and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid").Health > 0 and not enemy:FindFirstChild("ForceField") then
            local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude

            if distance < closestDistance then
                closestEnemy = enemy
                closestDistance = distance
            end
        end
    end

    return closestEnemy
end

AutoFarmGroupBox:AddToggle('MyToggle', {
    Text = 'Rifle Farm',
    Default = false,
    Tooltip = 'Rifle Farm',

    Callback = function(Value)
        getgenv().ScriptOptions.RifleFarm = Value
        while getgenv().ScriptOptions.RifleFarm do task.wait()
            local success, error = pcall(function()
                if getgenv().ScriptOptions.SelectedMethod == "Selected" then
                    local Args = {
                        [1] = "fire",
                        [2] = {
                            ["Start"] = game.Players.LocalPlayer.Character.Head.CFrame,
                            ["Gun"] = "Rifle",
                            ["joe"] = "true",
                            ["Position"] = GetClosestSelectedEnemy(getgenv().ScriptOptions.SelectedEnemy)[getgenv().ScriptOptions.SelectedHitbox].Position
                        }
                    }
            
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("CIcklcon"):FireServer(unpack(Args))  
                    local ReloadArgs = {
                        [1] = "reload",
                        [2] = {
                            ["Gun"] = "Rifle"
                        }
                    }
            
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("CIcklcon"):WaitForChild("gunFunctions"):InvokeServer(unpack(ReloadArgs))
                elseif getgenv().ScriptOptions.SelectedMethod == "Closest" then
                    local Args = {
                        [1] = "fire",
                        [2] = {
                            ["Start"] = game.Players.LocalPlayer.Character.Head.CFrame,
                            ["Gun"] = "Rifle",
                            ["joe"] = "true",
                            ["Position"] = GetClosestEnemy()[getgenv().ScriptOptions.SelectedHitbox].Position
                        }
                    }
            
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("CIcklcon"):FireServer(unpack(Args))  
                    local ReloadArgs = {
                        [1] = "reload",
                        [2] = {
                            ["Gun"] = "Rifle"
                        }
                    }
            
                    game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("CIcklcon"):WaitForChild("gunFunctions"):InvokeServer(unpack(ReloadArgs))
                end
            end)

            warn(success, error)
        end
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
        SelectEnemyDropdown:SetValues(GetEnemies())
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

local ScriptSettingsGroupBox = Tabs.Main:AddRightGroupbox('Script Settings')

ScriptSettingsGroupBox:AddSlider('MySlider', {
    Text = 'Tween Speed',
    Default = 50,
    Min = 20,
    Max = 70,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        getgenv().ScriptOptions.TweenSpeed = Value
    end
})

local AutoQuestGroupBox = Tabs.Main:AddRightGroupbox('Auto Quest')

local GetQuestTable = function()
    local quests = {}

    for _,npc in next, NPCs:GetChildren() do
        if npc:FindFirstChild("ForceField") and npc:FindFirstChild("HumanoidRootPart") then
            if not table.find(quests, npc.Name) then
                table.insert(quests, npc.Name)
            end
        end
    end

    return quests
end

AutoQuestGroupBox:AddToggle('MyToggle', {
    Text = 'Auto Quest',
    Default = false,
    Tooltip = 'Auto Quest',

    Callback = function(Value)
        getgenv().ScriptOptions.AutoQuest = Value
        if getgenv().ScriptOptions.AutoQuest then
            while getgenv().ScriptOptions.AutoQuest do task.wait()
                pcall(function()
                    if game.ReplicatedStorage['Stats'..game.Players.LocalPlayer.Name].Quest.CurrentQuest.Value == "None" then
                        TweenTo(NPCs[getgenv().ScriptOptions.SelectedQuest].HumanoidRootPart.CFrame, getgenv().ScriptOptions.TweenSpeed, Vector3.new(0, 0, 0))
                        keypress(Enum.KeyCode.T)
                        firesignal(game:GetService("Players").LocalPlayer.PlayerGui.NPCCHAT.Frame.go.MouseButton1Click)
                    else
                        if game.Players.LocalPlayer.PlayerGui:FindFirstChild("NPCCHAT") then
                            firesignal(game:GetService("Players").LocalPlayer.PlayerGui.NPCCHAT.Frame.endChat.MouseButton1Click)
                        else
                            TweenTo(getgenv().ScriptOptions.Position, getgenv().ScriptOptions.TweenSpeed, Vector3.new(0, 0, 0))
                        end
                        
                    end
                end)
            end
        else
            task.wait()
            if getgenv().ScriptOptions.TweenOngoing then
                getgenv().ScriptOptions.Tween:Cancel()
            end
        end
    end
})

local SelectQuestDropdown = AutoQuestGroupBox:AddDropdown('MyDropdown', {
    Values = GetQuestTable(),
    Default = 1,
    Multi = false,

    Text = 'Select Quest',
    Tooltip = 'Select Quest',

    Callback = function(Value)
        getgenv().ScriptOptions.SelectedQuest = Value
    end
})

AutoQuestGroupBox:AddButton({
    Text = 'Refresh Quests',
    Func = function()
        SelectQuestDropdown:SetValues(GetQuestTable())
    end,
    DoubleClick = false,
    Tooltip = 'Refresh Quests'
})

AutoQuestGroupBox:AddButton({
    Text = 'Set Position',
    Func = function()
        getgenv().ScriptOptions.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    end,
    DoubleClick = false,
    Tooltip = 'Refresh Quests'
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
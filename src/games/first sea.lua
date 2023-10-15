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
    Strength = false,
    Stamina = false,
    Defense = false,
    GunMastery = false,
    SwordMastery = false,
    Tween =  nil,
    TweenOngoing = false,
    SafeMode = false,
    AnticheatBypass = false,
    TweenSpeed = 50,
    AutoQuest = false,
    SelectedQuest = nil,
    Position = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame,
    WalkSpeed = false,
    WalkSpeedAmount = 150,
    JumpPower = false,
    JumpPowerAmount = 70
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

local AutoSkillpointsGroupBox = Tabs.Main:AddLeftGroupbox('Auto-add Skillpoints')

AutoSkillpointsGroupBox:AddToggle('MyToggle', {
    Text = 'Strength',
    Default = false,
    Tooltip = 'Strength',

    Callback = function(Value)
        getgenv().ScriptOptions.Strength = Value

        while getgenv().ScriptOptions.Strength do task.wait()
            firesignal(game.Players.LocalPlayer.PlayerGui.Main.Stats.Frame.Strength.TextButton.MouseButton1Click)
        end
    end
})

AutoSkillpointsGroupBox:AddToggle('MyToggle', {
    Text = 'Stamina',
    Default = false,
    Tooltip = 'Stamina',

    Callback = function(Value)
        getgenv().ScriptOptions.Stamina = Value

        while getgenv().ScriptOptions.Stamina do task.wait()
            firesignal(game.Players.LocalPlayer.PlayerGui.Main.Stats.Frame.Stamina.TextButton.MouseButton1Click)
        end
    end
})

AutoSkillpointsGroupBox:AddToggle('MyToggle', {
    Text = 'Defense',
    Default = false,
    Tooltip = 'Defense',

    Callback = function(Value)
        getgenv().ScriptOptions.Defense = Value

        while getgenv().ScriptOptions.Defense do task.wait()
            firesignal(game.Players.LocalPlayer.PlayerGui.Main.Stats.Frame.Defense.TextButton.MouseButton1Click)
        end
    end
})

AutoSkillpointsGroupBox:AddToggle('MyToggle', {
    Text = 'Gun Mastery',
    Default = false,
    Tooltip = 'Gun Mastery',

    Callback = function(Value)
        getgenv().ScriptOptions.GunMastery = Value

        while getgenv().ScriptOptions.GunMastery do task.wait()
            firesignal(game.Players.LocalPlayer.PlayerGui.Main.Stats.Frame.GunMastery.TextButton.MouseButton1Click)
        end
    end
})

AutoSkillpointsGroupBox:AddToggle('MyToggle', {
    Text = 'Sword Mastery',
    Default = false,
    Tooltip = 'Sword Mastery',

    Callback = function(Value)
        getgenv().ScriptOptions.SwordMastery = Value

        while getgenv().ScriptOptions.SwordMastery do task.wait()
            firesignal(game.Players.LocalPlayer.PlayerGui.Main.Stats.Frame.SwordMastery.TextButton.MouseButton1Click)
        end
    end
})

local ScriptSettingsGroupBox = Tabs.Main:AddRightGroupbox('Script Settings')

ScriptSettingsGroupBox:AddToggle('MyToggle', {
    Text = 'Safe Mode',
    Default = false,
    Tooltip = 'Safe Mode',

    Callback = function(Value)
        getgenv().ScriptOptions.SafeMode = Value
        if getgenv().ScriptOptions.SafeMode then
            getconnections(game:GetService("ScriptContext").Error)[1]:Disable()
        else
            getconnections(game:GetService("ScriptContext").Error)[1]:Enable()
        end
    end
})

ScriptSettingsGroupBox:AddToggle('MyToggle', {
    Text = 'Anti-cheat Bypass',
    Default = false,
    Tooltip = 'Anti-cheat Bypass',

    Callback = function(Value)
        getgenv().ScriptOptions.AnticheatBypass = Value
        
        while getgenv().ScriptOptions.AnticheatBypass do
            local args = {
                [1] = "Sky Walk2",
                [2] = {
                    ["char"] = game.Players.LocalPlayer.Character,
                    ["cf"] = CFrame.new(0, 0, 0)
                }
            }
            
            game:GetService("ReplicatedStorage"):WaitForChild("Events"):WaitForChild("Skill"):InvokeServer(unpack(args))            
            task.wait(1)
        end
    end
})

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

local LocalPlayerGroupBox = Tabs.Main:AddRightGroupbox('Local Player')

LocalPlayerGroupBox:AddToggle('MyToggle', {
    Text = 'Walk Speed',
    Default = false,
    Tooltip = 'Walk Speed',

    Callback = function(Value)
        getgenv().ScriptOptions.WalkSpeed = Value
        while getgenv().ScriptOptions.WalkSpeed do task.wait()
            pcall(function()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame += game.Players.LocalPlayer.Character.Humanoid.MoveDirection * (getgenv().ScriptOptions.WalkSpeedAmount / 1000)
            end)
        end
    end
})

LocalPlayerGroupBox:AddSlider('MySlider', {
    Text = 'Walk Speed',
    Default = 50,
    Min = 50,
    Max = 250,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        getgenv().ScriptOptions.WalkSpeedAmount = Value
    end
})

LocalPlayerGroupBox:AddToggle('MyToggle', {
    Text = 'Jump Power',
    Default = false,
    Tooltip = 'Jump Power',

    Callback = function(Value)
        getgenv().ScriptOptions.JumpPower = Value

        game:GetService("UserInputService").InputBegan:Connect(function(Input, Processed)
            if Processed then return end
            if Input.KeyCode == Enum.KeyCode.Space and getgenv().ScriptOptions.JumpPower then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, getgenv().ScriptOptions.JumpPowerAmount, 0)
            end
        end)
    end
})

LocalPlayerGroupBox:AddSlider('MySlider', {
    Text = 'Jump Power',
    Default = 70,
    Min = 50,
    Max = 150,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        getgenv().ScriptOptions.JumpPowerAmount = Value
    end
})

Library:SetWatermarkVisibility(false)

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

Library.KeybindFrame.Visible = true;

Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    for _,value in next, getgenv().ScriptOptions do
        if type(value) == "boolean" then
            value = false
        end
    end

    if getgenv().ScriptOptions.TweenOngoing then
        getgenv().ScriptOptions.Tween:Cancel()
    end

    print('Unloaded!')
    getgenv().Loaded = false
    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'LeftBracket', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)

SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('Project Pluto')

SaveManager:SetFolder('Project Pluto/GrandPieceOnline')

SaveManager:BuildConfigSection(Tabs['UI Settings'])

ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()
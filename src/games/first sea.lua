if getgenv().Loaded then return end
getgenv().Loaded = true

local Repository = "https://raw.githubusercontent.com/onlyokok/plutohook/main/src/"
local Library = loadstring(game:HttpGet(Repository.."linorias/source.lua"))()
local ThemeManager = loadstring(game:HttpGet(Repository.."linorias/thememanager.lua"))()
local SaveManager = loadstring(game:HttpGet(Repository.."linorias/savemanager.lua"))()

local tweenService = game:GetService("TweenService")
local info = TweenInfo.new(.45, Enum.EasingStyle.Sine)
local coreGui = game:GetService("CoreGui")

getgenv().loaderLibrary = {}
loaderLibrary.__index = loaderLibrary

function loaderLibrary.new(type, properties)
    local object = Instance.new(type)
    local props = properties or {}

    for property, value in next, props do
        object[property] = value
    end

    return object
end

function loaderLibrary:createLoader()
    local loader = setmetatable({}, self)

    loader.loader = self.new("ScreenGui", {
        Name = "Loader",
        Parent = coreGui
    })

    local background = self.new("Frame", {
        Name = "Background",
        Parent = loader.loader,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(33, 33, 39),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.499635577, 0, 0.5, 0),
        Size = UDim2.new(0, 457, 0, 234)
    })

    local corner = self.new("UICorner", {
        CornerRadius = UDim.new(0, 5),
        Name = "Corner",
        Parent = background
    })

    local gradient = self.new("UIGradient", {
        Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(63, 63, 63))},
        Rotation = 90,
        Name = "Gradient",
        Parent = background
    })

    local stroke = self.new("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Color = Color3.fromRGB(85, 123, 198),
        Transparency = 1,
        Name = "Stroke",
        Parent = background
    })

    local dropShadow = self.new("ImageLabel", {
        Name = "DropShadow",
        Parent = background,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1.000,
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 47, 1, 47),
        ZIndex = -1,
        Image = "rbxassetid://6014261993",
        ImageColor3 = Color3.fromRGB(85, 123, 198),
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })

    local title = self.new("TextLabel", {
        Name = "Title",
        Parent = background,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1.000,
        TextTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 1, 0),
        FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold),
        Text = "Soulware Loader",
        TextColor3 = Color3.fromRGB(85, 123, 198),
        TextScaled = false,
        TextSize = 14.000,
        TextWrapped = true
    })

    function loader:load()
        local backgroundTweenShow = tweenService:Create(background, info, {BackgroundTransparency = 0})
        backgroundTweenShow:Play()

        local titleTweenShow = tweenService:Create(title, info, {TextTransparency = 0})
        titleTweenShow:Play()

        local strokeTweenShow = tweenService:Create(stroke, info, {Transparency = 0})
        strokeTweenShow:Play()

        local dropShadowTweenShow = tweenService:Create(dropShadow, info, {ImageTransparency = 0.6})
        dropShadowTweenShow:Play()

        local cornerTweenIn = tweenService:Create(corner, info, {CornerRadius = UDim.new(0, 15)})
        cornerTweenIn:Play()

        local textSizeIn = tweenService:Create(title, info, {TextSize = 25})
        textSizeIn:Play()
    end

    function loader:unload()
        title.Text = "Loaded"

        task.wait(1)

        local backgroundTweenHide = tweenService:Create(background, info, {BackgroundTransparency = 1})
        backgroundTweenHide:Play()

        local titleTweenHide = tweenService:Create(title, info, {TextTransparency = 1})
        titleTweenHide:Play()

        local strokeTweenHide = tweenService:Create(stroke, info, {Transparency = 1})
        strokeTweenHide:Play()

        local dropShadowTweenHide = tweenService:Create(dropShadow, info, {ImageTransparency = 1})
        dropShadowTweenHide:Play()

        local cornerTweenOut = tweenService:Create(corner, info, {CornerRadius = UDim.new(0, 5)})
        cornerTweenOut:Play()

        local textSizeOut = tweenService:Create(title, info, {TextSize = 20})
        textSizeOut:Play()
    end

    
    return loader
end

local loader = loaderLibrary:createLoader()
loader:load()
task.wait(math.random(1, 5))
loader:unload()

local Window = Library:CreateWindow({
    Title = 'Soulware',
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
    SelectedMethod = "Closest",
    PlayerFarm = false,
    PlayerFarmRange = 10,
    PlayerFarmOffset = 0,
    PlayerFarmMethod = "Above",
    Strength = false,
    Stamina = false,
    Defense = false,
    GunMastery = false,
    SwordMastery = false,
    Start = false,
    SelectedIsland = nil,
    SelectedIslandMethod = "Air",
    Tween =  nil,
    TweenOngoing = false,
    SafeMode = false,
    AnticheatBypass = false,
    TweenSpeed = 70,
    AutoQuest = false,
    SelectedQuest = nil,
    Position = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame,
    WalkSpeed = false,
    WalkSpeedAmount = 150,
    JumpPower = false,
    JumpPowerAmount = 70,
    NoClip = false,
    NoRagdoll = false,
    NoStun = false,
    NoFallDamage = false,
    NoDrown = false,
    NoDrownPart = nil,
    FastM1 = false,
    CharacterOffset = false,
    GetGeppo = false,
    CharacterOffsetAnimation = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(game:GetService("ReplicatedStorage").Effects.BossAwakens.DemonAwaken.awaken)
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
                pcall(function()
                    TweenTo(GetClosestChest().CFrame, getgenv().ScriptOptions.TweenSpeed, Vector3.new(0, 5, 0))
                    fireclickdetector(GetClosestChest().ClickDetector)
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

local NPCs = game.Workspace.NPCs

local GetEnemies = function()
	local enemies = {}
    table.insert(enemies, "")

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
            pcall(function()
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
        end
    end
})

AutoFarmGroupBox:AddDropdown('MyDropdown', {
    Values = {"Selected", "Closest"},
    Default = 2,
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

AutoFarmGroupBox:AddButton({
    Text = 'Teleport to Fishman Island',
    Func = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(5639.86865, -92.762001, -16611.4688)
    end,
    DoubleClick = false,
    Tooltip = 'Teleport to Fishman Island'
})

AutoFarmGroupBox:AddButton({
    Text = 'Get World Scroll',
    Func = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-12186.1064453125, 0.42061471939086914, -18545.76953125)
        task.wait(.4)
        fireproximityprompt(workspace.Effects:WaitForChild("World Scroll").ProximityPrompt)
    end,
    DoubleClick = false,
    Tooltip = 'Get World Scroll'
})

local PlayerFarmGroupBox = Tabs.Main:AddLeftGroupbox('Player Farm')

local GetClosestToCharacter = function(MaxDistance)
    local ClosestPlayer = nil
    local ClosestDistance = math.huge

    for _,player in next, game.Players:GetPlayers() do
		pcall(function()
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid").Health > 0 then
                local Distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
    
                if Distance < ClosestDistance and Distance <= MaxDistance then
                    ClosestPlayer = player
                    ClosestDistance = Distance
                end
            end
        end)
	end

    return ClosestPlayer
end

PlayerFarmGroupBox:AddToggle('MyToggle', {
    Text = 'Player Farm',
    Default = false,
    Tooltip = 'Player Farm',

    Callback = function(Value)
        getgenv().ScriptOptions.PlayerFarm = Value

        while getgenv().ScriptOptions.PlayerFarm do task.wait()
            pcall(function()
                if getgenv().ScriptOptions.PlayerFarmMethod == "Above" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GetClosestToCharacter(getgenv().ScriptOptions.PlayerFarmRange).Character.HumanoidRootPart.CFrame + Vector3.new(0, getgenv().ScriptOptions.PlayerFarmOffset, 0)
                elseif getgenv().ScriptOptions.PlayerFarmMethod == "Below" then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GetClosestToCharacter(getgenv().ScriptOptions.PlayerFarmRange).Character.HumanoidRootPart.CFrame - Vector3.new(0, getgenv().ScriptOptions.PlayerFarmOffset, 0)
                end
            end)
        end
    end
}):AddKeyPicker('KeyPicker', {
    Default = 'nil',
    SyncToggleState = true,



    Mode = 'Toggle',

    Text = 'Player Farm',
    NoUI = false,

    Callback = function(Value)
        
    end,

    ChangedCallback = function(New)
        
    end
})

PlayerFarmGroupBox:AddSlider('MySlider', {
    Text = 'Range',
    Default = 10,
    Min = 10,
    Max = 30,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        getgenv().ScriptOptions.PlayerFarmRange = Value
    end
})

PlayerFarmGroupBox:AddSlider('MySlider', {
    Text = 'Offset',
    Default = 0,
    Min = 0,
    Max = 10,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        getgenv().ScriptOptions.PlayerFarmOffset = Value
    end
})

PlayerFarmGroupBox:AddDropdown('MyDropdown', {
    Values = {"Above", "Below"},
    Default = 1,
    Multi = false,

    Text = 'Select Method',
    Tooltip = 'Select Method',

    Callback = function(Value)
        getgenv().ScriptOptions.PlayerFarmMethod = Value
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

local TeleportsGroupBox = Tabs.Main:AddLeftGroupbox('Teleports')

local GetIslands = function()
    local islands = {}

    for _,island in next, workspace.Islands:GetChildren() do
        if not table.find(islands, island.Name) then
            table.insert(islands, island.Name)
        end
    end

    return islands
end

TeleportsGroupBox:AddToggle('MyToggle', {
    Text = 'Start',
    Default = false,
    Tooltip = 'Start',

    Callback = function(Value)
        getgenv().ScriptOptions.Start = Value
        if getgenv().ScriptOptions.Start then
            pcall(function()
                if getgenv().ScriptOptions.SelectedIslandMethod == "Air" then
                    local Position = CFrame.new(workspace.Islands[getgenv().ScriptOptions.SelectedIsland]:GetAttribute("islandPosition"))
                    local NewPosition = CFrame.new(Position.X, 15, Position.Z)
                    
                    if game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position.Y ~= 15 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, 15, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)
                    end

                    TweenTo(NewPosition, getgenv().ScriptOptions.TweenSpeed, Vector3.new(0, 0, 0))
                elseif getgenv().ScriptOptions.SelectedIslandMethod == "Swim" then
                    local Position = CFrame.new(workspace.Islands[getgenv().ScriptOptions.SelectedIsland]:GetAttribute("islandPosition"))
                    local NewPosition = CFrame.new(Position.X, -2.7, Position.Z)
                    
                    if game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position.Y ~= -2.7 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(game.Players.LocalPlayer.Character.HumanoidRootPart.Position.X, -2.7, game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Z)
                    end

                    TweenTo(NewPosition, getgenv().ScriptOptions.TweenSpeed, Vector3.new(0, 0, 0))
                end
            end)
        else
            if getgenv().ScriptOptions.TweenOngoing then
                getgenv().ScriptOptions.Tween:Cancel()
            end
        end
    end
})

TeleportsGroupBox:AddDropdown('MyDropdown', {
    Values = GetIslands(),
    Default = 1,
    Multi = false,

    Text = 'Select Island',
    Tooltip = 'Select Island',

    Callback = function(Value)
        getgenv().ScriptOptions.SelectedIsland = Value
    end
})

TeleportsGroupBox:AddDropdown('MyDropdown', {
    Values = {"Air", "Swim"},
    Default = 1,
    Multi = false,

    Text = 'Select Method',
    Tooltip = 'Select Method',

    Callback = function(Value)
        getgenv().ScriptOptions.SelectedIslandMethod = Value
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
    Default = 70,
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
    table.insert(quests, "-")

    for _,npc in next, NPCs:GetChildren() do
        if npc:FindFirstChild("ForceField") and npc:FindFirstChild("QuestMark") and npc:FindFirstChild("HumanoidRootPart") then
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
                        TweenTo(workspace.NPCs[getgenv().ScriptOptions.SelectedQuest].HumanoidRootPart.CFrame, getgenv().ScriptOptions.TweenSpeed, Vector3.new(0, 3, 0))
                        keypress(Enum.KeyCode.T)
                        firesignal(game:GetService("Players").LocalPlayer.PlayerGui.NPCCHAT.Frame.go.MouseButton1Click)
                        firesignal(game:GetService("Players").LocalPlayer.PlayerGui.NPCCHAT.Frame.endChat.MouseButton1Click)
                    else
                        pcall(function()
                            firesignal(game:GetService("Players").LocalPlayer.PlayerGui.NPCCHAT.Frame.endChat.MouseButton1Click)
                        end)
                        TweenTo(getgenv().ScriptOptions.Position, getgenv().ScriptOptions.TweenSpeed, Vector3.new(0, 0, 0))
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
    Max = 300,
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

LocalPlayerGroupBox:AddToggle('MyToggle', {
    Text = 'No Clip',
    Default = false,
    Tooltip = 'No Clip',

    Callback = function(Value)
        getgenv().ScriptOptions.NoClip = Value

        if getgenv().ScriptOptions.NoClip then
            while getgenv().ScriptOptions.NoClip do task.wait()
                game.Players.LocalPlayer.Character.HumanoidRootPart.CanCollide = false
                game.Players.LocalPlayer.Character.UpperTorso.CanCollide = false
                game.Players.LocalPlayer.Character.LowerTorso.CanCollide = false
            end
        else
            task.wait()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CanCollide = true
            game.Players.LocalPlayer.Character.UpperTorso.CanCollide = true
            game.Players.LocalPlayer.Character.LowerTorso.CanCollide = true
        end
    end
})

LocalPlayerGroupBox:AddToggle('MyToggle', {
    Text = 'No Ragdoll',
    Default = false,
    Tooltip = 'No Ragdoll',

    Callback = function(Value)
        getgenv().ScriptOptions.NoRagdoll = Value

        if getgenv().ScriptOptions.NoRagdoll then
            getconnections(game:GetService("ReplicatedStorage").Events.Ragdoll.OnClientEvent)[1]:Disable()
        else
            getconnections(game:GetService("ReplicatedStorage").Events.Ragdoll.OnClientEvent)[1]:Enable()
        end
    end
})

LocalPlayerGroupBox:AddToggle('MyToggle', {
    Text = 'No Stun',
    Default = false,
    Tooltip = 'No Stun',

    Callback = function(Value)
        getgenv().ScriptOptions.NoStun = Value

        while getgenv().ScriptOptions.NoStun do task.wait()
            pcall(function()
                game.Players.LocalPlayer.Character.Stun:Remove()
                game.Players.LocalPlayer.Character.HumanoidRootPart.knockback:Remove()
            end)
        end
    end
})

LocalPlayerGroupBox:AddToggle('MyToggle', {
    Text = 'No Fall Damage',
    Default = false,
    Tooltip = 'No Fall Damage',

    Callback = function(Value)
        getgenv().ScriptOptions.NoFallDamage = Value

        if getgenv().ScriptOptions.NoFallDamage then
            game.Players.LocalPlayer.Character.FallDamage.Disabled = true
        else
            game.Players.LocalPlayer.Character.FallDamage.Disabled = false
        end
    end
})

LocalPlayerGroupBox:AddToggle('MyToggle', {
    Text = 'No Drown',
    Default = false,
    Tooltip = 'No Drown',

    Callback = function(Value)
        getgenv().ScriptOptions.NoDrown = Value

        if getgenv().ScriptOptions.NoDrown then
            if game.Players.LocalPlayer.Character:FindFirstChild("coatBubble") then
                game.Players.LocalPlayer.Character.coatBubble:Remove()
            else
                getgenv().ScriptOptions.NoDrownPart = Instance.new("Part", game.Players.LocalPlayer.Character)
                getgenv().ScriptOptions.NoDrownPart.Name = "coatBubble"
            end
        else
            getgenv().ScriptOptions.NoDrownPart:Remove()
        end
    end
})

LocalPlayerGroupBox:AddToggle('MyToggle', {
    Text = 'Fast M1',
    Default = false,
    Tooltip = 'No Drown',

    Callback = function(Value)
        getgenv().ScriptOptions.FastM1 = Value

        while getgenv().ScriptOptions.FastM1 do task.wait()
            getrenv()._G.resetM1()
        end
    end
})

LocalPlayerGroupBox:AddToggle('MyToggle', {
    Text = 'Character Offset',
    Default = false,
    Tooltip = 'Character Offset',

    Callback = function(Value)
        getgenv().ScriptOptions.CharacterOffset = Value

        if getgenv().ScriptOptions.CharacterOffset then
            getgenv().ScriptOptions.CharacterOffsetAnimation:Play()
            getgenv().ScriptOptions.CharacterOffsetAnimation:AdjustSpeed(10)
            task.wait(.35)
            getgenv().ScriptOptions.CharacterOffsetAnimation:AdjustSpeed(0)
            getgenv().ScriptOptions.CharacterOffsetAnimation.Priority = Enum.AnimationPriority.Action4
        else
            getgenv().ScriptOptions.CharacterOffsetAnimation:Stop()
        end
    end
}):AddKeyPicker('KeyPicker', {
    Default = 'nil',
    SyncToggleState = true,



    Mode = 'Toggle',

    Text = 'Player Farm',
    NoUI = false,

    Callback = function(Value)
        
    end,

    ChangedCallback = function(New)
        
    end
})

LocalPlayerGroupBox:AddToggle('MyToggle', {
    Text = 'Get Geppo',
    Default = false,
    Tooltip = 'Get Geppo',

    Callback = function(Value)
        getgenv().ScriptOptions.GetGeppo = Value

        if getgenv().ScriptOptions.GetGeppo then
            game:GetService("ReplicatedStorage")['Stats'..game.Players.LocalPlayer.Name].Skills.skyWalk.Value = true
        else
            game:GetService("ReplicatedStorage")['Stats'..game.Players.LocalPlayer.Name].Skills.skyWalk.Value = false
        end
    end
})

local GetClosestPlayerToCursor = function()
	local ClosestPlayer = nil
	local ClosestDistance = math.huge

	for _,player in next, game.Players:GetPlayers() do
		pcall(function()
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid").Health > 0 then
                local Vector = workspace.CurrentCamera:WorldToScreenPoint(player.Character.Head.Position)
                local Distance = Vector2.new(game:GetService("UserInputService"):GetMouseLocation().X - Vector.X, game:GetService("UserInputService"):GetMouseLocation().Y - Vector.Y).Magnitude
    
                if Distance < ClosestDistance and Distance then
                    ClosestPlayer = player
                    ClosestDistance = Distance
                end
            end
        end)
	end

	return ClosestPlayer
end

Library:OnUnload(function()

    for _,value in next, getgenv().ScriptOptions do
        if type(value) == "boolean" then
            value = false
        end
    end

    if getgenv().ScriptOptions.TweenOngoing then
        getgenv().ScriptOptions.Tween:Cancel()
    end

    getgenv().ScriptOptions.CharacterOffsetAnimation:Stop()

    getgenv().Loaded = false
    Library.Unloaded = true
end)

-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)

MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'LeftBracket', NoUI = true, Text = 'Menu keybind' })

MenuGroup:AddToggle('MyToggle', {
    Text = 'Show Keybinds',
    Default = false,
    Tooltip = 'Show Keybinds',

    Callback = function(Value)
        Library.KeybindFrame.Visible = Value
    end
})

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
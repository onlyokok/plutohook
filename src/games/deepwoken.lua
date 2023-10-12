pcall(function()
    if getgenv().Executed then return end
    getgenv().Executed = true

    local Repository = "https://raw.githubusercontent.com/onlyokok/plutohook/main/src/"
    local Library = loadstring(game:HttpGet(Repository.."linorias/source.lua"))()
    local ThemeManager = loadstring(game:HttpGet(Repository.."linorias/thememanager.lua"))()
    local SaveManager = loadstring(game:HttpGet(Repository.."linorias/savemanager.lua"))()

    local Window = Library:CreateWindow({
        Title = 'Project Pluto',
        Center = true,
        AutoShow = true,
        TabPadding = 10,
        MenuFadeTime = 0.2
    })

    getgenv().ScriptOptions = {
        Fly = false,
        FlySpeed = 50,
        WalkSpeed = false,
        Speed = 1,
        InfiniteJump = false,
        Velocity = 150,
        NoFallDamage = false
    }

    local Tabs = {
        Main = Window:AddTab('DeepWoken'),
        ['UI Settings'] = Window:AddTab('Settings')
    }

    -- Local Player Group Box
    local LocalPlayerGroupBox = Tabs.Main:AddLeftGroupbox('Local Player')

    LocalPlayerGroupBox:AddToggle('MyToggle', {
        Text = 'Fly',
        Default = false,
        Tooltip = 'Fly',
    
        Callback = function(Value)
            getgenv().ScriptOptions.Fly = Value
            while getgenv().ScriptOptions.Fly do task.wait()
                pcall(function()
                    local Velocity = Vector3.new(0, 5, 0)
                    if not game:GetService("UserInputService"):GetFocusedTextBox() then
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                            Velocity += (workspace.CurrentCamera.CFrame.LookVector * getgenv().ScriptOptions.FlySpeed)
                        end
                
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                            Velocity += (workspace.CurrentCamera.CFrame.LookVector * -getgenv().ScriptOptions.FlySpeed)
                        end
                
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                            Velocity += (workspace.CurrentCamera.CFrame.RightVector * -getgenv().ScriptOptions.FlySpeed)
                        end
                
                        if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                            Velocity += (workspace.CurrentCamera.CFrame.RightVector * getgenv().ScriptOptions.FlySpeed)
                        end
                    end
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Velocity
                end)
            end
        end
    }):AddKeyPicker('KeyPicker', {
        Default = '',
        SyncToggleState = true,
    
    

        Mode = 'Toggle',
    
        Text = 'Fly',
        NoUI = false,
    
        Callback = function(Value)
            
        end,
    
        ChangedCallback = function(New)
            
        end
    })

    LocalPlayerGroupBox:AddToggle('MyToggle', {
        Text = 'Walk Speed',
        Default = false,
        Tooltip = 'Walk Speed',
    
        Callback = function(Value)
            getgenv().ScriptOptions.WalkSpeed = Value
            while getgenv().ScriptOptions.WalkSpeed do task.wait()
                pcall(function()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame += game.Players.LocalPlayer.Character.Humanoid.MoveDirection * getgenv().ScriptOptions.Speed
                end)
            end
        end
    }):AddKeyPicker('KeyPicker', {
        Default = '',
        SyncToggleState = true,
    
    

        Mode = 'Toggle',
    
        Text = 'Walk Speed',
        NoUI = false,
    
        Callback = function(Value)
            
        end,
    
        ChangedCallback = function(New)
            
        end
    })

    LocalPlayerGroupBox:AddToggle('MyToggle', {
        Text = 'Infinite Jump',
        Default = false,
        Tooltip = 'Infinite Jump',
    
        Callback = function(Value)
            getgenv().ScriptOptions.InfiniteJump = Value
            game:GetService("UserInputService").InputBegan:Connect(function(Input, Processed)
                pcall(function()
                    if Processed then return end
                    if Input.KeyCode == Enum.KeyCode.Space then
                        if getgenv().ScriptOptions.InfiniteJump then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, getgenv().ScriptOptions.Velocity, 0)
                        end
                    end
                end)
            end)
        end
    }):AddKeyPicker('KeyPicker', {
        Default = '',
        SyncToggleState = true,
    
    

        Mode = 'Toggle',
    
        Text = 'Infinite Jump',
        NoUI = false,
    
        Callback = function(Value)
            
        end,
    
        ChangedCallback = function(New)
            
        end
    })

    LocalPlayerGroupBox:AddToggle('MyToggle', {
        Text = 'No Fall Damage',
        Default = false,
        Tooltip = 'No Fall Damage',
    
        Callback = function(Value)
            getgenv().ScriptOptions.NoFallDamage = Value
        end
    })

    LocalPlayerGroupBox:AddSlider('MySlider', {
        Text = 'Fly',
        Default = 50,
        Min = 50,
        Max = 250,
        Rounding = 1,
        Compact = false,
    
        Callback = function(Value)
            getgenv().ScriptOptions.FlySpeed = Value
        end
    })

    LocalPlayerGroupBox:AddSlider('MySlider', {
        Text = 'Walk Speed',
        Default = 10,
        Min = 1,
        Max = 25,
        Rounding = 1,
        Compact = false,
    
        Callback = function(Value)
            getgenv().ScriptOptions.Speed = Value / 10
        end
    })

    LocalPlayerGroupBox:AddSlider('MySlider', {
        Text = 'Infinite Jump',
        Default = 120,
        Min = 100,
        Max = 200,
        Rounding = 1,
        Compact = false,
    
        Callback = function(Value)
            getgenv().ScriptOptions.Velocity = Value
        end
    })

    -- Hooks / Connection Removals / Prevents client printing to the console

    pcall(function()
        for i,v in next, getconnections(game:GetService("ScriptContext").Error) do
            v:Disable()
        end
        for i,v in next, getconnections(game:GetService("LogService").MessageOut) do
            v:Disable()
        end
    end)

    pcall(function()
        local x;
        x = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
            local args = {...}
            if type(args[1]) == "number" and type(args[2]) == "boolean" then
                if getgenv().ScriptOptions.NoFallDamage then
                    return
                end
            end
            return x(self, ...)
        end))
    end)

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

        print('Unloaded!')
        Library.Unloaded = true
    end)

    -- UI Settings
    local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

    -- I set NoUI so it does not show up in the keybinds menu
    MenuGroup:AddButton('Unload', function() 
        for _,v in next, getgenv().ScriptOptions do
            if type(v) == "boolean" then
                v = false
            end
        end
        getgenv().Executed = false
        Library:Unload() 
    end)
    
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
    SaveManager:SetFolder('Project Pluto/DeepWoken')

    -- Builds our config menu on the right side of our tab
    SaveManager:BuildConfigSection(Tabs['UI Settings'])

    -- Builds our theme menu (with plenty of built in themes) on the left side
    -- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
    ThemeManager:ApplyToTab(Tabs['UI Settings'])

    -- You can use the SaveManager:LoadAutoloadConfig() to load a config
    -- which has been marked to be one that auto loads!
    SaveManager:LoadAutoloadConfig()

end)
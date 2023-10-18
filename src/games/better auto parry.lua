local getBall = function()
    local realBall

    for _,v in next, workspace.Balls:GetChildren() do
        if v:GetAttribute("realBall") and v:GetAttribute("realBall") == true then
            realBall = v
        end
    end

    return realBall
end

local isTarget = function()
    if getBall():GetAttribute("target") == game.Players.LocalPlayer.Name or game.Players.LocalPlayer.Character:FindFirstChild("Highlight") then
        return true
    else
        return false
    end
end

local getDistance = function()
    return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getBall().Position).Magnitude
end

local getVelocity = function()
    return getBall().Velocity
end

local getTimeBeforeImpact = function()
    return getDistance() / getVelocity().Magnitude
end

local visualizer = Instance.new("Part", workspace)
visualizer.Material = Enum.Material.ForceField
visualizer.Color = Color3.new(1, 1, 1)
visualizer.CanCollide = false
visualizer.Shape = "Ball"
visualizer.CastShadow = false

game.Lighting.ClockTime = 4

game:GetService("RunService").RenderStepped:Connect(function()
    pcall(function()
        visualizer.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

        if (getVelocity().Magnitude / 2) < 25 then
            visualizer.Size = Vector3.new(20, 20, 20)
        else
            visualizer.Size = Vector3.new(getVelocity().Magnitude / 2.5, getVelocity().Magnitude / 2.5, getVelocity().Magnitude / 2.5)
        end

        if getDistance() <= visualizer.Size.Z / 2 and isTarget() then
            keypress(Enum.KeyCode.F)
        end
    end)
end)

task.spawn(function()
    while task.wait() do
        pcall(function()
            for _,v in next, game.Players:GetPlayers() do
                if v ~= game.Players.LocalPlayer then
                    local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude

                    if distance() <= 1.5 and getDistance() <= 1.5 then
                        if isTarget() or v.Character:FindFirstChild("Highlight") then
                            for i = 1,300 do
                                keypress(Enum.KeyCode.F)
                            end
                        end
                    elseif distance <= 3 and getDistance() <= 3 then
                        if isTarget() or v.Character:FindFirstChild("Highlight") then
                            for i = 1,110 do
                                keypress(Enum.KeyCode.F)
                            end
                        end
                    elseif distance <= 7 and getDistance() <= 7 then
                        if isTarget() or v.Character:FindFirstChild("Highlight") then
                            for i = 1,8 do
                                keypress(Enum.KeyCode.F)
                            end
                        end
                    end
                end
            end
        end)
    end
end)

x = hookmetamethod(game, "__namecall", function(self, ...)
	local m = getnamecallmethod()
	local args = {...}
	if self.Name == "Parried" and m == "Play" then
		self.SoundId = "rbxassetid://7512929338"
	end
	return x(self, ...)
end)
	
_G.curveBall = true

local ballCframe = nil

task.spawn(function()
	while task.wait() do
		pcall(function()
			ballCframe = workspace.Balls:FindFirstChildOfClass("Part").CFrame
		end)
	end
end)

z = hookmetamethod(game, "__namecall", function(self, ...)
	local args = {...}
	local method = getnamecallmethod()
	if tostring(self) == "ParryAttempt" and method == "FireServer" then
		if _G.curveBall then
            args[2] = ballCframe
            args[4][1] = game:GetService("UserInputService"):GetMouseLocation().X
            args[4][2] = game:GetService("UserInputService"):GetMouseLocation().Y
            return self.FireServer(self, unpack(args))
        end
	end
	return z(self, ...)
end)
local getBall = function()
    local realBall
    for _,v in next, workspace.Balls:GetChildren() do
        if v:GetAttribute("realBall") == true then
            realBall = v
        end
    end
    return realBall
end

local isTarget = function()
    if game.Players.LocalPlayer.Character:FindFirstChild("Highlight") then
        return true
    else
        return false
    end
end

local getDistance = function()
    return (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - getBall().Position).Magnitude
end

local getSpeed = function()
    return math.sqrt(getBall().Velocity.X ^ 2 + getBall().Velocity.Y ^ 2 + getBall().Velocity.Z ^ 2)
end

local getTimeBeforeImpact = function()
    return getDistance() / getSpeed()
end

local visualizer = Instance.new("Part", workspace)
visualizer.Material = Enum.Material.ForceField
visualizer.Color = Color3.new(1, 0, 1)
visualizer.Size = Vector3.new(.05, .05, .05)
visualizer.CanCollide = false
visualizer.CastShadow = false
visualizer.Shape = "Ball"

task.spawn(function()
	while task.wait() do
		pcall(function()
			visualizer.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			visualizer.Size = Vector3.new(getTimeBeforeImpact() * 7, getTimeBeforeImpact() * 7, getTimeBeforeImpact() * 7)

			if (getTimeBeforeImpact() <= 0.25) and (isTarget())  then
				keypress(Enum.KeyCode.F)
			end	
		end)
	end
end)

task.spawn(function()
	game:GetService("RunService").RenderStepped:Connect(function()
		for _,v in next, game.Players:GetPlayers() do
			pcall(function()
				local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
				if (distance < 5 and getDistance() < 5) and isTarget() and (getTimeBeforeImpact() < 0.23) then
					local args = {
						[1] = 0/0,
						[2] = CFrame.new(0/0, 0/0, 0/0),
						[3] = {},
						[4] = {
							[1] = 0/0,
							[2] = 0/0
						}
					}
					
					game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ParryAttempt"):FireServer(unpack(args))
				end
			end)
		end
	end)
end)

x = hookmetamethod(game, "__namecall", function(self, ...)
	local m = getnamecallmethod()
	local args = {...}
	if self.Name == "Parried" and m == "Play" then
		self.SoundId = "rbxassetid://7204949322"
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
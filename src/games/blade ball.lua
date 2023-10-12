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

local visualizer = Instance.new("MeshPart", workspace)
visualizer.MeshId = "rbxassetid://471124075"
visualizer.Material = Enum.Material.ForceField
visualizer.Color = Color3.new(1, 0, 1)
visualizer.Size = Vector3.new(.05, .05, .05)
visualizer.CanCollide = false
visualizer.CastShadow = false

task.spawn(function()
	while task.wait() do
		pcall(function()
			visualizer.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			visualizer.Size = Vector3.new(getTimeBeforeImpact() / 25, getTimeBeforeImpact() / 25, getTimeBeforeImpact() / 25)
			if (getTimeBeforeImpact() < 0.23) and (isTarget()) then
				keypress(Enum.KeyCode.F)
			end
		end)
	end
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
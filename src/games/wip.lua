getgenv().library = {
    enabled = true,
    textColor = Color3.new(1, 1, 1),
    tracerOrigin = "Bottom", -- options = {"Bottom", "Middle", "Top", "Cursor"}
    highlight = true,
    highlightColor = Color3.new(0, 0, 1),
    font = 2,
    textSize = 14,
    cache = {},
    connections = {}
}

function library.new(obj, properties)
    -- creating drawing instance
    local object = Drawing.new(obj)
    local props = properties or {}

    -- applying properties
    for property, value in next, properties do
        object[property] = value
    end

    -- returning the instance
    return object
end

function library:getDistance(obj)
    local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude
    return distance
end

function library:getTeam(plr)
    return game.Players[plr].Team
end

function library:getTeamColor(plr)
    return game.Players[plr].TeamColor
end

function library:getTeammates()
    local players = {}

    for _, player in next, game:GetService("Players"):GetPlayers() do
        if player and player.Team == game.Players.LocalPlayer.Team then
            table.insert(players, player.Name)
        end
    end

    return players
end

function library:getPlayerFromCharacter(char)
    return game.Players:GetPlayerFromCharacter(char)
end

function library:isObjectNearCursor(obj, range)
    -- return ending if the object doesnt exist
    if obj == nil then return end

    -- variables for positions
    local objectPosition = workspace.CurrentCamera:WorldToScreenPoint(obj.Position)
    local cursorPosition = game:GetService("UserInputService"):GetMouseLocation()
    -- getting the screen distance
    local distance = (Vector2.new(cursorPosition.X, cursorPosition.Y) - Vector2.new(objectPosition.X, objectPosition.Y)).Magnitude

    -- checking if its within range and returning true or false
    if distance <= range then
        return true
    else
        return false
    end
end

function library:addText(obj, text)
    local text = self.new("Text", {
        Text = text,
        Center = true,
        Color = self.textColor,
        Font = self.font,
        Size = self.textSize,
        Outline = true
    })

    table.insert(self.cache, text)

    local object;
    local vector, onScreen;

    -- creating the connection
    local connection = game:GetService("RunService").RenderStepped:Connect(function()
        object = obj

        local nilInstances = getnilinstances()

        local function doesObjectExist()
            if not table.find(nilInstances, object) then
                return true
            else
                return false
            end
        end

        if self.enabled then
            if doesObjectExist() then
                vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(object.Position)
                text.Position = Vector2.new(vector.x, vector.y)

                if self.highlight then
                    if library:isObjectNearCursor(object, 100) then
                        text.Color = self.highlightColor
                    else
                        text.Color = self.textColor
                    end
                else
                    text.Color = self.textColor
                end

                if onScreen then
                    text.Visible = true
                else
                    text.Visible = false
                end
            else
                text:Remove()
            end
        else
            text.Visible = false
        end
    end)

    -- inserting the text's update connection so that it can be disconnected if needed
    table.insert(self.connections, connection)

    return text
end

function library:addTracer(obj)
    local tracer = self.new("Line", {
        Thickness = 1,
        Color = self.textColor,
    })

    table.insert(self.cache, tracer)

    local object;
    local vector, onScreen;

    -- creating the connection
    local connection = game:GetService("RunService").RenderStepped:Connect(function()
        object = obj

        local nilInstances = getnilinstances()

        local function doesObjectExist()
            if not table.find(nilInstances, object) then
                return true
            else
                return false
            end
        end

        if self.enabled then
            if doesObjectExist() then
                vector, onScreen = workspace.CurrentCamera:WorldToViewportPoint(object.Position)

                if self.tracerOrigin == "Bottom" then
                    tracer.From = Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 1)
                end

                tracer.To = Vector2.new(vector.x, vector.y)

                if self.highlight then
                    if library:isObjectNearCursor(object, 100) then
                        tracer.Color = self.highlightColor
                    else
                        tracer.Color = self.textColor
                    end 
                else
                    tracer.Color = self.textColor
                end

                if onScreen then
                    tracer.Visible = true
                else
                    tracer.Visible = false
                end
            else
                tracer:Remove()
            end
        else
            tracer.Visible = false
        end
    end)

    -- inserting the tracers update connection so that it can be disconnected if needed
    table.insert(self.connections, connection)

    return tracer
end

function library:unload()
    for _, connection in next, self.connections do
        connection:Disconnect()
    end
    for _, object in next, self.cache do
        object.Visible = false
        object:Remove()
    end
end

for i,v in next, game.Players:GetChildren() do
	if v and v.Character and v.Character.Head and v ~= game.Players.LocalPlayer then
        library:addText(v.Character.Head, "["..v.Name.."]["..v.Character.Humanoid.Health.."/"..v.Character.Humanoid.MaxHealth.."]")
        library:addTracer(v.Character.HumanoidRootPart)
    end
end

game.Players.PlayerAdded:Connect(function(v)
    if v.Character and v.Character.HumanoidRootPart and v.Character.Head then
        library:addText(v.Character.Head, "["..v.Name.."]["..v.Character.Humanoid.Health.."/"..v.Character.Humanoid.MaxHealth.."]")
        library:addTracer(v.Character.HumanoidRootPart)
    end
    v.CharacterAdded:Connect(function(c)
        library:addText(c.Head, "["..v.Name.."]["..c.Humanoid.Health.."/"..c.Humanoid.MaxHealth.."]")
        library:addTracer(c.HumanoidRootPart)
    end)
end)
setfpscap(1000)
local function applyESP(config)
    -- Highlight
    local highlight = Instance.new("Highlight")
    highlight.Adornee = config.Adornee
    highlight.Parent = config.Parent
    highlight.FillColor = config.highlightColor.Fill
    highlight.OutlineColor = config.highlightColor.Outline
    highlight.Name = "ESPHighlight"
    
    -- Tracer (simple implementation using a line)
    if config.tracer then
        local tracer = Instance.new("Part")
        tracer.Anchored = true
        tracer.CanCollide = false
        tracer.Size = Vector3.new(0.1, 0.1, (config.Adornee.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
        tracer.CFrame = CFrame.new(config.Adornee.Position, game.Players.LocalPlayer.Character.HumanoidRootPart.Position) * CFrame.new(0, 0, -tracer.Size.Z/2)
        tracer.Color = config.highlightColor.Fill
        tracer.Name = "ESPTracer"
        tracer.Parent = config.Parent
    end
    
    -- Rainbow mode
    if config.rainbow then
        local step = 0
        game:GetService("RunService").RenderStepped:Connect(function()
            step = step + 1
            highlight.FillColor = Color3.fromHSV(step % 100 / 100, 1, 1)
        end)
    end
    
    -- Show distance
    if config.showDistance then
        local distanceLabel = Instance.new("BillboardGui")
        distanceLabel.Adornee = config.Adornee
        distanceLabel.Size = UDim2.new(2, 0, 1, 0)
        distanceLabel.StudsOffset = Vector3.new(0, 1, 0)
        distanceLabel.Name = "ESPDLabel"
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.new(1, 1, 1)
        textLabel.Font = config.font
        textLabel.Text = tostring(math.floor((config.Adornee.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude))
        textLabel.Parent = distanceLabel
        distanceLabel.Parent = config.Parent
    end
    
    -- Display model name on top
    local nameLabel = Instance.new("BillboardGui")
    nameLabel.Adornee = config.Adornee
    nameLabel.Size = UDim2.new(2, 0, 1, 0)
    nameLabel.StudsOffset = Vector3.new(0, 3, 0)
    nameLabel.Name = "ESPNameLabel"
    local nameText = Instance.new("TextLabel")
    nameText.Size = UDim2.new(1, 0, 1, 0)
    nameText.BackgroundTransparency = 1
    nameText.TextColor3 = Color3.new(1, 1, 1)
    nameText.Font = config.font
    nameText.Text = config.display
    nameText.Parent = nameLabel
    nameLabel.Parent = config.Parent
end

-- Remove highlight example
local function removeESP(model)
    for _, v in pairs(model:GetChildren()) do
        if v:IsA("Highlight") or v:IsA("Part") or v:IsA("BillboardGui") then
            v:Destroy()
        end
    end
end

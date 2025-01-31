local library = loadstring(game.HttpGet(game, "https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/0x"))()

local w1 = library:Window("Simple Experience") -- 更新窗口名称

w1:Slider(
    "WalkSpeed",
    "WS",
    16,
    300,
    function(value)
        spawn(function()
            while wait(0.1) do
                if game.Players.LocalPlayer and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
                end
            end
        end)
    end,
    22 -- 设置默认速度为 22
) -- Text, Flag, Minimum, Maximum, Callback, Default (Optional), Flag Location (Optional)

w1:Slider(
    "JumpPower",
    "JP",
    50,
    300,
    function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end,
    100
) -- Text, Flag, Minimum, Maximum, Callback, Default (Optional), Flag Location (Optional)

-- 新的自动 Swing 和 Infect toggles
local swingBottleEnabled = false
local swingBranchEnabled = false
local infectEnabled = false
local swingKatanaEnabled = false
local swingSpearEnabled = false
local espEnabled = false
w1:Toggle(
    "Auto Swing Bottle",
    "swingBottle",
    false,
    function(toggled)
        swingBottleEnabled = toggled
        if swingBottleEnabled then
            spawn(function()
                while swingBottleEnabled do
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character and character:FindFirstChild("Bottle") and character.Bottle:FindFirstChild("SwingEvent") then
                        character.Bottle.SwingEvent:FireServer()
                    end
                    wait(0.1)
                end
            end)
        end
    end
)

w1:Toggle(
    "Auto Swing Branch",
    "swingBranch",
    false,
    function(toggled)
        swingBranchEnabled = toggled
        if swingBranchEnabled then
            spawn(function()
                while swingBranchEnabled do
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character and character:FindFirstChild("Branch") and character.Branch:FindFirstChild("SwingEvent") then
                        character.Branch.SwingEvent:FireServer()
                    end
                    wait(0.1)
                end
            end)
        end
    end
)

w1:Toggle(
    "Auto Infect",
    "infect",
    false,
    function(toggled)
        infectEnabled = toggled
        if infectEnabled then
            spawn(function()
                while infectEnabled do
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character and character:FindFirstChild("Infected") and character.Infected:FindFirstChild("InfectEvent") then
                        character.Infected.InfectEvent:FireServer()
                    end
                    wait(0.1)
                end
            end)
        end
    end
)

w1:Toggle(
    "Auto Swing Katana",
    "swingKatana",
    false,
    function(toggled)
        swingKatanaEnabled = toggled
        if swingKatanaEnabled then
            spawn(function()
                while swingKatanaEnabled do
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character and character:FindFirstChild("Katana") and character.Katana:FindFirstChild("SwingEvent") then
                        character.Katana.SwingEvent:FireServer()
                    end
                    wait(0.1)
                end
            end)
        end
    end
)

w1:Toggle(
    "Auto Swing Spear",
    "swingSpear",
    false,
    function(toggled)
        swingSpearEnabled = toggled
        if swingSpearEnabled then
            spawn(function()
                while swingSpearEnabled do
                    local player = game.Players.LocalPlayer
                    local character = player.Character
                    if character and character:FindFirstChild("Spear") and character.Spear:FindFirstChild("SwingEvent") then
                        character.Spear.SwingEvent:FireServer()
                    end
                    wait(0.1)
                end
            end)
        end
    end
)

local function createESP(player)
    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.FillColor = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 255, 255) -- 团队颜色或默认白色
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- 外线白色
    highlight.Adornee = player.Character

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = player.Character
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = player.Character

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = string.format("Name: %s\nDistance: %d\nTeam: %s\nHealth: %d", player.Name, (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude, player.Team and player.Team.Name or "None", player.Character.Humanoid.Health)
    textLabel.Font = Enum.Font.RobotoMono
    textLabel.TextColor3 = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 255, 255) -- 团队颜色或默认白色
    textLabel.TextSize = 14
end

local function removeESP(player)
    if player.Character then
        for _, v in pairs(player.Character:GetChildren()) do
            if v:IsA("Highlight") or v:IsA("BillboardGui") then
                v:Destroy()
            end
        end
    end
end

local function applyESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            createESP(player)
        end
    end
    game.Players.PlayerAdded:Connect(function(player)
        if espEnabled then
            player.CharacterAdded:Connect(function()
                createESP(player)
            end)
        end
    end)
    game.Players.PlayerRemoving:Connect(function(player)
        removeESP(player)
    end)
end

local function removeAllESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        removeESP(player)
    end
end

w1:Toggle(
    "ESP Player",
    "espPlayer",
    false,
    function(toggled)
        espEnabled = toggled
        if espEnabled then
            applyESP()
        else
            removeAllESP()
        end
    end
)

local espEnabled2 = false

local function createESP2(object, infoText)
    local highlight = Instance.new("Highlight")
    highlight.Parent = object
    highlight.FillColor = Color3.fromRGB(255, 255, 255) -- 默认白色
    highlight.FillTransparency = 0.5 -- 设置填充颜色的透明度为 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- 外线白色
    highlight.Adornee = object

    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = object
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = object

    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboard
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = infoText
    textLabel.Font = Enum.Font.RobotoMono
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- 默认白色
    textLabel.TextSize = 14
end

local function searchAndApplyESP()
    -- 搜索 SmileCoin 并应用 ESP
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name == "SmileCoin" then
            createESP2(obj, "SmileCoin")
        end
    end

    -- 搜索 Infector 和其中的 Part 并应用 ESP
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Folder") and obj.Name == "Infector" then
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("Part") then
                    createESP2(part, string.format("Infector Part: %s", part.Name))
                end
            end
        end
    end
end

local function removeESP2(object)
    for _, v in pairs(object:GetChildren()) do
        if v:IsA("Highlight") or v:IsA("BillboardGui") then
            v:Destroy()
        end
    end
end

local function removeAllESP()
    -- 移除所有 SmileCoin 的 ESP
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name == "SmileCoin" then
            removeESP2(obj)
        end
    end

    -- 移除所有 Infector 及其 Part 的 ESP
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Folder") and obj.Name == "Infector" then
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("Part") then
                    removeESP2(part)
                end
            end
        end
    end
end

w1:Toggle(
    "ESP SmileCoin & Infector",
    "espItems",
    false,
    function(toggled)
        espEnabled2 = toggled
        if espEnabled2 then
            searchAndApplyESP()
        else
            removeAllESP()
        end
    end
)

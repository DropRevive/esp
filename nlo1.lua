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
local espEnabled = false

local function createESP(object, infoText)
    local highlight = Instance.new("Highlight")
    highlight.Parent = object
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
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
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextSize = 14
end

local function createPlayerESP(player)
    local character = player.Character
    if character then
        local highlight = Instance.new("Highlight")
        highlight.Parent = character
        highlight.FillColor = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Adornee = character

        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = character
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.Parent = character

        local textLabel = Instance.new("TextLabel")
        textLabel.Parent = billboard
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.Text = string.format("Name: %s\nDistance: %d\nTeam: %s\nHealth: %d", player.Name, (character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude, player.Team and player.Team.Name or "None", character.Humanoid.Health)
        textLabel.Font = Enum.Font.RobotoMono
        textLabel.TextColor3 = player.Team and player.TeamColor.Color or Color3.fromRGB(255, 255, 255)
        textLabel.TextSize = 14
    end
end

local function searchAndApplyESP1()
    while espEnabled do
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj.Name == "SmileCoin" then
                createESP(obj, "SmileCoin (")
            end
        end
        wait(0.5)
    end
end

local function searchAndApplyESP2()
    while espEnabled do
        for _, obj in pairs(game.Workspace:GetDescendants()) do
            if obj:IsA("Folder") and obj.Name == "Infector" then
                for _, part in pairs(obj:GetDescendants()) do
                    if part:IsA("Part") then
                        createESP(part, string.format("Infector BasePart: %s", part.Name))
                    end
                end
            end
        end
        wait(0.5)
    end
end

local function removeESP(object)
    for _, v in pairs(object:GetChildren()) do
        if v:IsA("Highlight") or v:IsA("BillboardGui") then
            v:Destroy()
        end
    end
end

local function removeAllESP()
    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj.Name == "SmileCoin" then
            removeESP(obj)
        end
    end

    for _, obj in pairs(game.Workspace:GetDescendants()) do
        if obj:IsA("Folder") and obj.Name == "Infector" then
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("Part") then
                    removeESP(part)
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
        espEnabled = toggled
        if espEnabled then
            spawn(searchAndApplyESP1)
            spawn(searchAndApplyESP2)
        else
            removeAllESP()
        end
    end
)

w1:Toggle(
    "ESP Player",
    "espPlayer",
    false,
    function(toggled)
        espEnabled = toggled
        if espEnabled then
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    createPlayerESP(player)
                end
            end
            game.Players.PlayerAdded:Connect(function(player)
                if espEnabled then
                    player.CharacterAdded:Connect(function()
                        createPlayerESP(player)
                    end)
                end
            end)
            game.Players.PlayerRemoving:Connect(function(player)
                removeESP(player)
            end)
        else
            for _, player in pairs(game.Players:GetPlayers()) do
                removeESP(player)
            end
        end
    end
)

local killGateSwitcherEnabled = false
local storedKillGateSwitcherObjects = {}
local storedGateObjects = {}

local function deleteKillGateSwitcher(object)
    if object.Name == "KillGateSwitcher" then
        local clone = object:Clone()
        table.insert(storedKillGateSwitcherObjects, {clone = clone, parent = object.Parent})
        object:Destroy()
    end
    for _, child in ipairs(object:GetChildren()) do
        deleteKillGateSwitcher(child)
    end
end

local function deleteGates(object)
    if object.Name == "Gate" then
        local clone = object:Clone()
        table.insert(storedGateObjects, {clone = clone, parent = object.Parent})
        object:Destroy()
    end
    for _, child in ipairs(object:GetChildren()) do
        deleteGates(child)
    end
end

local function deleteGatesInInfectGateSwitch(object)
    if object.Name == "InfectGateSwitch" or object.Name == "KillGateSwitcher" then
        for _, child in ipairs(object:GetChildren()) do
            deleteGates(child)
        end
    end
    for _, child in ipairs(object:GetChildren()) do
        deleteGatesInInfectGateSwitch(child)
    end
end

local function restoreKillGateSwitcher()
    for _, storedObject in ipairs(storedKillGateSwitcherObjects) do
        storedObject.clone.Parent = storedObject.parent
    end
    storedKillGateSwitcherObjects = {}
end

local function restoreGates()
    for _, storedObject in ipairs(storedGateObjects) do
        storedObject.clone.Parent = storedObject.parent
    end
    storedGateObjects = {}
end

local function applyKillGateSwitcherMovement()
    if killGateSwitcherEnabled then
        deleteKillGateSwitcher(game.Workspace)
        deleteGatesInInfectGateSwitch(game.Workspace)
    else
        restoreKillGateSwitcher()
        restoreGates()
    end
end

w1:Toggle(
    "Kill /Infect Gate Remove",
    "removeKillGateSwitcher",
    false,
    function(toggled)
        killGateSwitcherEnabled = toggled
        applyKillGateSwitcherMovement()
    end
)

local function findAndSetCooldown()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local function findCooldownValues(object)
        for _, child in ipairs(object:GetChildren()) do
            if child.Name == "Cooldown" then
                child.Value = 0
            end
            findCooldownValues(child)
        end
    end

    findCooldownValues(character)
end

w1:Button(
    "Porn Cooldown",
    function()
        findAndSetCooldown()
    end
)

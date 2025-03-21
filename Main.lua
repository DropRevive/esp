local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local swingBrEnabled = false
local swingBottleEnabled = false
local swingBranchEnabled = false
local infectEnabled = false
local swingKatanaEnabled = false
local swingSpearEnabled = false
local espEnabled = false
local killGateSwitcherEnabled = false
local storedKillGateSwitcherObjects = {}
local storedGateObjects = {}
local killerSawEnabled = false
local mapAntiHackRemoveEnabled = false
local antiKickEnabled = true
local noAnchoredEnabled = false
local removeInfectBasePartEnabled = false
local pornCooldownEnabled = false
local removeLavaEnabled = false
local removeTrainPartsEnabled = false
local strongBatEnabled = false
local Options = Library.Options
local Toggles = Library.Toggles
Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "Simple Edition",
    Footer = "Data V2",
    Icon = 18148044143,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Main"),
    Lol = Window:AddTab("UI Addons")
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox("Automatic")

local LeftGroupBox2 = Tabs.Main:AddLeftGroupbox("LocalSetting")

LeftGroupBox2:AddSlider("SpeedSlider", {
    Text = "Set Speed",
    Default = 22,
    Min = 20,
    Max = 30,
    Rounding = 1,
    Compact = false,

    Tooltip = "Adjust the speed of the slide.",
    DisabledTooltip = "Slider is disabled!",
    Disabled = false,
    Visible = true,
})

Options.SpeedSlider:OnChanged(function()
    local player = game.Players.LocalPlayer
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = Options.SpeedSlider.Value
    end
end)

local function maintainSpeed()
    while true do
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Options.SpeedSlider.Value
        end
        wait(0.1)
    end
end

spawn(maintainSpeed)

LeftGroupBox:AddToggle("1", {
    Text = "Swing Bat",
    Tooltip = "...",
    DisabledTooltip = "...",

    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,
})

Toggles["1"]:OnChanged(function(toggled)
    swingBrEnabled = toggled
    if swingBrEnabled then
        spawn(function()
            while swingBranchEnabled do
                local player = game.Players.LocalPlayer
                local character = player.Character
                if character and character:FindFirstChild("Bat") and character.Bat:FindFirstChild("SwingEvent") then
                    character.Bat.SwingEvent:FireServer()
                end
                wait(0.1)
            end
        end)
    end
end)

LeftGroupBox:AddToggle("SwingBranch", {
    Text = "Swing Branch",
    Default = false,
})

Toggles.SwingBranch:OnChanged(function(toggled)
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
end)

LeftGroupBox:AddToggle("SwingBranch", {
    Text = "Swing Chain",
    Default = false,
})

Toggles.SwingBranch:OnChanged(function(toggled)
    swingBranchEnabled = toggled
    if swingBranchEnabled then
        spawn(function()
            while swingBranchEnabled do
                local player = game.Players.LocalPlayer
                local character = player.Character
                if character and character:FindFirstChild("Chain") and character.Chain:FindFirstChild("SwingEvent") then
                    character.Chain.SwingEvent:FireServer()
                end
                wait(0.1)
            end
        end)
    end
end)
LeftGroupBox:AddToggle("SwingBottle", {
    Text = "Swing Bottle",
    Default = false,
})

Toggles.SwingBottle:OnChanged(function(toggled)
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
end)
LeftGroupBox:AddToggle("StrongBat", {
    Text = "Strong Bat",
    Default = false,
})

Toggles.StrongBat:OnChanged(function(toggled)
    strongBatEnabled = toggled
    if strongBatEnabled then
        spawn(function()
            while strongBatEnabled do
                local player = game.Players.LocalPlayer
                local character = player.Character

                if character then
                    -- Ensure player has a Bat
                    if character:FindFirstChild("Bat") then
                        local bat = character:FindFirstChild("Bat")

                        -- Check and set Cooldown
                        if bat:FindFirstChild("Cooldown") then
                            bat.Cooldown.Value = 1
                        end

                        -- Adjust V3's size
                        if bat:FindFirstChild("V3") then
                            bat.V3.Size = Vector3.new(3.5, 9, 3.5)
                        end
                    end
                end

                wait(0.1)
            end
        end)
    end
end)
local LocalPlayer = game.Players.LocalPlayer

LeftGroupBox:AddToggle("Skip Smilling", {
    Text = "Skip Smilling [TEST]",
    Default = false,
})

LeftGroupBox:AddToggle("Auto Infect", {
    Text = "Auto Infect [TEST]",
    Default = false,  -- Default on
})

local Hh = { KK = {}, Running = false }
game.Players.PlayerAdded:Connect(function(player)
    player:GetPropertyChangedSignal("Team"):Connect(function()
        previousTeam[player] = player.Team
    end)
    previousTeam[player] = player.Team
end)

game.Players.PlayerRemoving:Connect(function(player)
    previousTeam[player] = nil
end)

-- Function to handle player death and switch RigType (Skip Smilling logic)
local previousTeam = {}  -- Store previous team of players

local function triggerDeathByRigType(player)
    if player == LocalPlayer then return end  -- Skip local player

    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Checking if "Skip Smilling" toggle is on
    if Toggles["Skip Smilling"].Value then
        -- If the player's team is "Smilling" and was previously "Human", continuously toggle RigType if infected
        if previousTeam[player] == game.Teams.Human and player.Team == game.Teams.Smilling and player.Character:FindFirstChild("Infected") then
            local infectStatus = player.Character.Infected
            if infectStatus and infectStatus:FindFirstChild("InfectEvent") then
                task.spawn(function()
                    while humanoid and humanoid.Health >= 0 do
                        -- Check if the player is still in the "infecting" process
                        if infectStatus and infectStatus.Value then
                            humanoid.RigType = Enum.HumanoidRigType.R6
                            wait(0.15)
                            humanoid.RigType = Enum.HumanoidRigType.R15
                            wait(0.15)
                        else
                            break
                        end
                        if humanoid.Health < 0 then
                            break
                        end
                    end
                end)
            end
        end
    end

    -- Listen to health changes and trigger infection if necessary
    humanoid.HealthChanged:Connect(function()
        if humanoid.Health <= 0 then
            Hh.KK[player] = nil
        end
    end)
end

-- Update previous team information when player joins or changes team

-- Function to infect a player (Auto Infect without conditions)
local function infectPlayer(player)
    if player == LocalPlayer then return end  -- Skip local player

    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        triggerDeathByRigType(player)
    end
end

-- Find the closest player in range
local function findClosestPlayerInRange(player, range)
    local closestPlayer = nil
    local minDist = range
    local currentPos = player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position

    if currentPos then
        for _, other in ipairs(game.Players:GetPlayers()) do
            if other == player or Hh.KK[other] and Hh.KK[other].infected or other == LocalPlayer then
                continue
            end

            local otherChar = other.Character
            local root = otherChar and otherChar:FindFirstChild("HumanoidRootPart")

            if root then
                local dist = (root.Position - currentPos).Magnitude
                if dist < minDist then
                    minDist = dist
                    closestPlayer = other
                end
            end
        end
    end

    return closestPlayer
end

-- Clean up players when needed
local function cleanUpPlayers()
    for key, playerData in pairs(Hh.KK) do
        local player = key
        if not player or not player.Character then
            Hh.KK[key] = nil
            continue
        end

        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            Hh.KK[key] = nil
        end
    end
end

-- Toggle for Auto Infect (No conditions, infinite loop)
Toggles["Auto Infect"]:OnChanged(function(toggled)
    Hh.Running = false
    wait(0.15)

    if toggled then
        Hh.Running = true
        -- Infinite loop for auto infecting players (without conditions)
        while Hh.Running do
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character then
                    task.spawn(function()
                        local infectEvent = player.Character:FindFirstChild("Infected") and player.Character.Infected:FindFirstChild("InfectEvent")
                        if infectEvent then
                            pcall(function()
                                -- Directly fire the infection event without any condition
                                if infectEvent and infectEvent.FireServer then
                                    infectEvent:FireServer()
                                end
                            end)
                            Hh.KK[player] = { infected = true, lastPos = player.Character.HumanoidRootPart.Position }
                            infectPlayer(player)
                        end
                    end)
                end
            end
            wait(0.1)
        end
    else
        -- If toggled off, clear infected status
        for _, player in ipairs(game.Players:GetPlayers()) do
            if Hh.KK[player] then
                Hh.KK[player].infected = false
                -- Optionally, reset player's position or any other actions
            end
        end
    end
end)

-- Toggle for Skip Smilling (only infect if not Smilling)
Toggles["Skip Smilling"]:OnChanged(function(toggled)
    -- Print the current state of the toggle
    print("Skip Killing Smilling is now " .. (toggled and "enabled" or "disabled"))
end)

LeftGroupBox:AddToggle("SwingKatana", {
    Text = "Swing Katana",
    Default = false,
})

Toggles.SwingKatana:OnChanged(function(toggled)
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
end)

LeftGroupBox:AddToggle("SwingSpear", {
    Text = "Swing Spear",
    Default = false,
})

Toggles.SwingSpear:OnChanged(function(toggled)
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
end)
local function deleteKillerSaws(object)
    for _, child in ipairs(object:GetChildren()) do
        if child.Name == "KillerSaw" then
            child:Destroy()
        end
        deleteKillerSaws(child)
    end
end

local function deleteMapAntiHackRemove(object)
    for _, child in ipairs(object:GetChildren()) do
        if child.Name == "AntiHack" then
            child:Destroy()
        end
        deleteMapAntiHackRemove(child)
    end
end

local function checkAndRemoveKillerSaws()
    if killerSawEnabled then
        deleteKillerSaws(game.Workspace)
    end
end

local function checkAndRemoveMapAntiHackRemove()
    if mapAntiHackRemoveEnabled then
        deleteMapAntiHackRemove(game.Workspace)
    end
end

local RightGroupBox = Tabs.Main:AddRightGroupbox("Exploit")
RightGroupBox:AddToggle("KillerSaw", {
    Text = "Remove Killer Saws",
    Default = false,
})

Toggles.KillerSaw:OnChanged(function(toggled)
    killerSawEnabled = toggled
    checkAndRemoveKillerSaws()
end)

RightGroupBox:AddToggle("MapAntiHackRemove", {
    Text = "Remove AntiHack",
    Default = false,
})

Toggles.MapAntiHackRemove:OnChanged(function(toggled)
    mapAntiHackRemoveEnabled = toggled
    checkAndRemoveMapAntiHackRemove()
end)

RightGroupBox:AddToggle("AntiKick", {
    Text = "Enable AntiKick",
    Default = false,
})

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

RightGroupBox:AddToggle("AntiKillInfectGate", {
    Text = "Anti Kill / Infect Gate",
    Default = false,
})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

LeftGroupBox:AddToggle("Infect", {
    Text = "Anti prevention",
    Default = true,
})

Toggles.Infect:OnChanged(function(toggled)
    if toggled then
        while true do
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local torso = character:FindFirstChild("Torso")

            if torso then
                local touchInterest = torso:FindFirstChild("TouchInterest")
                if touchInterest then
                    touchInterest:Destroy()
                end
            end

            wait(1) -- 每秒检查一次
        end
    end
end)
Toggles.AntiKillInfectGate:OnChanged(function(toggled)
    killGateSwitcherEnabled = toggled
    applyKillGateSwitcherMovement()
end)
Toggles.AntiKick:OnChanged(function(toggled)
    antiKickEnabled = toggled
    applyAntiKick()
end)

local function applyAntiKick()
    if antiKickEnabled then
        local mt = getrawmetatable(game)
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)

        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" or method == "kick" then
                return
            end
            return oldNamecall(self, ...)
        end)

        setreadonly(mt, true)
    end
end
local function toggleNoAnchored()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local function unanchorParts(object)
        for _, child in ipairs(object:GetChildren()) do
            if child:IsA("BasePart") then
                child.Anchored = false
            end
            unanchorParts(child)
        end
    end

    if noAnchoredEnabled then
        unanchorParts(character)
        player.CharacterAdded:Connect(function(char)
            unanchorParts(char)
        end)
    end
end

RightGroupBox:AddToggle("lol", {
    Text = "No Anchored",
    Default = false,
})

Toggles.lol:OnChanged(function(toggled)
    noAnchoredEnabled = toggled
    toggleNoAnchored()
end)

local function removeAllDestroyable()
    local function removeDestroyable(object)
        local destroyablePart = object:FindFirstChild("Destroyable")
        if destroyablePart then
            destroyablePart:Destroy()
        end
    end

    local function recursiveRemoveDestroyable(parent)
        for _, child in ipairs(parent:GetChildren()) do
            removeDestroyable(child)
            recursiveRemoveDestroyable(child)
        end
    end

    recursiveRemoveDestroyable(game.Workspace)
end


local function removeAllDestroyable()
    local function removeDestroyable(object)
        local destroyablePart = object:FindFirstChild("Destroyable")
        if destroyablePart then
            destroyablePart:Destroy()
        end
    end

    local function recursiveRemoveDestroyable(parent)
        for _, child in ipairs(parent:GetChildren()) do
            removeDestroyable(child)
            recursiveRemoveDestroyable(child)
        end
    end

    recursiveRemoveDestroyable(game.Workspace)
end

local function toggleBigDestroyable()
    if bigDestroyableEnabled then
        removeAllDestroyable()
    end
end

RightGroupBox:AddToggle("sm", {
    Text = "Remove Destroyable",
    Default = false,
})

Toggles.sm:OnChanged(function(toggled)
    bigDestroyableEnabled = toggled
    removeAllDestroyable()
end)

local function checkAndRemoveHarmfulObjects()
    local workspace = game.Workspace
    local systemFolder = workspace:FindFirstChild("Map"):FindFirstChild("System")

    local function findHarmfulObjects(object)
        for _, child in ipairs(object:GetChildren()) do
            if removeInfectBasePartEnabled then
                if child:IsA("Script") and child.Name == "InfectScript" then
                    child:Destroy()
                elseif child:IsA("ParticleEmitter") and child.Name == "SmilesEmitter" then
                    child:Destroy()
                elseif child:IsA("TouchTransmitter") and child.Name == "TouchInterest" then
                    child:Destroy()
                elseif child:IsA("Sound") then
                    child:Destroy()
                elseif child.Name == "Infectors" then
                    child:Destroy()
                end
                findHarmfulObjects(child)
            end
        end
    end

    if systemFolder then
        systemFolder.ChildAdded:Connect(function(child)
            if removeInfectBasePartEnabled then
                findHarmfulObjects(systemFolder)
            end
        end)

        systemFolder.ChildRemoved:Connect(function(child)
            if removeInfectBasePartEnabled then
                findHarmfulObjects(systemFolder)
            end
        end)
    end

    -- Initial check for harmful objects
    findHarmfulObjects(systemFolder)
end

local function checkAndRemoveInfectors()
    local workspace = game.Workspace
    local mapFolder = workspace:FindFirstChild("Map")

    local function removeInfectors(object)
        for _, child in ipairs(object:GetChildren()) do
            if removeInfectBasePartEnabled then
                if child.Name == "Infectors" then
                    child:Destroy()
                end
                removeInfectors(child)
            end
        end
    end

    if mapFolder then
        mapFolder.ChildAdded:Connect(function(child)
            if removeInfectBasePartEnabled then
                removeInfectors(mapFolder)
            end
        end)

        mapFolder.ChildRemoved:Connect(function(child)
            if removeInfectBasePartEnabled then
                removeInfectors(mapFolder)
            end
        end)
    end

    -- Initial check and removal of all Infectors
    removeInfectors(mapFolder)
end

RightGroupBox:AddToggle("AntiInfectBase", {
    Text = "Anti Infect Base",
    Default = false,
})

Toggles.AntiInfectBase:OnChanged(function(toggled)
    removeInfectBasePartEnabled = toggled
    if toggled then
        checkAndRemoveHarmfulObjects()
        checkAndRemoveInfectors()
    end
end)
local pornCooldownEnabled = false

local function findAndSetCooldown()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    local function findCooldownValues(object)
        for _, child in ipairs(object:GetChildren()) do
            if pornCooldownEnabled then
                if child.Name == "Cooldown" then
                    child.Value = 0
                end
                findCooldownValues(child)
            end
        end
    end

    findCooldownValues(character)

    if pornCooldownEnabled then
        character.ChildAdded:Connect(function(child)
            if pornCooldownEnabled then
                findCooldownValues(child)
            end
        end)
    end
end

-- Toggle function for enabling/disabling the cooldown removal

RightGroupBox:AddToggle("PornCooldowns", {
    Text = "Porn Cooldowns",
    Default = false,
})

Toggles.PornCooldowns:OnChanged(function(toggled)
    pornCooldownEnabled = toggled
    if toggled then
        findAndSetCooldown()
    end
end)
local removeTrainPartsEnabled = false

local function removeTrainParts()
    local workspace = game:GetService("Workspace")
    local trainFolder = workspace:FindFirstChild("Map"):FindFirstChild("System"):FindFirstChild("Trains"):FindFirstChild("Train")

    local function removeAllTrainParts(object)
        for _, child in ipairs(object:GetChildren()) do
            if removeTrainPartsEnabled then
                child:Destroy()
                removeAllTrainParts(child)
            end
        end
    end

    -- Initial removal of all objects in Trains.Train
    if trainFolder then
        removeAllTrainParts(trainFolder)
    end
end

local function toggleRemoveTrainParts(toggled)
    removeTrainPartsEnabled = toggled
    if toggled then
        removeTrainParts()
    end
end

-- Adding toggle button in the UI
RightGroupBox:AddToggle("RemoveTrainParts", {
    Text = "Remove Train",
    Default = false,
})

Toggles.RemoveTrainParts:OnChanged(function(toggled)
    toggleRemoveTrainParts(toggled)
end)
local autoFarmEnabled = false

local function autoFarmSmileCoins()
    local workspace = game.Workspace
    local players = game:GetService("Players")
    local player = players.LocalPlayer
    local targetCFrame = player.Character and player.Character.PrimaryPart.CFrame or CFrame.new(0, 0, 0)

    local function findAndTeleportSmileCoins(object)
        for _, child in ipairs(object:GetChildren()) do
            if child.Name == "SmileCoin" and child:IsA("BasePart") then
                child.CFrame = targetCFrame
            end
            findAndTeleportSmileCoins(child)
        end
    end

    findAndTeleportSmileCoins(workspace)
end

local function toggleAutoFarmSmileCoins(toggled)
    autoFarmEnabled = toggled
    if autoFarmEnabled then
        spawn(function()
            while autoFarmEnabled do
                autoFarmSmileCoins()
                wait(1) -- Add a delay to prevent potential performance issues
            end
        end)
    end
end

RightGroupBox:AddToggle("AutoFarmSmileCoins", {
    Text = "Auto Farm SmileCoins",
    Default = false,
})

Toggles.AutoFarmSmileCoins:OnChanged(function(toggled)
    toggleAutoFarmSmileCoins(toggled)
end)
local function deleteLava(object)
    for _, child in ipairs(object:GetChildren()) do
        if child.Name == "Lava" then
            child:Destroy()
        end
        deleteLava(child)
    end
end

local function checkAndRemoveLava()
    if removeLavaEnabled then
        deleteLava(game.Workspace)
    end
end

LeftGroupBox:AddToggle("AntiLava", {
    Text = "Anti Lava",
    Default = false,
})

Toggles.AntiLava:OnChanged(function(toggled)
    removeLavaEnabled = toggled
    checkAndRemoveLava()
end)
local MenuGroup = Tabs.Lol:AddLeftGroupbox("Menu")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = true,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",

	Text = "Notification Side",

	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
	:AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
	Library:Unload()
end)

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
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place") -- if the game has multiple places inside of it (for example: DOORS)
-- you can use this to save configs for those places separately
-- The path in this script would be: MyScriptHub/specific-game/settings/specific-place
-- [ This is optional ]

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs["UI Settings"])

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs["UI Settings"])

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

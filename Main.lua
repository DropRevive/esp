local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
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

LeftGroupBox:AddToggle("1", {
    Text = "Swing Branch",
    Tooltip = "...",
    DisabledTooltip = "...",

    Default = true,
    Disabled = false,
    Visible = true,
    Risky = false,
})

Toggles["1"]:OnChanged(function(toggled)
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
    Text = "Swing Branch",
    Default = true,
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

LeftGroupBox:AddToggle("SwingBottle", {
    Text = "Swing Bottle",
    Default = true,
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

LeftGroupBox:AddToggle("Infect", {
    Text = "Infect",
    Default = true,
})

Toggles.Infect:OnChanged(function(toggled)
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
end)

LeftGroupBox:AddToggle("SwingKatana", {
    Text = "Swing Katana",
    Default = true,
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
    Default = true,
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
    Default = true,
})

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
    Default = true,
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
    Default = true,
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
    Default = true,
})

Toggles.AntiInfectBase:OnChanged(function(toggled)
    removeInfectBasePartEnabled = toggled
    if toggled then
        checkAndRemoveHarmfulObjects()
        checkAndRemoveInfectors()
    end
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

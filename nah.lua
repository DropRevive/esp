local library = loadstring(game.HttpGet(game, "https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/0x"))()

local w1 = library:Window("Simple Edition V1") -- 更新窗口名称

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
    22 -- 
) -- Text, Flag, Minimum, Maximum, Callback, Default (Optional), Flag Location (Optional)

w1:Slider(
    "JumpPower",
    "JP",
    50,
    300,
    function(value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end,
    50
) -- Text, Flag, Minimum, Maximum, Callback, Default (Optional), Flag Location (Optional)

local swingBottleEnabled = false
local swingBranchEnabled = false
local infectEnabled = false
local swingKatanaEnabled = false
local swingSpearEnabled = false

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

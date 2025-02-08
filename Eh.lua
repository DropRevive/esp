local TweenService = game:GetService("TweenService")
local LogService = game:GetService("LogService")

local cloneRef = function(serviceName)
    local success, service = pcall(function()
        return game:GetService(serviceName)
    end)
    if success then
        return service
    else
        warn("Failed to get service: " .. serviceName)
    end
end

local function createInstance(className, properties, parent)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    if parent then
        instance.Parent = parent
    end
    return instance
end

local function getHardwareID()
    local hwid = ""
    local guid = game:GetService("RbxAnalyticsService"):GetClientId()
    
    for i = 1, #guid do
        local byte = string.byte(guid, i)
        hwid = hwid .. string.format("%02X", byte)
    end

    return hwid
end
local hwid = getHardwareID()
print("loading Executor")
wait(1)

print(hwid)
print("success now")
local ScreenGui = createInstance("ScreenGui", { Name = hwid }, cloneRef("CoreGui"))
local Frame = createInstance("Frame", {
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), 
    BorderSizePixel = 0,
    Size = UDim2.new(0, 600, 0, 20),
    Position = UDim2.new(0.5, -300, 0.5, -10),
    Draggable = true, -- Enable dragging
    Active = true
}, ScreenGui)

local Title = createInstance("TextLabel", {
    Size = UDim2.new(0.9, 0, 1, -4),
    Position = UDim2.new(0, 0, 0, 2),
    AnchorPoint = Vector2.new(0, 0),
    BackgroundTransparency = 1,
    Text = "TyrenuX V1.0",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    Font = Enum.Font.RobotoMono,
    TextXAlignment = Enum.TextXAlignment.Left
}, Frame)

local ImageButton = createInstance("ImageButton", {
    Size = UDim2.new(0, 20, 0, 20),
    Position = UDim2.new(1, 0, 0, 0),
    AnchorPoint = Vector2.new(1, 0),
    BackgroundTransparency = 1,
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    Image = "rbxassetid://6031091001",
    ImageColor3 = Color3.fromRGB(255, 255, 255)
}, Frame)

local ExecuteButton = createInstance("TextButton", {
    Size = UDim2.new(0, 70, 0, 20),
    Position = UDim2.new(0, 10, 0, 30),
    AnchorPoint = Vector2.new(0, 0),
    BackgroundTransparency = 1,
    Text = "Execute",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    Font = Enum.Font.RobotoMono,
    TextXAlignment = Enum.TextXAlignment.Center,
    Visible = false
}, Frame)

local ClearButton = createInstance("TextButton", {
    Size = UDim2.new(0, 70, 0, 20),
    Position = UDim2.new(0, 90, 0, 30),
    AnchorPoint = Vector2.new(0, 0),
    BackgroundTransparency = 1,
    Text = "Clear",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    Font = Enum.Font.RobotoMono,
    TextXAlignment = Enum.TextXAlignment.Center,
    Visible = false
}, Frame)

local ConsoleButton = createInstance("TextButton", {
    Size = UDim2.new(0, 70, 0, 20),
    Position = UDim2.new(0, 170, 0, 30),
    AnchorPoint = Vector2.new(0, 0),
    BackgroundTransparency = 1,
    Text = "Console",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    Font = Enum.Font.RobotoMono,
    TextXAlignment = Enum.TextXAlignment.Center,
    Visible = false
}, Frame)

local InputBox = createInstance("TextBox", {
    Size = UDim2.new(1, -20, 0, 400),
    Position = UDim2.new(0, 10, 0, 60),
    AnchorPoint = Vector2.new(0, 0),
    BackgroundTransparency = 1, -- Transparent 1 
    BorderSizePixel = 0,
    Text = "",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    Font = Enum.Font.RobotoMono,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    MultiLine = true,
    ClearTextOnFocus = false,
    Visible = false,
    TextWrapped = true,
    TextEditable = true -- Allow text editing
}, Frame)

local ConsoleFrame = createInstance("ScrollingFrame", {
    Size = UDim2.new(1, -20, 0, 400),
    Position = UDim2.new(0, 10, 0, 60),
    AnchorPoint = Vector2.new(0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 8,
    Visible = false
}, Frame)

local LogLayout = createInstance("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 2)
}, ConsoleFrame)

local isExpanded = false
local isConsoleOpen = false
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

ImageButton.MouseButton1Click:Connect(function()
    if isExpanded then
        local tween = TweenService:Create(Frame, tweenInfo, {Size = UDim2.new(0, 600, 0, 20)})
        tween:Play()
        local imageTween = TweenService:Create(ImageButton, tweenInfo, {Rotation = 0})
        imageTween:Play()
        local titleTween = TweenService:Create(Title, tweenInfo, {Position = UDim2.new(0, 0, 0, 2)})
        titleTween:Play()
        ExecuteButton.Visible = false
        ClearButton.Visible = false
        ConsoleButton.Visible = false
        InputBox.Visible = false
        ConsoleFrame.Visible = false
    else
        local tween = TweenService:Create(Frame, tweenInfo, {Size = UDim2.new(0, 600, 0, 500)})
        tween:Play()
        local imageTween = TweenService:Create(ImageButton, tweenInfo, {Rotation = 180})
        imageTween:Play()
        local titleTween = TweenService:Create(Title, tweenInfo, {Position = UDim2.new(0, 0, 0, -240)})
        titleTween:Play()
        ExecuteButton.Visible = true
        ClearButton.Visible = true
        ConsoleButton.Visible = true
        if not isConsoleOpen then
            InputBox.Visible = true
        end
    end
    isExpanded = not isExpanded
end)

ConsoleButton.MouseButton1Click:Connect(function()
    if isConsoleOpen then
        InputBox.Visible = true
        ExecuteButton.Visible = true
        ClearButton.Visible = true
        ConsoleFrame.Visible = false
    else
        InputBox.Visible = false
        ExecuteButton.Visible = false
        ClearButton.Visible = false
        ConsoleFrame.Visible = true
    end
    isConsoleOpen = not isConsoleOpen
end)

LogService.MessageOut:Connect(function(message, messageType)
    local messagePrefix = "[Info]"
    local messageColor = Color3.fromRGB(255, 255, 255) -- White
    
    if messageType == Enum.MessageType.MessageWarning then
        messagePrefix = "[Warn]"
        messageColor = Color3.fromRGB(255, 255, 0) -- Yellow
    elseif messageType == Enum.MessageType.MessageError then
        messagePrefix = "[Error]"
        messageColor = Color3.fromRGB(255, 0, 0) -- Red
    end
    
    local newMessage = createInstance("TextLabel", {
        Size = UDim2.new(1, -20, 0, 20),
        BackgroundTransparency = 1,
        Text = messagePrefix .. " " .. message,
        TextColor3 = messageColor,
        TextSize = 15,
        Font = Enum.Font.RobotoMono,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        LayoutOrder = #ConsoleFrame:GetChildren()
    }, ConsoleFrame)
    
    newMessage.Parent = ConsoleFrame
    ConsoleFrame.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y + 20)
end)

ExecuteButton.MouseButton1Click:Connect(function()
    local code = InputBox.Text
    local func, err = loadstring(code)
    if func then
        local success, result = pcall(func)
        if success then
            print(result)
        else
            warn(result)
        end
    else
        warn(err)
    end
end)

ClearButton.MouseButton1Click:Connect(function()
    InputBox.Text = ""
end)

-- Make the UI draggable
local UIS = game:GetService("UserInputService")

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

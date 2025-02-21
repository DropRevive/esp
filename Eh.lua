shared.Functions = {
    ScriptType = {
        Paid = "paid",
        Free = "free"
    }
}

function shared.find(table, target)
    for i, v in next, table do
        if i == target then
            return v
        end
    end
end

API = "https://scriptblox.com/api/"

shared.FetchUrl = function(url)
    assert(game.HttpGet, "HttpGet is not supported on your executor.")
    assert(url, "URL resolves to nil")

    url = tostring(url)

    local response = game:HttpGet(url)
    local json = game:GetService("HttpService"):JSONDecode(response)
    
    return json
end

shared.RawSearch = function(query, page, max, paid)
    local url = API .. "script/search?q=" .. tostring(query):gsub(" ", "+") .. "&page=" .. tostring(page) .. "&max=" .. tostring(max)
    if paid then
        url = url .. "&mode=paid"
    else
        url = url .. "&mode=free"
    end
    return shared.FetchUrl(url)
end

function shared.Functions:Search(query, paid, page, max)
    assert(query, "Query resolves to nil.")

    page = page or 1
    max = max or 10
    paid = paid or false

    assert(type(page) == "number" and math.floor(page) == page, "\"page\" must be an integer.")
    assert(type(max) == "number" and math.floor(max) == max, "\"max\" must be an integer.")

    local result = shared.RawSearch(query, page, max, paid).result

    assert(result, "API did not return a result.")

    return result
end

function shared.Functions:FetchScripts(page)
    page = page or 1

    local fetched = shared.FetchUrl(API .. "script/fetch?page=" .. page)
    local result = fetched.result

    return result
end

function shared.Functions:GetLatestScript(result)
    assert(result and type(result) == "table", "Result resolves to nil or is not a table.")
    
    local scripts = shared.find(result, "scripts")

    if scripts == nil or type(scripts) ~= "table" then
        error("Result is not a valid table.")
    end

    return scripts[1]
end

function shared.Functions:GetScripts(result, predicate)
    assert(result and type(result) == "table", "Result resolves to nil or is not a table.")
    assert(result.scripts and type(result.scripts) == "table", "Result is not a valid table.")

    if predicate == nil or type(predicate) ~= "function" then
        predicate = function()
            return true
        end
    end

    local scripts = result.scripts
    local filteredScripts = {}

    for _, script in next, scripts do
        if predicate(script) then
            table.insert(filteredScripts, script)
        end
    end

    return filteredScripts
end

function shared.Functions:FetchTitle(script)
    return script.title or "No title"
end

function shared.Functions:FetchLoadstring(script)
    return script.script or "No loadstring"
end

function shared.Functions:FetchCode(slug)
    return slug.script.script or "No code"
end

function shared.Functions:FetchLikes(slug)
    return slug.script.likeCount or "No likes count"
end

function shared.Functions:FetchDislikes(slug)
    return slug.script.dislikeCount or 0
end

function shared.Functions:FetchScript(slug)
    return slug.script.script or "No script"
end

function shared.Functions:FetchViews(script)
    return script.views or "No views count"
end

function shared.Functions:HasKeySystem(script)
    return script.key or false
end

function shared.Functions:FetchKeyLink(script)
    if shared.Functions:HasKeySystem(script) then
        return script.keyLink or "No key link"
    end
    return "No key system"
end

function shared.Functions:ScriptIsVerified(script)
    return script.verified or false
end

function shared.Functions:IsPaid(script)
    return script.scriptType ~= "free"
end

function shared.Functions:IsUniversal(script)
    return script.isUniversal or false
end

function shared.Functions:FetchSlug(script)
    return shared.FetchUrl(API .. "script/" .. script.slug)
end

function shared.Functions:FetchDescription(slug)
    return slug.script.features or "No description"
end

function shared.Functions:FetchOwner(slug)
    assert(slug, "Slug resolves to nil.")

    return slug.script.owner or "No owner"
end

function shared.Functions:FetchUsername(owner)
    return owner.username or "No username"
end

function shared.Functions:FetchProfilePicture(owner)
    return owner.profilePicture or "No profile picture"
end

function shared.Functions:IsVerified(owner)
    return owner.verified or false
end

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

local ScreenGui = createInstance("ScreenGui", { Name = hwid }, cloneRef("CoreGui"))
local Frame = createInstance("Frame", {
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), 
    BorderSizePixel = 0,
    Size = UDim2.new(0, 600, 0, 20),
    Position = UDim2.new(0.5, -300, 0.5, -10),
    Draggable = true, -- Enable dragging
    Active = true
}, ScreenGui)

local Title = createInstance("ImageLabel", {
    Size = UDim2.new(0.9, 0, 1, -4),
    Position = UDim2.new(0, 0, 0, 2),
    AnchorPoint = Vector2.new(0, 0),
    BackgroundTransparency = 1,
    Image = "rbxassetid://13369885650",
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

local ScriptbloxButton = createInstance("TextButton", {
    Size = UDim2.new(0, 70, 0, 20),
    Position = UDim2.new(0, 250, 0, 30),
    AnchorPoint = Vector2.new(0, 0),
    BackgroundTransparency = 1,
    Text = "Scriptblox",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    Font = Enum.Font.RobotoMono,
    TextXAlignment = Enum.TextXAlignment.Center,
    Visible = true
}, Frame)

local SearchBox = createInstance("TextBox", {
    Size = UDim2.new(1, -20, 0, 30),
    Position = UDim2.new(0, 10, 0, 10),
    AnchorPoint = Vector2.new(0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Text = "Search...",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    Font = Enum.Font.RobotoMono,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    Visible = false
}, Frame)

local SearchResultFrame = createInstance("ScrollingFrame", {
    Size = UDim2.new(1, -20, 0, 300),
    Position = UDim2.new(0, 10, 0, 50),
    AnchorPoint = Vector2.new(0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 8,
    Visible = false
}, Frame)

local SearchLayout = createInstance("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 5)
}, SearchResultFrame)

local isScriptbloxOpen = false

ScriptbloxButton.MouseButton1Click:Connect(function()
    if isScriptbloxOpen then
        SearchBox.Visible = false
        SearchResultFrame.Visible = false
        InputBox.Visible = true
        ExecuteButton.Visible = true
        ClearButton.Visible = true
        ConsoleFrame.Visible = true
    else
        InputBox.Visible = false
        ExecuteButton.Visible = false
        ClearButton.Visible = false
        ConsoleFrame.Visible = false
        SearchBox.Visible = true
        SearchResultFrame.Visible = true
    end
    isScriptbloxOpen = not isScriptbloxOpen
end)

-- 搜索逻辑
SearchBox.FocusLost:Connect(function()
    local query = SearchBox.Text
    if query == "" or query == "Search..." then
        return
    end

    -- 清空之前的搜索结果
    for _, child in ipairs(SearchResultFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- 调用 API 搜索脚本
    local result = shared.Functions:Search(query, false, 1, 10)
    if result then
        for _, script in ipairs(result.scripts) do
            local scriptTitle = shared.Functions:FetchTitle(script)
            local scriptCode = shared.Functions:FetchLoadstring(script)
            local scriptPaid = shared.Functions:IsPaid(script)

            -- 创建搜索结果条目
            local ResultItem = createInstance("Frame", {
                Size = UDim2.new(1, -20, 0, 60),
                BackgroundTransparency = 1,
                LayoutOrder = #SearchResultFrame:GetChildren() + 1
            }, SearchResultFrame)

            
            local TitleLabel = createInstance("TextLabel", {
                Size = UDim2.new(1, 0, 0, 30),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = scriptTitle .. " (" .. (scriptPaid and "Paid" or "Free") .. ")",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 15,
                Font = Enum.Font.RobotoMono,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Center
            }, ResultItem)

            
            local CopyButton = createInstance("TextButton", {
                Size = UDim2.new(0, 80, 0, 25),
                Position = UDim2.new(0, 0, 0, 35),
                BackgroundTransparency = 1,
                Text = "Copy",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 15,
                Font = Enum.Font.RobotoMono,
                TextXAlignment = Enum.TextXAlignment.Center
            }, ResultItem)

            
            local ExecuteButton = createInstance("TextButton", {
                Size = UDim2.new(0, 80, 0, 25),
                Position = UDim2.new(0, 90, 0, 35),
                BackgroundTransparency = 1,
                Text = "Execute",
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 15,
                Font = Enum.Font.RobotoMono,
                TextXAlignment = Enum.TextXAlignment.Center
            }, ResultItem)

            
            CopyButton.MouseButton1Click:Connect(function()
                setclipboard(scriptCode)
                warn("Copied to clipboard!")
            end)

            
            ExecuteButton.MouseButton1Click:Connect(function()
                local func, err = loadstring(scriptCode)
                if func then
                  local success, result = pcall(func)
                    if success then
                        print("Script executed successfully!")
                    else
                        warn("Execution error: " .. tostring(result))
                    end
                else
                    warn("Loadstring error: " .. tostring(err))
                end
            end)
        end
    else
        warn("Failed to fetch search results.")
    end

    
    SearchResultFrame.CanvasSize = UDim2.new(0, 0, 0, SearchLayout.AbsoluteContentSize.Y + 20)
end)

--[[
    Steal a egg HUB - Key System GUI
    made by 𝚛𝚢𝚣𝚎
]]

-- ============================================================
--  CONFIG (edit these)
-- ============================================================
local Config = {
    HubName   = "Steal a egg HUB",
    Author    = "made by 𝚛𝚢𝚣𝚎",

    -- Paste your key link between the quotes. You can change it any time.
    KeyLink   = "https://www.roblox.je/communities/457642417669/Scrpter-Society",

    -- Option 1: static keys (leave empty {} if you only use a web check)
    Keys      = { "ASDWAVVVVBEASDDFFFFFFXXXXZDASSS" },

    -- Option 2: web check. Put a link to a raw text file / API that returns the valid key.
    -- Leave as "" to disable.
    KeyCheckURL = "",

    -- Called after a correct key is entered.
    -- IMPORTANT: this must be your MAIN hub file, NOT the file this key GUI is saved in,
    -- otherwise it will load the key GUI again in a loop.
    OnSuccess = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/burneracc68754-create/Steal-a-egg-HUB/refs/heads/main/Main.lua"))()
    end,
}

-- ============================================================
--  SERVICES
-- ============================================================
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- ============================================================
--  THEME
-- ============================================================
local Theme = {
    Background = Color3.fromRGB(18, 18, 26),
    Panel      = Color3.fromRGB(26, 26, 38),
    Input      = Color3.fromRGB(32, 32, 46),
    Accent     = Color3.fromRGB(255, 170, 60),
    AccentDark = Color3.fromRGB(235, 120, 40),
    Secondary  = Color3.fromRGB(52, 52, 74),
    Text       = Color3.fromRGB(240, 240, 250),
    SubText    = Color3.fromRGB(150, 150, 175),
    Success    = Color3.fromRGB(90, 220, 130),
    Error      = Color3.fromRGB(255, 90, 100),
}

-- ============================================================
--  HELPERS
-- ============================================================
local function safeParent(gui)
    local ok = pcall(function()
        if gethui then
            gui.Parent = gethui()
        else
            gui.Parent = CoreGui
        end
    end)
    if not ok or not gui.Parent then
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
end

local function create(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    for _, child in ipairs(children or {}) do
        child.Parent = inst
    end
    return inst
end

local function corner(r) return create("UICorner", { CornerRadius = UDim.new(0, r) }) end
local function stroke(color, thickness, transparency)
    return create("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function tween(obj, info, goal)
    local t = TweenService:Create(obj, TweenInfo.new(unpack(info)), goal)
    t:Play()
    return t
end

local function copyToClipboard(text)
    local fn = setclipboard or toclipboard or (syn and syn.write_clipboard) or (Clipboard and Clipboard.set)
    if fn then
        local ok = pcall(fn, text)
        return ok
    end
    return false
end

-- Remove any previous copy of the GUI
for _, parent in ipairs({ CoreGui, LocalPlayer:FindFirstChild("PlayerGui") }) do
    if parent then
        local old = parent:FindFirstChild("StealAnEggHubKeySystem")
        if old then old:Destroy() end
    end
end
pcall(function()
    if gethui then
        local old = gethui():FindFirstChild("StealAnEggHubKeySystem")
        if old then old:Destroy() end
    end
end)

-- ============================================================
--  BUILD GUI
-- ============================================================
local ScreenGui = create("ScreenGui", {
    Name = "StealAnEggHubKeySystem",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})
safeParent(ScreenGui)

-- Main window
local Main = create("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(0, 0),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = ScreenGui,
}, { corner(14), stroke(Theme.Accent, 1.5, 0.35) })

-- Soft gradient on the background
create("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 190, 210)),
    }),
    Rotation = 90,
    Parent = Main,
})

-- Top accent bar
local TopBar = create("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 4),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    Parent = Main,
}, {
    create("UIGradient", {
        Color = ColorSequence.new(Theme.Accent, Theme.AccentDark),
    }),
})

-- Drag handle area (title region)
local Header = create("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 80),
    Position = UDim2.fromOffset(0, 4),
    BackgroundTransparency = 1,
    Parent = Main,
})

local Icon = create("TextLabel", {
    Name = "Icon",
    Size = UDim2.fromOffset(44, 44),
    Position = UDim2.fromOffset(22, 18),
    BackgroundColor3 = Theme.Panel,
    Text = "🥚",
    TextSize = 26,
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.Text,
    Parent = Header,
}, { corner(12), stroke(Theme.Accent, 1, 0.5) })

local Title = create("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -150, 0, 26),
    Position = UDim2.fromOffset(78, 16),
    BackgroundTransparency = 1,
    Text = Config.HubName,
    Font = Enum.Font.GothamBlack,
    TextSize = 22,
    TextColor3 = Theme.Text,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header,
})

local Author = create("TextLabel", {
    Name = "Author",
    Size = UDim2.new(1, -150, 0, 18),
    Position = UDim2.fromOffset(78, 44),
    BackgroundTransparency = 1,
    Text = Config.Author,
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextColor3 = Theme.Accent,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header,
})

-- Close button
local Close = create("TextButton", {
    Name = "Close",
    Size = UDim2.fromOffset(30, 30),
    Position = UDim2.new(1, -44, 0, 18),
    BackgroundColor3 = Theme.Panel,
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Theme.SubText,
    AutoButtonColor = false,
    Parent = Header,
}, { corner(8) })

-- Divider
create("Frame", {
    Name = "Divider",
    Size = UDim2.new(1, -44, 0, 1),
    Position = UDim2.fromOffset(22, 88),
    BackgroundColor3 = Theme.Secondary,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
    Parent = Main,
})

-- Body label
create("TextLabel", {
    Name = "Hint",
    Size = UDim2.new(1, -44, 0, 18),
    Position = UDim2.fromOffset(22, 102),
    BackgroundTransparency = 1,
    Text = "Join the group for the key, then paste it below",
    Font = Enum.Font.GothamMedium,
    TextSize = 13,
    TextColor3 = Theme.SubText,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Main,
})

-- Key input
local KeyBox = create("TextBox", {
    Name = "KeyBox",
    Size = UDim2.new(1, -44, 0, 46),
    Position = UDim2.fromOffset(22, 128),
    BackgroundColor3 = Theme.Input,
    Text = "",
    PlaceholderText = "Paste your key here...",
    PlaceholderColor3 = Theme.SubText,
    TextColor3 = Theme.Text,
    Font = Enum.Font.GothamMedium,
    TextSize = 15,
    ClearTextOnFocus = false,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Parent = Main,
}, {
    corner(10),
    create("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }),
})
local KeyStroke = stroke(Theme.Secondary, 1.5, 0)
KeyStroke.Parent = KeyBox

-- Buttons row (left = Check Key, right = Copy Link)
local ButtonRow = create("Frame", {
    Name = "ButtonRow",
    Size = UDim2.new(1, -44, 0, 44),
    Position = UDim2.fromOffset(22, 188),
    BackgroundTransparency = 1,
    Parent = Main,
})

local CheckBtn = create("TextButton", {
    Name = "CheckKey",
    Size = UDim2.new(0.5, -6, 1, 0),
    Position = UDim2.fromScale(0, 0),
    BackgroundColor3 = Theme.Accent,
    Text = "Check Key",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Color3.fromRGB(30, 20, 10),
    AutoButtonColor = false,
    Parent = ButtonRow,
}, {
    corner(10),
    create("UIGradient", { Color = ColorSequence.new(Theme.Accent, Theme.AccentDark), Rotation = 90 }),
})

local CopyBtn = create("TextButton", {
    Name = "CopyLink",
    Size = UDim2.new(0.5, -6, 1, 0),
    Position = UDim2.new(0.5, 6, 0, 0),
    BackgroundColor3 = Theme.Secondary,
    Text = "Copy Link",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Theme.Text,
    AutoButtonColor = false,
    Parent = ButtonRow,
}, { corner(10), stroke(Theme.Accent, 1, 0.6) })

-- Status label
local Status = create("TextLabel", {
    Name = "Status",
    Size = UDim2.new(1, -44, 0, 20),
    Position = UDim2.fromOffset(22, 246),
    BackgroundTransparency = 1,
    Text = "Waiting for key...",
    Font = Enum.Font.GothamMedium,
    TextSize = 13,
    TextColor3 = Theme.SubText,
    Parent = Main,
})

-- ============================================================
--  BEHAVIOUR
-- ============================================================
local WINDOW_SIZE = UDim2.fromOffset(420, 284)
local busy = false

local function setStatus(text, color)
    Status.Text = text
    Status.TextColor3 = color or Theme.SubText
end

local function shake()
    local origin = Main.Position
    for _, offset in ipairs({ 8, -8, 5, -5, 0 }) do
        tween(Main, { 0.04 }, { Position = origin + UDim2.fromOffset(offset, 0) })
        task.wait(0.04)
    end
end

-- Hover effects
local function addHover(button, normal, hover, textNormal, textHover)
    button.MouseEnter:Connect(function()
        tween(button, { 0.15 }, { BackgroundColor3 = hover })
        if textHover then tween(button, { 0.15 }, { TextColor3 = textHover }) end
    end)
    button.MouseLeave:Connect(function()
        tween(button, { 0.15 }, { BackgroundColor3 = normal })
        if textNormal then tween(button, { 0.15 }, { TextColor3 = textNormal }) end
    end)
end

addHover(CheckBtn, Theme.Accent, Color3.fromRGB(255, 195, 100))
addHover(CopyBtn, Theme.Secondary, Color3.fromRGB(70, 70, 100))
addHover(Close, Theme.Panel, Theme.Error, Theme.SubText, Theme.Text)

-- Input focus highlight
KeyBox.Focused:Connect(function()
    tween(KeyStroke, { 0.15 }, { Color = Theme.Accent })
end)

-- Key validation
local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

local function validateKey(input)
    input = trim(input)
    if input == "" then return false, "Please enter a key." end

    for _, k in ipairs(Config.Keys) do
        if input == k then return true end
    end

    if Config.KeyCheckURL ~= "" then
        local ok, result = pcall(function()
            return game:HttpGet(Config.KeyCheckURL)
        end)
        if not ok then
            return false, "Could not reach key server."
        end
        if trim(result) == input then
            return true
        end
    end

    return false, "Invalid key. Try again."
end

local function closeGui()
    local t = tween(Main, { 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In }, {
        Size = UDim2.fromOffset(0, 0),
    })
    t.Completed:Wait()
    ScreenGui:Destroy()
end

local function runCheck()
    if busy then return end
    busy = true

    setStatus("Checking key...", Theme.Accent)
    CheckBtn.Text = "Checking..."
    task.wait(0.4)

    local ok, err = validateKey(KeyBox.Text)

    if ok then
        setStatus("Key accepted! Loading hub...", Theme.Success)
        CheckBtn.Text = "Success ✓"
        tween(KeyStroke, { 0.2 }, { Color = Theme.Success })
        task.wait(0.9)
        closeGui()
        task.spawn(Config.OnSuccess)
        return
    end

    setStatus(err, Theme.Error)
    CheckBtn.Text = "Check Key"
    tween(KeyStroke, { 0.2 }, { Color = Theme.Error })
    shake()
    task.wait(0.8)
    tween(KeyStroke, { 0.3 }, { Color = Theme.Secondary })
    busy = false
end

CheckBtn.MouseButton1Click:Connect(runCheck)

CopyBtn.MouseButton1Click:Connect(function()
    if copyToClipboard(Config.KeyLink) then
        setStatus("Link copied to clipboard!", Theme.Success)
        CopyBtn.Text = "Copied ✓"
    else
        setStatus("Clipboard not supported by your executor.", Theme.Error)
        CopyBtn.Text = "Failed"
    end
    task.wait(1.5)
    CopyBtn.Text = "Copy Link"
end)

KeyBox.FocusLost:Connect(function(enterPressed)
    tween(KeyStroke, { 0.15 }, { Color = Theme.Secondary })
    if enterPressed then
        runCheck()
    end
end)

Close.MouseButton1Click:Connect(closeGui)

-- Dragging
do
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Open animation (this is what makes the window appear)
tween(Main, { 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out }, { Size = WINDOW_SIZE })

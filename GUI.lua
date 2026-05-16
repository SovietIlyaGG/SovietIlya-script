-- =============================================
-- GUI.lua - ★ SovietIlya & Danil415k ★
-- v2.3 | Минимизация | Сохранение | Всё фиксы
-- =============================================

local GUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Конфиг
local function loadConfig()
    local success, config = pcall(function()
        if readfile then
            return game:GetService("HttpService"):JSONDecode(readfile("SovietIlya_Config.json"))
        end
        return {}
    end)
    if success and config then return config else return {} end
end

local function saveConfig(config)
    pcall(function()
        if writefile then
            writefile("SovietIlya_Config.json", game:GetService("HttpService"):JSONEncode(config))
        end
    end)
end

local savedConfig = loadConfig()

function GUI:Init(Funcs)
    local Functions = Funcs

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SovietIlyaMenu"
    ScreenGui.Parent = game.CoreGui

    -- ========================
    -- MINI BAR (всегда видно)
    -- ========================
    local MiniBar = Instance.new("Frame")
    MiniBar.Name = "MiniBar"
    MiniBar.Parent = ScreenGui
    MiniBar.Size = UDim2.new(0, 300, 0, 35)
    MiniBar.Position = savedConfig.MiniPosition and UDim2.new(0, savedConfig.MiniPosition.X, 0, savedConfig.MiniPosition.Y) or UDim2.new(0.5, -150, 0, 10)
    MiniBar.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    MiniBar.BackgroundTransparency = 0.15
    MiniBar.BorderColor3 = Color3.fromRGB(255, 30, 30)
    MiniBar.BorderSizePixel = 2
    MiniBar.Visible = true
    MiniBar.Active = true
    MiniBar.ClipsDescendants = true

    local MiniGradient = Instance.new("UIGradient")
    MiniGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 5)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
    })
    MiniGradient.Parent = MiniBar

    -- Перетаскивание MiniBar
    local miniDragging = false
    local miniDragStart = Vector2.new(0, 0)
    local miniStartPos = Vector2.new(0, 0)

    MiniBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            miniDragging = true
            miniDragStart = input.Position
            miniStartPos = MiniBar.AbsolutePosition
        end
    end)

    MiniBar.InputChanged:Connect(function(input)
        if miniDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - miniDragStart
            local newX = miniStartPos.X + delta.X
            local newY = miniStartPos.Y + delta.Y
            TweenService:Create(MiniBar, TweenInfo.new(0.05), {
                Position = UDim2.new(0, newX, 0, newY)
            }):Play()
        end
    end)

    MiniBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            miniDragging = false
            savedConfig.MiniPosition = {X = MiniBar.AbsolutePosition.X, Y = MiniBar.AbsolutePosition.Y}
            saveConfig(savedConfig)
        end
    end)

    -- Текст на MiniBar
    local MiniTitle = Instance.new("TextLabel")
    MiniTitle.Parent = MiniBar
    MiniTitle.Size = UDim2.new(0.7, 0, 1, 0)
    MiniTitle.Position = UDim2.new(0, 10, 0, 0)
    MiniTitle.BackgroundTransparency = 1
    MiniTitle.Text = "★ SovietIlya & Danil415k ★"
    MiniTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
    MiniTitle.TextSize = 14
    MiniTitle.Font = Enum.Font.GothamBold
    MiniTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Кнопка открыть/закрыть
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Parent = MiniBar
    ToggleBtn.Size = UDim2.new(0, 60, 0, 25)
    ToggleBtn.Position = UDim2.new(0.78, 0, 0.5, -12)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    ToggleBtn.BackgroundTransparency = 0.2
    ToggleBtn.Text = "OPEN"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 11
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.AutoButtonColor = false

    -- ========================
    -- MAIN FRAME 600x300
    -- ========================
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.Size = UDim2.new(0, 600, 0, 300)
    Main.Position = savedConfig.Position and UDim2.new(0, savedConfig.Position.X, 0, savedConfig.Position.Y) or UDim2.new(0.5, -300, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Main.BackgroundTransparency = 0.1
    Main.BorderColor3 = Color3.fromRGB(255, 30, 30)
    Main.BorderSizePixel = 2
    Main.Active = true
    Main.ClipsDescendants = true

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 5)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(180, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 15, 15)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(180, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
    })
    MainGradient.Parent = Main

    -- Перетаскивание Main
    local mainDragging = false
    local mainDragStart = Vector2.new(0, 0)
    local mainStartPos = Vector2.new(0, 0)

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            mainDragging = true
            mainDragStart = input.Position
            mainStartPos = Main.AbsolutePosition
        end
    end)

    Main.InputChanged:Connect(function(input)
        if mainDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - mainDragStart
            local newX = mainStartPos.X + delta.X
            local newY = mainStartPos.Y + delta.Y
            TweenService:Create(Main, TweenInfo.new(0.05), {
                Position = UDim2.new(0, newX, 0, newY)
            }):Play()
        end
    end)

    Main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            mainDragging = false
            savedConfig.Position = {X = Main.AbsolutePosition.X, Y = Main.AbsolutePosition.Y}
            saveConfig(savedConfig)
        end
    end)

    -- Toggle функция
    local menuOpen = true
    ToggleBtn.MouseButton1Click:Connect(function()
        menuOpen = not menuOpen
        if menuOpen then
            Main.Visible = true
            ToggleBtn.Text = "CLOSE"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        else
            Main.Visible = false
            ToggleBtn.Text = "OPEN"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        end
    end)

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Main
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Title.BackgroundTransparency = 0.2
    Title.Text = "★ SovietIlya & Danil415k ★"
    Title.TextColor3 = Color3.fromRGB(255, 255, 0)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.BorderSizePixel = 0

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Parent = Main
    SubTitle.Size = UDim2.new(1, 0, 0, 18)
    SubTitle.Position = UDim2.new(0, 0, 0, 35)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Script Menu Admin Menu"
    SubTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
    SubTitle.TextSize = 12
    SubTitle.Font = Enum.Font.Gotham

    -- Tab Holder
    local TabHolder = Instance.new("Frame")
    TabHolder.Parent = Main
    TabHolder.Size = UDim2.new(1, 0, 0, 30)
    TabHolder.Position = UDim2.new(0, 0, 0, 54)
    TabHolder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TabHolder.BackgroundTransparency = 0.3
    TabHolder.BorderSizePixel = 0

    local tabs = {"Main", "Steal a Brainrot", "Grow A Garden", "Other Scripts"}
    local tabButtons = {}
    local contentFrames = {}

    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Name = tabName .. "Tab"
        btn.Parent = TabHolder
        btn.Size = UDim2.new(1/4, -2, 1, -2)
        btn.Position = UDim2.new((i-1)/4, 0, 0, 1)
        btn.BackgroundColor3 = i == 1 and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(30, 30, 30)
        btn.BackgroundTransparency = 0.15
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        tabButtons[tabName] = btn

        local content = Instance.new("ScrollingFrame")
        content.Name = tabName .. "Content"
        content.Parent = Main
        content.Size = UDim2.new(1, -6, 1, -90)
        content.Position = UDim2.new(0, 3, 0, 86)
        content.BackgroundTransparency = 1
        content.Visible = (i == 1)
        content.ScrollBarThickness = 2
        content.ScrollBarImageColor3 = Color3.fromRGB(255, 30, 30)
        content.CanvasSize = UDim2.new(0, 0, 0, 850)
        content.BorderSizePixel = 0
        contentFrames[tabName] = content

        btn.MouseButton1Click:Connect(function()
            for _, b in pairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end
            btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            for _, c in pairs(contentFrames) do c.Visible = false end
            content.Visible = true
        end)
    end

    -- TOGGLE
    local function createToggle(parent, text, yPos, callback)
        local holder = Instance.new("Frame")
        holder.Parent = parent
        holder.Size = UDim2.new(1, -10, 0, 34)
        holder.Position = UDim2.new(0, 5, 0, yPos)
        holder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        holder.BackgroundTransparency = 0.25
        holder.BorderSizePixel = 0

        local label = Instance.new("TextLabel")
        label.Parent = holder
        label.Size = UDim2.new(0.75, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham

        local toggle = Instance.new("TextButton")
        toggle.Parent = holder
        toggle.Size = UDim2.new(0, 42, 0, 22)
        toggle.Position = UDim2.new(0.88, 0, 0.5, -11)
        toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        toggle.Text = ""
        toggle.BorderSizePixel = 0
        toggle.AutoButtonColor = false

        local toggleDot = Instance.new("Frame")
        toggleDot.Parent = toggle
        toggleDot.Size = UDim2.new(0, 18, 0, 18)
        toggleDot.Position = UDim2.new(0, 2, 0, 2)
        toggleDot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        toggleDot.BorderSizePixel = 0

        local enabled = false
        toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            if enabled then
                toggle.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
                TweenService:Create(toggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 22, 0, 2)}):Play()
            else
                toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                TweenService:Create(toggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
            end
            callback(enabled)
        end)
    end

    -- BUTTON
    local function createButton(parent, text, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.Size = UDim2.new(1, -10, 0, 32)
        btn.Position = UDim2.new(0, 5, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
        btn.BackgroundTransparency = 0.15
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.MouseButton1Click:Connect(callback)
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 10, 10)}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(160, 0, 0)}):Play() end)
    end

    -- POPUP
    local function createPopup(title, items, callback)
        local overlay = Instance.new("Frame")
        overlay.Parent = ScreenGui
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.6
        overlay.ZIndex = 10

        local popup = Instance.new("Frame")
        popup.Parent = overlay
        popup.Size = UDim2.new(0, 300, 0, 45 + #items * 34)
        popup.Position = UDim2.new(0.5, -150, 0.5, -(45 + #items * 34)/2)
        popup.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        popup.BorderColor3 = Color3.fromRGB(255, 40, 40)
        popup.BorderSizePixel = 2
        popup.ZIndex = 11

        local popTitle = Instance.new("TextLabel")
        popTitle.Parent = popup
        popTitle.Size = UDim2.new(1, 0, 0, 35)
        popTitle.BackgroundColor3 = Color3.fromRGB(180, 10, 10)
        popTitle.Text = title
        popTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
        popTitle.TextSize = 14
        popTitle.Font = Enum.Font.GothamBold
        popTitle.ZIndex = 11

        for i, itemName in ipairs(items) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Parent = popup
            itemBtn.Size = UDim2.new(1, -20, 0, 30)
            itemBtn.Position = UDim2.new(0, 10, 0, 38 + (i-1)*32)
            itemBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            itemBtn.Text = itemName
            itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            itemBtn.TextSize = 13
            itemBtn.Font = Enum.Font.GothamBold
            itemBtn.BorderSizePixel = 0
            itemBtn.AutoButtonColor = false
            itemBtn.ZIndex = 11
            itemBtn.MouseButton1Click:Connect(function() callback(itemName) overlay:Destroy() end)
            itemBtn.MouseEnter:Connect(function() TweenService:Create(itemBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 20, 20)}):Play() end)
            itemBtn.MouseLeave:Connect(function() TweenService:Create(itemBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play() end)
        end

        local closePopupBtn = Instance.new("TextButton")
        closePopupBtn.Parent = popup
        closePopupBtn.Size = UDim2.new(0, 26, 0, 26)
        closePopupBtn.Position = UDim2.new(1, -30, 0, 5)
        closePopupBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
        closePopupBtn.Text = "X"
        closePopupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closePopupBtn.TextSize = 13
        closePopupBtn.Font = Enum.Font.GothamBold
        closePopupBtn.ZIndex = 12
        closePopupBtn.AutoButtonColor = false
        closePopupBtn.MouseButton1Click:Connect(function() overlay:Destroy() end)
        overlay.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then overlay:Destroy() end end)
    end

    -- ========================
    -- TAB 1: MAIN
    -- ========================
    local mainContent = contentFrames["Main"]

    local mainLabel = Instance.new("TextLabel")
    mainLabel.Parent = mainContent
    mainLabel.Size = UDim2.new(1, 0, 0, 20)
    mainLabel.Position = UDim2.new(0, 5, 0, 5)
    mainLabel.BackgroundTransparency = 1
    mainLabel.Text = "-- MAIN FUNCTIONS --"
    mainLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    mainLabel.TextSize = 12
    mainLabel.Font = Enum.Font.Gotham

    createToggle(mainContent, "GodMode", 28, function(on) Functions:GodMode(on) end)
    createToggle(mainContent, "Anti-Ban & Anti-Cheat", 66, function(on) Functions:AntiBan(on) end)

    -- Spam Chat
    local spamHolder = Instance.new("Frame")
    spamHolder.Parent = mainContent
    spamHolder.Size = UDim2.new(1, -10, 0, 68)
    spamHolder.Position = UDim2.new(0, 5, 0, 104)
    spamHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    spamHolder.BackgroundTransparency = 0.25

    local spamLabel = Instance.new("TextLabel")
    spamLabel.Parent = spamHolder
    spamLabel.Size = UDim2.new(1, 0, 0, 20)
    spamLabel.BackgroundTransparency = 1
    spamLabel.Text = "Spam-Chat"
    spamLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    spamLabel.TextSize = 12
    spamLabel.Font = Enum.Font.Gotham

    local spamInput = Instance.new("TextBox")
    spamInput.Parent = spamHolder
    spamInput.Size = UDim2.new(0.7, 0, 0, 22)
    spamInput.Position = UDim2.new(0, 5, 0, 22)
    spamInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    spamInput.Text = "hello"
    spamInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    spamInput.TextSize = 11
    spamInput.Font = Enum.Font.Gotham

    local spamToggleBtn = Instance.new("TextButton")
    spamToggleBtn.Parent = spamHolder
    spamToggleBtn.Size = UDim2.new(0, 60, 0, 22)
    spamToggleBtn.Position = UDim2.new(0.75, 0, 0, 22)
    spamToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    spamToggleBtn.Text = "OFF"
    spamToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    spamToggleBtn.TextSize = 10
    spamToggleBtn.Font = Enum.Font.GothamBold
    spamToggleBtn.AutoButtonColor = false

    local spamOn = false
    spamToggleBtn.MouseButton1Click:Connect(function()
        spamOn = not spamOn
        if spamOn then
            spamToggleBtn.Text = "ON"
            spamToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
        else
            spamToggleBtn.Text = "OFF"
            spamToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        Functions:SpamChat(spamOn, spamInput.Text)
    end)

    createToggle(mainContent, "Fly (WASD/Space/Ctrl)", 176, function(on) Functions:Fly(on) end)

    local flySpeedLabel = Instance.new("TextLabel")
    flySpeedLabel.Parent = mainContent
    flySpeedLabel.Size = UDim2.new(0.35, 0, 0, 18)
    flySpeedLabel.Position = UDim2.new(0, 10, 0, 214)
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Text = "Fly Speed: 50"
    flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySpeedLabel.TextSize = 11
    flySpeedLabel.Font = Enum.Font.Gotham

    local flySlider = Instance.new("TextBox")
    flySlider.Parent = mainContent
    flySlider.Size = UDim2.new(0, 50, 0, 20)
    flySlider.Position = UDim2.new(0.4, 0, 0, 213)
    flySlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    flySlider.Text = "50"
    flySlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySlider.TextSize = 11
    flySlider.Font = Enum.Font.Gotham
    flySlider.FocusLost:Connect(function()
        local s = tonumber(flySlider.Text) or 50
        flySpeedLabel.Text = "Fly Speed: " .. s
        Functions:SetFlySpeed(s)
    end)

    createToggle(mainContent, "Speed Hack", 236, function(on) Functions:SpeedHack(on) end)

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Parent = mainContent
    speedLabel.Size = UDim2.new(0.35, 0, 0, 18)
    speedLabel.Position = UDim2.new(0, 10, 0, 274)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: 16"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 11
    speedLabel.Font = Enum.Font.Gotham

    local speedSlider = Instance.new("TextBox")
    speedSlider.Parent = mainContent
    speedSlider.Size = UDim2.new(0, 50, 0, 20)
    speedSlider.Position = UDim2.new(0.4, 0, 0, 273)
    speedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    speedSlider.Text = "16"
    speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedSlider.TextSize = 11
    speedSlider.Font = Enum.Font.Gotham
    speedSlider.FocusLost:Connect(function()
        local s = tonumber(speedSlider.Text) or 16
        speedLabel.Text = "Speed: " .. s
        Functions:SetSpeed(s)
    end)

    createToggle(mainContent, "Wallhack (ESP)", 296, function(on) Functions:ESP(on) end)

    -- ========================
    -- TAB 2: STEAL A BRAINROT
    -- ========================
    local brainContent = contentFrames["Steal a Brainrot"]

    local brainLabel = Instance.new("TextLabel")
    brainLabel.Parent = brainContent
    brainLabel.Size = UDim2.new(1, 0, 0, 20)
    brainLabel.Position = UDim2.new(0, 5, 0, 5)
    brainLabel.BackgroundTransparency = 1
    brainLabel.Text = "-- STEAL A BRAINROT --"
    brainLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    brainLabel.TextSize = 12
    brainLabel.Font = Enum.Font.Gotham

    local brainList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "GOD Brainrot", "SECRET", "OG"}
    local eventList = {"Blood Moon", "Double Luck", "Mythic Storm", "GOD Event", "SECRET Event", "OG Event"}

    createButton(brainContent, "Spawn Brainrot in Base", 30, function()
        createPopup("Select Brainrot Rarity", brainList, function(selected)
            Functions:SpawnBrainrot(selected, 999)
        end)
    end)

    createButton(brainContent, "Start Brainrot Event", 68, function()
        createPopup("Select Event", eventList, function(selected)
            Functions:StartEvent(selected)
        end)
    end)

    createToggle(brainContent, "Auto-Lock Base", 106, function(on) Functions:AutoLockBase(on) end)
    createToggle(brainContent, "Auto-PvP (Bat)", 144, function(on) Functions:AutoPvP(on) end)
    createToggle(brainContent, "Server Luck Boost", 182, function(on) Functions:LuckBoost(on) end)

    -- ========================
    -- TAB 3: GROW A GARDEN
    -- ========================
    local gardenContent = contentFrames["Grow A Garden"]

    local gardenLabel = Instance.new("TextLabel")
    gardenLabel.Parent = gardenContent
    gardenLabel.Size = UDim2.new(1, 0, 0, 20)
    gardenLabel.Position = UDim2.new(0, 5, 0, 5)
    gardenLabel.BackgroundTransparency = 1
    gardenLabel.Text = "-- GROW A GARDEN --"
    gardenLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    gardenLabel.TextSize = 12
    gardenLabel.Font = Enum.Font.Gotham

    local seedList = {"Sunflower", "Rose", "Tulip", "Daisy", "Cactus", "Venus Flytrap", "Golden Seed", "Mythic Seed", "GOD Seed", "SECRET Seed"}
    local petList = {"Dog", "Cat", "Bunny", "Dragon", "Unicorn", "Phoenix", "Alien Pet", "Mythic Pet", "GOD Pet", "SECRET Pet"}

    createButton(gardenContent, "Give Seeds (Dup x999)", 30, function()
        createPopup("Select Seed", seedList, function(selected) Functions:GiveSeeds(selected, 999) end)
    end)
    createButton(gardenContent, "Give Pet (Dup x999)", 68, function()
        createPopup("Select Pet", petList, function(selected) Functions:GivePet(selected, 999) end)
    end)
    createToggle(gardenContent, "Garden Luck Boost", 106, function(on) Functions:LuckBoost(on) end)

    -- ========================
    -- TAB 4: OTHER SCRIPTS
    -- ========================
    local otherContent = contentFrames["Other Scripts"]

    local otherLabel = Instance.new("TextLabel")
    otherLabel.Parent = otherContent
    otherLabel.Size = UDim2.new(1, 0, 0, 20)
    otherLabel.Position = UDim2.new(0, 5, 0, 5)
    otherLabel.BackgroundTransparency = 1
    otherLabel.Text = "-- OTHER SCRIPTS --"
    otherLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    otherLabel.TextSize = 12
    otherLabel.Font = Enum.Font.Gotham

    createButton(otherContent, "Give AK-47", 30, function() Functions:GiveWeapon("AK-47") end)
    createButton(otherContent, "Give RPG", 68, function() Functions:GiveWeapon("RPG") end)
    createButton(otherContent, "Give MP5", 106, function() Functions:GiveWeapon("MP5") end)
    createButton(otherContent, "Free Robuxes", 144, function() Functions:FreeRobuxes() end)
    createButton(otherContent, "Give FGM-148 Javelin", 182, function() Functions:GiveWeapon("FGM-148 Javelin") end)
    createButton(otherContent, "Spawn Bot (Self-Aware)", 220, function() Functions:SpawnBot() end)
    createButton(otherContent, "Give Admin & VIP", 258, function() Functions:GiveAdminVIP() end)

    print("GUI Loaded! ★ SovietIlya & Danil415k ★")
end

return GUI
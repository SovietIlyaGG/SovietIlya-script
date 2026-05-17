-- =============================================
-- GUI.lua - ★ SovietIlya & Danil415k ★
-- v5.0 | Circle Button | Drag Popups | Gradient
-- =============================================

local GUI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

function GUI:Init(Funcs)
    local Functions = Funcs

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SovietIlyaMenu"
    ScreenGui.Parent = game.CoreGui

    local UIS = game:GetService("UserInputService")

    -- ========================
    -- FLOATING CIRCLE BUTTON
    -- ========================
    local CircleBtn = Instance.new("TextButton")
    CircleBtn.Name = "CircleBtn"
    CircleBtn.Parent = ScreenGui
    CircleBtn.Size = UDim2.new(0, 55, 0, 55)
    CircleBtn.Position = UDim2.new(0, 20, 0, 100)
    CircleBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
    CircleBtn.BackgroundTransparency = 0.2
    CircleBtn.Text = "★"
    CircleBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
    CircleBtn.TextSize = 22
    CircleBtn.Font = Enum.Font.GothamBold
    CircleBtn.BorderSizePixel = 0
    CircleBtn.AutoButtonColor = false
    CircleBtn.Active = true
    CircleBtn.ZIndex = 20

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = CircleBtn

    local CircleGradient = Instance.new("UIGradient")
    CircleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 0, 0))
    })
    CircleGradient.Parent = CircleBtn

    local circleDragging, circleDragStart, circleStartPos

    CircleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            circleDragging = true
            circleDragStart = input.Position
            circleStartPos = CircleBtn.Position
        end
    end)

    CircleBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            circleDragging = false
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if circleDragging then
            local delta = UIS:GetMouseLocation() - circleDragStart
            CircleBtn.Position = UDim2.new(0, circleStartPos.X.Offset + delta.X, 0, circleStartPos.Y.Offset + delta.Y)
        end
    end)

    -- ========================
    -- MAIN FRAME
    -- ========================
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.Size = UDim2.new(0, 600, 0, 300)
    Main.Position = UDim2.new(0.5, -300, 0.5, -150)
    Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Main.BackgroundTransparency = 0.1
    Main.BorderColor3 = Color3.fromRGB(255, 30, 30)
    Main.BorderSizePixel = 2
    Main.Active = true
    Main.ClipsDescendants = true
    Main.Visible = false

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 5)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(160, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 10, 10)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(160, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
    })
    MainGradient.Parent = Main

    local mainDragging, mainDragStart, mainStartPos

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            mainDragging = true
            mainDragStart = input.Position
            mainStartPos = Main.Position
        end
    end)

    Main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            mainDragging = false
        end
    end)

    game:GetService("RunService").RenderStepped:Connect(function()
        if mainDragging then
            local delta = UIS:GetMouseLocation() - mainDragStart
            Main.Position = UDim2.new(0, mainStartPos.X.Offset + delta.X, 0, mainStartPos.Y.Offset + delta.Y)
        end
    end)

    CircleBtn.MouseButton1Click:Connect(function()
        if not circleDragging then
            Main.Visible = not Main.Visible
        end
    end)

    -- ========================
    -- TITLE
    -- ========================
    local Title = Instance.new("TextLabel")
    Title.Parent = Main
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Title.BackgroundTransparency = 0.2
    Title.Text = "★ SovietIlya & Danil415k ★"
    Title.TextColor3 = Color3.fromRGB(255, 255, 0)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Parent = Main
    SubTitle.Size = UDim2.new(1, 0, 0, 16)
    SubTitle.Position = UDim2.new(0, 0, 0, 35)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Script Menu Admin Menu"
    SubTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
    SubTitle.TextSize = 11
    SubTitle.Font = Enum.Font.Gotham

    local ExitBtn = Instance.new("TextButton")
    ExitBtn.Parent = Main
    ExitBtn.Size = UDim2.new(0, 28, 0, 28)
    ExitBtn.Position = UDim2.new(1, -32, 0, 4)
    ExitBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    ExitBtn.Text = "X"
    ExitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExitBtn.TextSize = 14
    ExitBtn.Font = Enum.Font.GothamBold
    ExitBtn.BorderSizePixel = 0
    ExitBtn.AutoButtonColor = false
    ExitBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- ========================
    -- TABS
    -- ========================
    local TabHolder = Instance.new("Frame")
    TabHolder.Parent = Main
    TabHolder.Size = UDim2.new(1, 0, 0, 28)
    TabHolder.Position = UDim2.new(0, 0, 0, 52)
    TabHolder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TabHolder.BackgroundTransparency = 0.3

    local tabs = {"Main", "Steal a Brainrot", "Grow A Garden"}
    local tabButtons = {}
    local contentFrames = {}

    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Parent = TabHolder
        btn.Size = UDim2.new(1/3, -2, 1, -2)
        btn.Position = UDim2.new((i-1)/3, 0, 0, 1)
        btn.BackgroundColor3 = i == 1 and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(30, 30, 30)
        btn.BackgroundTransparency = 0.15
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        tabButtons[tabName] = btn

        local content = Instance.new("ScrollingFrame")
        content.Parent = Main
        content.Size = UDim2.new(1, -6, 1, -86)
        content.Position = UDim2.new(0, 3, 0, 82)
        content.BackgroundTransparency = 1
        content.Visible = (i == 1)
        content.ScrollBarThickness = 2
        content.ScrollBarImageColor3 = Color3.fromRGB(255, 30, 30)
        content.CanvasSize = UDim2.new(0, 0, 0, 500)
        content.BorderSizePixel = 0
        contentFrames[tabName] = content

        btn.MouseButton1Click:Connect(function()
            for _, b in pairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(30, 30, 30) end
            btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            for _, c in pairs(contentFrames) do c.Visible = false end
            content.Visible = true
        end)
    end

    -- ========================
    -- TOGGLE
    -- ========================
    local function createToggle(parent, text, yPos, callback)
        local holder = Instance.new("Frame")
        holder.Parent = parent
        holder.Size = UDim2.new(1, -10, 0, 32)
        holder.Position = UDim2.new(0, 5, 0, yPos)
        holder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        holder.BackgroundTransparency = 0.25

        local label = Instance.new("TextLabel")
        label.Parent = holder
        label.Size = UDim2.new(0.75, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham

        local toggle = Instance.new("TextButton")
        toggle.Parent = holder
        toggle.Size = UDim2.new(0, 40, 0, 20)
        toggle.Position = UDim2.new(0.88, 0, 0.5, -10)
        toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        toggle.Text = "OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextSize = 9
        toggle.Font = Enum.Font.GothamBold
        toggle.BorderSizePixel = 0
        toggle.AutoButtonColor = false

        local enabled = false
        toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            if enabled then
                toggle.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
                toggle.Text = "ON"
            else
                toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                toggle.Text = "OFF"
            end
            callback(enabled)
        end)
    end

    -- ========================
    -- BUTTON
    -- ========================
    local function createButton(parent, text, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Position = UDim2.new(0, 5, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
        btn.BackgroundTransparency = 0.15
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.MouseButton1Click:Connect(callback)
        btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 10, 10)}):Play() end)
        btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(160, 0, 0)}):Play() end)
    end

    -- ========================
    -- DRAGGABLE POPUP
    -- ========================
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
        popup.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        popup.BorderColor3 = Color3.fromRGB(255, 40, 40)
        popup.BorderSizePixel = 2
        popup.ZIndex = 11
        popup.Active = true

        local PopGradient = Instance.new("UIGradient")
        PopGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 5)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(160, 10, 10)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
        })
        PopGradient.Parent = popup

        local popDragging, popDragStart, popStartPos
        popup.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                popDragging = true
                popDragStart = input.Position
                popStartPos = popup.Position
            end
        end)
        popup.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                popDragging = false
            end
        end)
        game:GetService("RunService").RenderStepped:Connect(function()
            if popDragging then
                local delta = UIS:GetMouseLocation() - popDragStart
                popup.Position = UDim2.new(0, popStartPos.X.Offset + delta.X, 0, popStartPos.Y.Offset + delta.Y)
            end
        end)

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
    mainLabel.Size = UDim2.new(1, 0, 0, 18)
    mainLabel.Position = UDim2.new(0, 5, 0, 3)
    mainLabel.BackgroundTransparency = 1
    mainLabel.Text = "-- MAIN FUNCTIONS --"
    mainLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    mainLabel.TextSize = 11
    mainLabel.Font = Enum.Font.Gotham

    createToggle(mainContent, "GodMode", 24, function(on) Functions:GodMode(on) end)
    createToggle(mainContent, "Anti-Ban & Anti-Cheat", 60, function(on) Functions:AntiBan(on) end)

    local spamHolder = Instance.new("Frame")
    spamHolder.Parent = mainContent
    spamHolder.Size = UDim2.new(1, -10, 0, 60)
    spamHolder.Position = UDim2.new(0, 5, 0, 96)
    spamHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    spamHolder.BackgroundTransparency = 0.25

    local spamLabel = Instance.new("TextLabel")
    spamLabel.Parent = spamHolder
    spamLabel.Size = UDim2.new(1, 0, 0, 18)
    spamLabel.BackgroundTransparency = 1
    spamLabel.Text = "Spam-Chat"
    spamLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    spamLabel.TextSize = 11
    spamLabel.Font = Enum.Font.Gotham

    local spamInput = Instance.new("TextBox")
    spamInput.Parent = spamHolder
    spamInput.Size = UDim2.new(0.65, 0, 0, 20)
    spamInput.Position = UDim2.new(0, 5, 0, 20)
    spamInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    spamInput.Text = "hello"
    spamInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    spamInput.TextSize = 10
    spamInput.Font = Enum.Font.Gotham

    local spamToggleBtn = Instance.new("TextButton")
    spamToggleBtn.Parent = spamHolder
    spamToggleBtn.Size = UDim2.new(0, 50, 0, 20)
    spamToggleBtn.Position = UDim2.new(0.72, 0, 0, 20)
    spamToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    spamToggleBtn.Text = "OFF"
    spamToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    spamToggleBtn.TextSize = 9
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

    createToggle(mainContent, "Fly (WASD/Space/Ctrl)", 160, function(on) Functions:Fly(on) end)

    local flySpeedLabel = Instance.new("TextLabel")
    flySpeedLabel.Parent = mainContent
    flySpeedLabel.Size = UDim2.new(0.3, 0, 0, 18)
    flySpeedLabel.Position = UDim2.new(0, 10, 0, 196)
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Text = "Speed: 50"
    flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySpeedLabel.TextSize = 10
    flySpeedLabel.Font = Enum.Font.Gotham

    local flySlider = Instance.new("TextBox")
    flySlider.Parent = mainContent
    flySlider.Size = UDim2.new(0, 45, 0, 18)
    flySlider.Position = UDim2.new(0.35, 0, 0, 196)
    flySlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    flySlider.Text = "50"
    flySlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySlider.TextSize = 10
    flySlider.Font = Enum.Font.Gotham
    flySlider.FocusLost:Connect(function()
        local s = tonumber(flySlider.Text) or 50
        flySpeedLabel.Text = "Speed: " .. s
        Functions:SetFlySpeed(s)
    end)

    createToggle(mainContent, "Speed Hack", 218, function(on) Functions:SpeedHack(on) end)

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Parent = mainContent
    speedLabel.Size = UDim2.new(0.3, 0, 0, 18)
    speedLabel.Position = UDim2.new(0, 10, 0, 254)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: 16"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 10
    speedLabel.Font = Enum.Font.Gotham

    local speedSlider = Instance.new("TextBox")
    speedSlider.Parent = mainContent
    speedSlider.Size = UDim2.new(0, 45, 0, 18)
    speedSlider.Position = UDim2.new(0.35, 0, 0, 254)
    speedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    speedSlider.Text = "16"
    speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedSlider.TextSize = 10
    speedSlider.Font = Enum.Font.Gotham
    speedSlider.FocusLost:Connect(function()
        local s = tonumber(speedSlider.Text) or 16
        speedLabel.Text = "Speed: " .. s
        Functions:SetSpeed(s)
    end)

    createToggle(mainContent, "Wallhack (ESP)", 276, function(on) Functions:ESP(on) end)

    -- ========================
    -- TAB 2: STEAL A BRAINROT
    -- ========================
    local brainContent = contentFrames["Steal a Brainrot"]

    local brainLabel = Instance.new("TextLabel")
    brainLabel.Parent = brainContent
    brainLabel.Size = UDim2.new(1, 0, 0, 18)
    brainLabel.Position = UDim2.new(0, 5, 0, 3)
    brainLabel.BackgroundTransparency = 1
    brainLabel.Text = "-- STEAL A BRAINROT --"
    brainLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    brainLabel.TextSize = 11
    brainLabel.Font = Enum.Font.Gotham

    local brainList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "GOD Brainrot", "SECRET", "OG"}
    local eventList = {"Blood Moon", "Double Luck", "Mythic Storm", "GOD Event", "SECRET Event", "OG Event"}

    createButton(brainContent, "Spawn Brainrot (Dup x999)", 24, function()
        createPopup("Select Brainrot Rarity", brainList, function(selected)
            Functions:SpawnBrainrot(selected, 999)
        end)
    end)

    createButton(brainContent, "Start Brainrot Event", 60, function()
        createPopup("Select Event", eventList, function(selected)
            Functions:StartEvent(selected)
        end)
    end)

    createToggle(brainContent, "Auto-Lock Base", 96, function(on) Functions:AutoLockBase(on) end)
    createToggle(brainContent, "Auto-PvP (Bat)", 132, function(on) Functions:AutoPvP(on) end)
    createToggle(brainContent, "Server Luck Boost", 168, function(on) Functions:LuckBoost(on) end)

    -- ========================
    -- TAB 3: GROW A GARDEN
    -- ========================
    local gardenContent = contentFrames["Grow A Garden"]

    local gardenLabel = Instance.new("TextLabel")
    gardenLabel.Parent = gardenContent
    gardenLabel.Size = UDim2.new(1, 0, 0, 18)
    gardenLabel.Position = UDim2.new(0, 5, 0, 3)
    gardenLabel.BackgroundTransparency = 1
    gardenLabel.Text = "-- GROW A GARDEN --"
    gardenLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    gardenLabel.TextSize = 11
    gardenLabel.Font = Enum.Font.Gotham

    local seedList = {"Sunflower", "Rose", "Tulip", "Daisy", "Cactus", "Venus Flytrap", "Golden Seed", "Mythic Seed", "GOD Seed", "SECRET Seed"}
    local petList = {"Dog", "Cat", "Bunny", "Dragon", "Unicorn", "Phoenix", "Alien Pet", "Mythic Pet", "GOD Pet", "SECRET Pet"}

    createButton(gardenContent, "Give Seeds (Dup x999)", 24, function()
        createPopup("Select Seed", seedList, function(selected) Functions:GiveSeeds(selected, 999) end)
    end)
    createButton(gardenContent, "Give Pet (Dup x999)", 60, function()
        createPopup("Select Pet", petList, function(selected) Functions:GivePet(selected, 999) end)
    end)
    createToggle(gardenContent, "Garden Luck Boost", 96, function(on) Functions:LuckBoost(on) end)

    print("★ SovietIlya & Danil415k GUI Loaded!")
end

return GUI
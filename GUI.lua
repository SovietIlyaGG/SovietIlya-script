-- =============================================
-- GUI.lua - ☭ SovietIlya & Danil415k ☭
-- 600x300 | Плавное | Попапы | Свой спам
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

    -- Main Frame 600x300
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

    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 5)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(180, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 15, 15)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(180, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
    })
    MainGradient.Parent = Main

    -- Плавное перетаскивание
    local dragging = false
    local dragStart = Vector2.new(0, 0)
    local startPos = Vector2.new(0, 0)

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.AbsolutePosition
        end
    end)

    Main.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            TweenService:Create(Main, TweenInfo.new(0.05), {
                Position = UDim2.new(0, startPos.X + delta.X, 0, startPos.Y + delta.Y)
            }):Play()
        end
    end)

    Main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Main
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Title.BackgroundTransparency = 0.2
    Title.Text = "☭ SovietIlya & Danil415k ☭"
    Title.TextColor3 = Color3.fromRGB(255, 255, 0)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.BorderSizePixel = 0

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
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
    TabHolder.Name = "TabHolder"
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
        content.CanvasSize = UDim2.new(0, 0, 0, 750)
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
        holder.Size = UDim2.new(1, -10, 0, 36)
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
        toggle.Size = UDim2.new(0, 44, 0, 22)
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
                TweenService:Create(toggleDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 24, 0, 2)}):Play()
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
        btn.Size = UDim2.new(1, -10, 0, 34)
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
        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 10, 10)}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(160, 0, 0)}):Play()
        end)
    end

    -- POPUP (исправлен)
    local function createPopup(title, items, callback)
        local overlay = Instance.new("Frame")
        overlay.Name = "Overlay"
        overlay.Parent = ScreenGui
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.6
        overlay.ZIndex = 9

        local popup = Instance.new("Frame")
        popup.Parent = overlay
        popup.Size = UDim2.new(0, 300, 0, 45 + #items * 34)
        popup.Position = UDim2.new(0.5, -150, 0.5, -(45 + #items * 34)/2)
        popup.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        popup.BackgroundTransparency = 0.02
        popup.BorderColor3 = Color3.fromRGB(255, 40, 40)
        popup.BorderSizePixel = 2
        popup.ZIndex = 10
        popup.ClipsDescendants = true

        local popTitle = Instance.new("TextLabel")
        popTitle.Parent = popup
        popTitle.Size = UDim2.new(1, 0, 0, 35)
        popTitle.BackgroundColor3 = Color3.fromRGB(180, 10, 10)
        popTitle.BackgroundTransparency = 0.1
        popTitle.Text = title
        popTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
        popTitle.TextSize = 14
        popTitle.Font = Enum.Font.GothamBold
        popTitle.ZIndex = 10

        for i, itemName in ipairs(items) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Parent = popup
            itemBtn.Size = UDim2.new(1, -20, 0, 30)
            itemBtn.Position = UDim2.new(0, 10, 0, 38 + (i-1)*32)
            itemBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            itemBtn.BackgroundTransparency = 0.05
            itemBtn.Text = itemName
            itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            itemBtn.TextSize = 13
            itemBtn.Font = Enum.Font.GothamBold
            itemBtn.BorderSizePixel = 0
            itemBtn.AutoButtonColor = false
            itemBtn.ZIndex = 10

            itemBtn.MouseButton1Click:Connect(function()
                callback(itemName)
                overlay:Destroy()
            end)
            itemBtn.MouseEnter:Connect(function()
                TweenService:Create(itemBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 20, 20)}):Play()
            end)
            itemBtn.MouseLeave:Connect(function()
                TweenService:Create(itemBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)
        end

        local closePopupBtn = Instance.new("TextButton")
        closePopupBtn.Parent = popup
        closePopupBtn.Size = UDim2.new(0, 26, 0, 26)
        closePopupBtn.Position = UDim2.new(1, -30, 0, 5)
        closePopupBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
        closePopupBtn.Text = "✕"
        closePopupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closePopupBtn.TextSize = 13
        closePopupBtn.Font = Enum.Font.GothamBold
        closePopupBtn.ZIndex = 11
        closePopupBtn.AutoButtonColor = false
        closePopupBtn.MouseButton1Click:Connect(function() overlay:Destroy() end)

        overlay.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then overlay:Destroy() end
        end)
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
    mainLabel.Text = "— MAIN FUNCTIONS —"
    mainLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    mainLabel.TextSize = 12
    mainLabel.Font = Enum.Font.Gotham

    createToggle(mainContent, "GodMode", 28, function(on) Functions:GodMode(on) end)
    createToggle(mainContent, "Anti-Ban & Anti-Cheat", 68, function(on) Functions:AntiBan(on) end)

    -- Spam Chat с кастомным текстом
    local spamHolder = Instance.new("Frame")
    spamHolder.Parent = mainContent
    spamHolder.Size = UDim2.new(1, -10, 0, 70)
    spamHolder.Position = UDim2.new(0, 5, 0, 108)
    spamHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    spamHolder.BackgroundTransparency = 0.25
    spamHolder.BorderSizePixel = 0

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
    spamInput.Size = UDim2.new(1, -10, 0, 22)
    spamInput.Position = UDim2.new(0, 5, 0, 22)
    spamInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    spamInput.PlaceholderText = "Текст для спама..."
    spamInput.Text = "hello"
    spamInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    spamInput.TextSize = 11
    spamInput.Font = Enum.Font.Gotham

    local spamToggle = Instance.new("TextButton")
    spamToggle.Parent = spamHolder
    spamToggle.Size = UDim2.new(0, 44, 0, 22)
    spamToggle.Position = UDim2.new(0.88, 0, 0, 22)
    spamToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    spamToggle.Text = ""
    spamToggle.BorderSizePixel = 0
    spamToggle.AutoButtonColor = false

    local spamDot = Instance.new("Frame")
    spamDot.Parent = spamToggle
    spamDot.Size = UDim2.new(0, 18, 0, 18)
    spamDot.Position = UDim2.new(0, 2, 0, 2)
    spamDot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
    spamDot.BorderSizePixel = 0

    local spamEnabled = false
    spamToggle.MouseButton1Click:Connect(function()
        spamEnabled = not spamEnabled
        if spamEnabled then
            spamToggle.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
            TweenService:Create(spamDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 24, 0, 2)}):Play()
            Functions:SpamChat(true, spamInput.Text)
        else
            spamToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            TweenService:Create(spamDot, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0, 2)}):Play()
            Functions:SpamChat(false)
        end
    end)

    createToggle(mainContent, "Fly", 182, function(on) Functions:Fly(on) end)

    local flySpeedLabel = Instance.new("TextLabel")
    flySpeedLabel.Parent = mainContent
    flySpeedLabel.Size = UDim2.new(0.4, 0, 0, 18)
    flySpeedLabel.Position = UDim2.new(0, 10, 0, 222)
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Text = "Fly Speed: 50"
    flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySpeedLabel.TextSize = 11
    flySpeedLabel.Font = Enum.Font.Gotham

    local flySlider = Instance.new("TextBox")
    flySlider.Parent = mainContent
    flySlider.Size = UDim2.new(0, 50, 0, 20)
    flySlider.Position = UDim2.new(0.45, 0, 0, 221)
    flySlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    flySlider.Text = "50"
    flySlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySlider.TextSize = 11
    flySlider.Font = Enum.Font.Gotham
    flySlider.FocusLost:Connect(function()
        local speed = tonumber(flySlider.Text) or 50
        flySpeedLabel.Text = "Fly Speed: " .. speed
        Functions:SetFlySpeed(speed)
    end)

    createToggle(mainContent, "Speed Hack", 244, function(on) Functions:SpeedHack(on) end)

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Parent = mainContent
    speedLabel.Size = UDim2.new(0.4, 0, 0, 18)
    speedLabel.Position = UDim2.new(0, 10, 0, 284)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: 16"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 11
    speedLabel.Font = Enum.Font.Gotham

    local speedSlider = Instance.new("TextBox")
    speedSlider.Parent = mainContent
    speedSlider.Size = UDim2.new(0, 50, 0, 20)
    speedSlider.Position = UDim2.new(0.45, 0, 0, 283)
    speedSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    speedSlider.Text = "16"
    speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedSlider.TextSize = 11
    speedSlider.Font = Enum.Font.Gotham
    speedSlider.FocusLost:Connect(function()
        local speed = tonumber(speedSlider.Text) or 16
        speedLabel.Text = "Speed: " .. speed
        Functions:SetSpeed(speed)
    end)

    createToggle(mainContent, "Wallhack (ESP)", 306, function(on) Functions:ESP(on) end)

    -- ========================
    -- TAB 2: STEAL A BRAINROT
    -- ========================
    local brainContent = contentFrames["Steal a Brainrot"]

    local brainLabel = Instance.new("TextLabel")
    brainLabel.Parent = brainContent
    brainLabel.Size = UDim2.new(1, 0, 0, 20)
    brainLabel.Position = UDim2.new(0, 5, 0, 5)
    brainLabel.BackgroundTransparency = 1
    brainLabel.Text = "— STEAL A BRAINROT —"
    brainLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    brainLabel.TextSize = 12
    brainLabel.Font = Enum.Font.Gotham

    local brainList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "GOD Brainrot", "SECRET", "OG"}

    createButton(brainContent, "Spawn Brainrot in Base", 30, function()
        createPopup("Select Brainrot Rarity", brainList, function(selected)
            Functions:SpawnBrainrot(selected)
        end)
    end)

    createToggle(brainContent, "Auto-Lock Base", 74, function(on) Functions:AutoLockBase(on) end)
    createToggle(brainContent, "Auto-PvP (Bat)", 114, function(on) Functions:AutoPvP(on) end)

    -- ========================
    -- TAB 3: GROW A GARDEN
    -- ========================
    local gardenContent = contentFrames["Grow A Garden"]

    local gardenLabel = Instance.new("TextLabel")
    gardenLabel.Parent = gardenContent
    gardenLabel.Size = UDim2.new(1, 0, 0, 20)
    gardenLabel.Position = UDim2.new(0, 5, 0, 5)
    gardenLabel.BackgroundTransparency = 1
    gardenLabel.Text = "— GROW A GARDEN —"
    gardenLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    gardenLabel.TextSize = 12
    gardenLabel.Font = Enum.Font.Gotham

    local seedList = {"Sunflower", "Rose", "Tulip", "Daisy", "Cactus", "Venus Flytrap", "Golden Seed", "Mythic Seed", "GOD Seed", "SECRET Seed"}
    local petList = {"Dog", "Cat", "Bunny", "Dragon", "Unicorn", "Phoenix", "Alien Pet", "Mythic Pet", "GOD Pet", "SECRET Pet"}

    createButton(gardenContent, "Give Seeds (Free Dupe)", 30, function()
        createPopup("Select Seed", seedList, function(selected) Functions:GiveSeeds(selected, 999) end)
    end)
    createButton(gardenContent, "Give Pet (Free Dupe)", 74, function()
        createPopup("Select Pet", petList, function(selected) Functions:GivePet(selected, 999) end)
    end)

    -- ========================
    -- TAB 4: OTHER SCRIPTS
    -- ========================
    local otherContent = contentFrames["Other Scripts"]

    local otherLabel = Instance.new("TextLabel")
    otherLabel.Parent = otherContent
    otherLabel.Size = UDim2.new(1, 0, 0, 20)
    otherLabel.Position = UDim2.new(0, 5, 0, 5)
    otherLabel.BackgroundTransparency = 1
    otherLabel.Text = "— OTHER SCRIPTS —"
    otherLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    otherLabel.TextSize = 12
    otherLabel.Font = Enum.Font.Gotham

    createButton(otherContent, "Give AK-47", 30, function() Functions:GiveWeapon("AK-47") end)
    createButton(otherContent, "Give RPG", 70, function() Functions:GiveWeapon("RPG") end)
    createButton(otherContent, "Give MP5", 110, function() Functions:GiveWeapon("MP5") end)
    createButton(otherContent, "Free Robuxes", 150, function() Functions:FreeRobuxes() end)
    createButton(otherContent, "Give FGM-148 Javelin", 190, function() Functions:GiveWeapon("FGM-148 Javelin") end)
    createButton(otherContent, "Spawn Bot (Self-Aware)", 230, function() Functions:SpawnBot() end)
    createButton(otherContent, "Give Admin & VIP Commands", 270, function() Functions:GiveAdminVIP() end)

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = Main
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -32, 0, 4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 5
    closeBtn.AutoButtonColor = false
    closeBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    print("✅ GUI SovietIlya & Danil415k загружен!")
end

return GUI
-- =============================================
-- GUI.lua - ★ Mod Menu By IlyaHacker ★
-- v9.0 FINAL | Circle Opens Menu | Menu Moves
-- =============================================

local GUI = {}
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

function GUI:Init(Funcs)
    local Functions = Funcs
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "IlyaHackerMenu"
    ScreenGui.Parent = game.CoreGui

    -- ========================
    -- CIRCLE BUTTON (FIXED)
    -- ========================
    local CircleBtn = Instance.new("TextButton")
    CircleBtn.Parent = ScreenGui
    CircleBtn.Size = UDim2.new(0, 55, 0, 55)
    CircleBtn.Position = UDim2.new(0, 20, 0, 100)
    CircleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    CircleBtn.BackgroundTransparency = 0.2
    CircleBtn.Text = "★"
    CircleBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
    CircleBtn.TextSize = 22
    CircleBtn.Font = Enum.Font.GothamBold
    CircleBtn.BorderSizePixel = 0
    CircleBtn.AutoButtonColor = false
    CircleBtn.ZIndex = 20
    Instance.new("UICorner", CircleBtn).CornerRadius = UDim.new(1, 0)

    local circleDragging = false
    local circleStartPos = nil
    local circleInputStart = nil
    local circleMoved = false

    CircleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            circleDragging = true
            circleMoved = false
            circleStartPos = CircleBtn.Position
            circleInputStart = input.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if circleDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - circleInputStart
            if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
                circleMoved = true
                CircleBtn.Position = UDim2.new(0, circleStartPos.X.Offset + delta.X, 0, circleStartPos.Y.Offset + delta.Y)
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            circleDragging = false
        end
    end)

    -- ========================
    -- MAIN FRAME (FIXED)
    -- ========================
    local Main = Instance.new("Frame")
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

    local mainDragging = false
    local mainStartPos = nil
    local mainInputStart = nil

    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            mainDragging = true
            mainStartPos = Main.Position
            mainInputStart = input.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if mainDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - mainInputStart
            Main.Position = UDim2.new(0, mainStartPos.X.Offset + delta.X, 0, mainStartPos.Y.Offset + delta.Y)
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            mainDragging = false
        end
    end)

    -- КЛИК ПО КРУГУ ОТКРЫВАЕТ МЕНЮ (только если не двигали)
    CircleBtn.MouseButton1Click:Connect(function()
        if not circleMoved then
            Main.Visible = not Main.Visible
        end
    end)

    -- TITLE
    local Title = Instance.new("TextLabel")
    Title.Parent = Main
    Title.Size = UDim2.new(1, 0, 0, 35)
    Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Title.Text = "★ Mod Menu By IlyaHacker ★"
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
    ExitBtn.AutoButtonColor = false
    ExitBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- TABS
    local TabHolder = Instance.new("Frame")
    TabHolder.Parent = Main
    TabHolder.Size = UDim2.new(1, 0, 0, 28)
    TabHolder.Position = UDim2.new(0, 0, 0, 52)
    TabHolder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    TabHolder.BackgroundTransparency = 0.3

    local tabs = {"Main", "Steal a Brainrot", "Grow A Garden", "99 Nights in Forest", "Other"}
    local tabButtons = {}
    local contentFrames = {}

    for i, tabName in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Parent = TabHolder
        btn.Size = UDim2.new(1/5, -2, 1, -2)
        btn.Position = UDim2.new((i-1)/5, 0, 0, 1)
        btn.BackgroundColor3 = i == 1 and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(30, 30, 30)
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 9
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        tabButtons[tabName] = btn

        local content = Instance.new("ScrollingFrame")
        content.Parent = Main
        content.Size = UDim2.new(1, -6, 1, -86)
        content.Position = UDim2.new(0, 3, 0, 82)
        content.BackgroundTransparency = 1
        content.Visible = (i == 1)
        content.ScrollBarThickness = 2
        content.CanvasSize = UDim2.new(0, 0, 0, 500)
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
        holder.Size = UDim2.new(1, -10, 0, 28)
        holder.Position = UDim2.new(0, 5, 0, yPos)
        holder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        holder.BackgroundTransparency = 0.25
        local label = Instance.new("TextLabel")
        label.Parent = holder
        label.Size = UDim2.new(0.75, 0, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        local toggle = Instance.new("TextButton")
        toggle.Parent = holder
        toggle.Size = UDim2.new(0, 36, 0, 18)
        toggle.Position = UDim2.new(0.88, 0, 0.5, -9)
        toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        toggle.Text = "OFF"
        toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggle.TextSize = 8
        toggle.Font = Enum.Font.GothamBold
        toggle.AutoButtonColor = false
        local enabled = false
        toggle.MouseButton1Click:Connect(function()
            enabled = not enabled
            if enabled then toggle.BackgroundColor3 = Color3.fromRGB(255, 30, 30) toggle.Text = "ON"
            else toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50) toggle.Text = "OFF" end
            callback(enabled)
        end)
    end

    -- BUTTON
    local function createButton(parent, text, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Parent = parent
        btn.Size = UDim2.new(1, -10, 0, 28)
        btn.Position = UDim2.new(0, 5, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 10
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.MouseButton1Click:Connect(callback)
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
        popup.Size = UDim2.new(0, 280, 0, 40 + #items * 30)
        popup.Position = UDim2.new(0.5, -140, 0.5, -(40 + #items * 30)/2)
        popup.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        popup.BorderColor3 = Color3.fromRGB(255, 40, 40)
        popup.BorderSizePixel = 2
        popup.ZIndex = 11
        local popTitle = Instance.new("TextLabel")
        popTitle.Parent = popup
        popTitle.Size = UDim2.new(1, 0, 0, 32)
        popTitle.BackgroundColor3 = Color3.fromRGB(180, 10, 10)
        popTitle.Text = title
        popTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
        popTitle.TextSize = 13
        popTitle.Font = Enum.Font.GothamBold
        popTitle.ZIndex = 11
        for i, itemName in ipairs(items) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Parent = popup
            itemBtn.Size = UDim2.new(1, -16, 0, 26)
            itemBtn.Position = UDim2.new(0, 8, 0, 34 + (i-1)*28)
            itemBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            itemBtn.Text = itemName
            itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            itemBtn.TextSize = 12
            itemBtn.Font = Enum.Font.GothamBold
            itemBtn.AutoButtonColor = false
            itemBtn.ZIndex = 11
            itemBtn.MouseButton1Click:Connect(function() callback(itemName) overlay:Destroy() end)
        end
        local closeBtn = Instance.new("TextButton")
        closeBtn.Parent = popup
        closeBtn.Size = UDim2.new(0, 24, 0, 24)
        closeBtn.Position = UDim2.new(1, -28, 0, 4)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
        closeBtn.Text = "X"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextSize = 12
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.ZIndex = 12
        closeBtn.AutoButtonColor = false
        closeBtn.MouseButton1Click:Connect(function() overlay:Destroy() end)
    end

    -- POPUP WITH AMOUNT
    local function createPopupWithAmount(title, items, callback)
        local overlay = Instance.new("Frame")
        overlay.Parent = ScreenGui
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        overlay.BackgroundTransparency = 0.6
        overlay.ZIndex = 10
        local popup = Instance.new("Frame")
        popup.Parent = overlay
        popup.Size = UDim2.new(0, 280, 0, 80 + #items * 30)
        popup.Position = UDim2.new(0.5, -140, 0.5, -(80 + #items * 30)/2)
        popup.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        popup.BorderColor3 = Color3.fromRGB(255, 40, 40)
        popup.BorderSizePixel = 2
        popup.ZIndex = 11
        local popTitle = Instance.new("TextLabel")
        popTitle.Parent = popup
        popTitle.Size = UDim2.new(1, 0, 0, 32)
        popTitle.BackgroundColor3 = Color3.fromRGB(180, 10, 10)
        popTitle.Text = title
        popTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
        popTitle.TextSize = 13
        popTitle.Font = Enum.Font.GothamBold
        popTitle.ZIndex = 11
        local amountLabel = Instance.new("TextLabel")
        amountLabel.Parent = popup
        amountLabel.Size = UDim2.new(0.4, 0, 0, 20)
        amountLabel.Position = UDim2.new(0, 10, 0, 36)
        amountLabel.BackgroundTransparency = 1
        amountLabel.Text = "Amount:"
        amountLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        amountLabel.TextSize = 11
        amountLabel.Font = Enum.Font.Gotham
        amountLabel.ZIndex = 11
        local amountInput = Instance.new("TextBox")
        amountInput.Parent = popup
        amountInput.Size = UDim2.new(0, 80, 0, 20)
        amountInput.Position = UDim2.new(0.45, 0, 0, 36)
        amountInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        amountInput.Text = "1"
        amountInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        amountInput.TextSize = 11
        amountInput.Font = Enum.Font.Gotham
        amountInput.ZIndex = 11
        for i, itemName in ipairs(items) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Parent = popup
            itemBtn.Size = UDim2.new(1, -16, 0, 26)
            itemBtn.Position = UDim2.new(0, 8, 0, 60 + (i-1)*28)
            itemBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            itemBtn.Text = itemName
            itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            itemBtn.TextSize = 12
            itemBtn.Font = Enum.Font.GothamBold
            itemBtn.AutoButtonColor = false
            itemBtn.ZIndex = 11
            itemBtn.MouseButton1Click:Connect(function()
                local amount = tonumber(amountInput.Text) or 1
                callback(itemName, amount)
                overlay:Destroy()
            end)
        end
        local closeBtn = Instance.new("TextButton")
        closeBtn.Parent = popup
        closeBtn.Size = UDim2.new(0, 24, 0, 24)
        closeBtn.Position = UDim2.new(1, -28, 0, 4)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
        closeBtn.Text = "X"
        closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeBtn.TextSize = 12
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.ZIndex = 12
        closeBtn.AutoButtonColor = false
        closeBtn.MouseButton1Click:Connect(function() overlay:Destroy() end)
    end

    -- ========================
    -- TAB 1: MAIN
    -- ========================
    local mainContent = contentFrames["Main"]
    local mainLabel = Instance.new("TextLabel")
    mainLabel.Parent = mainContent
    mainLabel.Size = UDim2.new(1, 0, 0, 16)
    mainLabel.Position = UDim2.new(0, 5, 0, 2)
    mainLabel.BackgroundTransparency = 1
    mainLabel.Text = "-- MAIN FUNCTIONS --"
    mainLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    mainLabel.TextSize = 11
    mainLabel.Font = Enum.Font.Gotham

    createToggle(mainContent, "GodMode", 22, function(on) Functions:GodMode(on) end)
    createToggle(mainContent, "Anti-Ban", 54, function(on) Functions:AntiBan(on) end)
    createToggle(mainContent, "Fly (WASD/Space/Ctrl)", 86, function(on) Functions:Fly(on) end)
    createToggle(mainContent, "Carousel", 118, function(on) Functions:Carousel(on) end)
    createToggle(mainContent, "Speed Hack", 150, function(on) Functions:SpeedHack(on) end)
    createToggle(mainContent, "Wallhack (ESP)", 182, function(on) Functions:ESP(on) end)
    createToggle(mainContent, "Free Robux (999B)", 214, function(on) Functions:RobuxHack(on) end)

    local spamHolder = Instance.new("Frame")
    spamHolder.Parent = mainContent
    spamHolder.Size = UDim2.new(1, -10, 0, 50)
    spamHolder.Position = UDim2.new(0, 5, 0, 246)
    spamHolder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    spamHolder.BackgroundTransparency = 0.25
    local spamLabel = Instance.new("TextLabel")
    spamLabel.Parent = spamHolder
    spamLabel.Size = UDim2.new(1, 0, 0, 16)
    spamLabel.BackgroundTransparency = 1
    spamLabel.Text = "Spam-Chat"
    spamLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    spamLabel.TextSize = 10
    spamLabel.Font = Enum.Font.Gotham
    local spamInput = Instance.new("TextBox")
    spamInput.Parent = spamHolder
    spamInput.Size = UDim2.new(0.6, 0, 0, 18)
    spamInput.Position = UDim2.new(0, 5, 0, 18)
    spamInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    spamInput.Text = "hello"
    spamInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    spamInput.TextSize = 10
    spamInput.Font = Enum.Font.Gotham
    local spamToggleBtn = Instance.new("TextButton")
    spamToggleBtn.Parent = spamHolder
    spamToggleBtn.Size = UDim2.new(0, 45, 0, 18)
    spamToggleBtn.Position = UDim2.new(0.65, 0, 0, 18)
    spamToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    spamToggleBtn.Text = "OFF"
    spamToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    spamToggleBtn.TextSize = 8
    spamToggleBtn.Font = Enum.Font.GothamBold
    spamToggleBtn.AutoButtonColor = false
    local spamOn = false
    spamToggleBtn.MouseButton1Click:Connect(function()
        spamOn = not spamOn
        if spamOn then spamToggleBtn.Text = "ON" spamToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 30, 30)
        else spamToggleBtn.Text = "OFF" spamToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) end
        Functions:SpamChat(spamOn, spamInput.Text)
    end)

    -- ========================
    -- TAB 2: STEAL A BRAINROT
    -- ========================
    local brainContent = contentFrames["Steal a Brainrot"]
    local brainLabel = Instance.new("TextLabel")
    brainLabel.Parent = brainContent
    brainLabel.Size = UDim2.new(1, 0, 0, 16)
    brainLabel.Position = UDim2.new(0, 5, 0, 2)
    brainLabel.BackgroundTransparency = 1
    brainLabel.Text = "-- STEAL A BRAINROT --"
    brainLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    brainLabel.TextSize = 11
    brainLabel.Font = Enum.Font.Gotham

    createToggle(brainContent, "Wall Hack", 22, function(on) Functions:WallHack(on) end)
    createToggle(brainContent, "Auto-Steal", 54, function(on) Functions:AutoSteal(on) end)
    createToggle(brainContent, "Auto-Bot", 86, function(on) Functions:AutoBot(on) end)
    createToggle(brainContent, "Auto-Lock Base", 118, function(on) Functions:AutoLockBase(on) end)
    createToggle(brainContent, "Auto-PvP (Bat)", 150, function(on) Functions:AutoPvP(on) end)
    createToggle(brainContent, "Luck Boost", 182, function(on) Functions:LuckBoost(on) end)

    -- ========================
    -- TAB 3: GROW A GARDEN
    -- ========================
    local gardenContent = contentFrames["Grow A Garden"]
    local gardenLabel = Instance.new("TextLabel")
    gardenLabel.Parent = gardenContent
    gardenLabel.Size = UDim2.new(1, 0, 0, 16)
    gardenLabel.Position = UDim2.new(0, 5, 0, 2)
    gardenLabel.BackgroundTransparency = 1
    gardenLabel.Text = "-- GROW A GARDEN --"
    gardenLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    gardenLabel.TextSize = 11
    gardenLabel.Font = Enum.Font.Gotham

    local seedList = {"Sunflower", "Rose", "Tulip", "Daisy", "Cactus", "Venus Flytrap", "Golden Seed", "Mythic Seed", "GOD Seed", "SECRET Seed"}
    local petList = {"Dog", "Cat", "Bunny", "Dragon", "Unicorn", "Phoenix", "Alien Pet", "Mythic Pet", "GOD Pet", "SECRET Pet"}

    createButton(gardenContent, "Give Seeds (Dup)", 22, function()
        createPopupWithAmount("Select Seed", seedList, function(seed, amount) Functions:GiveSeeds(seed, amount) end)
    end)
    createButton(gardenContent, "Give Pet (Dup)", 56, function()
        createPopupWithAmount("Select Pet", petList, function(pet, amount) Functions:GivePet(pet, amount) end)
    end)
    createToggle(gardenContent, "Fast Grow", 90, function(on) Functions:FastGrow(on) end)
    createToggle(gardenContent, "Farmer (Auto-Collect + Sell)", 122, function(on) Functions:Farmer(on) end)
    createToggle(gardenContent, "Luck Boost", 154, function(on) Functions:LuckBoost(on) end)

    -- ========================
    -- TAB 4: 99 Nights in Forest
    -- ========================
    local forestContent = contentFrames["99 Nights in Forest"]
    local forestLabel = Instance.new("TextLabel")
    forestLabel.Parent = forestContent
    forestLabel.Size = UDim2.new(1, 0, 0, 16)
    forestLabel.Position = UDim2.new(0, 5, 0, 2)
    forestLabel.BackgroundTransparency = 1
    forestLabel.Text = "-- 99 NIGHTS IN FOREST --"
    forestLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    forestLabel.TextSize = 11
    forestLabel.Font = Enum.Font.Gotham

    createToggle(forestContent, "ESP", 22, function(on) Functions:ForestESP(on) end)
    createToggle(forestContent, "Auto-Farm", 54, function(on) Functions:ForestAutoFarm(on) end)
    createToggle(forestContent, "One Hit Kill", 86, function(on) Functions:ForestOneHit(on) end)
    createToggle(forestContent, "Inf Diamonds", 118, function(on) Functions:ForestDiamonds(on) end)

    local itemList = {"Sword", "Axe", "Pickaxe", "Torch", "Armor", "Shield", "Bow"}
    createButton(forestContent, "Dupe Items", 150, function()
        createPopupWithAmount("Select Item", itemList, function(item, amount) Functions:DupeItem(item, amount) end)
    end)
    createButton(forestContent, "Dupe Chests", 184, function()
        createPopupWithAmount("How many?", {"10", "25", "50", "100", "500"}, function(amount) Functions:DupeChests(tonumber(amount)) end)
    end)
    local foodList = {"Bread", "Meat", "Fish", "Apple", "Soup", "Pie", "Stew"}
    createButton(forestContent, "Inf Foods", 218, function()
        createPopupWithAmount("Select Food", foodList, function(food, amount) Functions:DupeFood(food, amount) end)
    end)
    local gunList = {"Pistol", "Shotgun", "Rifle", "SMG", "Sniper", "Crossbow", "Musket"}
    createButton(forestContent, "Inf Guns", 252, function()
        createPopupWithAmount("Select Gun", gunList, function(gun, amount) Functions:DupeGun(gun, amount) end)
    end)
    createToggle(forestContent, "Inf Ammo", 286, function(on) Functions:InfAmmo(on) end)
    createButton(forestContent, "Dupe Wood", 318, function()
        createPopupWithAmount("How much?", {"1", "10", "50", "100", "500", "999"}, function(amount) Functions:DupeWood(tonumber(amount)) end)
    end)

    -- ========================
    -- TAB 5: OTHER
    -- ========================
    local otherContent = contentFrames["Other"]
    local otherLabel = Instance.new("TextLabel")
    otherLabel.Parent = otherContent
    otherLabel.Size = UDim2.new(1, 0, 0, 16)
    otherLabel.Position = UDim2.new(0, 5, 0, 2)
    otherLabel.BackgroundTransparency = 1
    otherLabel.Text = "-- OTHER --"
    otherLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    otherLabel.TextSize = 11
    otherLabel.Font = Enum.Font.Gotham

    createToggle(otherContent, "FPS Booster", 22, function(on) Functions:FPSBooster(on) end)
    createToggle(otherContent, "FPS Stabilizer", 54, function(on) Functions:FPSStabilizer(on) end)
    createToggle(otherContent, "Show FPS", 86, function(on) Functions:ShowFPS(on) end)
    createToggle(otherContent, "Low Graphics", 118, function(on) Functions:LowGraphics(on) end)
    createToggle(otherContent, "No Shadows", 150, function(on) Functions:NoShadows(on) end)
    createToggle(otherContent, "No Particles", 182, function(on) Functions:NoParticles(on) end)

    -- MUSIC PLAYER
    local musicLabel = Instance.new("TextLabel")
    musicLabel.Parent = otherContent
    musicLabel.Size = UDim2.new(1, 0, 0, 18)
    musicLabel.Position = UDim2.new(0, 5, 0, 214)
    musicLabel.BackgroundTransparency = 1
    musicLabel.Text = "-- MUSIC PLAYER --"
    musicLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    musicLabel.TextSize = 11
    musicLabel.Font = Enum.Font.Gotham

    local musicInput = Instance.new("TextBox")
    musicInput.Parent = otherContent
    musicInput.Size = UDim2.new(1, -10, 0, 24)
    musicInput.Position = UDim2.new(0, 5, 0, 234)
    musicInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    musicInput.PlaceholderText = "YouTube URL or Song ID..."
    musicInput.Text = ""
    musicInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    musicInput.TextSize = 10
    musicInput.Font = Enum.Font.Gotham

    local musicBtnHolder = Instance.new("Frame")
    musicBtnHolder.Parent = otherContent
    musicBtnHolder.Size = UDim2.new(1, -10, 0, 28)
    musicBtnHolder.Position = UDim2.new(0, 5, 0, 262)
    musicBtnHolder.BackgroundTransparency = 1

    local playBtn = Instance.new("TextButton")
    playBtn.Parent = musicBtnHolder
    playBtn.Size = UDim2.new(0, 80, 1, 0)
    playBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
    playBtn.Text = "Play"
    playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    playBtn.TextSize = 10
    playBtn.Font = Enum.Font.GothamBold
    playBtn.AutoButtonColor = false
    playBtn.MouseButton1Click:Connect(function() Functions:PlayMusic(musicInput.Text) end)

    local stopBtn = Instance.new("TextButton")
    stopBtn.Parent = musicBtnHolder
    stopBtn.Size = UDim2.new(0, 80, 1, 0)
    stopBtn.Position = UDim2.new(0, 85, 0, 0)
    stopBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    stopBtn.Text = "Stop"
    stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    stopBtn.TextSize = 10
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.AutoButtonColor = false
    stopBtn.MouseButton1Click:Connect(function() Functions:StopMusic() end)

    local volLabel = Instance.new("TextLabel")
    volLabel.Parent = otherContent
    volLabel.Size = UDim2.new(0.3, 0, 0, 18)
    volLabel.Position = UDim2.new(0, 10, 0, 294)
    volLabel.BackgroundTransparency = 1
    volLabel.Text = "Volume: 50"
    volLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    volLabel.TextSize = 10
    volLabel.Font = Enum.Font.Gotham

    local volSlider = Instance.new("TextBox")
    volSlider.Parent = otherContent
    volSlider.Size = UDim2.new(0, 50, 0, 18)
    volSlider.Position = UDim2.new(0.35, 0, 0, 294)
    volSlider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    volSlider.Text = "50"
    volSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
    volSlider.TextSize = 10
    volSlider.Font = Enum.Font.Gotham
    volSlider.FocusLost:Connect(function()
        local vol = tonumber(volSlider.Text) or 50
        volLabel.Text = "Volume: " .. vol
        Functions:SetVolume(vol)
    end)

    print("★ Mod Menu By IlyaHacker Loaded!")
end

return GUI
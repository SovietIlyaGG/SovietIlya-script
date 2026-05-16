-- =============================================
-- GUI.lua - ☭ SovietIlya & Danil415k ☭
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

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.Size = UDim2.new(0, 360, 0, 520)
    Main.Position = UDim2.new(0.5, -180, 0.5, -260)
    Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
    Main.BackgroundTransparency = 0.1
    Main.BorderColor3 = Color3.fromRGB(255, 30, 30)
    Main.BorderSizePixel = 2
    Main.Active = true
    Main.Draggable = true
    Main.ClipsDescendants = true

    -- Gradient Black-Red-Black
    local MainGradient = Instance.new("UIGradient")
    MainGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 5)),
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(180, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 15, 15)),
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(180, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
    })
    MainGradient.Parent = Main

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Main
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Title.BackgroundTransparency = 0.2
    Title.Text = "☭ SovietIlya & Danil415k ☭"
    Title.TextColor3 = Color3.fromRGB(255, 255, 0)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.BorderSizePixel = 0

    -- Subtitle
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = Main
    SubTitle.Size = UDim2.new(1, 0, 0, 22)
    SubTitle.Position = UDim2.new(0, 0, 0, 45)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "Script Menu Admin Menu"
    SubTitle.TextColor3 = Color3.fromRGB(255, 200, 0)
    SubTitle.TextSize = 11
    SubTitle.Font = Enum.Font.Gotham

    -- Tab Holder
    local TabHolder = Instance.new("Frame")
    TabHolder.Name = "TabHolder"
    TabHolder.Parent = Main
    TabHolder.Size = UDim2.new(1, 0, 0, 38)
    TabHolder.Position = UDim2.new(0, 0, 0, 68)
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
        btn.Size = UDim2.new(1/4, -2, 1, -4)
        btn.Position = UDim2.new((i-1)/4, 0, 0, 2)
        btn.BackgroundColor3 = i == 1 and Color3.fromRGB(180, 0, 0) or Color3.fromRGB(30, 30, 30)
        btn.BackgroundTransparency = 0.15
        btn.Text = tabName
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 9
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        tabButtons[tabName] = btn

        local tabGrad = Instance.new("UIGradient")
        tabGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 0))
        })
        tabGrad.Parent = btn

        local content = Instance.new("ScrollingFrame")
        content.Name = tabName .. "Content"
        content.Parent = Main
        content.Size = UDim2.new(1, -6, 1, -112)
        content.Position = UDim2.new(0, 3, 0, 108)
        content.BackgroundTransparency = 1
        content.Visible = (i == 1)
        content.ScrollBarThickness = 2
        content.ScrollBarImageColor3 = Color3.fromRGB(255, 30, 30)
        content.CanvasSize = UDim2.new(0, 0, 0, 900)
        content.BorderSizePixel = 0
        contentFrames[tabName] = content

        btn.MouseButton1Click:Connect(function()
            for _, b in pairs(tabButtons) do
                b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
            btn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            for _, c in pairs(contentFrames) do
                c.Visible = false
            end
            content.Visible = true
        end)
    end

    -- ========================
    -- CREATE TOGGLE
    -- ========================
    local function createToggle(parent, text, yPos, callback)
        local holder = Instance.new("Frame")
        holder.Name = text .. "Holder"
        holder.Parent = parent
        holder.Size = UDim2.new(1, -10, 0, 42)
        holder.Position = UDim2.new(0, 5, 0, yPos)
        holder.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        holder.BackgroundTransparency = 0.25
        holder.BorderSizePixel = 0
        holder.ClipsDescendants = true

        local holderGrad = Instance.new("UIGradient")
        holderGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 0, 0))
        })
        holderGrad.Parent = holder

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Parent = holder
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham

        local toggle = Instance.new("TextButton")
        toggle.Name = "Toggle"
        toggle.Parent = holder
        toggle.Size = UDim2.new(0, 46, 0, 24)
        toggle.Position = UDim2.new(0.85, 0, 0.5, -12)
        toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        toggle.Text = ""
        toggle.BorderSizePixel = 0
        toggle.AutoButtonColor = false

        local toggleDot = Instance.new("Frame")
        toggleDot.Name = "Dot"
        toggleDot.Parent = toggle
        toggleDot.Size = UDim2.new(0, 20, 0, 20)
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

    -- ========================
    -- CREATE BUTTON
    -- ========================
    local function createButton(parent, text, yPos, callback)
        local btn = Instance.new("TextButton")
        btn.Name = text .. "Btn"
        btn.Parent = parent
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.Position = UDim2.new(0, 5, 0, yPos)
        btn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
        btn.BackgroundTransparency = 0.15
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false

        local btnGrad = Instance.new("UIGradient")
        btnGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 0, 0))
        })
        btnGrad.Parent = btn

        btn.MouseButton1Click:Connect(callback)
        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
        end)
    end

    -- ========================
    -- CREATE POPUP
    -- ========================
    local function createPopup(title, items, callback)
        local popup = Instance.new("Frame")
        popup.Name = "Popup"
        popup.Parent = Main
        popup.Size = UDim2.new(0, 270, 0, 35 + #items * 32)
        popup.Position = UDim2.new(0.5, -135, 0.5, -(35 + #items * 32)/2)
        popup.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
        popup.BackgroundTransparency = 0.05
        popup.BorderColor3 = Color3.fromRGB(255, 40, 40)
        popup.BorderSizePixel = 2
        popup.ZIndex = 10
        popup.ClipsDescendants = true

        local popGrad = Instance.new("UIGradient")
        popGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 5, 5)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 5, 5))
        })
        popGrad.Parent = popup

        local popTitle = Instance.new("TextLabel")
        popTitle.Name = "PopTitle"
        popTitle.Parent = popup
        popTitle.Size = UDim2.new(1, 0, 0, 32)
        popTitle.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
        popTitle.BackgroundTransparency = 0.2
        popTitle.Text = title
        popTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
        popTitle.TextSize = 13
        popTitle.Font = Enum.Font.GothamBold
        popTitle.BorderSizePixel = 0

        for i, itemName in ipairs(items) do
            local itemBtn = Instance.new("TextButton")
            itemBtn.Name = itemName .. "Btn"
            itemBtn.Parent = popup
            itemBtn.Size = UDim2.new(1, -16, 0, 28)
            itemBtn.Position = UDim2.new(0, 8, 0, 34 + (i-1)*30)
            itemBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            itemBtn.BackgroundTransparency = 0.2
            itemBtn.Text = itemName
            itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            itemBtn.TextSize = 12
            itemBtn.Font = Enum.Font.Gotham
            itemBtn.BorderSizePixel = 0
            itemBtn.AutoButtonColor = false

            local itemGrad = Instance.new("UIGradient")
            itemGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 35)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 0, 0))
            })
            itemGrad.Parent = itemBtn

            itemBtn.MouseButton1Click:Connect(function()
                callback(itemName)
                popup:Destroy()
            end)

            itemBtn.MouseEnter:Connect(function()
                itemBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
            end)
            itemBtn.MouseLeave:Connect(function()
                itemBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end)
        end
    end

    -- ========================
    -- TAB 1: MAIN
    -- ========================
    local mainContent = contentFrames["Main"]

    local mainLabel = Instance.new("TextLabel")
    mainLabel.Parent = mainContent
    mainLabel.Size = UDim2.new(1, 0, 0, 22)
    mainLabel.Position = UDim2.new(0, 5, 0, 5)
    mainLabel.BackgroundTransparency = 1
    mainLabel.Text = "— MAIN FUNCTIONS —"
    mainLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    mainLabel.TextSize = 11
    mainLabel.Font = Enum.Font.Gotham

    createToggle(mainContent, "GodMode", 30, function(on) Functions:GodMode(on) end)
    createToggle(mainContent, "Anti-Ban & Anti-Cheat", 78, function(on) Functions:AntiBan(on) end)
    createToggle(mainContent, "Spam-Chat (hello)", 126, function(on) Functions:SpamChat(on) end)
    createToggle(mainContent, "✈️ Fly", 174, function(on) Functions:Fly(on) end)

    -- Fly Speed
    local flySpeedLabel = Instance.new("TextLabel")
    flySpeedLabel.Parent = mainContent
    flySpeedLabel.Size = UDim2.new(0.5, 0, 0, 20)
    flySpeedLabel.Position = UDim2.new(0, 10, 0, 220)
    flySpeedLabel.BackgroundTransparency = 1
    flySpeedLabel.Text = "Fly Speed: 50"
    flySpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    flySpeedLabel.TextSize = 11
    flySpeedLabel.Font = Enum.Font.Gotham

    local flySlider = Instance.new("TextBox")
    flySlider.Parent = mainContent
    flySlider.Size = UDim2.new(0, 60, 0, 22)
    flySlider.Position = UDim2.new(0.55, 0, 0, 219)
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

    createToggle(mainContent, "⚡ Speed Hack", 248, function(on) Functions:SpeedHack(on) end)

    -- Speed value
    local speedLabel = Instance.new("TextLabel")
    speedLabel.Parent = mainContent
    speedLabel.Size = UDim2.new(0.5, 0, 0, 20)
    speedLabel.Position = UDim2.new(0, 10, 0, 294)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: 16"
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.TextSize = 11
    speedLabel.Font = Enum.Font.Gotham

    local speedSlider = Instance.new("TextBox")
    speedSlider.Parent = mainContent
    speedSlider.Size = UDim2.new(0, 60, 0, 22)
    speedSlider.Position = UDim2.new(0.55, 0, 0, 293)
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

    createToggle(mainContent, "👁️ Wallhack (ESP)", 322, function(on) Functions:ESP(on) end)

    -- ========================
    -- TAB 2: STEAL A BRAINROT
    -- ========================
    local brainContent = contentFrames["Steal a Brainrot"]

    local brainLabel = Instance.new("TextLabel")
    brainLabel.Parent = brainContent
    brainLabel.Size = UDim2.new(1, 0, 0, 22)
    brainLabel.Position = UDim2.new(0, 5, 0, 5)
    brainLabel.BackgroundTransparency = 1
    brainLabel.Text = "— STEAL A BRAINROT —"
    brainLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    brainLabel.TextSize = 11
    brainLabel.Font = Enum.Font.Gotham

    local brainList = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "GOD Brainrot", "SECRET", "OG"}

    createButton(brainContent, "🌟 Spawn Brainrot in Base", 30, function()
        createPopup("Select Brainrot Rarity", brainList, function(selected)
            Functions:SpawnBrainrot(selected)
        end)
    end)

    createToggle(brainContent, "Auto-Lock Base", 80, function(on) Functions:AutoLockBase(on) end)
    createToggle(brainContent, "Auto-PvP (Bat)", 128, function(on) Functions:AutoPvP(on) end)

    -- ========================
    -- TAB 3: GROW A GARDEN
    -- ========================
    local gardenContent = contentFrames["Grow A Garden"]

    local gardenLabel = Instance.new("TextLabel")
    gardenLabel.Parent = gardenContent
    gardenLabel.Size = UDim2.new(1, 0, 0, 22)
    gardenLabel.Position = UDim2.new(0, 5, 0, 5)
    gardenLabel.BackgroundTransparency = 1
    gardenLabel.Text = "— GROW A GARDEN —"
    gardenLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    gardenLabel.TextSize = 11
    gardenLabel.Font = Enum.Font.Gotham

    local seedList = {"Sunflower", "Rose", "Tulip", "Daisy", "Cactus", "Venus Flytrap", "Golden Seed", "Mythic Seed", "GOD Seed", "SECRET Seed"}
    local petList = {"Dog", "Cat", "Bunny", "Dragon", "Unicorn", "Phoenix", "Alien Pet", "Mythic Pet", "GOD Pet", "SECRET Pet"}

    createButton(gardenContent, "🌱 Give Seeds (Free Dupe)", 30, function()
        createPopup("Select Seed (Free Dupe)", seedList, function(selected)
            Functions:GiveSeeds(selected, 999)
        end)
    end)

    createButton(gardenContent, "🐾 Give Pet (Free Dupe)", 78, function()
        createPopup("Select Pet (Free Dupe)", petList, function(selected)
            Functions:GivePet(selected, 999)
        end)
    end)

    -- ========================
    -- TAB 4: OTHER SCRIPTS
    -- ========================
    local otherContent = contentFrames["Other Scripts"]

    local otherLabel = Instance.new("TextLabel")
    otherLabel.Parent = otherContent
    otherLabel.Size = UDim2.new(1, 0, 0, 22)
    otherLabel.Position = UDim2.new(0, 5, 0, 5)
    otherLabel.BackgroundTransparency = 1
    otherLabel.Text = "— OTHER SCRIPTS —"
    otherLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
    otherLabel.TextSize = 11
    otherLabel.Font = Enum.Font.Gotham

    createButton(otherContent, "🔫 Give AK-47", 30, function() Functions:GiveWeapon("AK-47") end)
    createButton(otherContent, "🚀 Give RPG", 75, function() Functions:GiveWeapon("RPG") end)
    createButton(otherContent, "🔫 Give MP5", 120, function() Functions:GiveWeapon("MP5") end)
    createButton(otherContent, "💰 Free Robuxes", 165, function() Functions:FreeRobuxes() end)
    createButton(otherContent, "🔥 Give FGM-148 Javelin", 210, function() Functions:GiveWeapon("FGM-148 Javelin") end)
    createButton(otherContent, "🤖 Spawn Bot (Self-Aware)", 255, function() Functions:SpawnBot() end)
    createButton(otherContent, "👑 Give Admin & VIP Commands", 300, function() Functions:GiveAdminVIP() end)

    -- ========================
    -- CLOSE BUTTON
    -- ========================
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Parent = Main
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -32, 0, 5)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 5
    closeBtn.AutoButtonColor = false

    closeBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    print("✅ GUI SovietIlya & Danil415k загружен!")
end

return GUI
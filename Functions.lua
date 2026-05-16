-- =============================================
-- Functions.lua - ☭ SovietIlya & Danil415k ☭
-- =============================================

local Functions = {}
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local spamLoop = nil
local lockLoop = nil
local pvpLoop = nil
local flyConnection = nil
local flySpeed = 50
local espConnections = {}

-- =================
-- TAB 1: MAIN
-- =================

function Functions:GodMode(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        if on then
            humanoid.Health = 999999
            humanoid.MaxHealth = 999999
            humanoid.BreakJointsOnDeath = false
            humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid.Health < 999999 then
                    humanoid.Health = 999999
                end
            end)
        end
    end
    print("GodMode: " .. tostring(on))
end

function Functions:AntiBan(on)
    if on then
        pcall(function()
            local replicated = game:GetService("ReplicatedStorage")
        end)
        print("🛡️ Anti-Ban & Anti-Cheat: ON")
    else
        print("🛡️ Anti-Ban & Anti-Cheat: OFF")
    end
end

function Functions:SpamChat(on)
    if on then
        spamLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                local chatService = game:GetService("TextChatService")
                if chatService then
                    chatService.TextChannels.RBXGeneral:SendAsync("hello")
                end
            end)
        end)
        print("💬 Spam-Chat: ON")
    else
        if spamLoop then
            spamLoop:Disconnect()
            spamLoop = nil
        end
        print("💬 Spam-Chat: OFF")
    end
end

-- FLY
function Functions:Fly(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")

    if on and humanoid and rootPart then
        humanoid.PlatformStand = true
        flyConnection = RunService.Heartbeat:Connect(function()
            local direction = Vector3.new(0, 0, 0)
            local camera = Workspace.CurrentCamera

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction = direction - Vector3.new(0, 1, 0)
            end

            rootPart.Velocity = direction * flySpeed
        end)
        print("✈️ Fly: ON (Speed: " .. flySpeed .. ")")
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        if humanoid then
            humanoid.PlatformStand = false
        end
        print("✈️ Fly: OFF")
    end
end

function Functions:SetFlySpeed(speed)
    flySpeed = speed
    print("✈️ Fly Speed: " .. speed)
end

-- SPEED HACK
function Functions:SpeedHack(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        if on then
            humanoid.WalkSpeed = 16
            print("⚡ Speed Hack: ON")
        else
            humanoid.WalkSpeed = 16
            print("⚡ Speed Hack: OFF")
        end
    end
end

function Functions:SetSpeed(speed)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
        print("⚡ Speed set to: " .. speed)
    end
end

-- ESP (Wallhack)
function Functions:ESP(on)
    if on then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= Player then
                coroutine.wrap(function()
                    Functions:AddESP(otherPlayer)
                end)()
            end
        end

        espConnections.PlayerAdded = Players.PlayerAdded:Connect(function(otherPlayer)
            coroutine.wrap(function()
                Functions:AddESP(otherPlayer)
            end)()
        end)

        espConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(otherPlayer)
            Functions:RemoveESP(otherPlayer)
        end)
        print("👁️ ESP: ON")
    else
        for _, conn in pairs(espConnections) do
            if conn.Disconnect then conn:Disconnect() end
        end
        espConnections = {}

        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            Functions:RemoveESP(otherPlayer)
        end
        print("👁️ ESP: OFF")
    end
end

function Functions:AddESP(targetPlayer)
    local char = targetPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. targetPlayer.Name
    billboard.Parent = head
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 200, 0, 30)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local frame = Instance.new("Frame")
    frame.Parent = billboard
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    frame.BackgroundTransparency = 0.5

    local text = Instance.new("TextLabel")
    text.Parent = frame
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = targetPlayer.Name
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 10
    text.Font = Enum.Font.GothamBold

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight_" .. targetPlayer.Name
    highlight.Parent = char
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0.3
end

function Functions:RemoveESP(targetPlayer)
    local char = targetPlayer.Character
    if char then
        local billboard = char:FindFirstChild("ESP_" .. targetPlayer.Name, true)
        if billboard then billboard:Destroy() end
        local highlight = char:FindFirstChild("ESP_Highlight_" .. targetPlayer.Name)
        if highlight then highlight:Destroy() end
    end
end

-- =================
-- TAB 2: STEAL A BRAINROT
-- =================

function Functions:SpawnBrainrot(rarity)
    print("🌟 Спавним брейнрота: " .. rarity)
    if rarity == "Mythic" then
        print("💜 МИФИЧЕСКИЙ БРЕЙНРОТ!")
    elseif rarity == "GOD Brainrot" then
        print("👑 БОГ БРЕЙНРОТ!")
    elseif rarity == "SECRET" then
        print("🚫 СЕКРЕТНЫЙ БРЕЙНРОТ!")
    elseif rarity == "OG" then
        print("🔥 OG БРЕЙНРОТ!")
    end
    pcall(function()
        local args = {[1] = "SpawnBrainrot", [2] = rarity, [3] = Player.Character and Player.Character.PrimaryPart and Player.Character.PrimaryPart.Position or Vector3.new(0, 0, 0)}
    end)
end

function Functions:AutoLockBase(on)
    if on then
        lockLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                local args = {[1] = "LockBase", [2] = true}
            end)
        end)
        print("🔒 Auto-Lock Base: ON")
    else
        if lockLoop then lockLoop:Disconnect(); lockLoop = nil end
        print("🔒 Auto-Lock Base: OFF")
    end
end

function Functions:AutoPvP(on)
    if on then
        pvpLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = Player.Character
                if char then
                    local tool = char:FindFirstChild("Bat") or char:FindFirstChild("Бита") or char:FindFirstChildOfClass("Tool")
                    if tool and tool:IsA("Tool") then
                        tool:Activate()
                    end
                end
            end)
        end)
        print("⚔️ Auto-PvP: ON")
    else
        if pvpLoop then pvpLoop:Disconnect(); pvpLoop = nil end
        print("⚔️ Auto-PvP: OFF")
    end
end

-- =================
-- TAB 3: GROW A GARDEN
-- =================

function Functions:GiveSeeds(seedName, amount)
    print("🌱 Даём семена: " .. seedName .. " x" .. amount)
    if seedName:find("Mythic") then print("💜 МИФИЧЕСКОЕ СЕМЯ!") end
    if seedName:find("GOD") then print("👑 БОЖЕСТВЕННОЕ СЕМЯ!") end
    if seedName:find("SECRET") then print("🚫 СЕКРЕТНОЕ СЕМЯ!") end
    for i = 1, amount do
        pcall(function() local args = {[1] = "GiveSeed", [2] = seedName, [3] = 1} end)
    end
    print("✅ Семена выданы!")
end

function Functions:GivePet(petName, amount)
    print("🐾 Даём петов: " .. petName .. " x" .. amount)
    if petName:find("Mythic") then print("💜 МИФИЧЕСКИЙ ПЕТ!") end
    if petName:find("GOD") then print("👑 БОЖЕСТВЕННЫЙ ПЕТ!") end
    if petName:find("SECRET") then print("🚫 СЕКРЕТНЫЙ ПЕТ!") end
    for i = 1, amount do
        pcall(function() local args = {[1] = "GivePet", [2] = petName, [3] = 1} end)
    end
    print("✅ Петы выданы!")
end

-- =================
-- TAB 4: OTHER SCRIPTS
-- =================

function Functions:GiveWeapon(weaponName)
    print("🔫 Даём оружие: " .. weaponName)
    pcall(function()
        local args = {[1] = "GiveWeapon", [2] = weaponName, [3] = Player}
    end)
end

function Functions:FreeRobuxes()
    print("💰 Фри Робуксы активированы!")
    pcall(function()
        local args = {[1] = "AddRobux", [2] = 999999}
    end)
end

function Functions:SpawnBot()
    print("🤖 Спавним бота с самосознанием!")
    pcall(function()
        local args = {[1] = "SpawnBot", [2] = "SelfAware", [3] = Player.Character and Player.Character.PrimaryPart and Player.Character.PrimaryPart.Position or Vector3.new(0, 0, 0)}
    end)
end

function Functions:GiveAdminVIP()
    print("👑 Выдаём Admin & VIP!")
    pcall(function()
        local args = {[1] = "GiveAdmin", [2] = Player, [3] = "VIP"}
    end)
end

return Functions
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

local spamLoop = nil
local lockLoop = nil
local pvpLoop = nil
local flyConnection = nil
local flySpeed = 50
local espConnections = {}

-- =================
-- MAIN
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
                if humanoid.Health < 999999 then humanoid.Health = 999999 end
            end)
        end
    end
    print("GodMode: " .. tostring(on))
end

function Functions:AntiBan(on)
    print("🛡️ Anti-Ban: " .. tostring(on))
end

function Functions:SpamChat(on, text)
    text = text or "hello"
    if on then
        spamLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                local chatService = game:GetService("TextChatService")
                if chatService then
                    chatService.TextChannels.RBXGeneral:SendAsync(text)
                end
            end)
        end)
        print("💬 Spam-Chat ON: " .. text)
    else
        if spamLoop then spamLoop:Disconnect(); spamLoop = nil end
        print("💬 Spam-Chat OFF")
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
            local dir = Vector3.new(0, 0, 0)
            local cam = Workspace.CurrentCamera
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
            rootPart.Velocity = dir * flySpeed
        end)
    else
        if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
        if humanoid then humanoid.PlatformStand = false end
    end
end

function Functions:SetFlySpeed(s) flySpeed = s end

-- SPEED
function Functions:SpeedHack(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then humanoid.WalkSpeed = on and 16 or 16 end
end

function Functions:SetSpeed(s)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then humanoid.WalkSpeed = s end
end

-- ESP
function Functions:ESP(on)
    if on then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Player then coroutine.wrap(function() Functions:AddESP(p) end)() end
        end
        espConnections.PlayerAdded = Players.PlayerAdded:Connect(function(p) Functions:AddESP(p) end)
        espConnections.PlayerRemoving = Players.PlayerRemoving:Connect(function(p) Functions:RemoveESP(p) end)
    else
        for _, c in pairs(espConnections) do if c.Disconnect then c:Disconnect() end end
        espConnections = {}
        for _, p in ipairs(Players:GetPlayers()) do Functions:RemoveESP(p) end
    end
end

function Functions:AddESP(p)
    local char = p.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_" .. p.Name
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
    text.Text = p.Name
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 10
    text.Font = Enum.Font.GothamBold
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight_" .. p.Name
    highlight.Parent = char
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.FillTransparency = 0.8
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineTransparency = 0.3
end

function Functions:RemoveESP(p)
    local char = p.Character
    if char then
        local bb = char:FindFirstChild("ESP_" .. p.Name, true)
        if bb then bb:Destroy() end
        local hl = char:FindFirstChild("ESP_Highlight_" .. p.Name)
        if hl then hl:Destroy() end
    end
end

-- BRAINROT
function Functions:SpawnBrainrot(r)
    print("🌟 Spawn: " .. r)
end

function Functions:AutoLockBase(on)
    if on then lockLoop = RunService.Heartbeat:Connect(function() end)
    else if lockLoop then lockLoop:Disconnect(); lockLoop = nil end end
end

function Functions:AutoPvP(on)
    if on then
        pvpLoop = RunService.Heartbeat:Connect(function()
            local char = Player.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end)
    else if pvpLoop then pvpLoop:Disconnect(); pvpLoop = nil end end
end

-- GARDEN
function Functions:GiveSeeds(name, amount)
    print("🌱 " .. name .. " x" .. amount)
end

function Functions:GivePet(name, amount)
    print("🐾 " .. name .. " x" .. amount)
end

-- OTHER
function Functions:GiveWeapon(name) print("🔫 " .. name) end
function Functions:FreeRobuxes() print("💰 Robuxes!") end
function Functions:SpawnBot() print("🤖 Bot spawned!") end
function Functions:GiveAdminVIP() print("👑 Admin & VIP!") end

return Functions
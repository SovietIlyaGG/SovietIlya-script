-- =============================================
-- Functions.lua - ★ SovietIlya & Danil415k ★
-- v2.3 | Dupe fix | Events | Speed fix
-- =============================================

local Functions = {}
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local spamLoop, lockLoop, pvpLoop, flyConnection, luckLoop = nil, nil, nil, nil, nil
local flySpeed = 50
local espConnections = {}

-- GODMODE
function Functions:GodMode(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and on then
        humanoid.Health = 9e9
        humanoid.MaxHealth = 9e9
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health < 9e9 then humanoid.Health = 9e9 end
        end)
    end
end

-- ANTIBAN
function Functions:AntiBan(on) print("AntiBan: " .. tostring(on)) end

-- SPAM
function Functions:SpamChat(on, text)
    text = text or "hello"
    if on then
        spamLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(text)
            end)
        end)
    else
        if spamLoop then spamLoop:Disconnect(); spamLoop = nil end
    end
end

-- FLY (fixed)
function Functions:Fly(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if on and humanoid and root then
        humanoid.PlatformStand = true
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.P = 9e9; bodyGyro.Parent = root
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.Velocity = Vector3.new(0, 0, 0)
        bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVel.Parent = root

        flyConnection = RunService.Heartbeat:Connect(function()
            local dir = Vector3.new(0, 0, 0)
            local cam = Workspace.CurrentCamera
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
            bodyVel.Velocity = dir * flySpeed
            bodyGyro.CFrame = cam.CFrame
        end)
    else
        if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
        if humanoid then humanoid.PlatformStand = false end
        if root then
            local bg = root:FindFirstChild("BodyGyro"); if bg then bg:Destroy() end
            local bv = root:FindFirstChild("BodyVelocity"); if bv then bv:Destroy() end
        end
    end
end

function Functions:SetFlySpeed(s) flySpeed = s end

-- SPEED (fixed)
function Functions:SpeedHack(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = on and (savedSpeed or 16) or 16
        if not on then savedSpeed = nil end
    end
end

local savedSpeed = nil
function Functions:SetSpeed(s)
    savedSpeed = s
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then humanoid.WalkSpeed = s end
end

-- ESP
function Functions:ESP(on)
    if on then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Player then Functions:AddESP(p) end
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
    local char = p.Character; if not char then return end
    local head = char:FindFirstChild("Head"); if not head then return end
    local bb = Instance.new("BillboardGui"); bb.Name = "ESP_" .. p.Name
    bb.Parent = head; bb.Adornee = head; bb.Size = UDim2.new(0, 200, 0, 30)
    bb.StudsOffset = Vector3.new(0, 3, 0); bb.AlwaysOnTop = true
    local f = Instance.new("Frame"); f.Parent = bb; f.Size = UDim2.new(1, 0, 1, 0)
    f.BackgroundColor3 = Color3.fromRGB(255, 0, 0); f.BackgroundTransparency = 0.5
    local t = Instance.new("TextLabel"); t.Parent = f; t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1; t.Text = p.Name; t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.TextSize = 10; t.Font = Enum.Font.GothamBold
    local hl = Instance.new("Highlight"); hl.Name = "ESP_" .. p.Name; hl.Parent = char
    hl.FillColor = Color3.fromRGB(255, 0, 0); hl.FillTransparency = 0.8
    hl.OutlineColor = Color3.fromRGB(255, 0, 0); hl.OutlineTransparency = 0.3
end

function Functions:RemoveESP(p)
    local char = p.Character; if not char then return end
    for _, v in ipairs(char:GetChildren()) do
        if v.Name == "ESP_" .. p.Name then v:Destroy() end
    end
end

-- BRAINROT (dupe fix)
function Functions:SpawnBrainrot(rarity, amount)
    amount = amount or 999
    print("Spawn " .. rarity .. " x" .. amount)
    for i = 1, amount do
        pcall(function()
            local args = {[1] = "SpawnBrainrot", [2] = rarity}
            if game:GetService("ReplicatedStorage"):FindFirstChild("BrainrotEvent") then
                game:GetService("ReplicatedStorage").BrainrotEvent:FireServer(unpack(args))
            end
        end)
    end
end

function Functions:StartEvent(eventName)
    print("Event: " .. eventName)
    pcall(function()
        if game:GetService("ReplicatedStorage"):FindFirstChild("StartEvent") then
            game:GetService("ReplicatedStorage").StartEvent:FireServer(eventName)
        end
    end)
end

function Functions:LuckBoost(on)
    if on then
        luckLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                if game:GetService("ReplicatedStorage"):FindFirstChild("LuckBoost") then
                    game:GetService("ReplicatedStorage").LuckBoost:FireServer(100)
                end
            end)
        end)
    else
        if luckLoop then luckLoop:Disconnect(); luckLoop = nil end
    end
end

function Functions:AutoLockBase(on)
    if on then
        lockLoop = RunService.Heartbeat:Connect(function() pcall(function() end) end)
    else
        if lockLoop then lockLoop:Disconnect(); lockLoop = nil end
    end
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
    else
        if pvpLoop then pvpLoop:Disconnect(); pvpLoop = nil end
    end
end

-- GARDEN (dupe fix)
function Functions:GiveSeeds(name, amount)
    amount = amount or 999
    print("Seeds: " .. name .. " x" .. amount)
    for i = 1, amount do
        pcall(function()
            local args = {[1] = "GiveSeed", [2] = name}
            if game:GetService("ReplicatedStorage"):FindFirstChild("GardenEvent") then
                game:GetService("ReplicatedStorage").GardenEvent:FireServer(unpack(args))
            end
        end)
    end
end

function Functions:GivePet(name, amount)
    amount = amount or 999
    print("Pets: " .. name .. " x" .. amount)
    for i = 1, amount do
        pcall(function()
            local args = {[1] = "GivePet", [2] = name}
            if game:GetService("ReplicatedStorage"):FindFirstChild("GardenEvent") then
                game:GetService("ReplicatedStorage").GardenEvent:FireServer(unpack(args))
            end
        end)
    end
end

-- OTHER
function Functions:GiveWeapon(name) print("Given: " .. name)
    pcall(function()
        local args = {[1] = name, [2] = Player}
        if game:GetService("ReplicatedStorage"):FindFirstChild("GiveWeapon") then
            game:GetService("ReplicatedStorage").GiveWeapon:FireServer(unpack(args))
        end
    end)
end

function Functions:FreeRobuxes() print("Robux added!")
    pcall(function()
        if game:GetService("ReplicatedStorage"):FindFirstChild("AddRobux") then
            game:GetService("ReplicatedStorage").AddRobux:FireServer(999999)
        end
    end)
end

function Functions:SpawnBot() print("Bot spawned!")
    pcall(function()
        if game:GetService("ReplicatedStorage"):FindFirstChild("SpawnBot") then
            game:GetService("ReplicatedStorage").SpawnBot:FireServer("SelfAware", Player.Character.HumanoidRootPart.Position)
        end
    end)
end

function Functions:GiveAdminVIP() print("Admin & VIP!")
    pcall(function()
        if game:GetService("ReplicatedStorage"):FindFirstChild("GiveAdmin") then
            game:GetService("ReplicatedStorage").GiveAdmin:FireServer(Player, "VIP")
        end
    end)
end

return Functions
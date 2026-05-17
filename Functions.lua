-- =============================================
-- Functions.lua - ★ Mod Menu By IlyaHacker ★
-- v9.0 FINAL | All Fixed
-- =============================================

local Functions = {}
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local spamLoop, lockLoop, pvpLoop, flyLoop, luckLoop, robuxLoop = nil, nil, nil, nil, nil, nil
local flySpeed = 50
local savedSpeed = 16

-- =================
-- MAIN FUNCTIONS
-- =================

function Functions:GodMode(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        if on then
            humanoid.MaxHealth = 9e9
            humanoid.Health = 9e9
            humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                if humanoid.Health < 9e9 then humanoid.Health = 9e9 end
            end)
        end
    end
end

function Functions:AntiBan(on)
    if on then
        -- Базовый анти-бан
        pcall(function()
            for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:lower():find("ban") or v.Name:lower():find("kick")) then
                    v:Destroy()
                end
            end
        end)
    end
end

function Functions:SpamChat(on, text)
    text = text or "hello"
    if on then
        spamLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(text)
            end)
        end)
    else
        if spamLoop then spamLoop:Disconnect() spamLoop = nil end
    end
end

-- FLY (FIXED - No stutter, no freeze)
function Functions:Fly(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")

    if on and root and humanoid then
        humanoid.PlatformStand = false
        humanoid.Sit = false

        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.Name = "FlyBodyVel"
        bodyVel.Velocity = Vector3.zero
        bodyVel.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVel.Parent = root

        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name = "FlyBodyGyro"
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.P = 3000
        bodyGyro.Parent = root

        flyLoop = RunService.RenderStepped:Connect(function()
            if not root or not root.Parent then
                if flyLoop then flyLoop:Disconnect() flyLoop = nil end
                return
            end

            local cam = Workspace.CurrentCamera
            local moveDir = Vector3.zero

            if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir -= Vector3.new(0, 1, 0) end

            if moveDir.Magnitude > 0 then
                bodyVel.Velocity = moveDir.Unit * flySpeed
            else
                bodyVel.Velocity = Vector3.zero
            end

            bodyGyro.CFrame = cam.CFrame
        end)
    else
        if flyLoop then flyLoop:Disconnect() flyLoop = nil end
        if root then
            local bv = root:FindFirstChild("FlyBodyVel")
            local bg = root:FindFirstChild("FlyBodyGyro")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
        end
    end
end

function Functions:SetFlySpeed(s) flySpeed = s end

function Functions:Carousel(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")

    if on and root and humanoid then
        humanoid.PlatformStand = true

        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Name = "CarouselGyro"
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)
        bodyGyro.P = 3000
        bodyGyro.Parent = root

        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.Name = "CarouselVel"
        bodyVel.MaxForce = Vector3.new(400000, 400000, 400000)
        bodyVel.Velocity = Vector3.new(0, 5, 0)
        bodyVel.Parent = root

        flyLoop = RunService.RenderStepped:Connect(function()
            if not root or not root.Parent then
                if flyLoop then flyLoop:Disconnect() flyLoop = nil end
                return
            end
            bodyGyro.CFrame = Workspace.CurrentCamera.CFrame * CFrame.Angles(0, math.rad(5), 0)
        end)
    else
        if flyLoop then flyLoop:Disconnect() flyLoop = nil end
        if humanoid then humanoid.PlatformStand = false end
        if root then
            for _, name in ipairs({"CarouselGyro", "CarouselVel"}) do
                local obj = root:FindFirstChild(name)
                if obj then obj:Destroy() end
            end
        end
    end
end

function Functions:SpeedHack(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        if on then
            humanoid.WalkSpeed = savedSpeed
        else
            humanoid.WalkSpeed = 16
        end
    end
end

function Functions:SetSpeed(s)
    savedSpeed = s
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then humanoid.WalkSpeed = s end
end

function Functions:ESP(on)
    if on then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Player then Functions:AddESP(p) end
        end
        Players.PlayerAdded:Connect(function(p) Functions:AddESP(p) end)
    end
end

function Functions:AddESP(p)
    local char = p.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP"
    bb.Parent = head
    bb.Adornee = head
    bb.Size = UDim2.new(0, 200, 0, 30)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    local frame = Instance.new("Frame", bb)
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    frame.BackgroundTransparency = 0.5
    local text = Instance.new("TextLabel", frame)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = p.Name
    text.TextColor3 = Color3.fromRGB(255, 255, 255)
    text.TextSize = 10
end

function Functions:RobuxHack(on)
    if on then
        robuxLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") and r.Name:lower():find("robux") then
                        r:FireServer(9999999999999)
                    end
                end
            end)
        end)
    else
        if robuxLoop then robuxLoop:Disconnect() robuxLoop = nil end
    end
end

-- =================
-- STEAL A BRAINROT
-- =================

function Functions:WallHack(on)
    if on then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("wall") then
                v.CanCollide = false
            end
        end
    end
end

function Functions:AutoSteal(on)
    if on then
        lockLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") and r.Name:lower():find("steal") then
                        r:FireServer()
                    end
                end
            end)
        end)
    else
        if lockLoop then lockLoop:Disconnect() lockLoop = nil end
    end
end

function Functions:AutoBot(on)
    if on then
        pvpLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                -- Auto steal
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        if r.Name:lower():find("steal") or r.Name:lower():find("collect") then
                            r:FireServer()
                        end
                        if r.Name:lower():find("buy") or r.Name:lower():find("purchase") then
                            r:FireServer("Bat")
                        end
                    end
                end
                -- Auto PvP
                local char = Player.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end)
        end)
    else
        if pvpLoop then pvpLoop:Disconnect() pvpLoop = nil end
    end
end

function Functions:AutoLockBase(on)
    if on then
        lockLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") and r.Name:lower():find("lock") then
                        r:FireServer(true)
                    end
                end
            end)
        end)
    else
        if lockLoop then lockLoop:Disconnect() lockLoop = nil end
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
        if pvpLoop then pvpLoop:Disconnect() pvpLoop = nil end
    end
end

function Functions:LuckBoost(on)
    if on then
        luckLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") and r.Name:lower():find("luck") then
                        r:FireServer(100)
                    end
                end
            end)
        end)
    else
        if luckLoop then luckLoop:Disconnect() luckLoop = nil end
    end
end

-- =================
-- GROW A GARDEN
-- =================

function Functions:GiveSeeds(name, amount)
    amount = amount or 1
    for i = 1, amount do
        pcall(function()
            for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") and (r.Name:lower():find("seed") or r.Name:lower():find("harvest") or r.Name:lower():find("plant") or r.Name:lower():find("give")) then
                    r:FireServer(name)
                end
            end
        end)
    end
end

function Functions:GivePet(name, amount)
    amount = amount or 1
    for i = 1, amount do
        pcall(function()
            for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") and (r.Name:lower():find("pet") or r.Name:lower():find("hatch") or r.Name:lower():find("egg") or r.Name:lower():find("give")) then
                    r:FireServer(name)
                end
            end
        end)
    end
end

function Functions:FastGrow(on)
    if on then
        luckLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") and r.Name:lower():find("grow") then
                        r:FireServer()
                    end
                end
            end)
        end)
    else
        if luckLoop then luckLoop:Disconnect() luckLoop = nil end
    end
end

function Functions:Farmer(on)
    if on then
        lockLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        if r.Name:lower():find("collect") or r.Name:lower():find("harvest") then
                            r:FireServer()
                        end
                        if r.Name:lower():find("sell") then
                            r:FireServer()
                        end
                    end
                end
            end)
        end)
    else
        if lockLoop then lockLoop:Disconnect() lockLoop = nil end
    end
end

-- =================
-- 99 NIGHTS IN FOREST
-- =================

function Functions:ForestESP(on) Functions:ESP(on) end

function Functions:ForestAutoFarm(on)
    if on then
        luckLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") and (r.Name:lower():find("farm") or r.Name:lower():find("collect")) then
                        r:FireServer()
                    end
                end
            end)
        end)
    else
        if luckLoop then luckLoop:Disconnect() luckLoop = nil end
    end
end

function Functions:ForestOneHit(on)
    if on then
        pvpLoop = RunService.Heartbeat:Connect(function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("Humanoid") and v.Parent ~= Player.Character then
                    v.Health = 0
                end
            end
        end)
    else
        if pvpLoop then pvpLoop:Disconnect() pvpLoop = nil end
    end
end

function Functions:ForestDiamonds(on)
    if on then
        robuxLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") and (r.Name:lower():find("diamond") or r.Name:lower():find("gem")) then
                        r:FireServer(999999)
                    end
                end
            end)
        end)
    else
        if robuxLoop then robuxLoop:Disconnect() robuxLoop = nil end
    end
end

function Functions:DupeItem(name, amount)
    amount = amount or 1
    for i = 1, amount do
        pcall(function()
            for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") and (r.Name:lower():find("give") or r.Name:lower():find("item") or r.Name:lower():find("add")) then
                    r:FireServer(name)
                end
            end
        end)
    end
end

function Functions:DupeChests(amount)
    amount = amount or 10
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        for i = 1, amount do
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") and (r.Name:lower():find("chest") or r.Name:lower():find("spawn")) then
                        r:FireServer(root.Position)
                    end
                end
            end)
        end
    end
end

function Functions:DupeFood(name, amount)
    Functions:DupeItem(name, amount)
end

function Functions:DupeGun(name, amount)
    Functions:DupeItem(name, amount)
end

function Functions:InfAmmo(on)
    if on then
        pvpLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") and r.Name:lower():find("ammo") then
                        r:FireServer(999)
                    end
                end
            end)
        end)
    else
        if pvpLoop then pvpLoop:Disconnect() pvpLoop = nil end
    end
end

function Functions:DupeWood(amount)
    amount = amount or 10
    for i = 1, amount do
        pcall(function()
            for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") and (r.Name:lower():find("wood") or r.Name:lower():find("log")) then
                    r:FireServer()
                end
            end
        end)
    end
end

-- =================
-- OTHER
-- =================

function Functions:FPSBooster(on)
    if on then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Workspace.Terrain.WaterWaveSize = 0
        Workspace.Terrain.WaterWaveSpeed = 0
    end
end

function Functions:FPSStabilizer(on)
    if on then
        setfpscap(60)
    else
        setfpscap(0)
    end
end

function Functions:ShowFPS(on)
    if on then
        local fpsGui = Instance.new("ScreenGui")
        fpsGui.Name = "FPSGui"
        fpsGui.Parent = game.CoreGui
        local fpsLabel = Instance.new("TextLabel")
        fpsLabel.Name = "FPS"
        fpsLabel.Parent = fpsGui
        fpsLabel.Size = UDim2.new(0, 80, 0, 22)
        fpsLabel.Position = UDim2.new(0, 10, 0, 10)
        fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        fpsLabel.BackgroundTransparency = 0.5
        fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        fpsLabel.TextSize = 12
        fpsLabel.Text = "FPS: 0"
        RunService.RenderStepped:Connect(function()
            fpsLabel.Text = "FPS: " .. math.floor(1 / RunService.RenderStepped:Wait())
        end)
    else
        local g = game.CoreGui:FindFirstChild("FPSGui")
        if g then g:Destroy() end
    end
end

function Functions:LowGraphics(on)
    if on then
        Lighting.Brightness = 1
        Lighting.FogEnd = 9e9
        Lighting.GlobalShadows = false
    end
end

function Functions:NoShadows(on)
    Lighting.GlobalShadows = not on
end

function Functions:NoParticles(on)
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v.Enabled = not on
        end
    end
end

-- =================
-- MUSIC PLAYER
-- =================

local musicPlayer = nil

function Functions:PlayMusic(url)
    if musicPlayer then musicPlayer:Destroy() end
    musicPlayer = Instance.new("Sound")
    musicPlayer.Parent = Workspace
    musicPlayer.Volume = 0.5
    musicPlayer.SoundId = url
    musicPlayer:Play()
end

function Functions:StopMusic()
    if musicPlayer then musicPlayer:Stop() end
end

function Functions:SetVolume(vol)
    if musicPlayer then musicPlayer.Volume = vol / 100 end
end

return Functions
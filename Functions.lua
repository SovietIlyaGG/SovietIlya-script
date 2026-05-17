-- =============================================
-- Functions.lua - ★ Mod Menu By IlyaHacker ★
-- v8.0 FINAL
-- =============================================

local Functions = {}
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local spamLoop, lockLoop, pvpLoop, flyLoop, luckLoop, robuxLoop = nil, nil, nil, nil, nil, nil
local flySpeed = 50

function Functions:GodMode(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local h = char:FindFirstChild("Humanoid")
    if h and on then h.Health = 9e9 h.MaxHealth = 9e9 end
end

function Functions:AntiBan(on) end

function Functions:SpamChat(on, text)
    text = text or "hello"
    if on then
        spamLoop = RunService.Heartbeat:Connect(function()
            pcall(function() game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(text) end)
        end)
    else if spamLoop then spamLoop:Disconnect() spamLoop = nil end end
end

function Functions:Fly(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local h = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if on and h and root then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyVel"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = root
        flyLoop = RunService.RenderStepped:Connect(function()
            local dir = Vector3.new(0, 0, 0)
            local cam = Workspace.CurrentCamera
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
            bv.Velocity = dir * flySpeed
        end)
    else
        if flyLoop then flyLoop:Disconnect() flyLoop = nil end
        if root then local bv = root:FindFirstChild("FlyVel") if bv then bv:Destroy() end end
    end
end

function Functions:Carousel(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local h = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if on and h and root then
        h.PlatformStand = true
        local bg = Instance.new("BodyGyro")
        bg.Name = "CarouselGyro"
        bg.P = 9e9
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.Parent = root
        local bv = Instance.new("BodyVelocity")
        bv.Name = "CarouselVel"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = root
        flyLoop = RunService.RenderStepped:Connect(function()
            local cam = Workspace.CurrentCamera
            bg.CFrame = cam.CFrame * CFrame.Angles(0, math.rad(10), 0)
            bv.Velocity = Vector3.new(0, 5, 0)
        end)
    else
        if flyLoop then flyLoop:Disconnect() flyLoop = nil end
        if h then h.PlatformStand = false end
        if root then for _, v in ipairs({"CarouselGyro", "CarouselVel"}) do local x = root:FindFirstChild(v) if x then x:Destroy() end end end
    end
end

function Functions:SpeedHack(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local h = char:FindFirstChild("Humanoid")
    if h then h.WalkSpeed = on and 40 or 16 end
end

function Functions:ESP(on)
    if on then
        for _, p in ipairs(Players:GetPlayers()) do if p ~= Player then Functions:AddESP(p) end end
        Players.PlayerAdded:Connect(function(p) Functions:AddESP(p) end)
    end
end

function Functions:AddESP(p)
    local c = p.Character if not c then return end
    local h = c:FindFirstChild("Head") if not h then return end
    local bb = Instance.new("BillboardGui") bb.Name = "ESP" bb.Parent = h bb.Adornee = h bb.Size = UDim2.new(0, 200, 0, 30) bb.StudsOffset = Vector3.new(0, 3, 0) bb.AlwaysOnTop = true
    local f = Instance.new("Frame", bb) f.Size = UDim2.new(1, 0, 1, 0) f.BackgroundColor3 = Color3.fromRGB(255, 0, 0) f.BackgroundTransparency = 0.5
    Instance.new("TextLabel", f).Text = p.Name
end

function Functions:RobuxHack(on) end

function Functions:WallHack(on)
    if on then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("wall") then v.CanCollide = false end
        end
    end
end

function Functions:AutoSteal(on) print("Auto-Steal: " .. tostring(on)) end
function Functions:AutoBot(on) print("Auto-Bot: " .. tostring(on)) end

function Functions:AutoLockBase(on)
    if on then lockLoop = RunService.Heartbeat:Connect(function() end)
    else if lockLoop then lockLoop:Disconnect() lockLoop = nil end end
end

function Functions:AutoPvP(on)
    if on then pvpLoop = RunService.Heartbeat:Connect(function() local t = Player.Character and Player.Character:FindFirstChildOfClass("Tool") if t then t:Activate() end end)
    else if pvpLoop then pvpLoop:Disconnect() pvpLoop = nil end end
end

function Functions:LuckBoost(on)
    if on then luckLoop = RunService.Heartbeat:Connect(function() end)
    else if luckLoop then luckLoop:Disconnect() luckLoop = nil end end
end

function Functions:GiveSeeds(name, amount) print("Seeds: " .. name .. " x" .. amount) end
function Functions:GivePet(name, amount) print("Pets: " .. name .. " x" .. amount) end
function Functions:FastGrow(on) end
function Functions:Farmer(on) end

function Functions:ForestESP(on) Functions:ESP(on) end
function Functions:ForestAutoFarm(on) end
function Functions:ForestOneHit(on) end
function Functions:ForestDiamonds(on) end
function Functions:DupeItem(name, amount) print("Dupe: " .. name .. " x" .. amount) end
function Functions:DupeChests(amount) print("Chests: " .. amount) end
function Functions:DupeFood(name, amount) print("Food: " .. name .. " x" .. amount) end
function Functions:DupeGun(name, amount) print("Gun: " .. name .. " x" .. amount) end
function Functions:InfAmmo(on) end
function Functions:DupeWood(amount) print("Wood: " .. amount) end

function Functions:FPSBooster(on) if on then game:GetService("Lighting").GlobalShadows = false end end
function Functions:FPSStabilizer(on) if on then setfpscap(60) end end
function Functions:ShowFPS(on) end
function Functions:LowGraphics(on) end
function Functions:NoShadows(on) game:GetService("Lighting").GlobalShadows = not on end
function Functions:NoParticles(on) end

-- MUSIC
local musicPlayer = nil
function Functions:PlayMusic(url)
    if musicPlayer then musicPlayer:Destroy() end
    musicPlayer = Instance.new("Sound") musicPlayer.Parent = Workspace musicPlayer.Volume = 0.5 musicPlayer.SoundId = url musicPlayer:Play()
end
function Functions:StopMusic() if musicPlayer then musicPlayer:Stop() end end
function Functions:SetVolume(vol) if musicPlayer then musicPlayer.Volume = vol / 100 end end

return Functions
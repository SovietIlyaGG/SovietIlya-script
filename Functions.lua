-- =============================================
-- Functions.lua - ★ Mod Menu By IlyaHacker ★
-- v11 FINAL | All Fixed | Music Player
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

local function findCampfire()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("camp") or v.Name:lower():find("fire") or v.Name:lower():find("campfire") or v.Name:lower():find("kost") or v.Name:lower():find("bonfire") or v.Name:lower():find("spawn")) then
            return v.Position
        end
    end
    local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    return root and root.Position or Vector3.new(0, 0, 0)
end

function Functions:GodMode(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and on then
        humanoid.MaxHealth = 9e9 humanoid.Health = 9e9
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health < 9e9 then humanoid.Health = 9e9 end
        end)
    end
end

function Functions:AntiBan(on) end

function Functions:SpamChat(on, text)
    text = text or "hello"
    if on then spamLoop = RunService.Heartbeat:Connect(function()
        pcall(function() game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(text) end)
    end)
    else if spamLoop then spamLoop:Disconnect() spamLoop = nil end end
end

function Functions:Fly(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if on and root and humanoid then
        humanoid.PlatformStand = false humanoid.Sit = false
        local bv = Instance.new("BodyVelocity") bv.Name = "FlyVel" bv.MaxForce = Vector3.new(400000, 400000, 400000) bv.Parent = root
        local bg = Instance.new("BodyGyro") bg.Name = "FlyGyro" bg.MaxTorque = Vector3.new(400000, 400000, 400000) bg.P = 3000 bg.Parent = root
        flyLoop = RunService.RenderStepped:Connect(function()
            if not root or not root.Parent then if flyLoop then flyLoop:Disconnect() flyLoop = nil end return end
            local cam = Workspace.CurrentCamera local dir = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0, 1, 0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0, 1, 0) end
            bv.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
            bg.CFrame = cam.CFrame
        end)
    else
        if flyLoop then flyLoop:Disconnect() flyLoop = nil end
        if root then for _, n in ipairs({"FlyVel", "FlyGyro"}) do local x = root:FindFirstChild(n) if x then x:Destroy() end end end
    end
end

function Functions:SetFlySpeed(s) flySpeed = s end

function Functions:Carousel(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    if on and root and humanoid then
        humanoid.PlatformStand = true
        local bg = Instance.new("BodyGyro") bg.Name = "CarGyro" bg.MaxTorque = Vector3.new(400000, 400000, 400000) bg.P = 3000 bg.Parent = root
        local bv = Instance.new("BodyVelocity") bv.Name = "CarVel" bv.MaxForce = Vector3.new(400000, 400000, 400000) bv.Velocity = Vector3.new(0, 5, 0) bv.Parent = root
        flyLoop = RunService.RenderStepped:Connect(function()
            if not root or not root.Parent then if flyLoop then flyLoop:Disconnect() flyLoop = nil end return end
            bg.CFrame = Workspace.CurrentCamera.CFrame * CFrame.Angles(0, math.rad(5), 0)
        end)
    else
        if flyLoop then flyLoop:Disconnect() flyLoop = nil end
        if humanoid then humanoid.PlatformStand = false end
        if root then for _, n in ipairs({"CarGyro", "CarVel"}) do local x = root:FindFirstChild(n) if x then x:Destroy() end end end
    end
end

function Functions:SpeedHack(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then humanoid.WalkSpeed = on and savedSpeed or 16 end
end

function Functions:SetSpeed(s) savedSpeed = s
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then humanoid.WalkSpeed = s end
end

function Functions:ESP(on)
    if on then for _, p in ipairs(Players:GetPlayers()) do if p ~= Player then Functions:AddESP(p) end end end
end

function Functions:AddESP(p)
    local char = p.Character if not char then return end
    local head = char:FindFirstChild("Head") if not head then return end
    local bb = Instance.new("BillboardGui") bb.Name = "ESP" bb.Parent = head bb.Adornee = head bb.Size = UDim2.new(0, 200, 0, 30) bb.StudsOffset = Vector3.new(0, 3, 0) bb.AlwaysOnTop = true
    local f = Instance.new("Frame", bb) f.Size = UDim2.new(1, 0, 1, 0) f.BackgroundColor3 = Color3.fromRGB(255, 0, 0) f.BackgroundTransparency = 0.5
    Instance.new("TextLabel", f).Text = p.Name
end

function Functions:RobuxHack(on) end

function Functions:WallHack(on)
    if on then for _, v in ipairs(Workspace:GetDescendants()) do if v:IsA("BasePart") and v.Name:lower():find("wall") then v.CanCollide = false end end end
end

function Functions:AutoSteal(on) end
function Functions:AutoBot(on) end

function Functions:AutoLockBase(on)
    if on then lockLoop = RunService.Heartbeat:Connect(function() end)
    else if lockLoop then lockLoop:Disconnect() lockLoop = nil end end
end

function Functions:AutoPvP(on)
    if on then pvpLoop = RunService.Heartbeat:Connect(function()
        local char = Player.Character if char then local tool = char:FindFirstChildOfClass("Tool") if tool then tool:Activate() end end
    end)
    else if pvpLoop then pvpLoop:Disconnect() pvpLoop = nil end end
end

function Functions:LuckBoost(on)
    if on then luckLoop = RunService.Heartbeat:Connect(function() end)
    else if luckLoop then luckLoop:Disconnect() luckLoop = nil end end
end

function Functions:GiveSeeds(name, amount)
    amount = amount or 1
    for i = 1, amount do pcall(function() for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("seed") or r.Name:lower():find("harvest") or r.Name:lower():find("plant") or r.Name:lower():find("give")) then r:FireServer(name) end end end) end
end

function Functions:GivePet(name, amount)
    amount = amount or 1
    for i = 1, amount do pcall(function() for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("pet") or r.Name:lower():find("hatch") or r.Name:lower():find("egg") or r.Name:lower():find("give")) then r:FireServer(name) end end end) end
end

function Functions:FastGrow(on) end
function Functions:Farmer(on) end

function Functions:ForestESP(on) Functions:ESP(on) end

function Functions:ForestAutoFarm(on)
    if on then
        luckLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = Player.Character if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart") if not root then return end
                local humanoid = char:FindFirstChild("Humanoid")
                local tool = char:FindFirstChildOfClass("Tool")

                if humanoid and humanoid.Health < humanoid.MaxHealth then
                    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("eat") or r.Name:lower():find("consume")) then r:FireServer("Bread") end end
                end

                local nearestAnimal, nearestAnimalDist = nil, 200
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") and (v.Name:lower():find("deer") or v.Name:lower():find("boar") or v.Name:lower():find("wolf") or v.Name:lower():find("rabbit") or v.Name:lower():find("bear") or v.Name:lower():find("animal") or v.Name:lower():find("monster") or v.Name:lower():find("enemy")) then
                        local ar = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head") or v.PrimaryPart
                        if ar then local dist = (ar.Position - root.Position).Magnitude if dist < nearestAnimalDist then nearestAnimalDist = dist nearestAnimal = v end end
                    end
                end
                if nearestAnimal then
                    local ar = nearestAnimal:FindFirstChild("HumanoidRootPart") or nearestAnimal:FindFirstChild("Head") or nearestAnimal.PrimaryPart
                    if ar then root.CFrame = CFrame.new(ar.Position + Vector3.new(0, 3, 0))
                        for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("attack") or r.Name:lower():find("hit") or r.Name:lower():find("damage") or r.Name:lower():find("hunt")) then r:FireServer(nearestAnimal) end end
                        if tool then tool:Activate() end return
                    end
                end

                local nearestTree, nearestTreeDist = nil, 200
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name:lower():find("tree") or v.Name:lower():find("wood") or v.Name:lower():find("log") or v.Name:lower():find("oak") or v.Name:lower():find("pine") or v.Name:lower():find("birch") or v.Name:lower():find("bush") or v.Name:lower():find("plant") or v.Name:lower():find("rock") or v.Name:lower():find("stone")) then
                        local dist = (v.Position - root.Position).Magnitude if dist < nearestTreeDist then nearestTreeDist = dist nearestTree = v end
                    end
                end
                if nearestTree then root.CFrame = CFrame.new(nearestTree.Position + Vector3.new(0, 3, 0))
                    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("chop") or r.Name:lower():find("cut") or r.Name:lower():find("harvest") or r.Name:lower():find("farm") or r.Name:lower():find("collect") or r.Name:lower():find("hit") or r.Name:lower():find("mine")) then r:FireServer(nearestTree) end end
                    if tool then tool:Activate() end return
                end

                local campPos = findCampfire()
                if campPos then for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("plant") or r.Name:lower():find("grow") or r.Name:lower():find("seed")) then r:FireServer(campPos + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))) end end end
            end)
        end)
    else if luckLoop then luckLoop:Disconnect() luckLoop = nil end end
end

function Functions:ForestOneHit(on)
    if on then pvpLoop = RunService.Heartbeat:Connect(function() for _, v in ipairs(Workspace:GetDescendants()) do if v:IsA("Humanoid") and v.Parent ~= Player.Character then v.Health = 0 end end end)
    else if pvpLoop then pvpLoop:Disconnect() pvpLoop = nil end end
end

function Functions:ForestDiamonds(on)
    if on then robuxLoop = RunService.Heartbeat:Connect(function() pcall(function() for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("diamond") or r.Name:lower():find("gem")) then r:FireServer(999999) end end end) end)
    else if robuxLoop then robuxLoop:Disconnect() robuxLoop = nil end end
end

function Functions:DupeItem(name, amount)
    amount = amount or 1 local pos = findCampfire()
    for i = 1, amount do pcall(function() for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("give") or r.Name:lower():find("item") or r.Name:lower():find("add") or r.Name:lower():find("spawn")) then r:FireServer(name, pos) end end end) end
end

function Functions:DupeChests(amount)
    amount = amount or 10 local pos = findCampfire()
    for i = 1, amount do pcall(function() for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("chest") or r.Name:lower():find("spawn") or r.Name:lower():find("create") or r.Name:lower():find("loot")) then r:FireServer(pos + Vector3.new(math.random(-5, 5), 0, math.random(-5, 5))) end end end) end
end

function Functions:DupeFood(name, amount)
    amount = amount or 1 local pos = findCampfire()
    for i = 1, amount do pcall(function() for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("food") or r.Name:lower():find("give") or r.Name:lower():find("item") or r.Name:lower():find("spawn")) then r:FireServer(name, pos) end end end) end
end

function Functions:DupeGun(name, amount)
    amount = amount or 1 local pos = findCampfire()
    for i = 1, amount do pcall(function() for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("gun") or r.Name:lower():find("weapon") or r.Name:lower():find("give") or r.Name:lower():find("item") or r.Name:lower():find("spawn")) then r:FireServer(name, pos) end end end) end
end

function Functions:InfAmmo(on)
    if on then pvpLoop = RunService.Heartbeat:Connect(function() pcall(function() for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and r.Name:lower():find("ammo") then r:FireServer(999) end end end) end)
    else if pvpLoop then pvpLoop:Disconnect() pvpLoop = nil end end
end

function Functions:DupeWood(amount)
    amount = amount or 10 local pos = findCampfire()
    for i = 1, amount do pcall(function() for _, r in ipairs(ReplicatedStorage:GetDescendants()) do if r:IsA("RemoteEvent") and (r.Name:lower():find("wood") or r.Name:lower():find("log") or r.Name:lower():find("resource") or r.Name:lower():find("spawn")) then r:FireServer(pos + Vector3.new(math.random(-3, 3), 0, math.random(-3, 3))) end end end) end
end

function Functions:FPSBooster(on) if on then Lighting.GlobalShadows = false Lighting.FogEnd = 9e9 end end
function Functions:FPSStabilizer(on) if on then setfpscap(60) else setfpscap(0) end end
function Functions:ShowFPS(on) end
function Functions:LowGraphics(on) end
function Functions:NoShadows(on) Lighting.GlobalShadows = not on end
function Functions:NoParticles(on) end

-- MUSIC PLAYER
local musicPlayer = nil
local currentVolume = 50

function Functions:PlayMusic(id)
    if musicPlayer then musicPlayer:Destroy() end
    musicPlayer = Instance.new("Sound")
    musicPlayer.Parent = Workspace
    musicPlayer.Volume = currentVolume / 100
    musicPlayer.SoundId = "rbxassetid://" .. id
    musicPlayer:Play()
end

function Functions:StopMusic()
    if musicPlayer then musicPlayer:Stop() end
end

function Functions:SetVolume(vol)
    currentVolume = vol
    if musicPlayer then musicPlayer.Volume = vol / 100 end
end

function Functions:BrowseFiles()
    local files = {}
    pcall(function()
        if listfiles then
            for _, path in ipairs({"/storage/emulated/0/Music/", "/storage/emulated/0/Download/", "/storage/emulated/0/"}) do
                pcall(function()
                    for _, file in ipairs(listfiles(path)) do
                        if file:match("%.mp3$") or file:match("%.ogg$") or file:match("%.wav$") then
                            table.insert(files, file)
                        end
                    end
                end)
            end
        end
    end)
    return files
end

return Functions
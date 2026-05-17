-- =============================================
-- Functions.lua - ★ Mod Menu By IlyaHacker ★
-- v12 FINAL
-- =============================================

local Functions = {}

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local spamLoop = nil
local lockLoop = nil
local pvpLoop = nil
local flyLoop = nil
local luckLoop = nil
local robuxLoop = nil
local flySpeed = 50
local savedSpeed = 16

local function findCampfire()
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            local name = v.Name:lower()
            if name:find("camp") or name:find("fire") or name:find("campfire") or name:find("kost") or name:find("bonfire") or name:find("spawn") then
                return v.Position
            end
        end
    end
    local char = Player.Character
    if char then
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            return root.Position
        end
    end
    return Vector3.new(0, 0, 0)
end

function Functions:GodMode(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid and on then
        humanoid.MaxHealth = 9e9
        humanoid.Health = 9e9
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health < 9e9 then
                humanoid.Health = 9e9
            end
        end)
    end
end

function Functions:AntiBan(on)
    if on then
        pcall(function()
            for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    local name = v.Name:lower()
                    if name:find("ban") or name:find("kick") then
                        v:Destroy()
                    end
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
        if spamLoop then
            spamLoop:Disconnect()
            spamLoop = nil
        end
    end
end

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
                if flyLoop then
                    flyLoop:Disconnect()
                    flyLoop = nil
                end
                return
            end

            local cam = Workspace.CurrentCamera
            local moveDir = Vector3.zero

            if UIS:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + cam.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - cam.CFrame.LookVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - cam.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + cam.CFrame.RightVector
            end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0, 1, 0)
            end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir = moveDir - Vector3.new(0, 1, 0)
            end

            if moveDir.Magnitude > 0 then
                bodyVel.Velocity = moveDir.Unit * flySpeed
            else
                bodyVel.Velocity = Vector3.zero
            end

            bodyGyro.CFrame = cam.CFrame
        end)
    else
        if flyLoop then
            flyLoop:Disconnect()
            flyLoop = nil
        end
        if root then
            local bv = root:FindFirstChild("FlyBodyVel")
            local bg = root:FindFirstChild("FlyBodyGyro")
            if bv then
                bv:Destroy()
            end
            if bg then
                bg:Destroy()
            end
        end
    end
end

function Functions:SetFlySpeed(s)
    flySpeed = s
end

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
                if flyLoop then
                    flyLoop:Disconnect()
                    flyLoop = nil
                end
                return
            end
            bodyGyro.CFrame = Workspace.CurrentCamera.CFrame * CFrame.Angles(0, math.rad(5), 0)
        end)
    else
        if flyLoop then
            flyLoop:Disconnect()
            flyLoop = nil
        end
        if humanoid then
            humanoid.PlatformStand = false
        end
        if root then
            local bg = root:FindFirstChild("CarouselGyro")
            local bv = root:FindFirstChild("CarouselVel")
            if bg then
                bg:Destroy()
            end
            if bv then
                bv:Destroy()
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
    if humanoid then
        humanoid.WalkSpeed = s
    end
end

function Functions:ESP(on)
    if on then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Player then
                Functions:AddESP(p)
            end
        end
        Players.PlayerAdded:Connect(function(p)
            Functions:AddESP(p)
        end)
    end
end

function Functions:AddESP(p)
    local char = p.Character
    if not char then
        return
    end
    local head = char:FindFirstChild("Head")
    if not head then
        return
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
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
end

function Functions:RobuxHack(on)
    if on then
        robuxLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        if r.Name:lower():find("robux") then
                            r:FireServer(9999999999999)
                        end
                    end
                end
            end)
        end)
    else
        if robuxLoop then
            robuxLoop:Disconnect()
            robuxLoop = nil
        end
    end
end

function Functions:WallHack(on)
    if on then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                if v.Name:lower():find("wall") then
                    v.CanCollide = false
                end
            end
        end
    end
end

function Functions:AutoSteal(on)
    if on then
        lockLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        if r.Name:lower():find("steal") then
                            r:FireServer()
                        end
                    end
                end
            end)
        end)
    else
        if lockLoop then
            lockLoop:Disconnect()
            lockLoop = nil
        end
    end
end

function Functions:AutoBot(on)
    if on then
        pvpLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        local name = r.Name:lower()
                        if name:find("steal") or name:find("collect") then
                            r:FireServer()
                        end
                        if name:find("buy") or name:find("purchase") then
                            r:FireServer("Bat")
                        end
                    end
                end
                local char = Player.Character
                if char then
                    local tool = char:FindFirstChildOfClass("Tool")
                    if tool then
                        tool:Activate()
                    end
                end
            end)
        end)
    else
        if pvpLoop then
            pvpLoop:Disconnect()
            pvpLoop = nil
        end
    end
end

function Functions:AutoLockBase(on)
    if on then
        lockLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        if r.Name:lower():find("lock") then
                            r:FireServer(true)
                        end
                    end
                end
            end)
        end)
    else
        if lockLoop then
            lockLoop:Disconnect()
            lockLoop = nil
        end
    end
end

function Functions:AutoPvP(on)
    if on then
        pvpLoop = RunService.Heartbeat:Connect(function()
            local char = Player.Character
            if char then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                end
            end
        end)
    else
        if pvpLoop then
            pvpLoop:Disconnect()
            pvpLoop = nil
        end
    end
end

function Functions:LuckBoost(on)
    if on then
        luckLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        if r.Name:lower():find("luck") then
                            r:FireServer(100)
                        end
                    end
                end
            end)
        end)
    else
        if luckLoop then
            luckLoop:Disconnect()
            luckLoop = nil
        end
    end
end

function Functions:GiveSeeds(name, amount)
    amount = amount or 1
    for i = 1, amount do
        pcall(function()
            for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") then
                    local rname = r.Name:lower()
                    if rname:find("seed") or rname:find("harvest") or rname:find("plant") or rname:find("give") then
                        r:FireServer(name)
                    end
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
                if r:IsA("RemoteEvent") then
                    local rname = r.Name:lower()
                    if rname:find("pet") or rname:find("hatch") or rname:find("egg") or rname:find("give") then
                        r:FireServer(name)
                    end
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
                    if r:IsA("RemoteEvent") then
                        if r.Name:lower():find("grow") then
                            r:FireServer()
                        end
                    end
                end
            end)
        end)
    else
        if luckLoop then
            luckLoop:Disconnect()
            luckLoop = nil
        end
    end
end

function Functions:Farmer(on)
    if on then
        lockLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        local rname = r.Name:lower()
                        if rname:find("collect") or rname:find("harvest") then
                            r:FireServer()
                        end
                        if rname:find("sell") then
                            r:FireServer()
                        end
                    end
                end
            end)
        end)
    else
        if lockLoop then
            lockLoop:Disconnect()
            lockLoop = nil
        end
    end
end

function Functions:ForestESP(on)
    Functions:ESP(on)
end

function Functions:ForestAutoFarm(on)
    if on then
        luckLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = Player.Character
                if not char then
                    return
                end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then
                    return
                end
                local humanoid = char:FindFirstChild("Humanoid")
                local tool = char:FindFirstChildOfClass("Tool")

                if humanoid and humanoid.Health < humanoid.MaxHealth then
                    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") then
                            local rname = r.Name:lower()
                            if rname:find("eat") or rname:find("consume") or rname:find("use") then
                                r:FireServer("Bread")
                            end
                        end
                    end
                end

                local nearestAnimal = nil
                local nearestAnimalDist = 200

                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("Model") then
                        local vname = v.Name:lower()
                        if vname:find("deer") or vname:find("boar") or vname:find("wolf") or vname:find("rabbit") or vname:find("bear") or vname:find("animal") or vname:find("monster") or vname:find("enemy") then
                            local animalRoot = v:FindFirstChild("HumanoidRootPart") or v:FindFirstChild("Head") or v.PrimaryPart
                            if animalRoot then
                                local dist = (animalRoot.Position - root.Position).Magnitude
                                if dist < nearestAnimalDist then
                                    nearestAnimalDist = dist
                                    nearestAnimal = v
                                end
                            end
                        end
                    end
                end

                if nearestAnimal then
                    local animalRoot = nearestAnimal:FindFirstChild("HumanoidRootPart") or nearestAnimal:FindFirstChild("Head") or nearestAnimal.PrimaryPart
                    if animalRoot then
                        root.CFrame = CFrame.new(animalRoot.Position + Vector3.new(0, 3, 0))
                        for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                            if r:IsA("RemoteEvent") then
                                local rname = r.Name:lower()
                                if rname:find("attack") or rname:find("hit") or rname:find("damage") or rname:find("hunt") then
                                    r:FireServer(nearestAnimal)
                                end
                            end
                        end
                        if tool then
                            tool:Activate()
                        end
                        return
                    end
                end

                local nearestTree = nil
                local nearestTreeDist = 200

                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        local vname = v.Name:lower()
                        if vname:find("tree") or vname:find("wood") or vname:find("log") or vname:find("oak") or vname:find("pine") or vname:find("birch") or vname:find("bush") or vname:find("plant") or vname:find("rock") or vname:find("stone") then
                            local dist = (v.Position - root.Position).Magnitude
                            if dist < nearestTreeDist then
                                nearestTreeDist = dist
                                nearestTree = v
                            end
                        end
                    end
                end

                if nearestTree then
                    root.CFrame = CFrame.new(nearestTree.Position + Vector3.new(0, 3, 0))
                    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") then
                            local rname = r.Name:lower()
                            if rname:find("chop") or rname:find("cut") or rname:find("harvest") or rname:find("farm") or rname:find("collect") or rname:find("hit") or rname:find("mine") then
                                r:FireServer(nearestTree)
                            end
                        end
                    end
                    if tool then
                        tool:Activate()
                    end
                    return
                end

                local campPos = findCampfire()
                if campPos then
                    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") then
                            local rname = r.Name:lower()
                            if rname:find("plant") or rname:find("grow") or rname:find("seed") or rname:find("sapling") then
                                local plantPos = campPos + Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
                                r:FireServer(plantPos)
                            end
                        end
                    end
                end
            end)
        end)
    else
        if luckLoop then
            luckLoop:Disconnect()
            luckLoop = nil
        end
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
        if pvpLoop then
            pvpLoop:Disconnect()
            pvpLoop = nil
        end
    end
end

function Functions:ForestDiamonds(on)
    if on then
        robuxLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        local rname = r.Name:lower()
                        if rname:find("diamond") or rname:find("gem") then
                            r:FireServer(999999)
                        end
                    end
                end
            end)
        end)
    else
        if robuxLoop then
            robuxLoop:Disconnect()
            robuxLoop = nil
        end
    end
end

function Functions:DupeItem(name, amount)
    amount = amount or 1
    local pos = findCampfire()
    for i = 1, amount do
        local item = Instance.new("Tool")
        item.Name = name
        item.RequiresHandle = false
        item.Parent = Workspace

        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 1, 1)
        handle.Position = pos + Vector3.new(math.random(-3, 3), 3, math.random(-3, 3))
        handle.Anchored = false
        handle.Parent = item

        pcall(function()
            local char = Player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
                if root then
                    firetouchinterest(handle, root, 0)
                    wait(0.1)
                    firetouchinterest(handle, root, 1)
                end
            end
        end)
    end
end

function Functions:DupeFood(name, amount)
    amount = amount or 1
    local pos = findCampfire()
    for i = 1, amount do
        local food = Instance.new("Tool")
        food.Name = name
        food.RequiresHandle = false
        food.Parent = Workspace

        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(0.5, 0.5, 0.5)
        handle.Position = pos + Vector3.new(math.random(-3, 3), 3, math.random(-3, 3))
        handle.Anchored = false
        handle.Parent = food

        pcall(function()
            local char = Player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
                if root then
                    firetouchinterest(handle, root, 0)
                    wait(0.1)
                    firetouchinterest(handle, root, 1)
                end
            end
        end)
    end
end

function Functions:DupeGun(name, amount)
    amount = amount or 1
    local pos = findCampfire()
    for i = 1, amount do
        local gun = Instance.new("Tool")
        gun.Name = name
        gun.RequiresHandle = false
        gun.Parent = Workspace

        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(1, 0.5, 2)
        handle.Position = pos + Vector3.new(math.random(-3, 3), 3, math.random(-3, 3))
        handle.Anchored = false
        handle.Parent = gun

        pcall(function()
            local char = Player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
                if root then
                    firetouchinterest(handle, root, 0)
                    wait(0.1)
                    firetouchinterest(handle, root, 1)
                end
            end
        end)
    end
end

function Functions:DupeWood(amount)
    amount = amount or 10
    local pos = findCampfire()
    for i = 1, amount do
        local wood = Instance.new("Part")
        wood.Name = "Wood"
        wood.Size = Vector3.new(1, 0.5, 1)
        wood.Position = pos + Vector3.new(math.random(-5, 5), 2, math.random(-5, 5))
        wood.Anchored = false
        wood.BrickColor = BrickColor.new("Brown")
        wood.Parent = Workspace

        pcall(function()
            local char = Player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
                if root then
                    firetouchinterest(wood, root, 0)
                    wait(0.1)
                    firetouchinterest(wood, root, 1)
                end
            end
        end)
    end
end

function Functions:DupeChests(amount)
    amount = amount or 10
    local pos = findCampfire()
    for i = 1, amount do
        local chest = Instance.new("Part")
        chest.Name = "Chest"
        chest.Size = Vector3.new(2, 1.5, 2)
        chest.Position = pos + Vector3.new(math.random(-5, 5), 2, math.random(-5, 5))
        chest.Anchored = true
        chest.BrickColor = BrickColor.new("Gold")
        chest.Material = Enum.Material.Wood
        chest.Parent = Workspace

        local glow = Instance.new("PointLight")
        glow.Brightness = 1
        glow.Range = 3
        glow.Color = Color3.fromRGB(255, 215, 0)
        glow.Parent = chest
    end
end

function Functions:InfAmmo(on)
    if on then
        pvpLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        if r.Name:lower():find("ammo") then
                            r:FireServer(999)
                        end
                    end
                end
            end)
        end)
    else
        if pvpLoop then
            pvpLoop:Disconnect()
            pvpLoop = nil
        end
    end
end

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
        if g then
            g:Destroy()
        end
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
local currentVolume = 50

function Functions:PlayMusic(id)
    if musicPlayer then
        musicPlayer:Destroy()
    end

    musicPlayer = Instance.new("Sound")
    musicPlayer.Parent = Workspace
    musicPlayer.Volume = currentVolume / 100

    if tonumber(id) then
        musicPlayer.SoundId = "rbxassetid://" .. id
    else
        musicPlayer.SoundId = id
    end

    musicPlayer:Play()
end

function Functions:StopMusic()
    if musicPlayer then
        musicPlayer:Stop()
    end
end

function Functions:SetVolume(vol)
    currentVolume = vol
    if musicPlayer then
        musicPlayer.Volume = vol / 100
    end
end

function Functions:BrowseFiles()
    local files = {}

    pcall(function()
        local paths = {
            "/storage/emulated/0/Music/",
            "/storage/emulated/0/Download/",
            "/storage/emulated/0/DCIM/",
            "/storage/emulated/0/"
        }

        for _, path in ipairs(paths) do
            pcall(function()
                local cmd = 'ls "' .. path .. '"* 2>/dev/null | grep -i "\\.mp3$\\|\\.ogg$\\|\\.wav$"'
                local handle = io.popen(cmd)
                if handle then
                    for file in handle:lines() do
                        table.insert(files, file)
                    end
                    handle:close()
                end
            end)
        end
    end)

    if #files == 0 then
        table.insert(files, "No music files found")
    end

    return files
end

return Functions
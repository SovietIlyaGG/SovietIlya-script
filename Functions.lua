-- =============================================
-- Functions.lua - ★ Mod Menu By IlyaHacker ★
-- v14 FINAL | All Functions + Radius + Auto Chop
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
local radiusCircle = nil
local chopLoop = nil

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

-- =================
-- RADIUS CIRCLE
-- =================

function Functions:ShowRadius(on)
    if on then
        if radiusCircle then
            radiusCircle:Destroy()
        end
        
        local char = Player.Character or Player.CharacterAdded:Wait()
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        radiusCircle = Instance.new("Part")
        radiusCircle.Name = "RadiusCircle"
        radiusCircle.Shape = Enum.PartType.Cylinder
        radiusCircle.Size = Vector3.new(1, 0.1, 1)
        radiusCircle.Position = root.Position
        radiusCircle.Anchored = true
        radiusCircle.CanCollide = false
        radiusCircle.Transparency = 0.5
        radiusCircle.BrickColor = BrickColor.new("Really red")
        radiusCircle.Material = Enum.Material.Neon
        radiusCircle.Parent = Workspace
        
        spawn(function()
            while radiusCircle and radiusCircle.Parent do
                local char = Player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    radiusCircle.Position = char.HumanoidRootPart.Position
                    radiusCircle.Size = Vector3.new(50, 0.1, 50)
                end
                RunService.RenderStepped:Wait()
            end
        end)
    else
        if radiusCircle then
            radiusCircle:Destroy()
            radiusCircle = nil
        end
    end
end

-- =================
-- AUTO CHOP TREES
-- =================

function Functions:AutoChopTrees(on)
    if on then
        chopLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = Player.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
                local tool = char:FindFirstChildOfClass("Tool")

                local nearestTree = nil
                local nearestDist = 50

                -- Ищем BasePart деревья
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        local vname = v.Name:lower()
                        if vname:find("tree") or vname:find("wood") or vname:find("log") or vname:find("oak") or vname:find("pine") or vname:find("birch") or vname:find("bush") or vname:find("plant") or vname:find("rock") or vname:find("stone") or vname:find("branch") then
                            local dist = (v.Position - root.Position).Magnitude
                            if dist < nearestDist then
                                nearestDist = dist
                                nearestTree = v
                            end
                        end
                    end
                end

                -- Ищем Model деревья
                if not nearestTree then
                    for _, v in ipairs(Workspace:GetDescendants()) do
                        if v:IsA("Model") then
                            local vname = v.Name:lower()
                            if vname:find("tree") or vname:find("oak") or vname:find("pine") or vname:find("birch") or vname:find("log") then
                                local primary = v.PrimaryPart
                                if primary then
                                    local dist = (primary.Position - root.Position).Magnitude
                                    if dist < nearestDist then
                                        nearestDist = dist
                                        nearestTree = primary
                                    end
                                end
                            end
                        end
                    end
                end

                if nearestTree then
                    root.CFrame = CFrame.new(nearestTree.Position + Vector3.new(0, 3, 0))
                    
                    for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                        if r:IsA("RemoteEvent") then
                            local rname = r.Name:lower()
                            if rname:find("chop") or rname:find("cut") or rname:find("harvest") or rname:find("farm") or rname:find("collect") or rname:find("hit") or rname:find("mine") or rname:find("damage") or rname:find("attack") then
                                r:FireServer(nearestTree)
                            end
                        end
                    end
                    
                    if tool then
                        tool:Activate()
                    end
                    
                    pcall(function()
                        local mouse = Player:GetMouse()
                        if mouse then
                            mouse1click()
                        end
                    end)
                end
            end)
        end)
    else
        if chopLoop then
            chopLoop:Disconnect()
            chopLoop = nil
        end
    end
end

-- =================
-- MAIN FUNCTIONS
-- =================

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
        if flyLoop then
            flyLoop:Disconnect()
            flyLoop = nil
        end
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
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "CarouselGyro"
        bg.MaxTorque = Vector3.new(400000, 400000, 400000)
        bg.P = 3000
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "CarouselVel"
        bv.MaxForce = Vector3.new(400000, 400000, 400000)
        bv.Velocity = Vector3.new(0, 5, 0)
        flyLoop = RunService.RenderStepped:Connect(function()
            if not root or not root.Parent then if flyLoop then flyLoop:Disconnect() flyLoop = nil end return end
            bg.CFrame = Workspace.CurrentCamera.CFrame * CFrame.Angles(0, math.rad(5), 0)
        end)
    else
        if flyLoop then flyLoop:Disconnect() flyLoop = nil end
        if humanoid then humanoid.PlatformStand = false end
        if root then
            for _, n in ipairs({"CarouselGyro", "CarouselVel"}) do local x = root:FindFirstChild(n) if x then x:Destroy() end end
        end
    end
end

function Functions:SpeedHack(on)
    local char = Player.Character or Player.CharacterAdded:Wait()
    local h = char:FindFirstChild("Humanoid")
    if h then h.WalkSpeed = on and savedSpeed or 16 end
end

function Functions:SetSpeed(s)
    savedSpeed = s
    local char = Player.Character or Player.CharacterAdded:Wait()
    local h = char:FindFirstChild("Humanoid")
    if h then h.WalkSpeed = s end
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
    local c = p.Character if not c then return end
    local h = c:FindFirstChild("Head") if not h then return end
    local bb = Instance.new("BillboardGui") bb.Name = "ESP" bb.Parent = h bb.Adornee = h
    bb.Size = UDim2.new(0, 200, 0, 30) bb.StudsOffset = Vector3.new(0, 3, 0) bb.AlwaysOnTop = true
    local f = Instance.new("Frame", bb) f.Size = UDim2.new(1, 0, 1, 0) f.BackgroundColor3 = Color3.fromRGB(255, 0, 0) f.BackgroundTransparency = 0.5
    local t = Instance.new("TextLabel", f) t.Size = UDim2.new(1, 0, 1, 0) t.BackgroundTransparency = 1 t.Text = p.Name t.TextColor3 = Color3.fromRGB(255, 255, 255) t.TextSize = 10
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
                for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                    if r:IsA("RemoteEvent") then
                        local name = r.Name:lower()
                        if name:find("steal") or name:find("collect") then r:FireServer() end
                        if name:find("buy") or name:find("purchase") then r:FireServer("Bat") end
                    end
                end
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
                        local rname = r.Name:lower()
                        if rname:find("collect") or rname:find("harvest") then r:FireServer() end
                        if rname:find("sell") then r:FireServer() end
                    end
                end
            end)
        end)
    else
        if lockLoop then lockLoop:Disconnect() lockLoop = nil end
    end
end

function Functions:ForestESP(on) Functions:ESP(on) end

function Functions:ForestAutoFarm(on)
    if on then
        luckLoop = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = Player.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then return end
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
                                if dist < nearestAnimalDist then nearestAnimalDist = dist nearestAnimal = v end
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
                        if tool then tool:Activate() end
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
                            if dist < nearestTreeDist then nearestTreeDist = dist nearestTree = v end
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
                    if tool then tool:Activate() end
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
        if luckLoop then luckLoop:Disconnect() luckLoop = nil end
    end
end

function Functions:ForestOneHit(on)
    if on then
        pvpLoop = RunService.Heartbeat:Connect(function()
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("Humanoid") and v.Parent ~= Player.Character then v.Health = 0 end
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
    local pos = findCampfire()
    for i = 1, (amount or 1) do
        pcall(function()
            for _, r in ipairs(ReplicatedStorage:GetDescendants()) do
                if r:IsA("RemoteEvent") then r:FireServer(name, pos) end
            end
        end)
    end
end

function Functions:DupeFood(name, amount) Functions:DupeItem(name, amount) end
function Functions:DupeGun(name, amount) Functions:DupeItem(name, amount) end
function Functions:DupeWood(amount) Functions:DupeItem("Wood", amount) end
function Functions:DupeChests(amount) Functions:DupeItem("Chest", amount) end

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

function Functions:FPSBooster(on)
    if on then
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Workspace.Terrain.WaterWaveSize = 0
        Workspace.Terrain.WaterWaveSpeed = 0
    end
end

function Functions:FPSStabilizer(on)
    if on then setfpscap(60) else setfpscap(0) end
end

function Functions:ShowFPS(on)
    if on then
        local fpsGui = Instance.new("ScreenGui") fpsGui.Name = "FPSGui" fpsGui.Parent = game.CoreGui
        local fpsLabel = Instance.new("TextLabel") fpsLabel.Name = "FPS" fpsLabel.Parent = fpsGui
        fpsLabel.Size = UDim2.new(0, 80, 0, 22) fpsLabel.Position = UDim2.new(0, 10, 0, 10)
        fpsLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0) fpsLabel.BackgroundTransparency = 0.5
        fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0) fpsLabel.TextSize = 12 fpsLabel.Text = "FPS: 0"
        RunService.RenderStepped:Connect(function() fpsLabel.Text = "FPS: " .. math.floor(1 / RunService.RenderStepped:Wait()) end)
    else
        local g = game.CoreGui:FindFirstChild("FPSGui") if g then g:Destroy() end
    end
end

function Functions:LowGraphics(on)
    if on then Lighting.Brightness = 1 Lighting.FogEnd = 9e9 Lighting.GlobalShadows = false end
end

function Functions:NoShadows(on) Lighting.GlobalShadows = not on end

function Functions:NoParticles(on)
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") then v.Enabled = not on end
    end
end

return Functions

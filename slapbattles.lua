if not game:IsLoaded() then
    game.Loaded:Wait()
end

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local Window = OrionLib:MakeWindow({
    IntroText = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name,
    IntroIcon = "rbxassetid://15315284749",
    Name = "SilentHub - " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. " | " .. identifyexecutor(),
    IntroToggleIcon = "rbxassetid://7734091286",
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = "sxlent404"
})

local mainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local antiTab = Window:MakeTab({
    Name = "Anti",
    Icon = "rbxassetid://13793170713",
    PremiumOnly = false
})

local badgesTab = Window:MakeTab({
    Name = "Badges",
    Icon = "rbxassetid://16170504068",
    PremiumOnly = false
})

local combatTab = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://124159074947754",
    PremiumOnly = false
})

local FarmReplica = mainTab:AddToggle({
    Name = "Auto Slap Replica",
    Default = false,
    Callback = function(Value)
        ReplicaFarm = Value
        if not game.Players.LocalPlayer.leaderstats.Glove.Value == "Replica" or not game.Players.LocalPlayer.Character.IsInDefaultArena.Value then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "You don't have Replica equipped or you aren't in the island default",
                Image = "rbxassetid:7733658504",
                Time = 5
            })
            ReplicaFarm = false
            FarmReplica:Set(false)
            return
        end
        
        if ReplicaFarm then
            coroutine.wrap(SpamReplica)()
            
            while ReplicaFarm and wait() do
                for i,v in pairs(workspace:GetChildren()) do
                    if v.Name:match(game.Players.LocalPlayer.Name) and v:FindFirstChild("HumanoidRootPart") then
                        game.ReplicatedStorage.b:FireServer(v:WaitForChild("HumanoidRootPart"), true)
                    end
                end
            end
        end
    end
})

local Animations = {
    Floss = nil,
    Groove = nil,
    Headless = nil,
    Helicopter = nil,
    Kick = nil,
    L = nil,
    Laugh = nil,
    Parker = nil,
    Spasm = nil,
    Thriller = nil
}

local currentlyPlaying = nil
local lastPosition = nil
_G.AnimationsEnabled = false

local function LoadAnimations(humanoid)
    if not _G.AnimationsEnabled then return end
    
    Animations.Floss = humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Floss)
    Animations.Groove = humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Groove)
    Animations.Headless = humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Headless)
    Animations.Helicopter = humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Helicopter)
    Animations.Kick = humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Kick)
    Animations.L = humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.L)
    Animations.Laugh = humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Laugh)
    Animations.Parker = humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Parker)
    Animations.Spasm = humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Spasm)
    Animations.Thriller = humanoid:LoadAnimation(game.ReplicatedStorage.AnimationPack.Thriller)
end

local function StopCurrentAnimation()
    if currentlyPlaying then
        currentlyPlaying:Stop()
        currentlyPlaying = nil
        lastPosition = nil
    end
end

mainTab:AddToggle({
    Name = "Free Animations",
    Default = false,
    Callback = function(Value)
        _G.AnimationsEnabled = Value
        if Value then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                LoadAnimations(player.Character.Humanoid)
            end

            local chatConnection
            chatConnection = player.Chatted:connect(function(msg)
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                
                local commands = {
                    ["/e floss"] = Animations.Floss,
                    ["/e groove"] = Animations.Groove,
                    ["/e headless"] = Animations.Headless,
                    ["/e helicopter"] = Animations.Helicopter,
                    ["/e kick"] = Animations.Kick,
                    ["/e l"] = Animations.L,
                    ["/e laugh"] = Animations.Laugh,
                    ["/e parker"] = Animations.Parker,
                    ["/e spasm"] = Animations.Spasm,
                    ["/e thriller"] = Animations.Thriller
                }
                
                local animation = commands[string.lower(msg)]
                if animation then
                    StopCurrentAnimation()
                    animation:Play()
                    currentlyPlaying = animation
                    lastPosition = player.Character.HumanoidRootPart.Position
                end
            end)

            local function onHeartbeat()
                if currentlyPlaying and lastPosition then
                    local character = player.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local currentPosition = character.HumanoidRootPart.Position
                        local distance = (currentPosition - lastPosition).Magnitude
                        if distance > 1 then
                            StopCurrentAnimation()
                        end
                    else
                        StopCurrentAnimation()
                    end
                end
            end
            
            RunService.Heartbeat:Connect(onHeartbeat)
        else
            StopCurrentAnimation()
            for _, animation in pairs(Animations) do
                if animation then
                    animation:Stop()
                end
            end
            table.clear(Animations)
        end
    end    
})

player.CharacterAdded:Connect(function(char)
    if _G.AnimationsEnabled then
        local humanoid = char:WaitForChild("Humanoid")
        LoadAnimations(humanoid)
    end
end)

antiTab:AddToggle({
    Name = "Anti-Void",
    Default = false,
    Callback = function(Value)
        local connection
        
        if Value then
            connection = RunService.Heartbeat:Connect(function()
                if player.Character and 
                   player.Character:FindFirstChild("HumanoidRootPart") and 
                   player.Character.HumanoidRootPart.Position.Y < -25 then
                    player.Character:SetPrimaryPartCFrame(teleportCFrame)
                end
            end)
        else
            if connection then
                connection:Disconnect()
            end
        end
    end    
})

local slapEnabled = false
local slapDistance = 25
local slapCooldown = 0.2

combatTab:AddToggle({
    Name = "Slap Aura",
    Default = false,
    Save = true,
    Flag = "slapAuraToggle", 
    Callback = function(state)
        slapEnabled = state
        while slapEnabled do
            for i,v in pairs(game.Players:GetChildren()) do
                if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and v.Character then
                    if v.Character:FindFirstChild("entered") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("rock") == nil and v.Character.HumanoidRootPart.BrickColor ~= BrickColor.new("New Yeller") and v.Character.Ragdolled.Value == false then
                        if v.Character.Head:FindFirstChild("UnoReverseCard") == nil or game.Players.LocalPlayer.leaderstats.Glove.Value == "Error" then
                            Magnitude = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                            if slapDistance >= Magnitude then
                                shared.gloveHits[game.Players.LocalPlayer.leaderstats.Glove.Value]:FireServer(v.Character:WaitForChild("HumanoidRootPart"),true)
                            end
                        end
                    end
                end
            end
            task.wait(slapCooldown)
        end
    end
})

combatTab:AddSlider({
    Name = "Slap Range",
    Min = 5,
    Max = 50,
    Default = 25,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "studs",
    Save = true,
    Flag = "slapRangeSlider",
    Callback = function(Value)
        slapDistance = Value
    end    
})

combatTab:AddSlider({
    Name = "Slap Cooldown",
    Min = 0.1,
    Max = 2,
    Default = 0.2,
    Color = Color3.fromRGB(255,255,255),
    Increment = 0.1,
    ValueName = "seconds",
    Save = true,
    Flag = "slapCooldownSlider",
    Callback = function(Value)
        slapCooldown = Value
    end    
})

})
badgesTab:AddButton({
    Name = "Get Lamp Glove",
    Default = false,
    Callback = function()
        local player = game.Players.LocalPlayer
        local leaderstats = player:FindFirstChild("leaderstats")
        local gloveValue = leaderstats and leaderstats.Glove
        local slapsValue = leaderstats and leaderstats.Slaps
        local teleport1 = workspace.Lobby.Teleport1
        local zzzGlove = workspace.Lobby.ZZZZZZZ
        local badgeId = 490455814138437
        
        local hasBadge = game:GetService("BadgeService"):UserHasBadgeAsync(player.UserId, badgeId)
        if hasBadge then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "You already have the Lamp Glove badge.",
                Image = "rbxassetid://7733658504",
                Time = 5
            })
            return
        end

        if slapsValue.Value < 70 then
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "You need at least 70 slaps to proceed.",
                Image = "rbxassetid://7733658504",
                Time = 5
            })
            return
        end

        if gloveValue.Value ~= "ZZZZZZZ" then
            local clickDetector = zzzGlove:FindFirstChild("ClickDetector")
            if clickDetector then
                repeat
                    task.wait()
                    fireclickdetector(clickDetector)
                until gloveValue.Value == "ZZZZZZZ"
            else
                warn("ClickDetector not found on ZZZZZZZ glove.")
                return
            end
        end

        if not workspace:FindFirstChild(player.Name) or not workspace[player.Name]:FindFirstChild("regulararena") then
            teleport1.CanCollide = false
            player.Character:SetPrimaryPartCFrame(teleport1.CFrame)
            task.wait(0.5)
            teleport1.CanCollide = true
        end

        repeat
            task.wait()
            game:GetService("ReplicatedStorage").nightmare:FireServer("LightBroken")
        until game:GetService("BadgeService"):UserHasBadgeAsync(player.UserId, badgeId)
        
        OrionLib:MakeNotification({
            Name = "Success",
            Content = "You have obtained the Lamp Glove badge!",
            Image = "rbxassetid://7733658504",
            Time = 5
        })
    end
})

mainTab:AddButton({
    Name = "Get Free Titan Glove",
    Callback = function()
        for i, v in pairs(game:GetService("ReplicatedStorage")._NETWORK:GetChildren()) do
            if v.Name:find("{") then
                local args = {[1] = "Titan"}
                if v:IsA("RemoteEvent") then
                    v:FireServer(unpack(args))
                elseif v:IsA("RemoteFunction") then
                    local result = v:InvokeServer(unpack(args))
                end
            end
        end
    end    
})

mainTab:AddButton({
    Name = "No Cooldown",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local tool = character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
        
        while character.Humanoid.Health ~= 0 do
            local localscript = tool:FindFirstChildOfClass("LocalScript")
            local localscriptclone = localscript:Clone()
            localscriptclone = localscript:Clone()
            localscriptclone:Clone()
            localscript:Destroy()
            localscriptclone.Parent = tool
            wait(0.1)
        end
    end    
})

local localTab = Window:MakeTab({
    Name = "Local",
    Icon = "rbxassetid://9086582404",
    PremiumOnly = false
})

localTab:AddSlider({
    Name = "WalkSpeed",
    Min = 0,
    Max = 500,
    Default = 20,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        _G.WalkSpeedValue = value
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end    
})

localTab:AddToggle({
    Name = "Auto Set WalkSpeed",
    Default = false,
    Callback = function(Value)
        _G.WalkSpeedToggle = Value
        while _G.WalkSpeedToggle do
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue
            end
            task.wait()
        end
    end    
})

localTab:AddSlider({
    Name = "JumpPower",
    Min = 0,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = "Power",
    Callback = function(value)
        _G.JumpPowerValue = value
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end    
})

localTab:AddToggle({
    Name = "Auto Set JumpPower",
    Default = false,
    Callback = function(Value)
        _G.JumpPowerToggle = Value
        while _G.JumpPowerToggle do
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = _G.JumpPowerValue
            end
            task.wait()
        end
    end    
})

localTab:AddButton({
    Name = "Teleport Tool",
    Callback = function()
        local mouse = game.Players.LocalPlayer:GetMouse()
        local tool = Instance.new("Tool")
        tool.Name = "Click Teleport"
        tool.RequiresHandle = false
        
        tool.Activated:Connect(function()
            if mouse.Target then
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                end
            end
        end)
        
        tool.Parent = game.Players.LocalPlayer.Backpack
    end    
})

antiTab:AddToggle({
    Name = "Anti Ragdoll",
    Default = false,
    Callback = function(Value)
        _G.AntiRagdoll = Value
        while _G.AntiRagdoll and task.wait() do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                if workspace[player.Name]:FindFirstChild("Ragdolled") and workspace[player.Name].Ragdolled.Value == true then
                    player.Character.HumanoidRootPart.Anchored = true
                else
                    player.Character.HumanoidRootPart.Anchored = false
                end
            end
        end
    end    
})

mainTab:AddButton({
    Name = "Destroy GUI",
    Callback = function()
        OrionLib:Destroy()
    end
})

OrionLib:Init()

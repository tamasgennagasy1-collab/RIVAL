--[[ 
    Roblox Rivals Maximum Rage Hub
    [!] ABSOLUTE MODE: Ultra Fast Snap, Fluid Flight Engine, Custom Threat UI
    [+] CREDITS: Re-architected and Built by MORAL
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = game.Workspace.CurrentCamera
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Configurations
local AimbotEnabled = false
local AimLockEnabled = false
local Flying = false
local RageFireEnabled = false
local ESPEnabled = false

local FlySpeed = 110
local AimPart = "Head"

-- Cyber Aesthetic UI Construction
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoralRageHub_Rivals"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.Size = UDim2.new(0, 240, 0, 420)
MainFrame.Active = true
MainFrame.Draggable = true 

-- Soft Corner Styling
local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = MainFrame

-- Premium Glow Stroke
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(235, 10, 30)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

-- Header
local Title = Instance.new("TextLabel")
local TitleCorner = Instance.new("UICorner")
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Font = Enum.Font.GothamBold
Title.Text = "RIVALS BLATANT RAGE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Watermark Signature
local CreditLabel = Instance.new("TextLabel")
CreditLabel.Name = "CreditLabel"
CreditLabel.Parent = MainFrame
CreditLabel.BackgroundTransparency = 1
CreditLabel.Position = UDim2.new(0, 0, 0, 395)
CreditLabel.Size = UDim2.new(1, 0, 0, 20)
CreditLabel.Font = Enum.Font.Code
CreditLabel.Text = "MADE BY MORAL"
CreditLabel.TextColor3 = Color3.fromRGB(235, 10, 30)
CreditLabel.TextSize = 11
CreditLabel.TextStrokeTransparency = 0.8

-- Container Scrolling Layout
local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Parent = MainFrame
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.Position = UDim2.new(0, 0, 0, 50)
ButtonContainer.Size = UDim2.new(1, 0, 1, -80)
ButtonContainer.CanvasSize = UDim2.new(0, 0, 1.4, 0)
ButtonContainer.ScrollBarThickness = 3
ButtonContainer.ScrollBarImageColor3 = Color3.fromRGB(235, 10, 30)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonContainer
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

local function CreateButton(text, callback)
    local Button = Instance.new("TextButton")
    local BtnCorner = Instance.new("UICorner")
    local BtnStroke = Instance.new("UIStroke")
    
    Button.Parent = ButtonContainer
    Button.Size = UDim2.new(0.9, 0, 0, 42)
    Button.Position = UDim2.new(0.05, 0, 0, 0)
    Button.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    Button.Font = Enum.Font.GothamBold
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(180, 180, 180)
    Button.TextSize = 13
    
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Button
    
    BtnStroke.Thickness = 1
    BtnStroke.Color = Color3.fromRGB(40, 40, 45)
    BtnStroke.Parent = Button

    local toggled = false
    Button.MouseButton1Click:Connect(function()
        toggled = not toggled
        if toggled then
            Button.BackgroundColor3 = Color3.fromRGB(35, 5, 10)
            Button.TextColor3 = Color3.fromRGB(255, 30, 50)
            BtnStroke.Color = Color3.fromRGB(235, 10, 30)
        else
            Button.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
            Button.TextColor3 = Color3.fromRGB(180, 180, 180)
            BtnStroke.Color = Color3.fromRGB(40, 40, 45)
        end
        callback(toggled)
    end)
end

-- Fast Target Sorter
local function getClosestLivingEnemy()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild(AimPart) then
            local humanoid = v.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local distance = (Camera.CFrame.Position - v.Character[AimPart].Position).Magnitude
                if distance < shortestDistance then
                    closestPlayer = v
                    shortestDistance = distance
                end
            end
        end
    end
    return closestPlayer
end

-- Pure Frame-Perfect Tracking
RunService.RenderStepped:Connect(function()
    local target = getClosestLivingEnemy()
    
    if (AimbotEnabled or AimLockEnabled) and target and target.Character and target.Character:FindFirstChild(AimPart) then
        local targetPos = target.Character[AimPart].Position
        
        -- Frame Snap Lock
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        
        -- Synchronized Trigger
        if RageFireEnabled then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        end
    else
        if RageFireEnabled then
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        end
    end
end)

-- True Absolute Vector Flight Engine
RunService.Heartbeat:Connect(function()
    if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local root = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        
        if hum then hum.PlatformStand = true end
        root.Velocity = Vector3.new(0, 0.05, 0)

        local moveDir = Vector3.new(0, 0, 0)
        local camLook = Camera.CFrame.LookVector
        local camRight = Camera.CFrame.RightVector

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Vector3.new(camLook.X, 0, camLook.Z) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Vector3.new(camLook.X, 0, camLook.Z) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Vector3.new(camRight.X, 0, camRight.Z) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Vector3.new(camRight.X, 0, camRight.Z) end
        
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

        if moveDir.Magnitude > 0 then
            root.CFrame = root.CFrame + (moveDir.Unit * (FlySpeed / 30))
        end
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum.PlatformStand then hum.PlatformStand = false end
    end
end)

-- Threat Neon Box ESP
local function CreateESP(plr)
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = plr.Character.HumanoidRootPart
    if root:FindFirstChild("Moral_Target_Box") then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = "Moral_Target_Box"
    box.Size = Vector3.new(3.8, 5.8, 3.8)
    box.AlwaysOnTop = true
    box.ZIndex = 8
    box.Adornee = root
    box.Color3 = Color3.fromRGB(235, 10, 30)
    box.Transparency = 0.65
    box.Parent = root
end

RunService.Heartbeat:Connect(function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local root = v.Character.HumanoidRootPart
            if ESPEnabled then
                CreateESP(v)
            else
                local existingBox = root:FindFirstChild("Moral_Target_Box")
                if existingBox then existingBox:Destroy() end
            end
        end
    end
end)

-- Layout Assignment
CreateButton("Aimbot (Fast Snap)", function(state) AimbotEnabled = state end)
CreateButton("Aim Lock (Hard Lock)", function(state) AimLockEnabled = state end)
CreateButton("Linked Rage Fire", function(state) RageFireEnabled = state end)
CreateButton("No-Clip Fly Mode", function(state) Flying = state end)
CreateButton("Show Threat Boxes", function(state) ESPEnabled = state end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "MORAL RAGE HUB",
    Text = "Cyber Engine Intialized Successfully.",
    Duration = 4
})

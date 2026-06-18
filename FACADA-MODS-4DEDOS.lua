local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local VirtualInput = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local gui = Instance.new("ScreenGui")
gui.Name = "HMZH_HUB_V1"
gui.ResetOnSpawn = false
gui.Parent = (gethui and gethui()) or CoreGui or player:WaitForChild("PlayerGui")
local LOGO_ID = "rbxassetid://99354291916164"
local AimbotSettings = {
Enabled = false,
FovSize = 120,
WallCheck = false,
Smoothness = 50,
Prediction = false,
Distance = 80000,
TeamCheck = false,
ShowFov = true,
BodyPart = "Head",
}
local EspSettings = {
Box = false,
Name = false,
Health = false,
Line = false,
Distance = false,
Skeleton = false,
TeamCheck = false,
WallCheck = false,
}
local OtherSettings = {
FakeLag = false,
FakeDash = false,
WalkSpeed = 16,
JumpPower = 50,
FpsBoost = false,
FreezePlayers = false,
HeadHitboxExpander = false,
HeadHitboxSize = 5,
HeadHitboxTransparency = 0.8,
Spinbot = false,
SpinbotSpeed = 10,
Triggerbot = false,
ShowFps = false,
Float = false,
StreamMode = false,
}
local floatPart = nil
local floatLoop = nil
local jumpConnection = nil
local canJump = true
-- =============================================
-- CONTADOR DE FUNÇÕES ATIVAS
-- =============================================
local function countActiveFunctions()
local count = 0
for k, v in pairs(AimbotSettings) do if type(v) == "boolean" and v and k ~= "ShowFov" then count = count + 1 end end
for k, v in pairs(EspSettings) do if type(v) == "boolean" and v then count = count + 1 end end
for k, v in pairs(OtherSettings) do if type(v) == "boolean" and v and k ~= "ShowFps" then count = count + 1 end end
if streamModeActive then count = count + 1 end
return count
end
-- =============================================
-- STREAM MODE
-- =============================================
local streamModeActive = false
local streamUIElements = {}
local function collectUIElements()
streamUIElements = {}
if bubble then table.insert(streamUIElements, bubble) end
if main then table.insert(streamUIElements, main) end
if fpsFrame then table.insert(streamUIElements, fpsFrame) end
for _, v in pairs(gui:GetChildren()) do
if v ~= bubble and v ~= main and v ~= fpsFrame then
table.insert(streamUIElements, v)
end
end
end
local function toggleStreamUI()
streamModeActive = not streamModeActive
collectUIElements()
if streamModeActive then
for _, element in pairs(streamUIElements) do
if element and element.Parent then
element.Visible = false
end
end
if fovCircle then fovCircle.Visible = false end
if main then main.Visible = false end
bubbleStroke.Color = Color3.fromRGB(0, 255, 0)
else
for _, element in pairs(streamUIElements) do
if element and element.Parent then
element.Visible = true
end
end
if fovCircle and AimbotSettings.ShowFov then fovCircle.Visible = true end
if fpsFrame and OtherSettings.ShowFps then fpsFrame.Visible = true end
bubbleStroke.Color = Color3.fromRGB(255, 255, 255)
end
if streamIndicator then
if streamModeActive then
streamIndicator.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
streamIndicator.Text = "🔴 STREAM MODE: ATIVADO"
else
streamIndicator.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
streamIndicator.Text = "🟢 STREAM MODE: DESATIVADO"
end
end
end
local touchCount = 0
local lastTouchTime = 0
UIS.TouchStarted:Connect(function(touch)
local t = tick()
if t - lastTouchTime > 0.5 then touchCount = 0 end
touchCount = touchCount + 1
lastTouchTime = t
if touchCount >= 4 then
toggleStreamUI()
touchCount = 0
end
task.delay(0.5, function()
if t == lastTouchTime then touchCount = 0 end
end)
end)
UIS.TouchEnded:Connect(function()
if touchCount > 0 then touchCount = touchCount - 1 end
end)
UIS.InputBegan:Connect(function(input, gp)
if gp then return end
if input.KeyCode == Enum.KeyCode.F6 or input.KeyCode == Enum.KeyCode.End then
toggleStreamUI()
end
if input.KeyCode == Enum.KeyCode.F6 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
toggleStreamUI()
end
end)
-- =============================================
-- FPS OVERLAY
-- =============================================
local fpsFrame = Instance.new("Frame", gui)
fpsFrame.Name = "HMZH_FPS_Overlay"
fpsFrame.Size = UDim2.new(0, 320, 0, 32)
fpsFrame.Position = UDim2.new(0, 10, 0, 55)
fpsFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
fpsFrame.BackgroundTransparency = 0.15
fpsFrame.BorderSizePixel = 0
fpsFrame.Active = true
fpsFrame.Draggable = true
fpsFrame.Visible = false
Instance.new("UICorner", fpsFrame).CornerRadius = UDim.new(0, 8)
local fpsStroke = Instance.new("UIStroke", fpsFrame)
fpsStroke.Color = Color3.fromRGB(255, 255, 255)
fpsStroke.Transparency = 0.6
fpsStroke.Thickness = 1
local fpsIcon = Instance.new("ImageLabel", fpsFrame)
fpsIcon.BackgroundTransparency = 1
fpsIcon.Position = UDim2.new(0, 6, 0.15, 0)
fpsIcon.Size = UDim2.new(0, 22, 0, 22)
fpsIcon.Image = LOGO_ID
fpsIcon.ScaleType = Enum.ScaleType.Fit
local fpsTitle = Instance.new("TextLabel", fpsFrame)
fpsTitle.BackgroundTransparency = 1
fpsTitle.Position = UDim2.new(0, 32, 0, 0)
fpsTitle.Size = UDim2.new(0, 70, 1, 0)
fpsTitle.Font = Enum.Font.GothamBlack
fpsTitle.Text = "HMZH"
fpsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsTitle.TextSize = 11
fpsTitle.TextXAlignment = Enum.TextXAlignment.Left
local fpsDiv = Instance.new("Frame", fpsFrame)
fpsDiv.Position = UDim2.new(0, 85, 0.12, 0)
fpsDiv.Size = UDim2.new(0, 1, 0.76, 0)
fpsDiv.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
fpsDiv.BorderSizePixel = 0
fpsDiv.BackgroundTransparency = 0.5
local fpsInfo = Instance.new("TextLabel", fpsFrame)
fpsInfo.BackgroundTransparency = 1
fpsInfo.Position = UDim2.new(0, 95, 0, 0)
fpsInfo.Size = UDim2.new(1, -100, 1, 0)
fpsInfo.Font = Enum.Font.GothamBold
fpsInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsInfo.TextSize = 11
fpsInfo.TextXAlignment = Enum.TextXAlignment.Left
fpsInfo.Text = "FPS 0 | MS 0 | Ativos: 0 | 00:00:00"
local fpsCount = 0
local fpsLastTick = tick()
local fpsCurrent = 0
local fpsStart = tick()
RunService.RenderStepped:Connect(function()
fpsCount = fpsCount + 1
if tick() - fpsLastTick >= 1 then
fpsCurrent = fpsCount
fpsCount = 0
fpsLastTick = tick()
end
if fpsFrame and fpsFrame.Visible then
local ping = 0
pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
local elapsed = math.floor(tick() - fpsStart)
local hrs = math.floor(elapsed / 3600)
local mins = math.floor((elapsed % 3600) / 60)
local secs = elapsed % 60
local ativos = countActiveFunctions()
fpsInfo.Text = string.format("FPS %d | MS %d | Ativos: %d | %02d:%02d:%02d", fpsCurrent, ping, ativos, hrs, mins, secs)
if fpsCurrent >= 50 then
fpsInfo.TextColor3 = Color3.fromRGB(0, 255, 120)
elseif fpsCurrent >= 30 then
fpsInfo.TextColor3 = Color3.fromRGB(255, 200, 0)
else
fpsInfo.TextColor3 = Color3.fromRGB(255, 80, 80)
end
end
end)
-- =============================================
-- MARCADOS / TEAMCHECK / WALLCHECK
-- =============================================
local MarkedPlayers = {}
local function isMarked(target)
return MarkedPlayers[target] == true
end
local function isSameTeam(p1, p2)
if p1.TeamColor and p2.TeamColor and p1.TeamColor == p2.TeamColor then return true end
if p1.Team and p2.Team and p1.Team == p2.Team then return true end
local s1, t1 = pcall(function() return p1:GetAttribute("Team") or p1:GetAttribute("team") end)
local s2, t2 = pcall(function() return p2:GetAttribute("Team") or p2:GetAttribute("team") end)
if s1 and s2 and t1 and t2 and t1 == t2 then return true end
return false
end
local function isEnemy(target)
if isMarked(target) then return false end
if AimbotSettings.TeamCheck then return not isSameTeam(player, target) end
return true
end
local function isTargetVisible(pos)
if not player.Character then return false end
local origin = camera.CFrame.Position
local dir = (pos - origin).Unit
local dist = (pos - origin).Magnitude
local params = RaycastParams.new()
params.FilterType = Enum.RaycastFilterType.Blacklist
params.FilterDescendantsInstances = {player.Character, camera}
local result = Workspace:Raycast(origin, dir * dist, params)
if result then
local hitChar = result.Instance and result.Instance:FindFirstAncestorOfClass("Model")
for _, p in pairs(Players:GetPlayers()) do
if p.Character == hitChar then return true end
end
return false
end
return true
end
local function freezeAll(freeze)
for _, p in pairs(Players:GetPlayers()) do
if p ~= player and p.Character and isEnemy(p) then
local root = p.Character:FindFirstChild("HumanoidRootPart")
local hum = p.Character:FindFirstChild("Humanoid")
if root and hum and hum.Health > 0 then root.Anchored = freeze end
end
end
end
-- =============================================
-- HITBOX RESTAURAR
-- =============================================
local function restoreHitbox()
for _, p in pairs(Players:GetPlayers()) do
if p ~= player and p.Character then
local head = p.Character:FindFirstChild("Head")
if head then
head.Size = Vector3.new(2, 1, 1)
head.Transparency = 0
head.CanCollide = false
head.Massless = false
pcall(function() head.Shape = Enum.PartType.Block end)
end
end
end
end
-- =============================================
-- SISTEMA FLOAT (SISTEMA DE VÔO POR PLATAFORMA)
-- =============================================
local function toggleFloat(state)
OtherSettings.Float = state
if floatLoop then floatLoop:Disconnect(); floatLoop = nil end
if jumpConnection then jumpConnection:Disconnect(); jumpConnection = nil end
if floatPart then pcall(function() floatPart:Destroy() end); floatPart = nil end
if state and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
local root = player.Character.HumanoidRootPart
floatPart = Instance.new("Part")
floatPart.Name = "HMZH_FloatPlatform"
floatPart.Size = Vector3.new(6.5, 1, 6.5)
floatPart.Transparency = 1
floatPart.Anchored = true
floatPart.CanCollide = true
floatPart.CastShadow = false
floatPart.Parent = Workspace
floatPart.Position = root.Position - Vector3.new(0, 3.5, 0)
floatLoop = RunService.Heartbeat:Connect(function()
if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and floatPart then
local currentRoot = player.Character.HumanoidRootPart
floatPart.CFrame = CFrame.new(currentRoot.Position.X, floatPart.Position.Y, currentRoot.Position.Z)
end
end)
jumpConnection = UIS.JumpRequest:Connect(function()
if floatPart and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and canJump then
local currentRoot = player.Character.HumanoidRootPart
local hum = player.Character:FindFirstChildOfClass("Humanoid")
if hum and hum.Health > 0 then
canJump = false
floatPart.Position = floatPart.Position + Vector3.new(0, 5, 0)
currentRoot.CFrame = currentRoot.CFrame + Vector3.new(0, 5, 0)
task.wait(0.2)
canJump = true
end
end
end)
end
end
-- =============================================
-- BOLHA DO MENU
-- =============================================
local bubble = Instance.new("TextButton")
bubble.Parent = gui
bubble.Size = UDim2.new(0, 58, 0, 58)
bubble.Position = UDim2.new(0.1, 0, 0.5, 0)
bubble.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bubble.AutoButtonColor = false
bubble.Text = ""
bubble.BorderSizePixel = 0
Instance.new("UICorner", bubble).CornerRadius = UDim.new(0, 12)
local bubbleStroke = Instance.new("UIStroke", bubble)
bubbleStroke.Color = Color3.fromRGB(255, 255, 255)
bubbleStroke.Thickness = 2.5
local bubbleLogo = Instance.new("ImageLabel", bubble)
bubbleLogo.BackgroundTransparency = 1
bubbleLogo.AnchorPoint = Vector2.new(0.5, 0.5)
bubbleLogo.Position = UDim2.new(0.5, 0, 0.5, 0)
bubbleLogo.Size = UDim2.new(0.84, 0, 0.84, 0)
bubbleLogo.Image = LOGO_ID
bubbleLogo.ScaleType = Enum.ScaleType.Fit
local bubbleDrag = false
local bubbleDragStart, bubbleStartPos
bubble.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
bubbleDrag = true
bubbleDragStart = input.Position
bubbleStartPos = bubble.Position
end
end)
UIS.InputChanged:Connect(function(input)
if bubbleDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - bubbleDragStart
bubble.Position = UDim2.new(bubbleStartPos.X.Scale, bubbleStartPos.X.Offset + delta.X, bubbleStartPos.Y.Scale, bubbleStartPos.Y.Offset + delta.Y)
end
end)
UIS.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
bubbleDrag = false
end
end)
-- =============================================
-- MENU PRINCIPAL
-- =============================================
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 580, 0, 450)
main.Position = UDim2.new(0.5, -290, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 0
main.Visible = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 1.2
bubble.MouseButton1Click:Connect(function()
if not streamModeActive then
main.Visible = not main.Visible
end
end)
local top = Instance.new("Frame", main)
top.Size = UDim2.new(1, 0, 0, 45)
top.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
top.BorderSizePixel = 0
Instance.new("UICorner", top).CornerRadius = UDim.new(0, 12)
local logo = Instance.new("ImageLabel", top)
logo.BackgroundTransparency = 1
logo.Size = UDim2.new(0, 30, 0, 30)
logo.Position = UDim2.new(0, 10, 0, 7)
logo.Image = LOGO_ID
logo.ScaleType = Enum.ScaleType.Fit
local title = Instance.new("TextLabel", top)
title.BackgroundTransparency = 1
title.Position = UDim2.new(0, 48, 0, 0)
title.Size = UDim2.new(0, 300, 1, 0)
title.Text = "FACADA MODS"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 17
title.TextXAlignment = Enum.TextXAlignment.Left
panelDrag = false
local panelDragStart, panelStartPos
top.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
panelDrag = true
panelDragStart = input.Position
panelStartPos = main.Position
end
end)
UIS.InputChanged:Connect(function(input)
if panelDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
local delta = input.Position - panelDragStart
main.Position = UDim2.new(panelStartPos.X.Scale, panelStartPos.X.Offset + delta.X, panelStartPos.Y.Scale, panelStartPos.Y.Offset + delta.Y)
end
end)
UIS.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
panelDrag = false
end
end)
local function createTopButton(text, pos, color)
local b = Instance.new("TextButton", top)
b.Size = UDim2.new(0, 28, 0, 28)
b.Position = pos
b.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
b.AutoButtonColor = false
b.Text = text
b.TextColor3 = color or Color3.new(1, 1, 1)
b.Font = Enum.Font.GothamBold
b.TextSize = 14
b.BorderSizePixel = 0
Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
return b
end
local minimizeBtn = createTopButton("—", UDim2.new(1, -102, 0, 8))
local maximizeBtn = createTopButton("□", UDim2.new(1, -68, 0, 8))
local closeBtn = createTopButton("X", UDim2.new(1, -34, 0, 8), Color3.fromRGB(255, 90, 90))
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 145, 1, -45)
sidebar.Position = UDim2.new(0, 0, 0, 45)
sidebar.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
sidebar.BorderSizePixel = 0
local holder = Instance.new("ScrollingFrame", main)
holder.BackgroundTransparency = 1
holder.Size = UDim2.new(1, -145, 1, -45)
holder.Position = UDim2.new(0, 145, 0, 45)
holder.CanvasSize = UDim2.new(0, 0, 0, 2000)
holder.ScrollBarThickness = 4
holder.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
holder.BorderSizePixel = 0
local tabs = {
{name = "🎯 Aimbot", desc = "Mira automática"},
{name = "👁️ ESP", desc = "Ver inimigos"},
{name = "⚙️ Outros", desc = "Extras e utilidades"},
{name = "🛡️ TANQUE", desc = "Coords, Float, Stream"},
{name = "🚩 Marca", desc = "Marcar amigos"},
{name = "📜 Creditos", desc = "Informacoes"},
}
local pages = {}
for i, td in ipairs(tabs) do
local tab = Instance.new("TextButton", sidebar)
tab.Size = UDim2.new(1, -10, 0, 52)
tab.Position = UDim2.new(0, 5, 0, 10 + ((i - 1) * 60))
tab.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
tab.AutoButtonColor = false
tab.Text = ""
tab.BorderSizePixel = 0
Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 8)
local tl = Instance.new("TextLabel", tab)
tl.BackgroundTransparency = 1
tl.Size = UDim2.new(1, -6, 0, 28)
tl.Position = UDim2.new(0, 6, 0, 2)
tl.Text = td.name
tl.TextColor3 = Color3.fromRGB(255, 255, 255)
tl.Font = Enum.Font.GothamMedium
tl.TextSize = 13
tl.TextXAlignment = Enum.TextXAlignment.Left
local tdl = Instance.new("TextLabel", tab)
tdl.BackgroundTransparency = 1
tdl.Size = UDim2.new(1, -6, 0, 18)
tdl.Position = UDim2.new(0, 6, 0, 28)
tdl.Text = td.desc
tdl.TextColor3 = Color3.fromRGB(200, 200, 200)
tdl.Font = Enum.Font.Gotham
tdl.TextSize = 11
tdl.TextXAlignment = Enum.TextXAlignment.Left
local page = Instance.new("Frame", holder)
page.Size = UDim2.new(1, -10, 0, 1700)
page.BackgroundTransparency = 1
page.Visible = (i == 1)
pages[td.name] = page
tab.MouseButton1Click:Connect(function()
for _, p in pairs(pages) do p.Visible = false end
page.Visible = true
for _, t in pairs(sidebar:GetChildren()) do
if t:IsA("TextButton") then t.BackgroundColor3 = Color3.fromRGB(18, 20, 28) end
end
tab.BackgroundColor3 = Color3.fromRGB(28, 35, 55)
end)
end
-- =============================================
-- UI HELPERS
-- =============================================
local function createToggle(parent, text, y, callback)
local frame = Instance.new("Frame", parent)
frame.Size = UDim2.new(1, -30, 0, 45)
frame.Position = UDim2.new(0, 15, 0, y)
frame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
local label = Instance.new("TextLabel", frame)
label.BackgroundTransparency = 1
label.Position = UDim2.new(0, 10, 0, 0)
label.Size = UDim2.new(0.7, 0, 1, 0)
label.Text = text
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Left
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0, 58, 0, 26)
toggle.Position = UDim2.new(1, -70, 0.5, -13)
toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
toggle.AutoButtonColor = false
toggle.Text = ""
Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
local circle = Instance.new("Frame", toggle)
circle.Size = UDim2.new(0, 22, 0, 22)
circle.Position = UDim2.new(0, 2, 0.5, -11)
circle.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
local enabled = false
toggle.MouseButton1Click:Connect(function()
enabled = not enabled
if enabled then
toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
circle:TweenPosition(UDim2.new(1, -24, 0.5, -11), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
circle.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
else
toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
circle:TweenPosition(UDim2.new(0, 2, 0.5, -11), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
circle.BackgroundColor3 = Color3.new(1, 1, 1)
if text == "❄️ Congelar Jogadores" then freezeAll(false) end
if text == "🧠 Hitbox Expander (Cabeça)" then OtherSettings.HeadHitboxExpander = false; restoreHitbox() end
if text == "🚀 Ativar Sistema Float (Voar)" then OtherSettings.Float = false; toggleFloat(false) end
if text == "🔄 Spinbot" and player.Character then
local hum = player.Character:FindFirstChild("Humanoid")
if hum then hum.AutoRotate = true end
end
end
if callback then callback(enabled) end
end)
end
local function createSlider(parent, text, y, min, max, default, callback, isFloat)
local frame = Instance.new("Frame", parent)
frame.Size = UDim2.new(1, -30, 0, 60)
frame.Position = UDim2.new(0, 15, 0, y)
frame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
frame.BackgroundTransparency = 0.2
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
local value = default
local label = Instance.new("TextLabel", frame)
label.BackgroundTransparency = 1
label.Position = UDim2.new(0, 10, 0, 4)
label.Size = UDim2.new(1, -20, 0, 20)
label.Text = text .. " : " .. tostring(value)
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Left
local bar = Instance.new("Frame", frame)
bar.Size = UDim2.new(1, -40, 0, 6)
bar.Position = UDim2.new(0, 20, 0, 38)
bar.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
local percent = (default - min) / (max - min)
local fill = Instance.new("Frame", bar)
fill.Size = UDim2.new(percent, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
local knob = Instance.new("Frame", bar)
knob.Size = UDim2.new(0, 16, 0, 16)
knob.AnchorPoint = Vector2.new(0.5, 0.5)
knob.Position = UDim2.new(percent, 0, 0.5, 0)
knob.BackgroundColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
local dragging = false
local function updateSlider(input)
local sx = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
fill.Size = UDim2.new(sx, 0, 1, 0)
knob.Position = UDim2.new(sx, 0, 0.5, 0)
value = isFloat and math.floor((min + ((max - min) * sx)) * 100) / 100 or math.floor(min + ((max - min) * sx))
label.Text = text .. " : " .. tostring(value)
if callback then callback(value) end
end
bar.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = true
updateSlider(input)
end
end)
UIS.InputChanged:Connect(function(input)
if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
updateSlider(input)
end
end)
UIS.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
dragging = false
end
end)
local function setVal(newVal)
value = newVal
local sx = math.clamp((newVal - min) / (max - min), 0, 1)
fill.Size = UDim2.new(sx, 0, 1, 0)
knob.Position = UDim2.new(sx, 0, 0.5, 0)
label.Text = text .. " : " .. tostring(value)
if callback then callback(value) end
end
return setVal
end
local function createDropdown(parent, text, y, options, default, callback)
local frame = Instance.new("Frame", parent)
frame.Size = UDim2.new(1, -30, 0, 60)
frame.Position = UDim2.new(0, 15, 0, y)
frame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
frame.BackgroundTransparency = 0.2
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
local label = Instance.new("TextLabel", frame)
label.BackgroundTransparency = 1
label.Position = UDim2.new(0, 10, 0, 4)
label.Size = UDim2.new(1, -20, 0, 20)
label.Text = text .. " : " .. default
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.TextXAlignment = Enum.TextXAlignment.Left
local btn = Instance.new("TextButton", frame)
btn.Size = UDim2.new(1, -20, 0, 28)
btn.Position = UDim2.new(0, 10, 0, 28)
btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
btn.AutoButtonColor = false
btn.Text = default
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 13
btn.BorderSizePixel = 0
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
local open = false
btn.MouseButton1Click:Connect(function()
open = not open
if open then
for _, opt in pairs(options) do
local ob = Instance.new("TextButton", frame)
ob.Size = UDim2.new(1, -20, 0, 26)
ob.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
ob.AutoButtonColor = false
ob.Text = opt
ob.TextColor3 = Color3.new(1, 1, 1)
ob.Font = Enum.Font.Gotham
ob.TextSize = 12
ob.BorderSizePixel = 0
Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 4)
local idx = table.find(options, opt)
if idx then ob.Position = UDim2.new(0, 10, 0, 28 + (idx * 28)) end
ob.MouseButton1Click:Connect(function()
btn.Text = opt
label.Text = text .. " : " .. opt
if callback then callback(opt) end
for _, c in pairs(frame:GetChildren()) do
if c:IsA("TextButton") and c ~= btn then c:Destroy() end
end
open = false
end)
end
else
for _, c in pairs(frame:GetChildren()) do
if c:IsA("TextButton") and c ~= btn then c:Destroy() end
end
end
end)
end
local function createButton(parent, text, y, callback)
local btn = Instance.new("TextButton", parent)
btn.Size = UDim2.new(1, -30, 0, 40)
btn.Position = UDim2.new(0, 15, 0, y)
btn.BackgroundColor3 = Color3.fromRGB(35, 40, 50)
btn.AutoButtonColor = true
btn.Text = text
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.BorderSizePixel = 0
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
btn.MouseButton1Click:Connect(callback)
return btn
end
-- =============================================
-- FOV CIRCLE
-- =============================================
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1.5
fovCircle.NumSides = 100
fovCircle.Radius = 120
fovCircle.Filled = false
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Visible = false
-- =============================================
-- ESP
-- =============================================
local espCache = {}
local function createDrawing(c, p)
local d = Drawing.new(c)
for i, v in pairs(p) do d[i] = v end
return d
end
local function createSkel()
local l = {}
for i = 1, 15 do table.insert(l, createDrawing("Line", {Thickness = 1, Color = Color3.fromRGB(255, 255, 255), Visible = false})) end
return l
end
local function addEsp(p)
if p == player or espCache[p] then return end
espCache[p] = {
Box = createDrawing("Square", {Thickness = 1, Color = Color3.fromRGB(255, 255, 255), Filled = false, Visible = false}),
HealthBarBg = createDrawing("Line", {Thickness = 3, Color = Color3.fromRGB(0, 0, 0), Visible = false}),
HealthBar = createDrawing("Line", {Thickness = 1.5, Color = Color3.fromRGB(0, 255, 0), Visible = false}),
Tracer = createDrawing("Line", {Thickness = 1, Color = Color3.fromRGB(255, 255, 255), Visible = false}),
Name = createDrawing("Text", {Size = 14, Center = true, Color = Color3.fromRGB(255, 255, 255), Visible = false, Outline = true}),
Dist = createDrawing("Text", {Size = 12, Center = true, Color = Color3.fromRGB(200, 200, 200), Visible = false, Outline = true}),
SkeletonLines = createSkel()
}
end
local function removeEsp(p)
if espCache[p] then
for _, v in pairs(espCache[p]) do
if type(v) == "table" then for _, l in pairs(v) do pcall(function() l:Remove() end) end
else pcall(function() v:Remove() end) end
end
espCache[p] = nil
end
end
for _, p in pairs(Players:GetPlayers()) do addEsp(p) end
Players.PlayerAdded:Connect(function(p) addEsp(p)
p.CharacterAdded:Connect(function(char)
if not espCache[p] then addEsp(p) end
local hum = char:WaitForChild("Humanoid")
hum.Died:Connect(function()
if espCache[p] then
for _, v in pairs(espCache[p]) do
if type(v) == "table" then for _, l in pairs(v) do l.Visible = false end
else v.Visible = false end
end
end
end)
end)
end)
Players.PlayerRemoving:Connect(function(p) removeEsp(p) end)
-- =============================================
-- FUNÇÕES DE TARGET
-- =============================================
local function getTargetPart(char)
if not char then return nil end
local choice = AimbotSettings.BodyPart
if choice == "Head" then return char:FindFirstChild("Head") end
if choice == "Torso" then return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart") end
if choice == "Random" then
local parts = {"Head", "UpperTorso", "LowerTorso", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm", "LeftUpperLeg", "RightUpperLeg"}
local valid = {}
for _, n in pairs(parts) do
local p = char:FindFirstChild(n)
if p then table.insert(valid, p) end
end
if #valid > 0 then return valid[math.random(1, #valid)] end
return char:FindFirstChild("Head")
end
return char:FindFirstChild("Head")
end
local function getClosestTarget()
local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
local possibleTargets = {}
for _, p in pairs(Players:GetPlayers()) do
if p == player or not p.Character or isMarked(p) then continue end
if AimbotSettings.TeamCheck and isSameTeam(player, p) then continue end
local hum = p.Character:FindFirstChild("Humanoid")
if not hum or hum.Health <= 0 then continue end
local part = getTargetPart(p.Character)
if not part then continue end
local dist3D = (part.Position - camera.CFrame.Position).Magnitude
if dist3D > AimbotSettings.Distance then continue end
local sp, vis = camera:WorldToViewportPoint(part.Position)
if not vis then continue end
local dist2D = (Vector2.new(sp.X, sp.Y) - center).Magnitude
if dist2D <= AimbotSettings.FovSize then
table.insert(possibleTargets, {part = part, dist2D = dist2D, char = p.Character, dist3D = dist3D})
end
end
table.sort(possibleTargets, function(a, b) return a.dist2D < b.dist2D end)
for _, target in ipairs(possibleTargets) do
if AimbotSettings.WallCheck then
local rp = RaycastParams.new()
rp.FilterType = Enum.RaycastFilterType.Blacklist
local filter = {camera, target.char}
if player.Character then table.insert(filter, player.Character) end
rp.FilterDescendantsInstances = filter
local ray = Workspace:Raycast(camera.CFrame.Position, (target.part.Position - camera.CFrame.Position).Unit * target.dist3D, rp)
if not ray then return target.part end
else
return target.part
end
end
return nil
end
-- =============================================
-- LOOP PRINCIPAL (RENDERSTEPED)
-- =============================================
local spinAngle = 0
local coordsLabel = nil
RunService.RenderStepped:Connect(function()
local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
-- ATUALIZAÇÃO DO PAINEL DE COORDENADAS INTERNO
if coordsLabel and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
local pos = player.Character.HumanoidRootPart.Position
coordsLabel.Text = string.format("X: %d | Y: %d | Z: %d", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
end
-- SPINBOT - SÓ RODA O PERSONAGEM, NÃO MEXE NA CÂMERA
if OtherSettings.Spinbot and player.Character then
local root = player.Character:FindFirstChild("HumanoidRootPart")
local hum = player.Character:FindFirstChild("Humanoid")
if root and hum and hum.Health > 0 then
spinAngle = spinAngle + (OtherSettings.SpinbotSpeed * 0.02)
root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, spinAngle, 0)
hum.AutoRotate = false
end
end
-- HITBOX EXPANDER (CABEÇA - FORMATO BOLA)
if OtherSettings.HeadHitboxExpander then
for _, p in pairs(Players:GetPlayers()) do
if p == player or not p.Character or isMarked(p) then continue end
if EspSettings.TeamCheck and isSameTeam(player, p) then continue end
local hum = p.Character:FindFirstChild("Humanoid")
if not hum or hum.Health <= 0 then continue end
local head = p.Character:FindFirstChild("Head")
if head then
head.Size = Vector3.new(OtherSettings.HeadHitboxSize, OtherSettings.HeadHitboxSize, OtherSettings.HeadHitboxSize)
head.Transparency = OtherSettings.HeadHitboxTransparency
head.CanCollide = false
head.Massless = true
pcall(function() head.Shape = Enum.PartType.Ball end)
end
end
end
-- FREEZE PLAYERS
if OtherSettings.FreezePlayers then
for _, p in pairs(Players:GetPlayers()) do
if p ~= player and p.Character and not isMarked(p) then
local root = p.Character:FindFirstChild("HumanoidRootPart")
local hum = p.Character:FindFirstChild("Humanoid")
if root and hum and hum.Health > 0 then
if EspSettings.TeamCheck and isSameTeam(player, p) then continue end
root.Anchored = true
end
end
end
end
-- FOV CIRCLE
if not streamModeActive then
fovCircle.Position = center
fovCircle.Radius = AimbotSettings.FovSize
fovCircle.Visible = AimbotSettings.ShowFov
else
fovCircle.Visible = false
end
-- AIMBOT
if AimbotSettings.Enabled then
pcall(function()
local target = getClosestTarget()
if target then
local camCFrame = camera.CFrame
local tp = target.Position
local dist = (tp - camCFrame.Position).Magnitude
if AimbotSettings.Prediction then
local vel = target.AssemblyLinearVelocity
if vel then tp = tp + (vel * (dist / 800)) end
end
if dist > 0.1 then
local ncf = CFrame.new(camCFrame.Position, tp)
local s = AimbotSettings.Smoothness / 100
local alpha = math.clamp(1 - s, 0.01, 1)
camera.CFrame = s <= 0 and ncf or camCFrame:Lerp(ncf, alpha)
end
end
end)
end
-- ESP RENDER
for plr, esp in pairs(espCache) do
pcall(function()
local char = plr.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
local head = char and char:FindFirstChild("Head")
local hum = char and char:FindFirstChild("Humanoid")
local alive = char and root and head and hum and hum.Health > 0
local render = alive and not isMarked(plr)
if render and EspSettings.TeamCheck then render = not isSameTeam(player, plr) end
if render then
local pR, on = camera:WorldToViewportPoint(root.Position)
local pT = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
local pB = camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
if on then
local h = math.abs(pT.Y - pB.Y)
local w = h * 0.6
local bp = Vector2.new(pR.X - w / 2, pT.Y)
if EspSettings.Box then
esp.Box.Size = Vector2.new(w, h)
esp.Box.Position = bp
esp.Box.Color = EspSettings.WallCheck and (isTargetVisible(head.Position) and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)) or Color3.fromRGB(255,255,255)
esp.Box.Visible = true
else esp.Box.Visible = false end
if EspSettings.Health then
local hp = hum.Health / hum.MaxHealth
esp.HealthBarBg.From = Vector2.new(bp.X - 5, bp.Y); esp.HealthBarBg.To = Vector2.new(bp.X - 5, bp.Y + h); esp.HealthBarBg.Visible = true
esp.HealthBar.From = Vector2.new(bp.X - 5, bp.Y + h); esp.HealthBar.To = Vector2.new(bp.X - 5, bp.Y + h - (h * hp))
esp.HealthBar.Color = Color3.fromRGB(255 - (hp * 255), 255 * hp, 0); esp.HealthBar.Visible = true
else esp.HealthBarBg.Visible = false; esp.HealthBar.Visible = false end
if EspSettings.Name then esp.Name.Position = Vector2.new(pR.X, pT.Y - 16); esp.Name.Text = plr.Name; esp.Name.Visible = true else esp.Name.Visible = false end
if EspSettings.Distance then
local dist = math.floor((root.Position - camera.CFrame.Position).Magnitude)
esp.Dist.Position = Vector2.new(pR.X, pB.Y + 2); esp.Dist.Text = dist .. "m"; esp.Dist.Visible = true
else esp.Dist.Visible = false end
if EspSettings.Line then esp.Tracer.From = Vector2.new(camera.ViewportSize.X / 2, 0); esp.Tracer.To = Vector2.new(pR.X, pT.Y); esp.Tracer.Visible = true else esp.Tracer.Visible = false end
if EspSettings.Skeleton then
local joints = char:FindFirstChild("UpperTorso") and {
{"Head","UpperTorso"},{"UpperTorso","LowerTorso"},{"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
{"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
{"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
{"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"}
} or {{"Head","Torso"},{"Torso","Left Arm"},{"Torso","Right Arm"},{"Torso","Left Leg"},{"Torso","Right Leg"}}
for i = 1, 15 do
if joints[i] then
local p1 = char:FindFirstChild(joints[i][1]); local p2 = char:FindFirstChild(joints[i][2])
if p1 and p2 then
local pos1, s1 = camera:WorldToViewportPoint(p1.Position); local pos2, s2 = camera:WorldToViewportPoint(p2.Position)
if s1 and s2 then esp.SkeletonLines[i].From = Vector2.new(pos1.X, pos1.Y); esp.SkeletonLines[i].To = Vector2.new(pos2.X, pos2.Y); esp.SkeletonLines[i].Visible = true
else esp.SkeletonLines[i].Visible = false end
else esp.SkeletonLines[i].Visible = false end
else esp.SkeletonLines[i].Visible = false end
end
else for _, l in pairs(esp.SkeletonLines) do l.Visible = false end end
else
for _, v in pairs(esp) do
if type(v) == "table" then for _, l in pairs(v) do l.Visible = false end else v.Visible = false end
end
end
else
for _, v in pairs(esp) do
if type(v) == "table" then for _, l in pairs(v) do l.Visible = false end else v.Visible = false end
end
end
end)
end
-- WALKSPEED / JUMPPOWER COM ANTI-RESET
if player.Character then
local hum = player.Character:FindFirstChild("Humanoid")
if hum and hum.Health > 0 then
if hum.WalkSpeed ~= OtherSettings.WalkSpeed then
hum.WalkSpeed = OtherSettings.WalkSpeed
end
hum.UseJumpPower = true
if hum.JumpPower ~= OtherSettings.JumpPower then
hum.JumpPower = OtherSettings.JumpPower
end
if OtherSettings.Spinbot then
hum.AutoRotate = false
end
end
end
end)
-- =============================================
-- CHARACTER ADDED - GARANTE VALORES AO RENASCER
-- =============================================
player.CharacterAdded:Connect(function(char)
task.wait(0.5)
local hum = char:FindFirstChild("Humanoid")
if hum then
hum.WalkSpeed = OtherSettings.WalkSpeed
hum.JumpPower = OtherSettings.JumpPower
hum.UseJumpPower = true
end
if OtherSettings.Float then
toggleFloat(false)
task.wait(0.1)
toggleFloat(true)
end
end)
-- =============================================
-- FAKE LAG / DASH
-- =============================================
task.spawn(function()
local last = 0
while task.wait(0.1) do
if OtherSettings.FakeLag and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
local root = player.Character.HumanoidRootPart; local hum = player.Character.Humanoid
if hum.MoveDirection.Magnitude > 0 and os.clock() - last >= 0.4 then last = os.clock(); root.CFrame = root.CFrame + (root.CFrame.LookVector * 5) end
end
end
end)
task.spawn(function()
while task.wait(0.05) do
if OtherSettings.FakeDash and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
local hum = player.Character.Humanoid; local root = player.Character.HumanoidRootPart
if hum.MoveDirection.Magnitude > 0 then root.CFrame = root.CFrame + (hum.MoveDirection * 3) end
end
end
end)
-- =============================================
-- BOTÕES TOP
-- =============================================
minimizeBtn.MouseButton1Click:Connect(function()
sidebar.Visible = false; holder.Visible = false
main:TweenSize(UDim2.new(0, 580, 0, 45), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
end)
maximizeBtn.MouseButton1Click:Connect(function()
main:TweenSize(UDim2.new(0, 580, 0, 450), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
task.wait(0.2); sidebar.Visible = true; holder.Visible = true
end)
closeBtn.MouseButton1Click:Connect(function() main.Visible = false end)
-- =============================================
-- CONTEÚDO DAS TABS
-- =============================================
local a = pages["🎯 Aimbot"]
createToggle(a, "🎯 Aim Lock (Center)", 10, function(s) AimbotSettings.Enabled = s end)
createToggle(a, "👁️ Mostrar FOV", 65, function(s) AimbotSettings.ShowFov = s end)
createToggle(a, "👥 Team Check (Aimbot)", 120, function(s) AimbotSettings.TeamCheck = s end)
createSlider(a, "👁️ FOV", 175, 0, 360, 120, function(v) AimbotSettings.FovSize = v end)
createToggle(a, "🧱 Wall Check", 250, function(s) AimbotSettings.WallCheck = s end)
createSlider(a, "💫 Smoothness", 305, 0, 100, 50, function(v) AimbotSettings.Smoothness = v end)
createToggle(a, "🔮 Prediction", 380, function(s) AimbotSettings.Prediction = s end)
createDropdown(a, "🎯 Parte do Corpo", 435, {"Head", "Torso", "Random"}, "Head", function(v) AimbotSettings.BodyPart = v end)
local e = pages["👁️ ESP"]
createToggle(e, "📦 Box ESP", 10, function(s) EspSettings.Box = s end)
createToggle(e, "🏷️ Name ESP", 65, function(s) EspSettings.Name = s end)
createToggle(e, "❤️ Health ESP", 120, function(s) EspSettings.Health = s end)
createToggle(e, "📏 Line ESP", 175, function(s) EspSettings.Line = s end)
createToggle(e, "📐 Distance ESP", 230, function(s) EspSettings.Distance = s end)
createToggle(e, "🦴 Skeleton ESP", 285, function(s) EspSettings.Skeleton = s end)
createToggle(e, "👥 Team Check (ESP)", 340, function(s) EspSettings.TeamCheck = s end)
createToggle(e, "🧱 Wall Check (Box Color)", 395, function(s) EspSettings.WallCheck = s end)
local o = pages["⚙️ Outros"]
createToggle(o, "⏳ Fake Lag (5m Front)", 10, function(s) OtherSettings.FakeLag = s end)
createToggle(o, "💨 Fake Dash (3m Auto)", 65, function(s) OtherSettings.FakeDash = s end)
createToggle(o, "🔄 Spinbot", 120, function(s)
OtherSettings.Spinbot = s
if s and player.Character then
local hum = player.Character:FindFirstChild("Humanoid")
if hum then hum.AutoRotate = false end
elseif not s and player.Character then
local hum = player.Character:FindFirstChild("Humanoid")
if hum then hum.AutoRotate = true end
end
end)
createSlider(o, "🎚️ Spinbot Velocidade", 175, 1, 50, 10, function(v) OtherSettings.SpinbotSpeed = v end)
createToggle(o, "❄️ Congelar Jogadores", 250, function(s) OtherSettings.FreezePlayers = s end)
local setSpeedVisual = createSlider(o, "🏃 WalkSpeed", 305, 0, 200, 16, function(v) OtherSettings.WalkSpeed = v end)
local setJumpVisual = createSlider(o, "🦘 JumpPower", 380, 0, 200, 50, function(v) OtherSettings.JumpPower = v end)
createButton(o, "🔄 Resetar Velocidade e Pulo", 455, function()
OtherSettings.WalkSpeed = 16
OtherSettings.JumpPower = 50
setSpeedVisual(16)
setJumpVisual(50)
if player.Character and player.Character:FindFirstChild("Humanoid") then
player.Character.Humanoid.WalkSpeed = 16
player.Character.Humanoid.JumpPower = 50
end
end)
createToggle(o, "⚡ FPS Boost", 510, function(s)
OtherSettings.FpsBoost = s
if s then
Lighting.GlobalShadows = false
for _, v in pairs(Workspace:GetDescendants()) do
if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
if v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
end
end
end)
createToggle(o, "🧠 Hitbox Expander (Cabeça)", 575, function(s) OtherSettings.HeadHitboxExpander = s; if not s then restoreHitbox() end end)
createSlider(o, "📏 Tamanho Hitbox", 630, 1, 20, 5, function(v) OtherSettings.HeadHitboxSize = v end)
createSlider(o, "👁️ Transp. Hitbox", 685, 0, 1, 0.8, function(v) OtherSettings.HeadHitboxTransparency = v end, true)
createToggle(o, "📊 Ver FPS (Painel)", 740, function(s) fpsFrame.Visible = s; OtherSettings.ShowFps = s end)
-- =============================================
-- ABA TANQUE (COORDENADAS & PLATAFORMA FLOAT)
-- =============================================
local tq = pages["🛡️ TANQUE"]
local tqTitulo = Instance.new("TextLabel", tq)
tqTitulo.BackgroundTransparency = 1
tqTitulo.Size = UDim2.new(1, -30, 0, 30)
tqTitulo.Position = UDim2.new(0, 15, 0, 10)
tqTitulo.Text = "🛡️ FACADA MODS - SISTEMAS"
tqTitulo.TextColor3 = Color3.fromRGB(255, 255, 255)
tqTitulo.Font = Enum.Font.GothamBold
tqTitulo.TextSize = 16
tqTitulo.TextXAlignment = Enum.TextXAlignment.Left
local tqInfo = Instance.new("TextLabel", tq)
tqInfo.BackgroundTransparency = 1
tqInfo.Size = UDim2.new(1, -30, 0, 40)
tqInfo.Position = UDim2.new(0, 15, 0, 40)
tqInfo.Text = "📱 Toque com 4 dedos para ocultar a UI\n💻 Tecla F6 no PC para ativar o Modo Stream"
tqInfo.TextColor3 = Color3.fromRGB(255, 200, 100)
tqInfo.Font = Enum.Font.Gotham
tqInfo.TextSize = 12
tqInfo.TextXAlignment = Enum.TextXAlignment.Left
tqInfo.TextYAlignment = Enum.TextYAlignment.Top
local streamIndicator = Instance.new("TextLabel", tq)
streamIndicator.BackgroundTransparency = 0.8
streamIndicator.Size = UDim2.new(1, -30, 0, 30)
streamIndicator.Position = UDim2.new(0, 15, 0, 90)
streamIndicator.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
Instance.new("UICorner", streamIndicator).CornerRadius = UDim.new(0, 8)
streamIndicator.Text = "🟢 STREAM MODE: DESATIVADO"
streamIndicator.TextColor3 = Color3.fromRGB(255, 255, 255)
streamIndicator.Font = Enum.Font.GothamBold
streamIndicator.TextSize = 14
-- VISOR DE COORDENADAS INTEGRADO
local coordsFrame = Instance.new("Frame", tq)
coordsFrame.Size = UDim2.new(1, -30, 0, 40)
coordsFrame.Position = UDim2.new(0, 15, 0, 130)
coordsFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
coordsFrame.BackgroundTransparency = 0.2
coordsFrame.BorderSizePixel = 0
Instance.new("UICorner", coordsFrame).CornerRadius = UDim.new(0, 8)
local coordsIcon = Instance.new("TextLabel", coordsFrame)
coordsIcon.BackgroundTransparency = 1
coordsIcon.Position = UDim2.new(0, 10, 0, 0)
coordsIcon.Size = UDim2.new(0, 30, 1, 0)
coordsIcon.Text = "📍"
coordsIcon.TextSize = 14
coordsIcon.Font = Enum.Font.Gotham
coordsIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
coordsLabel = Instance.new("TextLabel", coordsFrame)
coordsLabel.BackgroundTransparency = 1
coordsLabel.Position = UDim2.new(0, 40, 0, 0)
coordsLabel.Size = UDim2.new(1, -50, 1, 0)
coordsLabel.Text = "X: 0 | Y: 0 | Z: 0"
coordsLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
coordsLabel.Font = Enum.Font.GothamBold
coordsLabel.TextSize = 13
coordsLabel.TextXAlignment = Enum.TextXAlignment.Left
-- BOTÃO COPIAR COORDENADAS
local copyBtn = Instance.new("TextButton", tq)
copyBtn.Size = UDim2.new(1, -30, 0, 38)
copyBtn.Position = UDim2.new(0, 15, 0, 180)
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
copyBtn.AutoButtonColor = true
copyBtn.Text = "📋 Copiar Coordenadas"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 13
Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 8)
copyBtn.MouseButton1Click:Connect(function()
if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
local pos = player.Character.HumanoidRootPart.Position
local coordsString = string.format("%f, %f, %f", pos.X, pos.Y, pos.Z)
if setclipboard then
setclipboard(coordsString)
elseif toclipboard then
toclipboard(coordsString)
end
copyBtn.Text = "✅ Copiado com Sucesso!"
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
task.wait(1.5)
copyBtn.Text = "📋 Copiar Coordenadas"
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
end
end)
-- ALTERNADOR DO FLOAT (VOAR)
createToggle(tq, "🚀 Ativar Sistema Float (Voar)", 230, function(s)
toggleFloat(s)
end)
-- =============================================
-- TELEPORTE LISTA ATUALIZADA
-- =============================================
local tpLabel = Instance.new("TextLabel", tq)
tpLabel.BackgroundTransparency = 1
tpLabel.Size = UDim2.new(1, -30, 0, 25)
tpLabel.Position = UDim2.new(0, 15, 0, 290)
tpLabel.Text = "👥 TELEPORTAR ATÉ JOGADOR (Clique para ir)"
tpLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
tpLabel.Font = Enum.Font.GothamBold
tpLabel.TextSize = 14
tpLabel.TextXAlignment = Enum.TextXAlignment.Left
local tpContainer = Instance.new("ScrollingFrame", tq)
tpContainer.Size = UDim2.new(1, -30, 0, 240)
tpContainer.Position = UDim2.new(0, 15, 0, 320)
tpContainer.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
tpContainer.BorderSizePixel = 0
tpContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
tpContainer.ScrollBarThickness = 4
tpContainer.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", tpContainer).CornerRadius = UDim.new(0, 8)
local tpButtons = {}
local function createTPButton(plr)
if tpButtons[plr] or plr == player then return end
local frame = Instance.new("Frame", tpContainer)
frame.Size = UDim2.new(1, -10, 0, 40)
frame.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
local nameLabel = Instance.new("TextLabel", frame)
nameLabel.BackgroundTransparency = 1
nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
nameLabel.Position = UDim2.new(0, 10, 0, 0)
nameLabel.Text = plr.Name
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.Font = Enum.Font.GothamMedium
nameLabel.TextSize = 14
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
local distLabel = Instance.new("TextLabel", frame)
distLabel.BackgroundTransparency = 1
distLabel.Size = UDim2.new(0, 60, 1, 0)
distLabel.Position = UDim2.new(0.5, 0, 0, 0)
distLabel.Text = "...m"
distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
distLabel.Font = Enum.Font.Gotham
distLabel.TextSize = 12
distLabel.TextXAlignment = Enum.TextXAlignment.Left
local tpBtn = Instance.new("TextButton", frame)
tpBtn.Size = UDim2.new(0, 70, 0, 28)
tpBtn.Position = UDim2.new(1, -80, 0.5, -14)
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
tpBtn.AutoButtonColor = false
tpBtn.Text = "📍 TP"
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 13
tpBtn.BorderSizePixel = 0
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
local updateDist = RunService.RenderStepped:Connect(function()
if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
local dist = math.floor((plr.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude)
distLabel.Text = tostring(dist) .. "m"
else
distLabel.Text = "N/A"
end
end)
tpBtn.MouseButton1Click:Connect(function()
if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and player.Character then
local targetRoot = plr.Character.HumanoidRootPart
local myRoot = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
if myRoot then
myRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 3, 0))
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 80)
tpBtn.Text = "✅ OK!"
task.wait(0.5)
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
tpBtn.Text = "📍 TP"
end
end
end)
tpButtons[plr] = {frame = frame, btn = tpBtn, label = nameLabel, distLabel = distLabel, conn = updateDist}
local yPos = 5
for _, data in pairs(tpButtons) do
data.frame.Position = UDim2.new(0, 5, 0, yPos)
yPos = yPos + 45
end
tpContainer.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
end
local function removeTPButton(plr)
if tpButtons[plr] then
if tpButtons[plr].conn then tpButtons[plr].conn:Disconnect() end
tpButtons[plr].frame:Destroy()
tpButtons[plr] = nil
local yPos = 5
for _, data in pairs(tpButtons) do
data.frame.Position = UDim2.new(0, 5, 0, yPos)
yPos = yPos + 45
end
tpContainer.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)
end
end
for _, plr in pairs(Players:GetPlayers()) do
if plr ~= player then createTPButton(plr) end
end
Players.PlayerAdded:Connect(function(plr)
if plr ~= player then createTPButton(plr) end
end)
Players.PlayerRemoving:Connect(function(plr)
removeTPButton(plr)
end)
-- =============================================
-- NOVA SEÇÃO: IDENTIFICADO
-- =============================================
local idFrame = Instance.new("Frame", tq)
idFrame.Size = UDim2.new(1, -30, 0, 160)
idFrame.Position = UDim2.new(0, 15, 0, 585) -- logo abaixo do tpContainer (320+240=560 + margem)
idFrame.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
idFrame.BackgroundTransparency = 0.2
idFrame.BorderSizePixel = 0
Instance.new("UICorner", idFrame).CornerRadius = UDim.new(0, 12)
local idTitle = Instance.new("TextLabel", idFrame)
idTitle.BackgroundTransparency = 1
idTitle.Size = UDim2.new(1, -20, 0, 25)
idTitle.Position = UDim2.new(0, 10, 0, 8)
idTitle.Text = "🆔 Identificado"
idTitle.TextColor3 = Color3.fromRGB(255, 200, 100)
idTitle.Font = Enum.Font.GothamBold
idTitle.TextSize = 15
idTitle.TextXAlignment = Enum.TextXAlignment.Left
-- Foto do personagem (headshot)
local avatarImage = Instance.new("ImageLabel", idFrame)
avatarImage.Size = UDim2.new(0, 60, 0, 60)
avatarImage.Position = UDim2.new(0, 15, 0, 45)
avatarImage.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
avatarImage.Image = "rbxassetid://0" -- placeholder
avatarImage.ScaleType = Enum.ScaleType.Fit
Instance.new("UICorner", avatarImage).CornerRadius = UDim.new(0, 30) -- redondo
-- Labels de informação
local infoContainer = Instance.new("Frame", idFrame)
infoContainer.BackgroundTransparency = 1
infoContainer.Size = UDim2.new(1, -90, 0, 80)
infoContainer.Position = UDim2.new(0, 90, 0, 40)
infoContainer.BorderSizePixel = 0
local nameLabel = Instance.new("TextLabel", infoContainer)
nameLabel.BackgroundTransparency = 1
nameLabel.Size = UDim2.new(1, 0, 0, 22)
nameLabel.Position = UDim2.new(0, 0, 0, 0)
nameLabel.Text = "Nome: " .. player.Name
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 14
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
local deviceLabel = Instance.new("TextLabel", infoContainer)
deviceLabel.BackgroundTransparency = 1
deviceLabel.Size = UDim2.new(1, 0, 0, 22)
deviceLabel.Position = UDim2.new(0, 0, 0, 26)
deviceLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
deviceLabel.Font = Enum.Font.Gotham
deviceLabel.TextSize = 13
deviceLabel.TextXAlignment = Enum.TextXAlignment.Left
local executorLabel = Instance.new("TextLabel", infoContainer)
executorLabel.BackgroundTransparency = 1
executorLabel.Size = UDim2.new(1, 0, 0, 22)
executorLabel.Position = UDim2.new(0, 0, 0, 52)
executorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
executorLabel.Font = Enum.Font.Gotham
executorLabel.TextSize = 13
executorLabel.TextXAlignment = Enum.TextXAlignment.Left
-- Função para carregar a foto do avatar
local function updateAvatar()
local success, thumbnail = pcall(function()
return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
end)
if success and thumbnail then
avatarImage.Image = thumbnail
else
avatarImage.Image = "rbxassetid://0"
end
end
-- Detectar dispositivo
local function getDevice()
if UIS.TouchEnabled and not UIS.MouseEnabled then
return "Mobile / Touch"
elseif UIS.TouchEnabled and UIS.MouseEnabled then
return "Touchscreen PC / Tablet"
else
return "PC / Console"
end
end
-- Detectar executor
local function getExecutor()
local execName = "Desconhecido"
pcall(function()
if identifyexecutor then
local result = identifyexecutor()
if type(result) == "string" and result ~= "" then
execName = result
end
end
end)
if execName == "Desconhecido" then
pcall(function()
local result = getexecutorname()
if type(result) == "string" and result ~= "" then
execName = result
end
end)
end
return execName
end
-- Atualizar labels
local function updateInfo()
nameLabel.Text = "Nome: " .. player.Name
deviceLabel.Text = "Dispositivo: " .. getDevice()
executorLabel.Text = "Executor: " .. getExecutor()
end
updateAvatar()
updateInfo()
-- Atualizar avatar e info ao renascer (caso mudem, mas avatar é estático)
player.CharacterAdded:Connect(function()
task.wait(0.2)
updateAvatar()
updateInfo()
end)
-- =============================================
-- ABA MARCA
-- =============================================
local m = pages["🚩 Marca"]
local mt = Instance.new("TextLabel", m)
mt.BackgroundTransparency = 1; mt.Size = UDim2.new(1, -30, 0, 30); mt.Position = UDim2.new(0, 15, 0, 10)
mt.Text = "🚩 Marcar / Desmarcar Amigos"; mt.TextColor3 = Color3.fromRGB(255, 255, 255)
mt.Font = Enum.Font.GothamBold; mt.TextSize = 16; mt.TextXAlignment = Enum.TextXAlignment.Left
local md = Instance.new("TextLabel", m)
md.BackgroundTransparency = 1; md.Size = UDim2.new(1, -30, 0, 20); md.Position = UDim2.new(0, 15, 0, 40)
md.Text = "Jogadores marcados sao ignorados pelo Aimbot e ESP"; md.TextColor3 = Color3.fromRGB(200, 200, 200)
md.Font = Enum.Font.Gotham; md.TextSize = 12; md.TextXAlignment = Enum.TextXAlignment.Left
local plc = Instance.new("ScrollingFrame", m)
plc.Size = UDim2.new(1, -30, 1, -120); plc.Position = UDim2.new(0, 15, 0, 70)
plc.BackgroundColor3 = Color3.fromRGB(15, 18, 25); plc.BorderSizePixel = 0; plc.CanvasSize = UDim2.new(0, 0, 0, 0)
plc.ScrollBarThickness = 4; plc.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", plc).CornerRadius = UDim.new(0, 8)
local pbtns = {}
local function createPB(p)
if pbtns[p] then return end
local f = Instance.new("Frame", plc); f.Size = UDim2.new(1, -10, 0, 40); f.BackgroundColor3 = Color3.fromRGB(20, 22, 32); f.BorderSizePixel = 0
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
local nl = Instance.new("TextLabel", f); nl.BackgroundTransparency = 1; nl.Size = UDim2.new(0.6, -10, 1, 0); nl.Position = UDim2.new(0, 10, 0, 0)
nl.Text = p.Name; nl.TextColor3 = Color3.fromRGB(255, 255, 255); nl.Font = Enum.Font.GothamMedium; nl.TextSize = 14; nl.TextXAlignment = Enum.TextXAlignment.Left
local mb = Instance.new("TextButton", f); mb.Size = UDim2.new(0, 80, 0, 28); mb.Position = UDim2.new(1, -90, 0.5, -14)
mb.BackgroundColor3 = Color3.fromRGB(45, 45, 50); mb.AutoButtonColor = false; mb.TextColor3 = Color3.fromRGB(200, 200, 200)
mb.Font = Enum.Font.GothamBold; mb.TextSize = 12; mb.BorderSizePixel = 0; Instance.new("UICorner", mb).CornerRadius = UDim.new(0, 6)
if isMarked(p) then mb.BackgroundColor3 = Color3.fromRGB(0, 180, 80); mb.Text = "✅ Marcado" else mb.Text = "🔴 Marcar" end
mb.MouseButton1Click:Connect(function()
if MarkedPlayers[p] then MarkedPlayers[p] = nil; mb.BackgroundColor3 = Color3.fromRGB(45, 45, 50); mb.Text = "🔴 Marcar"
else MarkedPlayers[p] = true; mb.BackgroundColor3 = Color3.fromRGB(0, 180, 80); mb.Text = "✅ Marcado" end
end)
pbtns[p] = {frame = f, btn = mb, label = nl}
local y = 5; for _, d in pairs(pbtns) do d.frame.Position = UDim2.new(0, 5, 0, y); y = y + 45 end; plc.CanvasSize = UDim2.new(0, 0, 0, y + 5)
end
local function removePB(p)
if pbtns[p] then pbtns[p].frame:Destroy(); pbtns[p] = nil
local y = 5; for _, d in pairs(pbtns) do d.frame.Position = UDim2.new(0, 5, 0, y); y = y + 45 end; plc.CanvasSize = UDim2.new(0, 0, 0, y + 5)
end
end
for _, p in pairs(Players:GetPlayers()) do if p ~= player then createPB(p) end end
Players.PlayerAdded:Connect(function(p) if p ~= player then createPB(p) end end)
Players.PlayerRemoving:Connect(function(p) removePB(p); MarkedPlayers[p] = nil end)
-- =============================================
-- CRÉDITOS
-- =============================================
local c = pages["📜 Creditos"]
local cf = Instance.new("Frame", c); cf.Size = UDim2.new(1, -30, 0, 200); cf.Position = UDim2.new(0, 15, 0, 40)
cf.BackgroundColor3 = Color3.fromRGB(15, 18, 25); cf.BorderSizePixel = 0; Instance.new("UICorner", cf).CornerRadius = UDim.new(0, 12)
local ct = Instance.new("TextLabel", cf); ct.BackgroundTransparency = 1; ct.Size = UDim2.new(1, -20, 0, 35); ct.Position = UDim2.new(0, 10, 0, 10)
ct.Text = "📜 Creditos"; ct.TextColor3 = Color3.fromRGB(255, 255, 255); ct.Font = Enum.Font.GothamBold; ct.TextSize = 18; ct.TextXAlignment = Enum.TextXAlignment.Left
local l1 = Instance.new("TextLabel", cf); l1.BackgroundTransparency = 1; l1.Size = UDim2.new(1, -20, 0, 25); l1.Position = UDim2.new(0, 10, 0, 55)
l1.Text = "🎵 TikTok: @stoppedmenuhmzhhub"; l1.TextColor3 = Color3.fromRGB(255, 255, 255); l1.Font = Enum.Font.GothamMedium; l1.TextSize = 15; l1.TextXAlignment = Enum.TextXAlignment.Left
local l2 = Instance.new("TextLabel", cf); l2.BackgroundTransparency = 1; l2.Size = UDim2.new(1, -20, 0, 25); l2.Position = UDim2.new(0, 10, 0, 85)
l2.Text = "👤 Criado: facada"; l2.TextColor3 = Color3.fromRGB(255, 255, 255); l2.Font = Enum.Font.Gotham; l2.TextSize = 15; l2.TextXAlignment = Enum.TextXAlignment.Left

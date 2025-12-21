if not game:IsLoaded() then game.Loaded:Wait() end

if game.CoreGui:FindFirstChild("UltraBlocker_Final") then
    game.CoreGui:FindFirstChild("UltraBlocker_Final"):Destroy()
end

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local Vim = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- === КЛЮЧОВЕ ===
local VALID_KEYS = {
    ["PROMO-2025"] = "2025-12-31",
    ["USER-1DAY"] = "2025-12-21", 
}

-- ФУНКЦИЯ ЗА МЕСТЕНЕ
local function makeDraggable(topbarobject, object)
    local dragging, dragInput, dragStart, startPos
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- GUI SETUP
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 260, 0, 420); Main.Position = UDim2.new(0.5, -130, 0.5, -210); Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5); Main.Visible = false
Instance.new("UICorner", Main); local Stroke = Instance.new("UIStroke", Main); Stroke.Thickness = 2; Stroke.Color = Color3.fromRGB(0, 255, 255)

-- HEADER (УВЕЛИЧЕН ЗА ГОЛЕМИЯ НАДПИС)
local Header = Instance.new("Frame", Main); Header.Size = UDim2.new(1, 0, 0, 45); Header.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", Header)
makeDraggable(Header, Main)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Text = "veyz hub"
Title.TextColor3 = Color3.new(0, 1, 1) -- Сложих му лек неонов цвят
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20 -- ТУК Е ПРОМЯНАТА (беше 12)
Title.BackgroundTransparency = 1

-- БУТОНИ
local RefreshBtn = Instance.new("TextButton", Main); RefreshBtn.Size = UDim2.new(1, -20, 0, 30); RefreshBtn.Position = UDim2.new(0, 10, 0, 55); RefreshBtn.Text = "REFRESH LIST 🔄"; RefreshBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35); RefreshBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", RefreshBtn)
local SpeedBtn = Instance.new("TextButton", Main); SpeedBtn.Size = UDim2.new(1, -20, 0, 30); SpeedBtn.Position = UDim2.new(0, 10, 0, 90); SpeedBtn.Text = "SPEED: OFF "; SpeedBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50); SpeedBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", SpeedBtn)
local EspBtn = Instance.new("TextButton", Main); EspBtn.Size = UDim2.new(1, -20, 0, 30); EspBtn.Position = UDim2.new(0, 10, 0, 125); EspBtn.Text = "ESP: OFF"; EspBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50); EspBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", EspBtn)

local Scroll = Instance.new("ScrollingFrame", Main); Scroll.Size = UDim2.new(1, -10, 1, -170); Scroll.Position = UDim2.new(0, 5, 0, 165); Scroll.BackgroundTransparency = 1; Scroll.ScrollBarThickness = 2; Scroll.AutomaticCanvasSize = 2; Instance.new("UIListLayout", Scroll).Padding = UDim.new(0, 5)

-- LOGIC
local espActive, speedActive = false, false

local function createEsp(p)
    local box = Drawing.new("Square"); box.Visible = false; box.Color = Color3.new(0, 1, 1); box.Thickness = 2
    local name = Drawing.new("Text"); name.Visible = false; name.Color = Color3.new(1, 1, 1); name.Size = 16; name.Center = true; name.Outline = true
    RunService.RenderStepped:Connect(function()
        if espActive and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local sizeX, sizeY = 2500 / pos.Z, 3500 / pos.Z
                box.Size = Vector2.new(sizeX, sizeY); box.Position = Vector2.new(pos.X - sizeX / 2, pos.Y - sizeY / 2); box.Visible = true
                name.Position = Vector2.new(pos.X, pos.Y - sizeY / 2 - 20); name.Text = p.DisplayName; name.Visible = true
            else box.Visible = false; name.Visible = false end
        else box.Visible = false; name.Visible = false end
    end)
end

EspBtn.MouseButton1Click:Connect(function()
    espActive = not espActive; EspBtn.Text = espActive and "ESP: ON" or "ESP: OFF"
    EspBtn.BackgroundColor3 = espActive and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(40, 40, 50)
    if espActive then for _, p in pairs(Players:GetPlayers()) do if p ~= lp then createEsp(p) end end end
end)

SpeedBtn.MouseButton1Click:Connect(function() 
    speedActive = not speedActive; SpeedBtn.Text = speedActive and "SPEED: ON" or "SPEED: OFF "
    SpeedBtn.BackgroundColor3 = speedActive and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(40, 40, 50)
end)

RunService.RenderStepped:Connect(function() 
    if speedActive and lp.Character and lp.Character:FindFirstChild("Humanoid") then 
        lp.Character.Humanoid.WalkSpeed = 28 
    end 
end)

local function update()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp then
            local f = Instance.new("Frame", Scroll); f.Size = UDim2.new(1, 0, 0, 35); f.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", f)
            local t = Instance.new("TextLabel", f); t.Size = UDim2.new(0.6, 0, 1, 0); t.Position = UDim2.new(0, 10, 0, 0); t.Text = p.DisplayName; t.TextColor3 = Color3.new(1,1,1); t.BackgroundTransparency = 1; t.TextXAlignment = 0
            local b = Instance.new("TextButton", f); b.Size = UDim2.new(0.3, 0, 0.8, 0); b.Position = UDim2.new(0.65, 0, 0.1, 0); b.Text = "BLOCK"; b.BackgroundColor3 = Color3.fromRGB(255, 50, 50); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
            b.MouseButton1Click:Connect(function() 
                b.Text = "DONE"
                game:GetService("StarterGui"):SetCore("PromptBlockPlayer", p)
                local vps = workspace.CurrentCamera.ViewportSize
                local cx, cy = vps.X / 2, vps.Y / 2 + 50
                for i = 1, 10 do Vim:SendMouseButtonEvent(cx, cy, 0, true, game, 0); Vim:SendMouseButtonEvent(cx, cy, 0, false, game, 0); task.wait(0.01) end
            end)
        end
    end
end

-- KEY SYSTEM
local KeyGui = Instance.new("Frame", ScreenGui); KeyGui.Size = UDim2.new(0, 260, 0, 160); KeyGui.Position = UDim2.new(0.5, -130, 0.5, -80); KeyGui.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Instance.new("UICorner", KeyGui); makeDraggable(KeyGui, KeyGui)
local KeyInput = Instance.new("TextBox", KeyGui); KeyInput.Size = UDim2.new(0.8, 0, 0, 35); KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0); KeyInput.PlaceholderText = "Key..."; KeyInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KeyInput)
local SubmitBtn = Instance.new("TextButton", KeyGui); SubmitBtn.Size = UDim2.new(0.8, 0, 0, 35); SubmitBtn.Position = UDim2.new(0.1, 0, 0.65, 0); SubmitBtn.Text = "VERIFY"; SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 255); Instance.new("UICorner", SubmitBtn)
SubmitBtn.MouseButton1Click:Connect(function() if VALID_KEYS[KeyInput.Text] then KeyGui:Destroy(); Main.Visible = true; update() end end)

UIS.InputBegan:Connect(function(i, p) if not p and i.KeyCode == Enum.KeyCode.LeftControl then Main.Visible = not Main.Visible end end)
RefreshBtn.MouseButton1Click:Connect(update)

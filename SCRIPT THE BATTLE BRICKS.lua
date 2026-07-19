-- AUTO FARM для The Battle Bricks (ручной ввод уровней)

local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- ===== СОЗДАЁМ ОКНО =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = gui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "AUTO FARM"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- ===== ПОЛЕ ДЛЯ УРОВНЯ 1 =====
local label1 = Instance.new("TextLabel")
label1.Size = UDim2.new(0.9, 0, 0, 22)
label1.Position = UDim2.new(0.05, 0, 0.12, 0)
label1.BackgroundTransparency = 1
label1.Text = "🔴 УРОВЕНЬ 1:"
label1.TextColor3 = Color3.fromRGB(255, 100, 100)
label1.TextScaled = true
label1.Font = Enum.Font.GothamBold
label1.Parent = mainFrame

local input1 = Instance.new("TextBox")
input1.Size = UDim2.new(0.9, 0, 0, 30)
input1.Position = UDim2.new(0.05, 0, 0.19, 0)
input1.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
input1.Text = ""
input1.TextColor3 = Color3.fromRGB(255, 255, 255)
input1.TextScaled = true
input1.Font = Enum.Font.Gotham
input1.PlaceholderText = "Например: Stage 1"
input1.Parent = mainFrame

-- ===== ПОЛЕ ДЛЯ УРОВНЯ 2 =====
local label2 = Instance.new("TextLabel")
label2.Size = UDim2.new(0.9, 0, 0, 22)
label2.Position = UDim2.new(0.05, 0, 0.31, 0)
label2.BackgroundTransparency = 1
label2.Text = "🔵 УРОВЕНЬ 2:"
label2.TextColor3 = Color3.fromRGB(100, 100, 255)
label2.TextScaled = true
label2.Font = Enum.Font.GothamBold
label2.Parent = mainFrame

local input2 = Instance.new("TextBox")
input2.Size = UDim2.new(0.9, 0, 0, 30)
input2.Position = UDim2.new(0.05, 0, 0.38, 0)
input2.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
input2.Text = ""
input2.TextColor3 = Color3.fromRGB(255, 255, 255)
input2.TextScaled = true
input2.Font = Enum.Font.Gotham
input2.PlaceholderText = "Например: Stage 2"
input2.Parent = mainFrame

-- ===== СЛОТ ДЛЯ СПАМА =====
local labelSlot = Instance.new("TextLabel")
labelSlot.Size = UDim2.new(0.9, 0, 0, 22)
labelSlot.Position = UDim2.new(0.05, 0, 0.47, 0)
labelSlot.BackgroundTransparency = 1
labelSlot.Text = "⚔️ СЛОТ ДЛЯ СПАМА:"
labelSlot.TextColor3 = Color3.fromRGB(200, 200, 200)
labelSlot.TextScaled = true
labelSlot.Font = Enum.Font.GothamBold
labelSlot.Parent = mainFrame

local inputSlot = Instance.new("TextBox")
inputSlot.Size = UDim2.new(0.3, 0, 0, 30)
inputSlot.Position = UDim2.new(0.05, 0, 0.54, 0)
inputSlot.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
inputSlot.Text = "1"
inputSlot.TextColor3 = Color3.fromRGB(255, 255, 255)
inputSlot.TextScaled = true
inputSlot.Font = Enum.Font.Gotham
inputSlot.PlaceholderText = "1-8"
inputSlot.Parent = mainFrame

-- ===== КНОПКА СТАРТ =====
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.9, 0, 0, 40)
startBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
startBtn.Text = "🚀 СТАРТ ФАРМА"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextScaled = true
startBtn.Font = Enum.Font.GothamBold
startBtn.Parent = mainFrame

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 25)
statusLabel.Position = UDim2.new(0.05, 0, 0.80, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "⏳ Введи названия уровней и нажми СТАРТ"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- ===== ПЕРЕМЕННЫЕ =====
local farming = false

-- ===== ФУНКЦИИ =====
local function clickButton(text)
    for _, button in pairs(gui:GetDescendants()) do
        if button:IsA("TextButton") and button.Visible and button.Text == text then
            button:Click()
            return true
        end
    end
    return false
end

local function spamUnit(slot)
    for _, button in pairs(gui:GetDescendants()) do
        if button:IsA("TextButton") and button.Visible and button:FindFirstChild("SlotNumber") then
            if button.SlotNumber.Value == slot then
                button:Click()
                return true
            end
        end
    end
    return false
end

-- ===== ОСНОВНАЯ ЛОГИКА =====
startBtn.MouseButton1Click:Connect(function()
    local level1 = input1.Text
    local level2 = input2.Text
    local slot = tonumber(inputSlot.Text) or 1
    
    if level1 == "" or level2 == "" then
        statusLabel.Text = "⚠️ Введи названия обоих уровней!"
        return
    end
    
    farming = not farming
    
    if farming then
        startBtn.Text = "⏹️ СТОП"
        startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "🟢 Фарм активен: " .. level1 .. " ↔ " .. level2
        
        spawn(function()
            while farming do
                -- Уровень 1
                statusLabel.Text = "🔄 Заходим на " .. level1
                if clickButton(level1) then
                    wait(2)
                    for i = 1, 30 do
                        spamUnit(slot)
                        wait(0.3)
                    end
                    wait(25)
                    clickButton("Повторить")
                    wait(2)
                else
                    statusLabel.Text = "❌ Не найден уровень: " .. level1
                    farming = false
                    startBtn.Text = "🚀 СТАРТ ФАРМА"
                    startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
                    break
                end
                
                -- Уровень 2
                statusLabel.Text = "🔄 Заходим на " .. level2
                if clickButton(level2) then
                    wait(2)
                    for i = 1, 30 do
                        spamUnit(slot)
                        wait(0.3)
                    end
                    wait(25)
                    clickButton("Повторить")
                    wait(2)
                else
                    statusLabel.Text = "❌ Не найден уровень: " .. level2
                    farming = false
                    startBtn.Text = "🚀 СТАРТ ФАРМА"
                    startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
                    break
                end
            end
        end)
    else
        startBtn.Text = "🚀 СТАРТ ФАРМА"
        startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
        statusLabel.Text = "⏸️ Фарм остановлен"
    end
end)

print("✅ Скрипт загружен! Просто введи названия уровней и нажми СТАРТ")

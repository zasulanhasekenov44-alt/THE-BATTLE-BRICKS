-- AUTO FARM для The Battle Bricks (сканирует уровни из открытого меню)
-- Инструкция: открой в игре нужную сложность и главу, затем запусти скрипт

local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = gui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 420)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 200, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "⚡ AUTO FARM ⚡"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Кнопка сканирования
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.9, 0, 0, 35)
scanBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
scanBtn.Text = "📡 СКАНИРОВАТЬ УРОВНИ"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextScaled = true
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Parent = mainFrame

-- Список уровней
local listFrame = Instance.new("ScrollingFrame")
listFrame.Size = UDim2.new(0.9, 0, 0, 150)
listFrame.Position = UDim2.new(0.05, 0, 0.22, 0)
listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
listFrame.BackgroundTransparency = 0.3
listFrame.BorderSizePixel = 1
listFrame.BorderColor3 = Color3.fromRGB(80, 80, 120)
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ScrollBarThickness = 6
listFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 3)
uiListLayout.Parent = listFrame

-- Выбранные уровни
local level1Label = Instance.new("TextLabel")
level1Label.Size = UDim2.new(0.9, 0, 0, 22)
level1Label.Position = UDim2.new(0.05, 0, 0.62, 0)
level1Label.BackgroundTransparency = 1
level1Label.Text = "🔴 Уровень 1: не выбран"
level1Label.TextColor3 = Color3.fromRGB(255, 100, 100)
level1Label.TextScaled = true
level1Label.Font = Enum.Font.Gotham
level1Label.Parent = mainFrame

local level2Label = Instance.new("TextLabel")
level2Label.Size = UDim2.new(0.9, 0, 0, 22)
level2Label.Position = UDim2.new(0.05, 0, 0.69, 0)
level2Label.BackgroundTransparency = 1
level2Label.Text = "🔵 Уровень 2: не выбран"
level2Label.TextColor3 = Color3.fromRGB(100, 100, 255)
level2Label.TextScaled = true
level2Label.Font = Enum.Font.Gotham
level2Label.Parent = mainFrame

-- Кнопка старт
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.9, 0, 0, 40)
startBtn.Position = UDim2.new(0.05, 0, 0.78, 0)
startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
startBtn.Text = "🚀 СТАРТ ФАРМА"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextScaled = true
startBtn.Font = Enum.Font.GothamBold
startBtn.Parent = mainFrame

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 25)
statusLabel.Position = UDim2.new(0.05, 0, 0.90, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "⏳ Открой главу и сложность в игре"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- ===== ПЕРЕМЕННЫЕ =====
local selected1 = nil
local selected2 = nil
local levelButtons = {}
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

-- ===== СКАНИРОВАНИЕ =====
local function scanLevels()
    -- Очищаем старые кнопки
    for _, btn in pairs(levelButtons) do
        btn:Destroy()
    end
    levelButtons = {}
    
    local count = 0
    -- Ищем все видимые кнопки в интерфейсе (кроме служебных)
    for _, button in pairs(gui:GetDescendants()) do
        if button:IsA("TextButton") and button.Visible and button.Text ~= "" then
            local text = button.Text
            -- Фильтруем служебные кнопки
            if not text:match("Повтор") and not text:match("Меню") and not text:match("Назад") and not text:match("Старт") and not text:match("Выбор") and not text:match("Настройки") then
                local newBtn = Instance.new("TextButton")
                newBtn.Size = UDim2.new(1, -10, 0, 30)
                newBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                newBtn.Text = text
                newBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                newBtn.TextScaled = true
                newBtn.Font = Enum.Font.Gotham
                newBtn.Parent = listFrame
                
                -- Логика выбора
                newBtn.MouseButton1Click:Connect(function()
                    if selected1 == text then
                        selected1 = nil
                        newBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                        level1Label.Text = "🔴 Уровень 1: не выбран"
                        level1Label.TextColor3 = Color3.fromRGB(255, 100, 100)
                        print("❌ Сброшен уровень 1")
                    elseif selected2 == text then
                        selected2 = nil
                        newBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                        level2Label.Text = "🔵 Уровень 2: не выбран"
                        level2Label.TextColor3 = Color3.fromRGB(100, 100, 255)
                        print("❌ Сброшен уровень 2")
                    elseif selected1 == nil then
                        selected1 = text
                        newBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                        level1Label.Text = "🔴 Уровень 1: " .. text
                        level1Label.TextColor3 = Color3.fromRGB(0, 255, 100)
                        print("✅ Уровень 1: " .. text)
                    elseif selected2 == nil then
                        selected2 = text
                        newBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                        level2Label.Text = "🔵 Уровень 2: " .. text
                        level2Label.TextColor3 = Color3.fromRGB(100, 100, 255)
                        print("✅ Уровень 2: " .. text)
                    else
                        statusLabel.Text = "⚠️ Оба уровня уже выбраны!"
                    end
                end)
                
                table.insert(levelButtons, newBtn)
                count = count + 1
            end
        end
    end
    
    listFrame.CanvasSize = UDim2.new(0, 0, 0, count * 33 + 10)
    statusLabel.Text = "🔍 Найдено уровней: " .. count .. " (выберите два)"
    print("🔍 Найдено уровней: " .. count)
end

scanBtn.MouseButton1Click:Connect(scanLevels)

-- ===== ФАРМ =====
startBtn.MouseButton1Click:Connect(function()
    if not selected1 or not selected2 then
        statusLabel.Text = "⚠️ Выберите 2 уровня из списка!"
        return
    end
    
    farming = not farming
    
    if farming then
        startBtn.Text = "⏹️ СТОП"
        startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "🟢 Фарм активен"
        
        spawn(function()
            while farming do
                -- Уровень 1
                statusLabel.Text = "🔄 Заходим на " .. selected1
                if clickButton(selected1) then
                    wait(2)
                    for i = 1, 30 do
                        spamUnit(1)
                        wait(0.3)
                    end
                    wait(25)
                    clickButton("Повторить")
                    wait(2)
                end
                
                -- Уровень 2
                statusLabel.Text = "🔄 Заходим на " .. selected2
                if clickButton(selected2) then
                    wait(2)
                    for i = 1, 30 do
                        spamUnit(1)
                        wait(0.3)
                    end
                    wait(25)
                    clickButton("Повторить")
                    wait(2)
                end
            end
        end)
    else
        startBtn.Text = "🚀 СТАРТ ФАРМА"
        startBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
        statusLabel.Text = "⏸️ Фарм остановлен"
        print("⏹️ Фарм остановлен")
    end
end)

-- Авто-сканирование при запуске
wait(1)
scanLevels()

print("✅ GUI загружен! Скрипт сам отсканировал уровни из открытого меню.")            

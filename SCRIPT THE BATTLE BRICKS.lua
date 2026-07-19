-- Авто-фарм для The Battle Bricks с GUI выбором уровней
-- Инструкция: выполните скрипт, появится панель в левом верхнем углу.

local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")

-- Создаём главное окно
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = gui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 350)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Заголовок
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔥 AUTO FARM 🔥"
titleLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Кнопка сканирования уровней
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(0.9, 0, 0, 35)
scanBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
scanBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 200)
scanBtn.Text = "📡 СКАНИРОВАТЬ УРОВНИ"
scanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scanBtn.TextScaled = true
scanBtn.Font = Enum.Font.GothamBold
scanBtn.Parent = mainFrame

-- Список уровней (скролл)
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

-- Переменные для выбранных уровней
local selectedLevel1 = nil
local selectedLevel2 = nil
local levelButtons = {}

-- Функция обновления списка
local function updateLevelList()
    -- Очищаем старые кнопки
    for _, btn in pairs(levelButtons) do
        btn:Destroy()
    end
    levelButtons = {}
    
    -- Сканируем все кнопки уровней
    local count = 0
    for _, button in pairs(gui:GetDescendants()) do
        if button:IsA("TextButton") and button.Visible and button.Text ~= "" then
            -- Проверяем, что это кнопка уровня (не "Повторить" и т.д.)
            if not button.Text:match("Повтор") and not button.Text:match("Меню") and not button.Text:match("Назад") then
                local newBtn = Instance.new("TextButton")
                newBtn.Size = UDim2.new(1, -10, 0, 30)
                newBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                newBtn.Text = button.Text
                newBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                newBtn.TextScaled = true
                newBtn.Font = Enum.Font.Gotham
                newBtn.Parent = listFrame
                
                -- Сохраняем название уровня
                local levelName = button.Text
                
                -- Логика выбора
                newBtn.MouseButton1Click:Connect(function()
                    if selectedLevel1 == levelName then
                        selectedLevel1 = nil
                        newBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                        print("❌ Уровень 1 сброшен")
                    elseif selectedLevel2 == levelName then
                        selectedLevel2 = nil
                        newBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                        print("❌ Уровень 2 сброшен")
                    elseif selectedLevel1 == nil then
                        selectedLevel1 = levelName
                        newBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
                        print("✅ Выбран уровень 1: " .. levelName)
                    elseif selectedLevel2 == nil then
                        selectedLevel2 = levelName
                        newBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                        print("✅ Выбран уровень 2: " .. levelName)
                    else
                        print("⚠️ Оба уровня уже выбраны! Нажмите на выбранный для сброса.")
                    end
                    
                    -- Обновляем статус
                    statusLabel.Text = "Уровень 1: " .. (selectedLevel1 or "❌") .. " | Уровень 2: " .. (selectedLevel2 or "❌")
                end)
                
                table.insert(levelButtons, newBtn)
                count = count + 1
            end
        end
    end
    
    -- Обновляем размер холста
    listFrame.CanvasSize = UDim2.new(0, 0, 0, count * 33 + 10)
    print("🔍 Найдено уровней: " .. count)
end

-- Кнопка сканирования
scanBtn.MouseButton1Click:Connect(updateLevelList)

-- Кнопка запуска фарма
local startBtn = Instance.new("TextButton")
startBtn.Size = UDim2.new(0.9, 0, 0, 40)
startBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
startBtn.Text = "▶️ СТАРТ ФАРМА"
startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
startBtn.TextScaled = true
startBtn.Font = Enum.Font.GothamBold
startBtn.Parent = mainFrame

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 40)
statusLabel.Position = UDim2.new(0.05, 0, 0.80, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Выберите 2 уровня"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Функция спама юнитом
local function spamUnit(slotNumber)
    for _, button in pairs(gui:GetDescendants()) do
        if button:IsA("TextButton") and button.Visible and button:FindFirstChild("SlotNumber") then
            if button.SlotNumber.Value == slotNumber then
                button:Click()
                return true
            end
        end
    end
    return false
end

-- Функция поиска и клика по кнопке
local function clickButton(text)
    for _, button in pairs(gui:GetDescendants()) do
        if button:IsA("TextButton") and button.Visible and button.Text == text then
            button:Click()
            return true
        end
    end
    return false
end

-- Основной цикл фарма
local farming = false
startBtn.MouseButton1Click:Connect(function()
    if not selectedLevel1 or not selectedLevel2 then
        statusLabel.Text = "⚠️ ОШИБКА: Выберите 2 уровня!"
        return
    end
    
    farming = not farming
    if farming then
        startBtn.Text = "⏹️ СТОП"
        startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "🟢 ФАРМ АКТИВЕН: " .. selectedLevel1 .. " ↔ " .. selectedLevel2
        
        -- Запускаем фарм в отдельном потоке
        spawn(function()
            while farming do
                -- Уровень 1
                if clickButton(selectedLevel1) then
                    print("➡️ Зашли на " .. selectedLevel1)
                    wait(3)
                    for i = 1, 30 do
                        spamUnit(1)
                        wait(0.3)
                    end
                    wait(25) -- Время на прохождение
                    clickButton("Повторить")
                    wait(2)
                end
                
                -- Уровень 2
                if clickButton(selectedLevel2) then
                    print("➡️ Зашли на " .. selectedLevel2)
                    wait(3)
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
        startBtn.Text = "▶️ СТАРТ ФАРМА"
        startBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "⏸️ ФАРМ ОСТАНОВЛЕН"
        print("⏹️ Фарм остановлен")
    end
end)

-- Автосканирование при запуске
wait(1)
updateLevelList()
print("✅ GUI загружен! Нажмите 'Сканировать уровни' чтобы обновить список.")

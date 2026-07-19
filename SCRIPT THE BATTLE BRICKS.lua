-- ═══════════════════════════════════════════════════
-- MACRO RECORDER + ГЕНЕРАТОР СКРИПТОВ
-- Записывает действия и создаёт готовый Lua-скрипт
-- ═══════════════════════════════════════════════════

local player = game.Players.LocalPlayer
local gui = player:WaitForChild("PlayerGui")
local mouse = player:GetMouse()

-- ===== СОЗДАЁМ GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = gui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
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
title.Text = "🎬 РЕКОРДЕР + ГЕНЕРАТОР"
title.TextColor3 = Color3.fromRGB(255, 200, 50)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Кнопка записи
local recordBtn = Instance.new("TextButton")
recordBtn.Size = UDim2.new(0.9, 0, 0, 40)
recordBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
recordBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
recordBtn.Text = "🔴 НАЧАТЬ ЗАПИСЬ"
recordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
recordBtn.TextScaled = true
recordBtn.Font = Enum.Font.GothamBold
recordBtn.Parent = mainFrame

-- Кнопка стоп/генерации
local generateBtn = Instance.new("TextButton")
generateBtn.Size = UDim2.new(0.9, 0, 0, 40)
generateBtn.Position = UDim2.new(0.05, 0, 0.24, 0)
generateBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
generateBtn.Text = "⏹️ ОСТАНОВИТЬ И СГЕНЕРИРОВАТЬ"
generateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
generateBtn.TextScaled = true
generateBtn.Font = Enum.Font.GothamBold
generateBtn.Parent = mainFrame
generateBtn.Visible = false -- скрываем пока не начали запись

-- Поле для вывода кода
local codeBox = Instance.new("ScrollingFrame")
codeBox.Size = UDim2.new(0.9, 0, 0, 200)
codeBox.Position = UDim2.new(0.05, 0, 0.36, 0)
codeBox.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
codeBox.BorderSizePixel = 1
codeBox.BorderColor3 = Color3.fromRGB(100, 100, 200)
codeBox.CanvasSize = UDim2.new(0, 0, 0, 0)
codeBox.ScrollBarThickness = 6
codeBox.Parent = mainFrame

local codeLabel = Instance.new("TextLabel")
codeLabel.Size = UDim2.new(1, 0, 0, 0) -- будет расширяться
codeLabel.BackgroundTransparency = 1
codeLabel.Text = ""
codeLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
codeLabel.TextScaled = false
codeLabel.Font = Enum.Font.Code
codeLabel.TextSize = 14
codeLabel.TextXAlignment = Enum.TextXAlignment.Left
codeLabel.TextYAlignment = Enum.TextYAlignment.Top
codeLabel.Parent = codeBox

-- Кнопка копирования
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(0.4, 0, 0, 30)
copyBtn.Position = UDim2.new(0.05, 0, 0.78, 0)
copyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
copyBtn.Text = "📋 КОПИРОВАТЬ"
copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
copyBtn.TextScaled = true
copyBtn.Font = Enum.Font.GothamBold
copyBtn.Parent = mainFrame

-- Кнопка сохранить (имитация)
local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.4, 0, 0, 30)
saveBtn.Position = UDim2.new(0.55, 0, 0.78, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
saveBtn.Text = "💾 ПОКАЗАТЬ КОД"
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.TextScaled = true
saveBtn.Font = Enum.Font.GothamBold
saveBtn.Parent = mainFrame

-- Статус
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9, 0, 0, 25)
statusLabel.Position = UDim2.new(0.05, 0, 0.88, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "⏳ Нажми 'Начать запись'"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- ===== ПЕРЕМЕННЫЕ =====
local isRecording = false
local actions = {}
local connections = {}

-- ===== ФУНКЦИИ ЗАПИСИ =====
local function recordAction(actionType, data)
    table.insert(actions, {type = actionType, data = data})
    statusLabel.Text = "📝 Записано действий: " .. #actions
end

local function startRecording()
    actions = {}
    isRecording = true
    recordBtn.Visible = false
    generateBtn.Visible = true
    statusLabel.Text = "🔴 ИДЁТ ЗАПИСЬ... кликай по кнопкам и полю"
    codeLabel.Text = ""
    codeBox.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    -- Запись кликов по кнопкам (через DescendantAdded)
    local conn1 = gui.DescendantAdded:Connect(function(desc)
        if isRecording and desc:IsA("TextButton") then
            desc.MouseButton1Click:Connect(function()
                if isRecording then
                    recordAction("clickButton", {text = desc.Text})
                end
            end)
        end
    end)
    table.insert(connections, conn1)
    
    -- Запись кликов по игровому полю (через Mouse)
    local conn2 = mouse.Button1Down:Connect(function()
        if isRecording then
            local hit = mouse.Hit
            if hit then
                local pos = hit.Position
                -- Проверяем, что клик не по GUI (если объект не часть интерфейса)
                local target = mouse.Target
                if target and not target:IsDescendantOf(gui) and not target:IsDescendantOf(screenGui) then
                    recordAction("placeUnit", {x = pos.X, y = pos.Y, z = pos.Z})
                end
            end
        end
    end)
    table.insert(connections, conn2)
end

local function stopAndGenerate()
    isRecording = false
    for _, conn in pairs(connections) do
        conn:Disconnect()
    end
    connections = {}
    recordBtn.Visible = true
    generateBtn.Visible = false
    statusLabel.Text = "⏹️ Запись остановлена. Генерация кода..."
    
    -- Генерируем скрипт
    local scriptLines = {}
    table.insert(scriptLines, "-- Автоматически сгенерированный скрипт")
    table.insert(scriptLines, "-- Количество действий: " .. #actions)
    table.insert(scriptLines, "")
    table.insert(scriptLines, "local player = game.Players.LocalPlayer")
    table.insert(scriptLines, "local gui = player:WaitForChild('PlayerGui')")
    table.insert(scriptLines, "")
    table.insert(scriptLines, "local function clickButton(text)")
    table.insert(scriptLines, "    for _, button in pairs(gui:GetDescendants()) do")
    table.insert(scriptLines, "        if button:IsA('TextButton') and button.Visible and button.Text == text then")
    table.insert(scriptLines, "            button:Click()")
    table.insert(scriptLines, "            return true")
    table.insert(scriptLines, "        end")
    table.insert(scriptLines, "    end")
    table.insert(scriptLines, "    return false")
    table.insert(scriptLines, "end")
    table.insert(scriptLines, "")
    table.insert(scriptLines, "local function placeUnit(x, y, z)")
    table.insert(scriptLines, "    local mouse = player:GetMouse()")
    table.insert(scriptLines, "    -- Эмуляция клика по координатам (зависит от игры)")
    table.insert(scriptLines, "    -- В Roblox нельзя программно кликнуть по миру, поэтому эта функция")
    table.insert(scriptLines, "    -- может быть реализована через симуляцию нажатия или через удалённые события.")
    table.insert(scriptLines, "    -- В данном случае мы просто выводим координаты для ручной вставки.")
    table.insert(scriptLines, "    print('Разместить юнита по координатам:', x, y, z)")
    table.insert(scriptLines, "    -- Здесь можно добавить вызов игровой функции, если известна.")
    table.insert(scriptLines, "end")
    table.insert(scriptLines, "")
    table.insert(scriptLines, "-- Основной блок действий")
    table.insert(scriptLines, "print('Запуск автоматизации...')")
    
    for i, action in ipairs(actions) do
        if action.type == "clickButton" then
            table.insert(scriptLines, string.format('clickButton("%s")', action.data.text:gsub('"', '\\"')))
        elseif action.type == "placeUnit" then
            local x, y, z = action.data.x, action.data.y, action.data.z
            table.insert(scriptLines, string.format('placeUnit(%.2f, %.2f, %.2f)', x, y, z))
        end
        table.insert(scriptLines, "wait(0.1)") -- небольшая задержка
    end
    
    table.insert(scriptLines, "")
    table.insert(scriptLines, "print('Автоматизация завершена')")
    
    local fullScript = table.concat(scriptLines, "\n")
    codeLabel.Text = fullScript
    -- Обновляем размер Canvas
    local lineCount = #scriptLines
    codeBox.CanvasSize = UDim2.new(0, 0, 0, lineCount * 20 + 20)
    statusLabel.Text = "✅ Код сгенерирован! Можно копировать."
end

-- ===== ОБРАБОТЧИКИ КНОПОК =====
recordBtn.MouseButton1Click:Connect(startRecording)

generateBtn.MouseButton1Click:Connect(stopAndGenerate)

copyBtn.MouseButton1Click:Connect(function()
    if codeLabel.Text ~= "" then
        setclipboard(codeLabel.Text)
        statusLabel.Text = "📋 Скопировано в буфер обмена!"
    else
        statusLabel.Text = "⚠️ Нет кода для копирования!"
    end
end)

saveBtn.MouseButton1Click:Connect(function()
    if codeLabel.Text ~= "" then
        -- Показываем код в отдельном окне или просто фокусируем поле
        codeBox.ScrollBarThickness = 6
        statusLabel.Text = "📄 Код показан в окне выше"
    else
        statusLabel.Text = "⚠️ Сначала сгенерируй код!"
    end
end)

print("✅ Рекордер с генерацией загружен!")
print("1. Нажми 'Начать запись'")
print("2. Кликай по кнопкам и полю (размещай юнитов)")
print("3. Нажми 'Остановить и сгенерировать'")
print("4. Скопируй готовый скрипт!")

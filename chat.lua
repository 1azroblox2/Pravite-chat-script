-- 1AZROBLOXCHAT - PC & MOBILE & EXECUTOR UYUMLU
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TouchInputService = game:GetService("TouchInputService")

local chatUI = nil
local privateChats = {}
local isMobile = false -- Mobil kontrol

local CHAT_COLORS = {
    Background = Color3.fromRGB(25,5,8),
    OwnerName = Color3.fromRGB(255,100,150),
    NormalName = Color3.fromRGB(200,120,150),
    Message = Color3.fromRGB(240,200,210),
    Border = Color3.fromRGB(80,20,40),
    PrivateChat = Color3.fromRGB(150, 50, 100),
    MobileButton = Color3.fromRGB(220, 100, 140) -- Mobil buton rengi
}

local OWNER_USERIDS = {5224146556}

local function isOwner(id)
    for _,v in pairs(OWNER_USERIDS) do
        if v == id then return true end
    end
    return false
end

-- Mobil kontrol
if TouchInputService.TouchEnabled then
    isMobile = true
end

-- Özel chat (PC & Mobile)
function createPrivateChat(playerName)
    local privateGui = Instance.new("ScreenGui")
    privateGui.Name = "PrivateChat_" .. playerName
    privateGui.ResetOnSpawn = false
    
    -- Mobil için küçük boyut
    local main = Instance.new("Frame")
    main.Size = isMobile and UDim2.new(0, 300, 0, 200) or UDim2.new(0, 400, 0, 300)
    main.Position = isMobile and UDim2.new(0.5, -150, 0.5, -100) or UDim2.new(0, 450, 1, -370)
    main.BackgroundColor3 = CHAT_COLORS.PrivateChat
    main.BackgroundTransparency = 0.1
    main.BorderColor3 = CHAT_COLORS.Border
    main.BorderSizePixel = 2
    
    -- Başlık
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, isMobile and 25 or 30)
    title.Text = "ÖZEL: " .. playerName
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundColor3 = CHAT_COLORS.Border
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = isMobile and 14 or 16
    title.Parent = main
    
    -- Chat mesajları
    local chatFrame = Instance.new("ScrollingFrame")
    chatFrame.Size = UDim2.new(1, -20, 1, -80)
    chatFrame.Position = UDim2.new(0, 10, 0, isMobile and 30 or 40)
    chatFrame.BackgroundTransparency = 1
    chatFrame.ScrollBarThickness = 5
    chatFrame.ScrollBarImageColor3 = CHAT_COLORS.OwnerName
    chatFrame.Parent = main
    
    local layout = Instance.new("UIListLayout")
    layout.Parent = chatFrame
    
    -- Mesaj yazma
    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -20, 0, isMobile and 25 or 35)
    textBox.Position = UDim2.new(0, 10, 1, -40)
    textBox.PlaceholderText = playerName .. " ile mesaj..."
    textBox.TextColor3 = CHAT_COLORS.Message
    textBox.BackgroundColor3 = CHAT_COLORS.Border
    textBox.ClearTextOnFocus = false
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = isMobile and 12 or 14
    textBox.Parent = main
    
    -- Kapatma butonu (PC & Mobile)
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, isMobile and 20 or 30, 0, isMobile and 20 or 30)
    closeBtn.Position = UDim2.new(1, -25, 0, 5)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Font = Enum.Font.SourceSansBold
    closeBtn.TextSize = isMobile and 12 or 14
    closeBtn.Parent = main
    
    closeBtn.MouseButton1Click:Connect(function()
        privateGui:Destroy()
        privateChats[playerName] = nil
    end)
    
    -- Mobil için touch event
    if isMobile then
        closeBtn.TouchTap:Connect(function()
            privateGui:Destroy()
            privateChats[playerName] = nil
        end)
    end
    
    main.Parent = privateGui
    privateGui.Parent = player:WaitForChild("PlayerGui")
    
    -- Özel chat'e mesaj ekleme
    local function addPrivateMessage(sender, message)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, isMobile and 20 or 25)
        frame.BackgroundTransparency = 1
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0, 80, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = sender
        nameLabel.TextColor3 = CHAT_COLORS.OwnerName
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Font = Enum.Font.SourceSans
        nameLabel.TextSize = isMobile and 10 or 12
        nameLabel.Parent = frame
        
        local msgLabel = Instance.new("TextLabel")
        msgLabel.Size = UDim2.new(1, -80, 1, 0)
        msgLabel.Position = UDim2.new(0, 80, 0, 0)
        msgLabel.BackgroundTransparency = 1
        msgLabel.Text = message
        msgLabel.TextColor3 = CHAT_COLORS.Message
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.Font = Enum.Font.SourceSans
        msgLabel.TextSize = isMobile and 10 or 12
        msgLabel.Parent = frame
        
        frame.Parent = chatFrame
        
        -- Otomatik scroll
        chatFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
        chatFrame.CanvasPosition = Vector2.new(0, chatFrame.CanvasSize.Y.Offset)
    end
    
    -- Mesaj gönderme
    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and textBox.Text ~= "" then
            addPrivateMessage(player.Name, textBox.Text)
            textBox.Text = ""
        end
    end)
    
    -- Tabloya kaydet
    privateChats[playerName] = {
        Gui = privateGui,
        AddMessage = addPrivateMessage
    }
    
    -- İlk mesaj
    addPrivateMessage("Sistem", "Özel chat başlatıldı: " .. playerName)
    
    return privateChats[playerName]
end

function createUI()
    local gui = Instance.new("ScreenGui")
    gui.Name = "1AZROBLOXCHAT_UI"
    gui.ResetOnSpawn = false

    -- Mobil için küçük boyut
    local main = Instance.new("Frame")
    main.Size = isMobile and UDim2.new(0, 350, 0, 250) or UDim2.new(0,450,0,350)
    main.Position = isMobile and UDim2.new(0.5, -175, 0.5, -125) or UDim2.new(0,20,1,-370)
    main.BackgroundColor3 = CHAT_COLORS.Background
    main.BorderColor3 = CHAT_COLORS.Border
    main.Parent = gui

    local chatFrame = Instance.new("ScrollingFrame")
    chatFrame.Size = UDim2.new(1,-20,1,-80)
    chatFrame.Position = UDim2.new(0,10,0,10)
    chatFrame.BackgroundTransparency = 1
    chatFrame.ScrollBarThickness = 5
    chatFrame.ScrollBarImageColor3 = CHAT_COLORS.OwnerName
    chatFrame.Parent = main

    local layout = Instance.new("UIListLayout")
    layout.Parent = chatFrame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1,-20,0,isMobile and 25 or 35)
    textBox.Position = UDim2.new(0,10,1,-40)
    textBox.PlaceholderText = "Mesaj yaz..."
    textBox.TextColor3 = CHAT_COLORS.Message
    textBox.BackgroundColor3 = CHAT_COLORS.Border
    textBox.ClearTextOnFocus = false
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = isMobile and 12 or 14
    textBox.Parent = main

    -- Mobil için aç/kapat butonu
    if isMobile then
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 40, 0, 40)
        toggleBtn.Position = UDim2.new(1, -45, 1, -45)
        toggleBtn.Text = "CHAT"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.BackgroundColor3 = CHAT_COLORS.MobileButton
        toggleBtn.Font = Enum.Font.SourceSansBold
        toggleBtn.TextSize = 12
        toggleBtn.Parent = gui
        
        toggleBtn.MouseButton1Click:Connect(function()
            AZChat.ToggleChat()
        end)
        
        toggleBtn.TouchTap:Connect(function()
            AZChat.ToggleChat()
        end)
    end

    gui.Parent = player:WaitForChild("PlayerGui")

    chatUI = {
        Gui = gui,
        ChatFrame = chatFrame,
        TextBox = textBox,
        Layout = layout
    }
end

function addMessage(name,msg,isowner)
    if not chatUI then return end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,isMobile and 20 or 25)
    frame.BackgroundTransparency = 1

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0,80,1,0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = (isowner and "[OWNER] " or "")..name
    nameLabel.TextColor3 = isowner and CHAT_COLORS.OwnerName or CHAT_COLORS.NormalName
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Font = Enum.Font.SourceSans
    nameLabel.TextSize = isMobile and 10 or 12
    nameLabel.Parent = frame

    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1,-80,1,0)
    msgLabel.Position = UDim2.new(0,80,0,0)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = msg
    msgLabel.TextColor3 = CHAT_COLORS.Message
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Font = Enum.Font.SourceSans
    msgLabel.TextSize = isMobile and 10 or 12
    msgLabel.Parent = frame

    frame.Parent = chatUI.ChatFrame
    
    -- Otomatik scroll
    chatUI.ChatFrame.CanvasSize = UDim2.new(0, 0, 0, chatUI.Layout.AbsoluteContentSize.Y)
    chatUI.ChatFrame.CanvasPosition = Vector2.new(0, chatUI.ChatFrame.CanvasSize.Y.Offset)
end

function startChat()
    createUI()
    
    addMessage("1AZROBLOXCHAT","Sistem başlatıldı",true)
    addMessage("Sistem",isMobile and "Mobil: CHAT butonu" or "PC: F1/F2 tuşları",false)

    chatUI.TextBox.FocusLost:Connect(function(enter)
        if enter then
            local msg = chatUI.TextBox.Text
            if msg ~= "" then
                addMessage(player.Name,msg,isOwner(player.UserId))
                chatUI.TextBox.Text = ""
            end
        end
    end)
    
    -- PC için tuş kontrolleri
    if not isMobile then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if not gameProcessed then
                if input.KeyCode == Enum.KeyCode.F1 then
                    AZChat.ToggleChat()
                elseif input.KeyCode == Enum.KeyCode.F2 then
                    -- Executor'larda input alma
                    local executorInput = ""
                    
                    -- Delta/Xeno/Veciloty için input
                    if getgenv().ExecutorInput then
                        executorInput = getgenv().ExecutorInput("Oyuncu ismi gir:")
                    else
                        -- Alternatif: chat'ten al
                        chatUI.TextBox.PlaceholderText = "Özel chat için oyuncu ismi:"
                        chatUI.TextBox.FocusLost:Once(function()
                            local nameInput = chatUI.TextBox.Text
                            if nameInput ~= "" then
                                createPrivateChat(nameInput)
                                chatUI.TextBox.PlaceholderText = "Mesaj yaz..."
                                chatUI.TextBox.Text = ""
                            end
                        end)
                    end
                    
                    if executorInput ~= "" then
                        createPrivateChat(executorInput)
                    end
                end
            end
        end)
    end
end

if player then
    player.CharacterAdded:Connect(function()
        task.wait(1)
        startChat()
    end)

    if player.Character then
        startChat()
    end
end

getgenv().AZChat = {}

function AZChat.ToggleChat()
    local gui = player.PlayerGui:FindFirstChild("1AZROBLOXCHAT_UI")
    if gui then
        gui.Enabled = not gui.Enabled
        addMessage("Sistem","Chat " .. (gui.Enabled and "açıldı" or "kapandı"),false)
    end
end

function AZChat.CreatePrivateChat(playerName)
    if type(playerName) == "string" and playerName ~= "" then
        createPrivateChat(playerName)
        return true
    end
    return false
end

function AZChat.CloseAllPrivateChats()
    for name, data in pairs(privateChats) do
        if data.Gui then
            data.Gui:Destroy()
        end
    end
    privateChats = {}
end

-- Executor uyumluluk
if getgenv().Executor then
    print("1AZROBLOXCHAT - Executor uyumlu")
    
    -- Delta/Xeno/Veciloty için shortcut
    getgenv().ExecutorShortcuts = {
        ToggleChat = AZChat.ToggleChat,
        PrivateChat = function(name)
            return AZChat.CreatePrivateChat(name)
        end,
        ClosePrivate = AZChat.CloseAllPrivateChats
    }
end

print("1AZROBLOXCHAT yüklendi!")
print(isMobile and "Mobil versiyon" or "PC versiyon")
print("Komutlar: AZChat.ToggleChat(), AZChat.CreatePrivateChat('isim')")

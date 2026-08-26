-- RJR_NEW.lua (已整合快速攻擊與自動化模組)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- 建立第一階段歡迎與載入介面
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RJR_LoginGui"
ScreenGui.Parent = CoreGui
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 450, 0, 280)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 136)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

-- 右上角叉叉關閉按鈕
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Position = UDim2.new(0, 0, 0, 15)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "1amnotReal - 驗證系統"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 22
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 30)
SubTitle.Position = UDim2.new(0, 0, 0, 60)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "請輸入授權密碼以繼續使用腳本"
SubTitle.TextColor3 = Color3.fromRGB(170, 170, 170)
SubTitle.TextSize = 14
SubTitle.Font = Enum.Font.SourceSans
SubTitle.Parent = MainFrame

local TextBox = Instance.new("TextBox")
TextBox.Size = UDim2.new(0, 350, 0, 45)
TextBox.Position = UDim2.new(0.5, -175, 0, 110)
TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TextBox.BorderSizePixel = 0
TextBox.Text = ""
TextBox.PlaceholderText = "在此輸入密碼..."
TextBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
TextBox.TextSize = 16
TextBox.Font = Enum.Font.SourceSans
TextBox.Parent = MainFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = TextBox

local LoginBtn = Instance.new("TextButton")
LoginBtn.Size = UDim2.new(0, 350, 0, 45)
LoginBtn.Position = UDim2.new(0.5, -175, 0, 175)
LoginBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
LoginBtn.BorderSizePixel = 0
LoginBtn.Text = "確認登入"
LoginBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
LoginBtn.TextSize = 16
LoginBtn.Font = Enum.Font.SourceSansBold
LoginBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = LoginBtn

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 25)
StatusLabel.Position = UDim2.new(0, 0, 0, 235)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.Parent = MainFrame

-- 主腳本載入函數
local function LoadMainScript()
    ScreenGui:Destroy()

    local CONFIG_FILE = "RJR_NEW_C.json"

    -- 全域變數預設值初始化
    _G.SilentAimEnabled = _G.SilentAimEnabled or false
    _G.SilentAimSkills = _G.SilentAimSkills or { "M1 (普攻)" }
    _G.SilentAimTargetMode = _G.SilentAimTargetMode or "最近目標"
    _G.SilentAimSelectedPlayer = _G.SilentAimSelectedPlayer or nil
    _G.SilentAimTargetPlayers = _G.SilentAimTargetPlayers or true
    _G.SilentAimTeamCheck = _G.SilentAimTeamCheck or true
    _G.SilentAimTargetMobs = _G.SilentAimTargetMobs or false
    _G.SilentAimShowLine = _G.SilentAimShowLine or false
    _G.SilentAimShowFOV = _G.SilentAimShowFOV or false
    _G.SilentAimFOVMode = _G.SilentAimFOVMode or "跟随鼠標"
    _G.SilentAimFOV = _G.SilentAimFOV or 150
    _G.SilentAimFOVThickness = _G.SilentAimFOVThickness or 1.5
    _G.SilentAimFOVTransparency = _G.SilentAimFOVTransparency or 1
    _G.SilentAimDrawings = _G.SilentAimDrawings or {}

    -- 快速攻擊與龍槍變數初始化 (已整合新傳入的邏輯)
    _G.G_FastAttack        = _G.G_FastAttack ~= false
    _G.G_FastAttackMode    = _G.G_FastAttackMode or "模式2(部分账号失效用)"
    _G.G_AttackMobs        = _G.G_AttackMobs ~= false
    _G.G_AttackPlayers     = _G.G_AttackPlayers ~= false

    _G.FastAttackMode = _G.FastAttackMode or "模式1"
    _G.DragonGunM1 = _G.DragonGunM1 or false
    _G.DragonGunCooldown = _G.DragonGunCooldown or 0.1
    _G.AttackMobs = _G.AttackMobs or false
    _G.AttackPlayers = _G.AttackPlayers or true
    _G.M1FireInterval = _G.M1FireInterval or 0.1

    _G.G_AutoHaki = _G.G_AutoHaki or false
    _G.G_AutoV3 = _G.G_AutoV3 or false
    _G.AutoV4_Enabled = _G.AutoV4_Enabled or true 
    _G.G_NoWalkAnimation = _G.G_NoWalkAnimation or false
    _G.G_AutoSmoothWalk = _G.G_AutoSmoothWalk or false
    _G.G_AutoFlee = _G.G_AutoFlee or false
    _G.G_AutoFleeHP = _G.G_AutoFleeHP or 30
    _G.G_translateSpeed = _G.G_translateSpeed or 50
    _G.G_translateAccel = _G.G_translateAccel or false
    _G.G_jumpHeight = _G.G_jumpHeight or 50
    _G.G_jumpEnabled = _G.G_jumpEnabled or false
    
    -- 飛行與速度變數初始化
    _G.G_Fly = _G.G_Fly or false
    _G.G_FlySpeed = _G.G_FlySpeed or 1
    
    -- 血量低於20%自動更換種族變數初始化
    _G.G_AutoLowHpRace = _G.G_AutoLowHpRace or false
    _G.G_LowHpRaceChoice = _G.G_LowHpRaceChoice or "吸血鬼"
    
    -- 傳送偏移變數
    _G.G_TeleportOffsetX = _G.G_TeleportOffsetX or 0
    _G.G_TeleportOffsetY = _G.G_TeleportOffsetY or 0
    _G.G_TeleportOffsetZ = _G.G_TeleportOffsetZ or 0
    _G.G_SelectPly = _G.G_SelectPly or ""
    
    -- ESP 變數
    _G.G_ESPEnabled = _G.G_ESPEnabled ~= false
    _G.G_ESP_Name = _G.G_ESP_Name ~= false
    _G.G_ESP_Level = _G.G_ESP_Level ~= false
    _G.G_ESP_Bounty = _G.G_ESP_Bounty ~= false
    _G.G_ESP_Fruit = _G.G_ESP_Fruit ~= false
    _G.G_ESP_Distance = _G.G_ESP_Distance ~= false
    _G.G_ESP_HP = _G.G_ESP_HP ~= false
    _G.G_ESP_TextSize = _G.G_ESP_TextSize or 14
    _G.G_ESP_Highlight = _G.G_ESP_Highlight or false
    _G.G_ESP_HighlightColor = _G.G_ESP_HighlightColor or "00FF88"

    _G.G_AutoLoadConfig = _G.G_AutoLoadConfig or false
    _G.G_AutoSaveConfig = _G.G_AutoSaveConfig ~= false 
    _G.G_Theme = _G.G_Theme or "Dark"
    _G.G_Language = _G.G_Language or "中文"

    local Translations = {
        ["中文"] = {},
        ["English"] = {
            ["1amnotReal"] = "1amnotReal",
            ["主要功能"] = "Main",
            ["ESP"] = "ESP",
            ["PVP"] = "PVP",
            ["特別"] = "Special",
            ["设置"] = "Settings",
            ["顯示玩家名字"] = "Show Player Name",
            ["顯示玩家等級"] = "Show Player Level",
            ["顯示玩家賞金"] = "Show Bounty",
            ["顯示惡魔果實"] = "Show Devil Fruit",
            ["顯示距離"] = "Show Distance",
            ["顯示血量"] = "Show HP",
            ["高亮顯示玩家"] = "Highlight Players",
            ["高亮顏色"] = "Highlight Color",
            ["ESP 字體大小"] = "ESP Text Size",
            ["語言"] = "Language",
            ["中文"] = "Chinese",
            ["正在鎖人: "] = "Locking: ",
            ["自动 V3"] = "Auto V3",
            ["Auto V4"] = "Auto V4",
            ["無走路特效"] = "No Walk Animation",
            ["更换吸血鬼"] = "Change Vampire",
            ["血量低於20%自動更換種族"] = "Auto Race Change on Low HP (<20%)",
            ["選擇低血量切換種族"] = "Select Race for Low HP",
            ["自動順步開關"] = "Auto Smooth Walk Toggle",
            ["已開啟自動順步跟隨"] = "Auto smooth walk enabled",
            ["已關閉自動順步跟隨"] = "Auto smooth walk disabled",
            ["自動保存配置"] = "Auto Save Config",
            ["進遊戲自動加載配置"] = "Auto Load Config",
            ["飛行開關"] = "Flight Toggle",
            ["飛行速度"] = "Flight Speed",
        }
    }

    local function L(text)
        if _G.G_Language == "English" and Translations["English"][text] then
            return Translations["English"][text]
        end
        return text
    end

    -- ========================================================
    -- 【新整合的 FastAttack 核心邏輯】
    -- ========================================================
    local M1_State = { consecutiveFailures = 0, maxConsecutiveFailures = 5, Remotes = nil, Net = nil, RegisterAttack = nil, RegisterHit = nil, Enemies = nil }

    local function IsAlive(character)
        if not character then return false end
        local hum = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        return hum ~= nil and hum.Health > 0 and root ~= nil
    end

    local function GetRandomValidPart(model)
        if not model then return nil end
        local parts = {}
        for _, v in ipairs(model:GetChildren()) do
            if v:IsA("BasePart") then table.insert(parts, v) end
        end
        if #parts > 0 then return parts[math.random(1, #parts)] end
        return model.PrimaryPart or model:FindFirstChild("HumanoidRootPart")
    end

    local function M1_CheckAndGetCoreComponents()
        if M1_State.Remotes and M1_State.Net and M1_State.RegisterAttack and M1_State.RegisterHit and M1_State.Enemies then
            return M1_State.Remotes, M1_State.Net, M1_State.RegisterAttack, M1_State.RegisterHit, M1_State.Enemies
        end
        local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
        local Modules = ReplicatedStorage:FindFirstChild("Modules")
        local Net = Modules and Modules:FindFirstChild("Net")
        local RegisterAttack = Net and (Net:FindFirstChild("RE/RegisterAttack") or Net:FindFirstChild("RegisterAttack"))
        local RegisterHit = Net and (Net:FindFirstChild("RE/RegisterHit") or Net:FindFirstChild("RegisterHit"))
        local Enemies = workspace:FindFirstChild("Enemies") or workspace:FindFirstChild("NPCs")
        if Remotes and Modules and Net and RegisterAttack and RegisterHit and Enemies then
            M1_State.Remotes = Remotes; M1_State.Net = Net; M1_State.RegisterAttack = RegisterAttack; M1_State.RegisterHit = RegisterHit; M1_State.Enemies = Enemies
            return Remotes, Net, RegisterAttack, RegisterHit, Enemies
        end
        return nil, nil, nil, nil, nil
    end

    local function M1_ProcessEnemies(OthersEnemies, Folder)
        if not Folder or not _G.G_AttackMobs then return nil end
        local BasePart = nil
        local myPos = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and LocalPlayer.Character.PrimaryPart.Position
        if not myPos then return nil end
        for _, Enemy in ipairs(Folder:GetChildren()) do
            if Enemy == LocalPlayer.Character or not IsAlive(Enemy) then continue end
            local enemyRoot = Enemy:FindFirstChild("HumanoidRootPart")
            if not enemyRoot then continue end
            if (enemyRoot.Position - myPos).Magnitude < 500 then
                 local foundPart = GetRandomValidPart(Enemy)
                 if foundPart then
                    table.insert(OthersEnemies, {Enemy, foundPart})
                    BasePart = foundPart
                 end
            end
        end
        return BasePart
    end

    local function M1_ProcessRealPlayers(OthersEnemies)
        if not _G.G_AttackPlayers then return nil end
        local BasePart = nil
        local myPos = LocalPlayer.Character and LocalPlayer.Character.PrimaryPart and LocalPlayer.Character.PrimaryPart.Position
        if not myPos then return nil end
        for _, OtherPlayer in ipairs(Players:GetPlayers()) do
            if OtherPlayer == LocalPlayer then continue end
            local OtherChar = OtherPlayer.Character
            if not IsAlive(OtherChar) then continue end
            local foundPart = GetRandomValidPart(OtherChar)
            if foundPart and LocalPlayer:DistanceFromCharacter(foundPart.Position) < 500 then
                table.insert(OthersEnemies, {OtherChar, foundPart})
                BasePart = foundPart
            end
        end
        return BasePart
    end

    local function M1_Attack(BasePart, OthersEnemies)
        local _, Net, temp_RegisterAttack, temp_RegisterHit, _ = M1_CheckAndGetCoreComponents()
        if not (BasePart and OthersEnemies and #OthersEnemies > 0 and temp_RegisterAttack and temp_RegisterHit) then
            M1_State.consecutiveFailures = M1_State.consecutiveFailures + 1
            if M1_State.consecutiveFailures >= M1_State.maxConsecutiveFailures then
                M1_State.Remotes = nil; M1_State.Net = nil; M1_State.RegisterAttack = nil; M1_State.RegisterHit = nil; M1_State.Enemies = nil; M1_State.consecutiveFailures = 0
            end
            return
        end
        M1_State.consecutiveFailures = 0
        local success, _ = pcall(function()
            temp_RegisterAttack:FireServer(0.3)
            temp_RegisterHit:FireServer(BasePart, OthersEnemies)
        end)
        if not success then M1_State.RegisterAttack = nil; M1_State.RegisterHit = nil end
    end

    local function PerformAttackMode1()
        local _, _, _, _, Enemies = M1_CheckAndGetCoreComponents()
        if not Enemies then M1_State.Enemies = nil; return end
        local OthersEnemies = {}
        local Part1 = M1_ProcessEnemies(OthersEnemies, Enemies)
        local Part2 = M1_ProcessRealPlayers(OthersEnemies)
        if #OthersEnemies > 0 then M1_Attack(Part1 or Part2, OthersEnemies) end
    end

    local Settings = { Range = 5000, AttackSpeed = 0.05, AutoScanRemotes = true }
    local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
    local RegisterAttack = Net:WaitForChild("RE/RegisterAttack")
    local RegisterHit = Net:WaitForChild("RE/RegisterHit")
    local RemoteSeed = Net:FindFirstChild("seed")
    local State = { FoundRemote = nil, FoundRemoteId = nil, LastAttack = 0 }

    if Settings.AutoScanRemotes then
        task.spawn(function()
            local folders = { ReplicatedStorage:FindFirstChild("Util"), ReplicatedStorage:FindFirstChild("Common"), ReplicatedStorage:FindFirstChild("Remotes"), ReplicatedStorage:FindFirstChild("Assets"), ReplicatedStorage:FindFirstChild("FX") }
            local function checkChild(child)
                if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
                    State.FoundRemoteId = child:GetAttribute("Id")
                    State.FoundRemote = child
                end
            end
            for _, folder in ipairs(folders) do
                if folder then
                    for _, child in ipairs(folder:GetChildren()) do checkChild(child) end
                    folder.ChildAdded:Connect(checkChild)
                end
            end
        end)
    end

    local function GetTargets()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return {} end
        local targets = {}
        local myPos = root.Position
        local folders = {workspace:FindFirstChild("Enemies"), workspace:FindFirstChild("Characters")}
        for _, folder in ipairs(folders) do
            if not folder then continue end
            for _, model in ipairs(folder:GetChildren()) do
                if model == char then continue end
                local tRoot = model:FindFirstChild("HumanoidRootPart")
                local tHum = model:FindFirstChild("Humanoid")
                if tRoot and tHum and tHum.Health > 0 then
                    local dist = (tRoot.Position - myPos).Magnitude
                    if dist <= Settings.Range then
                        table.insert(targets, { Model = model, Root = tRoot, Head = model:FindFirstChild("Head") or tRoot })
                    end
                end
            end
        end
        return targets
    end

    local function PerformAttackMode2()
        local char = LocalPlayer.Character
        if not char then return end
        local hasTool = char:FindFirstChildOfClass("Tool") or char:FindFirstChild("EquippedWeapon")
        if not hasTool then return end
        local targets = GetTargets()
        if #targets == 0 then return end
        local mainTarget = targets[1]
        local hitList = {}
        for i, target in ipairs(targets) do table.insert(hitList, {target.Model, target.Root}) end
        RegisterAttack:FireServer()
        local fakeHash = tostring(LocalPlayer.UserId):sub(2,4) .. tostring(math.random(10000, 99999))
        pcall(function()
            RegisterHit:FireServer(mainTarget.Head, hitList, {}, fakeHash)
        end)
        if State.FoundRemote and State.FoundRemoteId then
            pcall(function()
                local seedValue = RemoteSeed and RemoteSeed:InvokeServer() or 1
                local encryptedId = bit32.bxor(State.FoundRemoteId + 909090, seedValue * 2)
                local rawName = "RE/RegisterHit"
                local timestamp = math.floor(workspace:GetServerTimeNow() / 10 % 10) + 1
                local encryptedName = string.gsub(rawName, ".", function(c) return string.char(bit32.bxor(string.byte(c), timestamp)) end)
                State.FoundRemote:FireServer(encryptedName, encryptedId, mainTarget.Head, hitList)
            end)
        end
    end

    local function PerformAttack()
        if not _G.G_FastAttack then return end
        if _G.G_FastAttackMode == "模式1" then
            local Character = LocalPlayer.Character
            local Equipped = Character and IsAlive(Character) and Character:FindFirstChildOfClass("Tool")
            if not Equipped or Equipped.ToolTip == "Gun" then return end
            PerformAttackMode1()
        else
            PerformAttackMode2()
        end
    end

    task.spawn(function()
        while true do
            local startTime = tick()
            pcall(PerformAttack)
            if _G.G_FastAttackMode == "模式1" then
                 task.wait(0.3)
            else
                 local elapsed = tick() - startTime
                 local waitTime = math.max(0.05 - elapsed, 0.001)
                 task.wait(waitTime)
            end
        end
    end)
    -- ========================================================

    -- 配置收集與存取函式
    local function CollectConfig()
        return {
            Combat = {
                FastAttackMode = _G.FastAttackMode,
                DragonGunM1 = _G.DragonGunM1,
                DragonGunCooldown = _G.DragonGunCooldown,
                AttackMobs = _G.AttackMobs,
                AttackPlayers = _G.AttackPlayers,
            },
            Auto = {
                AutoHaki = _G.G_AutoHaki,
                AutoV3 = _G.G_AutoV3,
                AutoV4_Enabled = _G.AutoV4_Enabled,
                NoWalkAnimation = _G.G_NoWalkAnimation,
                AutoSmoothWalk = _G.G_AutoSmoothWalk,
                AutoLowHpRace = _G.G_AutoLowHpRace,
                LowHpRaceChoice = _G.G_LowHpRaceChoice,
                AutoFlee = _G.G_AutoFlee,
                AutoFleeHP = _G.G_AutoFleeHP,
            },
            Main = {
                translateSpeed = _G.G_translateSpeed,
                translateAccel = _G.G_translateAccel,
                jumpHeight = _G.G_jumpHeight,
                jumpEnabled = _G.G_jumpEnabled,
                Fly = _G.G_Fly,
                FlySpeed = _G.G_FlySpeed,
                TeleportOffsetX = _G.G_TeleportOffsetX,
                TeleportOffsetY = _G.G_TeleportOffsetY,
                TeleportOffsetZ = _G.G_TeleportOffsetZ,
            },
            ESP = {
                ESPEnabled = _G.G_ESPEnabled,
                ESP_Name = _G.G_ESP_Name,
                ESP_Level = _G.G_ESP_Level,
                ESP_Bounty = _G.G_ESP_Bounty,
                ESP_Fruit = _G.G_ESP_Fruit,
                ESP_Distance = _G.G_ESP_Distance,
                ESP_HP = _G.G_ESP_HP,
                ESP_TextSize = _G.G_ESP_TextSize,
                ESP_Highlight = _G.G_ESP_Highlight,
                ESP_HighlightColor = _G.G_ESP_HighlightColor,
            },
            UI = {
                Theme = _G.G_Theme,
                Language = _G.G_Language,
                AutoSaveConfig = _G.G_AutoSaveConfig,
                AutoLoadConfig = _G.G_AutoLoadConfig,
            }
        }
    end

    local function SaveConfiguration()
        if not _G.G_AutoSaveConfig then return end
        pcall(function()
            if writefile then
                writefile(CONFIG_FILE, HttpService:JSONEncode(CollectConfig()))
            end
        end)
    end

    local function LoadConfiguration()
        if not isfile or not readfile then return end
        if not isfile(CONFIG_FILE) then return end
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if not ok or type(data) ~= "table" then return end

        for category, values in pairs(data) do
            if type(values) == "table" then
                for k, v in pairs(values) do
                    if category == "Combat" then
                        _G[k] = v
                    elseif category == "Auto" then
                        if k == "AutoV4_Enabled" then
                            _G.AutoV4_Enabled = v
                        else
                            _G["G_" .. k] = v
                        end
                    elseif category == "Main" or category == "ESP" or category == "UI" then
                        _G["G_" .. k] = v
                    end
                end
            end
        end
    end

    pcall(function()
        if isfile and readfile and isfile(CONFIG_FILE) then
            local rawData = HttpService:JSONDecode(readfile(CONFIG_FILE))
            if rawData and rawData.UI and rawData.UI.AutoLoadConfig then
                _G.G_AutoLoadConfig = true
                LoadConfiguration()
            end
        end
    end)

    local executorName = identifyexecutor and identifyexecutor() or "Unknown"
    local disableHook = false
    pcall(function()
        if not getrawmetatable or not setreadonly then
            disableHook = true
        end
    end)

    -- ========================================================
    -- 【整合後的現代輕量化飛行腳本 UI (點擊開關型)】
    -- ========================================================
    local flightScreenGui = Instance.new("ScreenGui")
    flightScreenGui.Name = "ModernFlyGui_Compact"
    flightScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    flightScreenGui.ResetOnSpawn = false
    flightScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    flightScreenGui.Enabled = false 

    local Frame = Instance.new("Frame")
    Frame.Name = "MainFrame"
    Frame.Parent = flightScreenGui
    Frame.BackgroundColor3 = Color3.fromRGB(15, 16, 22)
    Frame.BackgroundTransparency = 0.15
    Frame.Position = UDim2.new(0.1, 0, 0.35, 0)
    Frame.Size = UDim2.new(0, 220, 0, 215)
    Frame.ClipsDescendants = true
    Frame.Active = true
    Frame.Draggable = true

    local FrameCorner = Instance.new("UICorner")
    FrameCorner.CornerRadius = UDim.new(0, 10)
    FrameCorner.Parent = Frame

    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Thickness = 1.5
    FrameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    FrameStroke.Parent = Frame

    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Parent = Frame
    TopBar.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
    TopBar.BackgroundTransparency = 0.2
    TopBar.Size = UDim2.new(1, 0, 0, 32)

    local TopCorner = Instance.new("UICorner")
    TopCorner.CornerRadius = UDim.new(0, 10)
    TopCorner.Parent = TopBar

    local TitleLabelFly = Instance.new("TextLabel")
    TitleLabelFly.Parent = TopBar
    TitleLabelFly.BackgroundTransparency = 1
    TitleLabelFly.Position = UDim2.new(0, 10, 0, 0)
    TitleLabelFly.Size = UDim2.new(0, 140, 1, 0)
    TitleLabelFly.Font = Enum.Font.GothamBold
    TitleLabelFly.Text = "⚡ COMPACT FLY"
    TitleLabelFly.TextSize = 13
    TitleLabelFly.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabelFly.TextXAlignment = Enum.TextXAlignment.Left

    local Controls = Instance.new("Frame")
    Controls.Parent = TopBar
    Controls.BackgroundTransparency = 1
    Controls.Position = UDim2.new(1, -55, 0, 0)
    Controls.Size = UDim2.new(0, 50, 1, 0)

    local mini = Instance.new("TextButton")
    mini.Parent = Controls
    mini.BackgroundTransparency = 1
    mini.Size = UDim2.new(0, 25, 1, 0)
    mini.Font = Enum.Font.GothamBold
    mini.Text = "-"
    mini.TextColor3 = Color3.fromRGB(180, 185, 200)
    mini.TextSize = 12

    local closebutton = Instance.new("TextButton")
    closebutton.Parent = Controls
    closebutton.BackgroundTransparency = 1
    closebutton.Position = UDim2.new(0, 25, 0, 0)
    closebutton.Size = UDim2.new(0, 25, 1, 0)
    closebutton.Font = Enum.Font.GothamBold
    closebutton.Text = "x"
    closebutton.TextColor3 = Color3.fromRGB(255, 90, 90)
    closebutton.TextSize = 13

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = "ContentFrame"
    ContentFrame.Parent = Frame
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.Position = UDim2.new(0, 8, 0, 38)
    ContentFrame.Size = UDim2.new(1, -16, 1, -44)

    local noclip = Instance.new("TextButton")
    noclip.Name = "NoclipButton"
    noclip.Parent = ContentFrame
    noclip.BackgroundColor3 = Color3.fromRGB(28, 31, 43)
    noclip.Position = UDim2.new(0, 0, 0, 0)
    noclip.Size = UDim2.new(0.48, -2, 0, 45)
    noclip.Font = Enum.Font.GothamBold
    noclip.Text = "穿牆 [ OFF ]"
    noclip.TextColor3 = Color3.fromRGB(160, 165, 185)
    noclip.TextSize = 12

    local noclipCorner = Instance.new("UICorner")
    noclipCorner.CornerRadius = UDim.new(0, 8)
    noclipCorner.Parent = noclip

    local noclipStroke = Instance.new("UIStroke")
    noclipStroke.Color = Color3.fromRGB(45, 50, 68)
    noclipStroke.Thickness = 1
    noclipStroke.Parent = noclip

    local onof = Instance.new("TextButton")
    onof.Name = "FlyButton"
    onof.Parent = ContentFrame
    onof.BackgroundColor3 = Color3.fromRGB(28, 31, 43)
    onof.Position = UDim2.new(0.52, 2, 0, 0)
    onof.Size = UDim2.new(0.48, -2, 0, 45)
    onof.Font = Enum.Font.GothamBold
    onof.Text = "飛行 [ OFF ]"
    onof.TextColor3 = Color3.fromRGB(160, 165, 185)
    onof.TextSize = 12

    local onofCorner = Instance.new("UICorner")
    onofCorner.CornerRadius = UDim.new(0, 8)
    onofCorner.Parent = onof

    local onofStroke = Instance.new("UIStroke")
    onofStroke.Color = Color3.fromRGB(45, 50, 68)
    onofStroke.Thickness = 1
    onofStroke.Parent = onof

    local SpeedPanel = Instance.new("Frame")
    SpeedPanel.Parent = ContentFrame
    SpeedPanel.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
    SpeedPanel.BackgroundTransparency = 0.3
    SpeedPanel.Position = UDim2.new(0, 0, 0, 52)
    SpeedPanel.Size = UDim2.new(1, 0, 0, 45)

    local speedCorner = Instance.new("UICorner")
    speedCorner.CornerRadius = UDim.new(0, 8)
    speedCorner.Parent = SpeedPanel

    local speedStroke = Instance.new("UIStroke")
    speedStroke.Color = Color3.fromRGB(40, 45, 60)
    speedStroke.Thickness = 1
    speedStroke.Parent = SpeedPanel

    local mine = Instance.new("TextButton")
    mine.Parent = SpeedPanel
    mine.BackgroundColor3 = Color3.fromRGB(35, 39, 54)
    mine.Position = UDim2.new(0, 6, 0.5, -14)
    mine.Size = UDim2.new(0, 28, 0, 28)
    mine.Font = Enum.Font.GothamBold
    mine.Text = "-"
    mine.TextColor3 = Color3.fromRGB(255, 255, 255)
    mine.TextSize = 13

    local mineCorner = Instance.new("UICorner")
    mineCorner.CornerRadius = UDim.new(0, 6)
    mineCorner.Parent = mine

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Parent = SpeedPanel
    speedLabel.BackgroundTransparency = 1
    speedLabel.Position = UDim2.new(0, 35, 0, 0)
    speedLabel.Size = UDim2.new(1, -70, 1, 0)
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.Text = "速度: " .. (_G.G_FlySpeed or 1)
    speedLabel.TextColor3 = Color3.fromRGB(240, 240, 255)
    speedLabel.TextSize = 13

    local plus = Instance.new("TextButton")
    plus.Parent = SpeedPanel
    plus.BackgroundColor3 = Color3.fromRGB(35, 39, 54)
    plus.Position = UDim2.new(1, -34, 0.5, -14)
    plus.Size = UDim2.new(0, 28, 0, 28)
    plus.Font = Enum.Font.GothamBold
    plus.Text = "+"
    plus.TextColor3 = Color3.fromRGB(255, 255, 255)
    plus.TextSize = 13

    local plusCorner = Instance.new("UICorner")
    plusCorner.CornerRadius = UDim.new(0, 6)
    plusCorner.Parent = plus

    local downButton = Instance.new("TextButton")
    downButton.Name = "DownButton"
    downButton.Parent = ContentFrame
    downButton.BackgroundColor3 = Color3.fromRGB(28, 31, 43)
    downButton.Position = UDim2.new(0, 0, 0, 104)
    downButton.Size = UDim2.new(0.48, -2, 0, 45)
    downButton.Font = Enum.Font.GothamBold
    downButton.Text = "下降 (Q)"
    downButton.TextColor3 = Color3.fromRGB(200, 210, 240)
    downButton.TextSize = 12

    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 8)
    downCorner.Parent = downButton

    local downStroke = Instance.new("UIStroke")
    downStroke.Color = Color3.fromRGB(45, 50, 68)
    downStroke.Thickness = 1
    downStroke.Parent = downButton

    local upButton = Instance.new("TextButton")
    upButton.Name = "UpButton"
    upButton.Parent = ContentFrame
    upButton.BackgroundColor3 = Color3.fromRGB(28, 31, 43)
    upButton.Position = UDim2.new(0.52, 2, 0, 104)
    upButton.Size = UDim2.new(0.48, -2, 0, 45)
    upButton.Font = Enum.Font.GothamBold
    upButton.Text = "上升 (E)"
    upButton.TextColor3 = Color3.fromRGB(200, 210, 240)
    upButton.TextSize = 12

    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 8)
    upCorner.Parent = upButton

    local upStroke = Instance.new("UIStroke")
    upStroke.Color = Color3.fromRGB(45, 50, 68)
    upStroke.Thickness = 1
    upStroke.Parent = upButton

    local noclipOn = false
    local noclipConnection = nil
    local flying = false
    local flyConnection = nil
    local isMinimized = false
    local ctrl = {f = 0, b = 0, l = 0, r = 0, u = 0, d = 0}

    local keyMap = {
        [Enum.KeyCode.W] = "f",
        [Enum.KeyCode.S] = "b",
        [Enum.KeyCode.A] = "l",
        [Enum.KeyCode.D] = "r",
        [Enum.KeyCode.E] = "u",
        [Enum.KeyCode.Q] = "d"
    }

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        local dir = keyMap[input.KeyCode]
        if dir then
            ctrl[dir] = (dir == "b" or dir == "l" or dir == "d") and -1 or 1
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        local dir = keyMap[input.KeyCode]
        if dir then
            ctrl[dir] = 0
        end
    end)

    local isDownActive, isUpActive = false, false

    downButton.MouseButton1Down:Connect(function()
        isDownActive = not isDownActive
        ctrl.d = isDownActive and -1 or 0
        downButton.TextColor3 = isDownActive and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(200, 210, 240)
    end)

    upButton.MouseButton1Down:Connect(function()
        isUpActive = not isUpActive
        ctrl.u = isUpActive and 1 or 0
        upButton.TextColor3 = isUpActive and Color3.fromRGB(0, 255, 170) or Color3.fromRGB(200, 210, 240)
    end)

    local hue = 0
    RunService.RenderStepped:Connect(function(delta)
        hue = (hue + delta * 0.25) % 1
        local rgbColor = Color3.fromHSV(hue, 0.8, 1)
        FrameStroke.Color = rgbColor
        TitleLabelFly.TextColor3 = rgbColor

        if noclipOn then noclipStroke.Color = rgbColor end
        if flying then onofStroke.Color = rgbColor end
    end)

    local function tween(obj, properties, time, easingStyle)
        TweenService:Create(obj, TweenInfo.new(time or 0.15, easingStyle or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties):Play()
    end

    local function stopFlying()
        flying = false
        _G.G_Fly = false
        ctrl.u = 0
        ctrl.d = 0
        isDownActive, isUpActive = false, false
        downButton.TextColor3 = Color3.fromRGB(200, 210, 240)
        upButton.TextColor3 = Color3.fromRGB(200, 210, 240)
        
        onof.Text = "飛行 [ OFF ]"
        onof.TextColor3 = Color3.fromRGB(160, 165, 185)
        tween(onof, {BackgroundColor3 = Color3.fromRGB(28, 31, 43)})
        onofStroke.Color = Color3.fromRGB(45, 50, 68)

        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end

        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
            local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
            if root then
                if root:FindFirstChild("FlyBodyGyro") then root.FlyBodyGyro:Destroy() end
                if root:FindFirstChild("FlyBodyVelocity") then root.FlyBodyVelocity:Destroy() end
            end
            if char:FindFirstChild("Animate") then char.Animate.Disabled = false end
        end
    end

    local function startFlying()
        flying = true
        _G.G_Fly = true
        onof.Text = "飛行 [ ON ]"
        onof.TextColor3 = Color3.fromRGB(255, 255, 255)
        tween(onof, {BackgroundColor3 = Color3.fromRGB(120, 60, 235)})

        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")

        if not rootPart or not hum then return end

        hum.PlatformStand = true
        if char:FindFirstChild("Animate") then char.Animate.Disabled = true end

        local bg = Instance.new("BodyGyro")
        bg.Name = "FlyBodyGyro"
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = rootPart.CFrame
        bg.Parent = rootPart

        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlyBodyVelocity"
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Parent = rootPart

        local baseSpeed = 50

        flyConnection = RunService.RenderStepped:Connect(function()
            if not flying or not rootPart or not rootPart.Parent or not hum or hum.Health <= 0 then
                stopFlying()
                return
            end

            local cam = workspace.CurrentCamera
            local forward = cam.CFrame.LookVector * (ctrl.f + ctrl.b)
            local right = cam.CFrame.RightVector * (ctrl.r + ctrl.l)
            local up = Vector3.new(0, ctrl.u + ctrl.d, 0)

            local moveDir = forward + right + up

            if moveDir.Magnitude > 0 then
                bv.velocity = moveDir.Unit * (baseSpeed * (_G.G_FlySpeed or 1))
            else
                bv.velocity = Vector3.new(0, 0, 0)
            end

            bg.cframe = cam.CFrame
        end)
    end

    onof.MouseButton1Click:Connect(function()
        if flying then
            stopFlying()
        else
            startFlying()
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function()
        stopFlying()
    end)

    noclip.MouseButton1Click:Connect(function()
        noclipOn = not noclipOn
        if noclipOn then
            noclip.Text = "穿牆 [ ON ]"
            noclip.TextColor3 = Color3.fromRGB(255, 255, 255)
            tween(noclip, {BackgroundColor3 = Color3.fromRGB(0, 170, 120)})
            noclipConnection = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            noclip.Text = "穿牆 [ OFF ]"
            noclip.TextColor3 = Color3.fromRGB(160, 165, 185)
            tween(noclip, {BackgroundColor3 = Color3.fromRGB(28, 31, 43)})
            noclipStroke.Color = Color3.fromRGB(45, 50, 68)
            if noclipConnection then noclipConnection:Disconnect() end
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end)

    plus.MouseButton1Down:Connect(function()
        _G.G_FlySpeed = (_G.G_FlySpeed or 1) + 1
        speedLabel.Text = "速度: " .. tostring(_G.G_FlySpeed)
        SaveConfiguration()
    end)

    mine.MouseButton1Down:Connect(function()
        _G.G_FlySpeed = math.max(1, (_G.G_FlySpeed or 1) - 1)
        speedLabel.Text = "速度: " .. tostring(_G.G_FlySpeed)
        SaveConfiguration()
    end)

    closebutton.MouseButton1Click:Connect(function()
        stopFlying()
        if noclipConnection then noclipConnection:Disconnect() end
        flightScreenGui:Destroy()
    end)

    mini.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            ContentFrame.Visible = false
            tween(Frame, {Size = UDim2.new(0, 220, 0, 32)}, 0.2)
            mini.Text = "□"
        else
            tween(Frame, {Size = UDim2.new(0, 220, 0, 215)}, 0.2)
            task.wait(0.1)
            ContentFrame.Visible = true
            mini.Text = "-"
        end
    end)

    -- Aimbot 邏輯程式碼
    local LastSkillPressed = "M1 (普攻)"

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if UserInputService:GetFocusedTextBox() then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            LastSkillPressed = "M1 (普攻)"
        elseif input.KeyCode == Enum.KeyCode.Z then
            LastSkillPressed = "Z"
        elseif input.KeyCode == Enum.KeyCode.X then
            LastSkillPressed = "X"
        elseif input.KeyCode == Enum.KeyCode.C then
            LastSkillPressed = "C"
        elseif input.KeyCode == Enum.KeyCode.V then
            LastSkillPressed = "V"
        elseif input.KeyCode == Enum.KeyCode.F then
            LastSkillPressed = "F"
        elseif input.KeyCode == Enum.KeyCode.R then
            LastSkillPressed = "R"
        end
    end)

    local function IsSkillSelected(skillName)
        local skills = _G.SilentAimSkills
        if not skills then return true end
        if type(skills) == "table" then
            if next(skills) == nil then return false end
            if skills[skillName] ~= nil then return skills[skillName] == true end
            for _, v in pairs(skills) do
                if v == skillName then return true end
            end
            return false
        end
        return true
    end

    local function IsCurrentSkillEnabled()
        return IsSkillSelected(LastSkillPressed)
    end

    local function IsSilentAimAlly(player)
        if not player then return false end
        local main = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main")
        if not main then return false end
        local allies = main:FindFirstChild("Allies")
        local container = allies and allies:FindFirstChild("Container")
        local subAllies = container and container:FindFirstChild("Allies")
        if not subAllies then return false end
        local frame = subAllies:FindFirstChild("Frame") or (subAllies:FindFirstChild("ScrollingFrame") and subAllies.ScrollingFrame:FindFirstChild("Frame"))
        if not frame then return false end
        return frame:FindFirstChild(player.Name) ~= nil
    end

    local function IsSilentAimEnemy(player)
        if not player or player == LocalPlayer then return false end
        if IsSilentAimAlly(player) then return false end
        local myTeam = LocalPlayer.Team
        local targetTeam = player.Team
        if myTeam and targetTeam and myTeam.Name == "Marines" and targetTeam.Name == "Marines" then
            return false
        end
        return true
    end

    local function GetSilentAimOrigin()
        local p = UserInputService:GetMouseLocation()
        if _G.SilentAimFOVMode == "屏幕中心" or p.X <= 0 or p.Y <= 0 then
            local v = Camera.ViewportSize
            return Vector2.new(v.X / 2, v.Y / 2)
        end
        return p
    end

    local SnapLineThickness = 2.8
    local RainbowSnapLine = true
    local LaserPulseSpeed = 10
    local BaseLaserColor = Color3.fromRGB(0, 240, 255)

    local FovCircle = Drawing.new("Circle")
    FovCircle.NumSides = 96
    FovCircle.Thickness = 1.5
    FovCircle.Color = Color3.fromRGB(255, 255, 255)
    FovCircle.Filled = false
    FovCircle.Transparency = 1
    FovCircle.Visible = false
    table.insert(_G.SilentAimDrawings, FovCircle)

    local LaserGlowLayers = {}
    for i = 1, 7 do
        local glowLine = Drawing.new("Line")
        glowLine.Visible = false
        table.insert(_G.SilentAimDrawings, glowLine)
        table.insert(LaserGlowLayers, glowLine)
    end

    local SnapLineCore = Drawing.new("Line")
    SnapLineCore.Visible = false
    table.insert(_G.SilentAimDrawings, SnapLineCore)

    local LaserBeads = {}
    for i = 1, 6 do
        local bead = Drawing.new("Circle")
        bead.NumSides = 16
        bead.Filled = true
        bead.Visible = false
        table.insert(_G.SilentAimDrawings, bead)
        table.insert(LaserBeads, bead)
    end

    local TargetLockRings = {}
    for i = 1, 4 do
        local ring = Drawing.new("Circle")
        ring.NumSides = 48
        ring.Thickness = (i == 1) and 2.5 or 1.2
        ring.Filled = false
        ring.Visible = false
        table.insert(_G.SilentAimDrawings, ring)
        table.insert(TargetLockRings, ring)
    end

    local TargetLockCenterDot = Drawing.new("Circle")
    TargetLockCenterDot.NumSides = 20
    TargetLockCenterDot.Filled = true
    TargetLockCenterDot.Visible = false
    table.insert(_G.SilentAimDrawings, TargetLockCenterDot)

    local TargetCornerBrackets = {}
    for i = 1, 8 do
        local line = Drawing.new("Line")
        line.Thickness = 2.2
        line.Visible = false
        table.insert(_G.SilentAimDrawings, line)
        table.insert(TargetCornerBrackets, line)
    end

    local currentSilentAimTarget = nil
    local currentSilentAimTargetPos = nil
    local currentTargetDistance = math.huge

    local function GetClosestSilentAimTarget()
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil, math.huge end

        if _G.SilentAimTargetMode == "指定玩家" then
            local targetPlr = _G.SilentAimSelectedPlayer
            if targetPlr and targetPlr.Parent and targetPlr.Character then
                if not _G.SilentAimTeamCheck or IsSilentAimEnemy(targetPlr) then
                    local char = targetPlr.Character
                    if IsAlive(char) then
                        local part = char:FindFirstChild("HumanoidRootPart")
                        if part then
                            local dist = (part.Position - myRoot.Position).Magnitude
                            local passFOV = true
                            if _G.SilentAimShowFOV then
                                local origin = GetSilentAimOrigin()
                                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                                if onScreen then
                                    local screenDist = (Vector2.new(pos.X, pos.Y) - origin).Magnitude
                                    if screenDist > _G.SilentAimFOV then passFOV = false end
                                else
                                    passFOV = false
                                end
                            end
                            if passFOV then return part, dist end
                        end
                    end
                end
            end
            return nil, math.huge
        end

        local closest = nil
        local shortest = math.huge

        local function check(character)
            if not IsAlive(character) then return end
            local part = character:FindFirstChild("HumanoidRootPart")
            if not part then return end
            local dist = (part.Position - myRoot.Position).Magnitude
            local passFOV = true
            if _G.SilentAimShowFOV then
                local origin = GetSilentAimOrigin()
                local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local screenDist = (Vector2.new(pos.X, pos.Y) - origin).Magnitude
                    if screenDist > _G.SilentAimFOV then passFOV = false end
                else
                    passFOV = false
                end
            end
            if passFOV and dist < shortest then
                closest = part
                shortest = dist
            end
        end

        if _G.SilentAimTargetPlayers then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if not _G.SilentAimTeamCheck or IsSilentAimEnemy(player) then
                        check(player.Character)
                    end
                end
            end
        end

        if _G.SilentAimTargetMobs then
            local enemiesFolder = workspace:FindFirstChild("Enemies")
            if enemiesFolder then
                for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                    check(enemy)
                end
            end
        end

        return closest, shortest
    end

    if not _G.SilentAimHooked and not disableHook then
        _G.SilentAimHooked = true

        task.spawn(function()
            local MouseModuleInstance = ReplicatedStorage:WaitForChild("Mouse", 5)
            if MouseModuleInstance then
                pcall(function()
                    local MouseModule = require(MouseModuleInstance)
                    if typeof(MouseModule) == "table" then
                        local realStore = { Hit = rawget(MouseModule, "Hit"), Target = rawget(MouseModule, "Target") }
                        local mmt = getrawmetatable(MouseModule) or {}
                        setreadonly(mmt, false)
                        rawset(MouseModule, "Hit", nil)
                        rawset(MouseModule, "Target", nil)
                        mmt.__index = function(self, key)
                            if key == "Hit" then
                                if _G.SilentAimEnabled and currentSilentAimTargetPos and IsCurrentSkillEnabled() then
                                    return CFrame.new(currentSilentAimTargetPos)
                                end
                                return realStore.Hit
                            elseif key == "Target" then
                                if _G.SilentAimEnabled and currentSilentAimTarget and IsCurrentSkillEnabled() then
                                    return currentSilentAimTarget
                                end
                                return realStore.Target
                            end
                            return rawget(self, key)
                        end
                        mmt.__newindex = function(self, key, value)
                            if key == "Hit" or key == "Target" then realStore[key] = value else rawset(self, key, value) end
                        end
                        setreadonly(mmt, true)
                        setmetatable(MouseModule, mmt)
                    end
                end)
            end
        end)

        local gmt = getrawmetatable(game)
        if gmt then
            setreadonly(gmt, false)
            local oldIndex = gmt.__index
            local mouse = LocalPlayer:GetMouse()
            gmt.__index = newcclosure(function(self, key)
                if not checkcaller() and _G.SilentAimEnabled and currentSilentAimTargetPos and self == mouse and IsCurrentSkillEnabled() then
                    local targetPos = currentSilentAimTargetPos
                    local camPos = Camera.CFrame.Position
                    if key == "Hit" then return CFrame.new(targetPos)
                    elseif key == "Target" then return currentSilentAimTarget
                    elseif key == "UnitRay" then return Ray.new(camPos, (targetPos - camPos).Unit)
                    elseif key == "Origin" then return CFrame.new(camPos)
                    elseif key == "Direction" then return (targetPos - camPos).Unit end
                end
                return oldIndex(self, key)
            end)
            setreadonly(gmt, true)
        end
    end

    local function HideAllLaserDrawings()
        for _, glow in ipairs(LaserGlowLayers) do glow.Visible = false end
        SnapLineCore.Visible = false
        for _, bead in ipairs(LaserBeads) do bead.Visible = false end
        for _, ring in ipairs(TargetLockRings) do ring.Visible = false end
        TargetLockCenterDot.Visible = false
        for _, bracket in ipairs(TargetCornerBrackets) do bracket.Visible = false end
    end

    if _G.SilentAimLoop then _G.SilentAimLoop:Disconnect() end

    _G.SilentAimLoop = RunService.RenderStepped:Connect(function()
        local origin = GetSilentAimOrigin()
        local clockTime = os.clock()

        if _G.SilentAimShowFOV then
            FovCircle.Visible = true
            FovCircle.Radius = _G.SilentAimFOV
            FovCircle.Position = origin
            FovCircle.Thickness = _G.SilentAimFOVThickness
            FovCircle.Color = RainbowSnapLine and Color3.fromHSV((clockTime * 0.2) % 1, 0.5, 1) or Color3.fromRGB(255, 255, 255)
            FovCircle.Transparency = _G.SilentAimFOVTransparency
        else
            FovCircle.Visible = false
        end

        currentSilentAimTarget, currentTargetDistance = GetClosestSilentAimTarget()
        currentSilentAimTargetPos = currentSilentAimTarget and currentSilentAimTarget.Position or nil
        _G.SilentAimTargetPos = currentSilentAimTargetPos

        if _G.SilentAimShowLine and currentSilentAimTargetPos then
            local pos, onScreen = Camera:WorldToViewportPoint(currentSilentAimTargetPos)
            if onScreen then
                local targetScreenPos = Vector2.new(pos.X, pos.Y)
                local lineVector = targetScreenPos - origin
                local clampedDist = math.clamp(currentTargetDistance, 10, 300)
                local distFactor = (clampedDist - 10) / (300 - 10)
                local distanceBaseRadius = math.clamp(38 * (1 - distFactor * 0.5), 14, 45)
                local glowThicknessScale = 1 + (distFactor * 0.5)
                local particleSpeedMultiplier = 1.2 + ((1 - distFactor) * 1.8)
                local baseHue = (clockTime * LaserPulseSpeed * 0.06) % 1
                local pulseWave = math.sin(clockTime * LaserPulseSpeed)
                local cosPulse = math.cos(clockTime * LaserPulseSpeed * 1.4)
                local alphaPulse = 0.85 + (pulseWave * 0.15)

                local coreColor, glowColorBase
                if RainbowSnapLine then
                    coreColor = Color3.fromRGB(255, 255, 255)
                    glowColorBase = Color3.fromHSV(baseHue, 0.85, 1)
                else
                    local lerpFactor = (pulseWave + 1) / 2
                    glowColorBase = BaseLaserColor:Lerp(Color3.fromRGB(180, 240, 255), lerpFactor * 0.4)
                    coreColor = Color3.fromRGB(245, 255, 255)
                end

                local glowMultipliers = {14.0, 9.0, 5.5, 3.2, 2.0, 1.3, 0.8}
                local alphaMultipliers = {0.03, 0.06, 0.12, 0.22, 0.38, 0.60, 0.85}

                for i, glow in ipairs(LaserGlowLayers) do
                    glow.Visible = true
                    glow.From = origin
                    glow.To = targetScreenPos
                    glow.Thickness = SnapLineThickness * glowMultipliers[i] * glowThicknessScale
                    if RainbowSnapLine then
                        local phaseShift = (baseHue + (i * 0.02)) % 1
                        glow.Color = Color3.fromHSV(phaseShift, 0.8, 1)
                    else
                        glow.Color = glowColorBase
                    end
                    glow.Transparency = alphaMultipliers[i] * alphaPulse
                end

                SnapLineCore.Visible = true
                SnapLineCore.From = origin
                SnapLineCore.To = targetScreenPos
                SnapLineCore.Color = coreColor
                SnapLineCore.Thickness = SnapLineThickness * 0.8
                SnapLineCore.Transparency = 1.0

                for i, bead in ipairs(LaserBeads) do
                    local speed = (0.4 + (i * 0.1)) * particleSpeedMultiplier
                    local offset = (i - 1) * (1 / #LaserBeads)
                    local progress = (clockTime * speed + offset) % 1
                    bead.Visible = true
                    bead.Position = origin + (lineVector * progress)
                    local beadPulse = math.sin(clockTime * 20 + i) * 0.5 + 1
                    bead.Radius = SnapLineThickness * (1.1 + beadPulse * 0.6)
                    bead.Color = RainbowSnapLine and Color3.fromHSV((baseHue + progress * 0.3) % 1, 0.5, 1) or Color3.fromRGB(255, 255, 255)
                    local fadeMask = math.sin(progress * math.pi)
                    bead.Transparency = 0.95 * fadeMask
                end

                local currentRadius = distanceBaseRadius + (pulseWave * 2.5)

                TargetLockRings[1].Visible = true
                TargetLockRings[1].Position = targetScreenPos
                TargetLockRings[1].Radius = currentRadius
                TargetLockRings[1].Color = glowColorBase
                TargetLockRings[1].Transparency = 0.9

                TargetLockRings[2].Visible = true
                TargetLockRings[2].Position = targetScreenPos
                TargetLockRings[2].Radius = currentRadius * 1.55 + (cosPulse * 4)
                TargetLockRings[2].Color = RainbowSnapLine and Color3.fromHSV((baseHue + 0.12) % 1, 0.85, 1) or glowColorBase
                TargetLockRings[2].Transparency = 0.4 * alphaPulse

                TargetLockRings[3].Visible = true
                TargetLockRings[3].Position = targetScreenPos
                TargetLockRings[3].Radius = math.max(3, currentRadius * 0.4 - (pulseWave * 1.5))
                TargetLockRings[3].Color = Color3.fromRGB(255, 255, 255)
                TargetLockRings[3].Transparency = 0.95

                TargetLockRings[4].Visible = true
                TargetLockRings[4].Position = targetScreenPos
                TargetLockRings[4].Radius = currentRadius * 2.2
                TargetLockRings[4].Color = glowColorBase
                TargetLockRings[4].Transparency = 0.15

                TargetLockCenterDot.Visible = true
                TargetLockCenterDot.Position = targetScreenPos
                TargetLockCenterDot.Radius = math.clamp(distanceBaseRadius * 0.12, 1.8, 3.5)
                TargetLockCenterDot.Color = RainbowSnapLine and Color3.fromHSV(baseHue, 1, 1) or Color3.fromRGB(255, 255, 255)
                TargetLockCenterDot.Transparency = 1.0

                local boxSize = currentRadius * 1.3
                local bracketLen = boxSize * 0.45
                local rotation = clockTime * (1.5 + (1 - distFactor))

                local corners = {
                    Vector2.new(-boxSize, -boxSize),
                    Vector2.new(boxSize, -boxSize),
                    Vector2.new(boxSize, boxSize),
                    Vector2.new(-boxSize, boxSize)
                }

                for i = 1, 4 do
                    local offset = corners[i]
                    local cosR, sinR = math.cos(rotation), math.sin(rotation)
                    local rotX = offset.X * cosR - offset.Y * sinR
                    local rotY = offset.X * sinR + offset.Y * cosR
                    local cornerPos = targetScreenPos + Vector2.new(rotX, rotY)
                    local dirX = (i == 1 or i == 4) and 1 or -1
                    local dirY = (i == 1 or i == 2) and 1 or -1

                    local lineH = TargetCornerBrackets[(i - 1) * 2 + 1]
                    lineH.Visible = true
                    lineH.From = cornerPos
                    lineH.To = cornerPos + Vector2.new(dirX * bracketLen * cosR, dirX * bracketLen * sinR)
                    lineH.Color = glowColorBase
                    lineH.Transparency = 0.85

                    local lineV = TargetCornerBrackets[(i - 1) * 2 + 2]
                    lineV.Visible = true
                    lineV.From = cornerPos
                    lineV.To = cornerPos + Vector2.new(-dirY * bracketLen * sinR, dirY * bracketLen * cosR)
                    lineV.Color = glowColorBase
                    lineV.Transparency = 0.85
                end
            else
                HideAllLaserDrawings()
            end
        else
            HideAllLaserDrawings()
        end
    end)

    -- DragonGun 邏輯程式碼
    task.spawn(function()
        local Modules = ReplicatedStorage:WaitForChild("Modules", 5)
        if not Modules then return end
        local DragonNet = Modules:WaitForChild("Net", 5)
        if not DragonNet then return end
        local ShootGunEvent = DragonNet:WaitForChild("RE/ShootGunEvent", 5)
        local Validator2 = ReplicatedStorage:WaitForChild("Remotes", 5) and ReplicatedStorage.Remotes:WaitForChild("Validator2", 5)
        local getupval = debug.getupvalue or getupvalue
        local setupval = debug.setupvalue or setupvalue
        local getupvals = debug.getupvalues or getupvalues
        local ShootFunction
        local V_Idx = { v26 = 12, v22 = 13, v25 = 14, v21 = 15, v23 = 16, v24 = 17, v27 = 18 }
        
        local function InitDragonGun()
            local success, result = pcall(require, ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("CombatController"))
            if success and type(result) == "table" and result.Attack then 
                ShootFunction = getupval(result.Attack, 9) 
            end
        end
        
        local function GetNextValidator()
            if not ShootFunction then InitDragonGun() end
            if not ShootFunction then return 0, 0 end
            local upvals = getupvals(ShootFunction)
            if not upvals then return 0, 0 end
            if upvals[V_Idx.v21] ~= 727595 then
                for i, v in pairs(upvals) do
                    if v == 727595 then
                        local offset = i - 15
                        V_Idx.v21 = i; V_Idx.v22 = 13 + offset; V_Idx.v23 = 16 + offset; V_Idx.v24 = 17 + offset
                        V_Idx.v26 = 12 + offset; V_Idx.v25 = 14 + offset; V_Idx.v27 = 18 + offset
                        break
                    end
                end
            end
            local v1 = getupval(ShootFunction, V_Idx.v21)
            local v2 = getupval(ShootFunction, V_Idx.v22)
            local v3 = getupval(ShootFunction, V_Idx.v23)
            local v4 = getupval(ShootFunction, V_Idx.v24)
            local v5 = getupval(ShootFunction, V_Idx.v25)
            local v6 = getupval(ShootFunction, V_Idx.v26)
            local v7 = getupval(ShootFunction, V_Idx.v27)
            if not (v1 and v2 and v3 and v4 and v5 and v6 and v7) then return 0, 0 end
            local v8 = v6 * v2
            local v9 = (v5 * v2 + v6 * v1) % v3
            v9 = (v9 * v3 + v8) % v4
            v5 = math.floor(v9 / v3)
            v6 = v9 - v5 * v3
            v7 = v7 + 1
            setupval(ShootFunction, V_Idx.v25, v5); setupval(ShootFunction, V_Idx.v26, v6); setupval(ShootFunction, V_Idx.v27, v7)
            return math.floor(v9 / v4 * 16777215), v7
        end
        
        local function GetClosestDragonTarget()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return nil end
            local closest, dist = nil, math.huge
            local myPos = root.Position
            
            if _G.AttackMobs then
                local enemiesFolder = workspace:FindFirstChild("Enemies")
                if enemiesFolder then
                    for _, enemy in enemiesFolder:GetChildren() do
                        local eHum = enemy:FindFirstChildOfClass("Humanoid")
                        local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                        if eHum and eHum.Health > 0 and eRoot then
                            local d = (eRoot.Position - myPos).Magnitude
                            if d < dist then dist = d; closest = eRoot end
                        end
                    end
                end
            end
            
            if _G.AttackPlayers then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        if not _G.SilentAimTeamCheck or IsSilentAimEnemy(player) then
                            local pHum = player.Character:FindFirstChildOfClass("Humanoid")
                            local pRoot = player.Character:FindFirstChild("HumanoidRootPart")
                            if pHum and pHum.Health > 0 and pRoot then
                                local d = (pRoot.Position - myPos).Magnitude
                                if d < dist then dist = d; closest = pRoot end
                            end
                        end
                    end
                end
            end
            return closest
        end
        
        while true do
            task.wait(_G.DragonGunCooldown)
            if not _G.DragonGunM1 then continue end
            pcall(function()
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                if not tool or tool.ToolTip ~= "Gun" then return end
                local targetPart = GetClosestDragonTarget()
                if not targetPart then return end
                local valCode, valCount = GetNextValidator()
                if valCode ~= 0 and Validator2 then Validator2:FireServer(valCode, valCount) end
                tool:SetAttribute("LocalOverheat", 0)
                tool:SetAttribute("LocalTotalShots", (tool:GetAttribute("LocalTotalShots") or 0) + 1)
                if ShootGunEvent then ShootGunEvent:FireServer(targetPart.Position, { targetPart }) end
            end)
        end
    end)

    -- 平滑傳送相關函式
    local ActiveTween = nil
    local function SetNoCollide()
        local character = LocalPlayer.Character
        if not character then return end
        for _, v in ipairs(character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    local function SetCollide()
        local character = LocalPlayer.Character
        if not character then return end
        for _, v in ipairs(character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
    local function topos(Pos)
        if not LocalPlayer or not LocalPlayer.Character then return end
        local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if not HRP or not Humanoid then return end

        HRP.AssemblyLinearVelocity = Vector3.zero
        HRP.AssemblyAngularVelocity = Vector3.zero
        Humanoid:ChangeState(Enum.HumanoidStateType.Physics)

        local Distance = (Pos.Position - HRP.Position).Magnitude
        local Speed = 300

        if ActiveTween then ActiveTween:Cancel() end

        ActiveTween = TweenService:Create(
            HRP,
            TweenInfo.new(Distance / Speed, Enum.EasingStyle.Linear),
            {CFrame = Pos}
        )

        local isActive = true
        task.spawn(function()
            while isActive and ActiveTween and ActiveTween.PlaybackState == Enum.PlaybackState.Playing do
                SetNoCollide()
                task.wait(0.001)
            end
        end)

        ActiveTween:Play()

        ActiveTween.Completed:Connect(function()
            isActive = false
            if Humanoid then
                SetCollide()
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
        
        task.delay(0.05, function()
            if Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Running) end
        end)
    end
    local function StopTween()
        if ActiveTween then ActiveTween:Cancel(); ActiveTween = nil end
    end

    local WindUI = loadstring(request({
        Url = "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
    }).Body)()

    WindUI:SetTheme("Dark")

    local Window = WindUI:CreateWindow({
        Title = "1amnotReal",
        Icon = "sparkles",
        Author = "by 1amnotReal",
        Folder = "WindUI",
        Size = UDim2.fromOffset(580, 460),
        Transparent = true,
        Theme = "Dark",
        Acrylic = true,
        HideSearchBar = false,
        SideBarWidth = 200,
        OpenButton = {
            Title = "1amnotReal",
            CornerRadius = UDim.new(1, 0),
            StrokeThickness = 2,
            Enabled = true,
            OnlyMobile = false,
            Draggable = true,
            OnlyIcon = false,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromHex("#00FF88")),
                ColorSequenceKeypoint.new(0.5, Color3.fromHex("#007A4D")),
                ColorSequenceKeypoint.new(1, Color3.fromHex("#003322"))
            }),
        },
        ToggleKey = Enum.KeyCode.G,
    })

    local Tabs = {
        [L("主要功能")] = Window:Section({Title = "主功能區", Opened = true}),
        ["Aimbot&M1"] = Window:Section({Title = "自瞄與M1", Opened = true}),
        ["特別"] = Window:Section({Title = "特別功能區", Opened = true}),
        ["Setting"] = Window:Section({Title = "系統設置", Opened = true}),
    }

    local RJR = {
        [L("主要功能")] = Tabs[L("主要功能")]:Tab({Title = "主要控制", Icon = "zap"}),
        ["ESP"] = Tabs[L("主要功能")]:Tab({Title = "透視 ESP", Icon = "eye"}),
        ["PVP"] = Tabs[L("主要功能")]:Tab({Title = "PVP 控制", Icon = "swords"}),
        ["Aimbot&M1"] = Tabs["Aimbot&M1"]:Tab({Title = "自瞄與戰鬥", Icon = "crosshair"}),
        ["特別"] = Tabs["特別"]:Tab({Title = L("特別"), Icon = "star"}),
        [L("设置")] = Tabs["Setting"]:Tab({Title = "腳本設置", Icon = "settings"}),
    }

    -- 創建各個分頁內容
    RJR[L("主要功能")]:Dropdown({
        Title = "快速攻擊模式",
        Values = { "模式1", "模式2" },
        Value = _G.FastAttackMode,
        Callback = function(v)
            _G.FastAttackMode = v
            SaveConfiguration()
        end
    })

    RJR[L("主要功能")]:Toggle({
        Title = "開啟龍槍 M1",
        Value = _G.DragonGunM1,
        Callback = function(v)
            _G.DragonGunM1 = v
            SaveConfiguration()
        end
    })

    RJR[L("主要功能")]:Slider({
        Title = "龍槍頻率/冷卻調整",
        Value = { Min = 0.01, Max = 1, Default = _G.DragonGunCooldown, Increment = 0.01 },
        Callback = function(v)
            _G.DragonGunCooldown = v
            SaveConfiguration()
        end
    })

    RJR[L("主要功能")]:Toggle({
        Title = "龍槍攻擊玩家",
        Value = _G.AttackPlayers,
        Callback = function(v)
            _G.AttackPlayers = v
            SaveConfiguration()
        end
    })

    RJR[L("主要功能")]:Toggle({
        Title = "龍槍攻擊 NPC",
        Value = _G.AttackMobs,
        Callback = function(v)
            _G.AttackMobs = v
            SaveConfiguration()
        end
    })

    RJR["PVP"]:Toggle({
        Title = L("飛行開關"),
        Value = _G.G_Fly or false,
        Callback = function(state)
            _G.G_Fly = state
            flightScreenGui.Enabled = state
            SaveConfiguration()
            if state then
                startFlying()
            else
                stopFlying()
            end
        end
    })

    RJR["PVP"]:Slider({
        Title = L("飛行速度"),
        Value = { Min = 1, Max = 50, Default = _G.G_FlySpeed or 1 },
        Callback = function(v)
            _G.G_FlySpeed = v
            speedLabel.Text = "速度: " .. v
            SaveConfiguration()
        end
    })

    RJR["PVP"]:Toggle({
        Title = L("自動順步開關"),
        Value = _G.G_AutoSmoothWalk or false,
        Callback = function(state)
            _G.G_AutoSmoothWalk = state
            SaveConfiguration()
            if state then
                WindUI:Notify({ Title = L("PVP"), Content = L("已開啟自動順步跟隨"), Duration = 2 })
                task.spawn(function()
                    while _G.G_AutoSmoothWalk do
                        task.wait(0.1)
                        pcall(function()
                            if _G.G_SelectPly and _G.G_SelectPly ~= "" then
                                local TargetPlr = Players:FindFirstChild(_G.G_SelectPly)
                                if TargetPlr and TargetPlr.Character and TargetPlr.Character:FindFirstChild("HumanoidRootPart") then
                                    local targetCFrame = TargetPlr.Character.HumanoidRootPart.CFrame + Vector3.new(_G.G_TeleportOffsetX, _G.G_TeleportOffsetY, _G.G_TeleportOffsetZ)
                                    topos(targetCFrame)
                                end
                            end
                        end)
                    end
                end)
            else
                WindUI:Notify({ Title = L("PVP"), Content = L("已關閉自動順步跟隨"), Duration = 2 })
                StopTween()
            end
        end
    })

    local function handleAbility(abilityType)
        task.spawn(function()
            while true do
                if (_G["G_Auto"..abilityType]) then
                    if abilityType == "V3" then
                        local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
                        local CommE = Remotes and Remotes:FindFirstChild("CommE")
                        if CommE then pcall(function() CommE:FireServer("ActivateAbility") end) end
                    end
                end
                task.wait(1)
            end
        end)
    end
    handleAbility("V3")

    local function GetAwakeningRemote()
        local p = Players.LocalPlayer
        if not p then return nil end
        local backpack = p:FindFirstChild("Backpack")
        local awakening = backpack and backpack:FindFirstChild("Awakening")
        if awakening and awakening:FindFirstChild("RemoteFunction") then return awakening.RemoteFunction end
        local char = p.Character
        local charAwakening = char and char:FindFirstChild("Awakening")
        if charAwakening and charAwakening:FindFirstChild("RemoteFunction") then return charAwakening.RemoteFunction end
        return nil
    end

    task.spawn(function()
        while true do
            task.wait(0.1)
            if _G.AutoV4_Enabled then
                local remote = GetAwakeningRemote()
                if remote then
                    task.spawn(function() pcall(function() remote:InvokeServer(true) end) end)
                end
            end
        end
    end)

    RJR["PVP"]:Toggle({ Title = L("自动 V3"), Value = _G.G_AutoV3, Callback = function(v) _G.G_AutoV3 = v; SaveConfiguration() end })
    RJR["PVP"]:Toggle({ Title = "Auto V4", Desc = "自動開啟V4", Value = _G.AutoV4_Enabled, Callback = function(v) _G.AutoV4_Enabled = v; SaveConfiguration() end })

    task.spawn(function()
        RunService.Stepped:Connect(function()
            if _G.G_NoWalkAnimation then
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local animate = char:FindFirstChild("Animate")
                        if animate and animate:IsA("LocalScript") then animate.Disabled = true end
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                                if track.Animation.AnimationId:find("rbxassetid://") then
                                    if track.Name == "WalkAnim" or track.Name == "RunAnim" or track.Name == "ClimbAnim" then track:Stop() end
                                end
                            end
                        end
                    end
                end)
            else
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local animate = char:FindFirstChild("Animate")
                        if animate and animate:IsA("LocalScript") then animate.Disabled = false end
                    end
                end)
            end
        end)
    end)

    RJR["PVP"]:Toggle({ Title = L("無走路特效"), Value = _G.G_NoWalkAnimation, Callback = function(v) _G.G_NoWalkAnimation = v; SaveConfiguration() end })
    RJR["PVP"]:Button({ Title = L("更换吸血鬼"), Icon = "moon", Callback = function() game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack({"Ectoplasm", "Change", 4})) end })

    task.spawn(function()
        while true do
            task.wait(0.2)
            if _G.G_AutoLowHpRace then
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local hum = char:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 and hum.MaxHealth > 0 then
                            local hpPercent = (hum.Health / hum.MaxHealth) * 100
                            if hpPercent <= 20 then
                                local raceId = (_G.G_LowHpRaceChoice == "機器人") and 3 or 4
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack({"Ectoplasm", "Change", raceId}))
                                task.wait(3)
                            end
                        end
                    end
                end)
            end
        end
    end)

    RJR["特別"]:Dropdown({ Title = L("選擇低血量切換種族"), Values = { "吸血鬼", "機器人" }, Value = _G.G_LowHpRaceChoice, Callback = function(v) _G.G_LowHpRaceChoice = v; SaveConfiguration() end })
    RJR["特別"]:Toggle({ Title = L("血量低於20%自動更換種族"), Value = _G.G_AutoLowHpRace, Callback = function(v) _G.G_AutoLowHpRace = v; SaveConfiguration() end })

    RJR[L("设置")]:Toggle({ Title = L("自動保存配置"), Value = _G.G_AutoSaveConfig, Callback = function(v) _G.G_AutoSaveConfig = v; SaveConfiguration() end })
    RJR[L("设置")]:Toggle({ Title = L("進遊戲自動加載配置"), Value = _G.G_AutoLoadConfig, Callback = function(v) _G.G_AutoLoadConfig = v; SaveConfiguration() end })

    RJR["Aimbot&M1"]:Toggle({ Title = "開啟自瞄 (技能 & M1)", Value = _G.SilentAimEnabled, Locked = disableHook, Callback = function(v) if disableHook then return end _G.SilentAimEnabled = v end })
    RJR["Aimbot&M1"]:Dropdown({ Title = "自瞄招式", Values = { "M1 (普攻)", "Z", "X", "C", "V", "F", "R" }, Value = _G.SilentAimSkills, Multi = true, Callback = function(v) _G.SilentAimSkills = v end })

    local function GetSilentAimPlayerList()
        local list = {}
        for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer then table.insert(list, plr.Name) end end
        return list
    end

    local silentAimPlayerDropdown = RJR["Aimbot&M1"]:Dropdown({ Title = "選擇指定玩家", Values = GetSilentAimPlayerList(), Value = nil, Callback = function(v) _G.SilentAimSelectedPlayer = nil; _G.G_SelectPly = v; for _, plr in ipairs(Players:GetPlayers()) do if plr.Name == v then _G.SilentAimSelectedPlayer = plr; break end end end })
    Players.PlayerAdded:Connect(function() if silentAimPlayerDropdown then silentAimPlayerDropdown:Refresh(GetSilentAimPlayerList()) end end)
    Players.PlayerRemoving:Connect(function() if silentAimPlayerDropdown then silentAimPlayerDropdown:Refresh(GetSilentAimPlayerList()) end end)

    RJR["Aimbot&M1"]:Dropdown({ Title = "瞄準模式", Values = { "最近目標", "指定玩家" }, Value = _G.SilentAimTargetMode, Callback = function(v) _G.SilentAimTargetMode = v end })
    RJR["Aimbot&M1"]:Toggle({ Title = "瞄準玩家", Value = _G.SilentAimTargetPlayers, Callback = function(v) _G.SilentAimTargetPlayers = v end })
    RJR["Aimbot&M1"]:Toggle({ Title = "隊伍檢測(不瞄隊友)", Value = _G.SilentAimTeamCheck, Callback = function(v) _G.SilentAimTeamCheck = v end })
    RJR["Aimbot&M1"]:Toggle({ Title = "瞄準 NPC ", Value = _G.SilentAimTargetMobs, Callback = function(v) _G.SilentAimTargetMobs = v end })
    RJR["Aimbot&M1"]:Toggle({ Title = "顯示射線 (指向最近目標)", Value = _G.SilentAimShowLine, Callback = function(v) _G.SilentAimShowLine = v end })
    RJR["Aimbot&M1"]:Toggle({ Title = "顯示 FOV ", Value = _G.SilentAimShowFOV, Callback = function(v) _G.SilentAimShowFOV = v end })
    RJR["Aimbot&M1"]:Dropdown({ Title = "FOV 圓圈位置", Values = { "跟随鼠標", "屏幕中心" }, Value = _G.SilentAimFOVMode, Callback = function(v) _G.SilentAimFOVMode = v end })
    RJR["Aimbot&M1"]:Slider({ Title = "FOV 範圍大小", Value = { Min = 10, Max = 1000, Default = _G.SilentAimFOV }, Callback = function(v) _G.SilentAimFOV = v end })
    RJR["Aimbot&M1"]:Slider({ Title = "FOV 線條粗細", Value = { Min = 1, Max = 10, Default = _G.SilentAimFOVThickness }, Callback = function(v) _G.SilentAimFOVThickness = v end })
    RJR["Aimbot&M1"]:Slider({ Title = "FOV 透明度", Value = { Min = 0, Max = 1, Default = _G.SilentAimFOVTransparency, Increment = 0.1 }, Callback = function(v) _G.SilentAimFOVTransparency = v end })

    local function hexToColor3(hex)
        hex = tostring(hex or "00FF88"):gsub("#", "")
        if #hex < 6 then hex = "00FF88" end
        return Color3.fromRGB(tonumber(hex:sub(1, 2), 16) or 0, tonumber(hex:sub(3, 4), 16) or 255, tonumber(hex:sub(5, 6), 16) or 136)
    end

    local ESPRunning = false
    local espObjects = {}
    local espUpdateConnection = nil
    local playerCache = {}
    local lastESPUpdate = 0
    local ESP_UPDATE_INTERVAL = 0.1

    local function getTeamInfo(player)
        if not player.Team then return "Unknown", Color3.fromRGB(255, 255, 255) end
        if player.Team.Name == "Marines" then return "海軍", Color3.fromRGB(0, 170, 255) end
        return "海賊", Color3.fromRGB(255, 70, 70)
    end

    local function removeESP(player)
        if espObjects[player] then
            pcall(function()
                if espObjects[player].gui then espObjects[player].gui:Destroy() end
                if espObjects[player].highlight then espObjects[player].highlight:Destroy() end
            end)
            espObjects[player] = nil
        end
    end

    local function isExcludedPlayer(player)
        return player:GetAttribute("IsAuthor") or player.Name == "Mas_Yes" or player.Name == "sjqgduf" or player.Name == "huha123444" or player.Name == "ksxrcm111" or player.Name == "Dddyy5"
    end

    local function createESP(player)
        if player == LocalPlayer or isExcludedPlayer(player) then return end
        local char = player.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        if not head then return end

        local team, color = getTeamInfo(player)
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "RJR_ESP"
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 70)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true

        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundTransparency = 1
        text.TextSize = _G.G_ESP_TextSize
        text.RichText = true
        text.Font = Enum.Font.SourceSansBold
        text.TextStrokeTransparency = 0
        text.TextColor3 = color
        text.Parent = billboard
        billboard.Parent = head

        local highlight
        if _G.G_ESP_Highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "ESP_PlayerHighlight"
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = hexToColor3(_G.G_ESP_HighlightColor)
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = highlight.FillColor
            highlight.OutlineTransparency = 0
            highlight.Parent = char
        end

        espObjects[player] = { gui = billboard, label = text, char = char, highlight = highlight }
    end

    local function getPlayerData(player)
        if not playerCache[player] then
            playerCache[player] = { level = "?", fruit = "None", bounty = 0, team = "Unknown", color = Color3.fromRGB(255, 255, 255), lastUpdate = 0 }
        end
        local data = playerCache[player]
        local now = tick()
        if now - data.lastUpdate > 5 then
            pcall(function() data.level = player.Data.Level.Value end)
            pcall(function() data.fruit = player.Data.DevilFruit.Value end)
            pcall(function() data.bounty = player.leaderstats["Bounty/Honor"].Value end)
            data.team, data.color = getTeamInfo(player)
            data.lastUpdate = now
        end
        return data
    end

    local function updateESP()
        local now = tick()
        if now - lastESPUpdate < ESP_UPDATE_INTERVAL then return end
        lastESPUpdate = now
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local myPos = myRoot.Position

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if isExcludedPlayer(player) then
                    if espObjects[player] then removeESP(player) end
                    continue
                end
                local char = player.Character
                local head = char and char:FindFirstChild("Head")
                local data = espObjects[player]
                if char and head then
                    if not data or data.char ~= char or not data.gui.Parent then
                        removeESP(player)
                        createESP(player)
                        data = espObjects[player]
                    end
                else
                    if data then removeESP(player) end
                    continue
                end
                if not data then continue end
                local hum = char:FindFirstChild("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum and root then
                    local distance = math.floor((root.Position - myPos).Magnitude)
                    local hp = hum.MaxHealth > 0 and math.floor((hum.Health / hum.MaxHealth) * 100) or 0
                    local pData = getPlayerData(player)
                    data.label.TextColor3 = pData.color
                    data.label.TextSize = _G.G_ESP_TextSize

                    local parts = {}
                    if _G.G_ESP_Name then table.insert(parts, "[" .. pData.team .. "] <font color=\"rgb(0,255,136)\">" .. player.Name .. "</font>") end
                    if _G.G_ESP_Level then table.insert(parts, " [Lv." .. pData.level .. "]") end
                    table.insert(parts, "\n")
                    if _G.G_ESP_Fruit then table.insert(parts, "水果: " .. tostring(pData.fruit) .. "\n") end
                    if _G.G_ESP_Bounty then table.insert(parts, "賞金: " .. math.floor(pData.bounty / 1000000) .. "M\n") end
                    if _G.G_ESP_Distance then table.insert(parts, distance .. "米 | ") end
                    if _G.G_ESP_HP then table.insert(parts, "生命 " .. hp .. "%") end

                    data.label.Text = table.concat(parts)
                end
            end
        end
    end

    local function EnableESP()
        if ESPRunning then return end
        ESPRunning = true
        for _, player in ipairs(Players:GetPlayers()) do createESP(player) end
        espUpdateConnection = task.spawn(function()
            while ESPRunning do
                pcall(updateESP)
                task.wait(ESP_UPDATE_INTERVAL)
            end
        end)
    end

    local function DisableESP()
        ESPRunning = false
        espUpdateConnection = nil
        for player in pairs(espObjects) do removeESP(player) end
        espObjects = {}
    end

    RJR["ESP"]:Toggle({ Title = L("ESP 開關"), Value = _G.G_ESPEnabled, Callback = function(state) _G.G_ESPEnabled = state; if state then EnableESP() else DisableESP() end; SaveConfiguration() end })
    RJR["ESP"]:Toggle({ Title = L("顯示玩家名字"), Value = _G.G_ESP_Name, Callback = function(v) _G.G_ESP_Name = v; SaveConfiguration() end })
    RJR["ESP"]:Toggle({ Title = L("顯示玩家等級"), Value = _G.G_ESP_Level, Callback = function(v) _G.G_ESP_Level = v; SaveConfiguration() end })
    RJR["ESP"]:Toggle({ Title = L("顯示玩家賞金"), Value = _G.G_ESP_Bounty, Callback = function(v) _G.G_ESP_Bounty = v; SaveConfiguration() end })
    RJR["ESP"]:Toggle({ Title = L("顯示惡魔果實"), Value = _G.G_ESP_Fruit, Callback = function(v) _G.G_ESP_Fruit = v; SaveConfiguration() end })
    RJR["ESP"]:Toggle({ Title = L("顯示距離"), Value = _G.G_ESP_Distance, Callback = function(v) _G.G_ESP_Distance = v; SaveConfiguration() end })
    RJR["ESP"]:Toggle({ Title = L("顯示血量"), Value = _G.G_ESP_HP, Callback = function(v) _G.G_ESP_HP = v; SaveConfiguration() end })
    RJR["ESP"]:Toggle({ Title = L("高亮顯示玩家"), Value = _G.G_ESP_Highlight, Callback = function(v) _G.G_ESP_Highlight = v; SaveConfiguration() end })
    RJR["ESP"]:Colorpicker({ Title = L("高亮顏色"), Default = hexToColor3(_G.G_ESP_HighlightColor), Transparency = 0, Callback = function(color) _G.G_ESP_HighlightColor = string.format("%02X%02X%02X", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5)); SaveConfiguration() end })
    RJR["ESP"]:Slider({ Title = L("ESP 字體大小"), Value = { Min = 8, Max = 32, Default = _G.G_ESP_TextSize or 14 }, Callback = function(v) _G.G_ESP_TextSize = v; SaveConfiguration() end })

    pcall(function() Window:SelectTab(RJR[L("主要功能")]) end)
end

-- 密碼驗證邏輯
local CorrectPassword = "K9#m$2x!pL7@qZ8*vB4%yT1&fH3^dN6"

LoginBtn.MouseButton1Click:Connect(function()
    if TextBox.Text == CorrectPassword then
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 136)
        StatusLabel.Text = "登入成功！正在載入主介面..."
        task.wait(0.5)
        LoadMainScript()
    else
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        StatusLabel.Text = "密碼錯誤，請重新輸入！"
    end
end)

-- RJR_NEW.lua 
-- 包含完整登入介面與主腳本功能 (支援新增 PVP 分頁與完整功能搬移)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local Camera = Workspace.CurrentCamera

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

    -- 快速攻擊與龍槍變數初始化
    _G.FastAttackMode = _G.FastAttackMode or "模式1"
    _G.DragonGunM1 = _G.DragonGunM1 or false
    _G.DragonGunCooldown = _G.DragonGunCooldown or 0.1
    _G.AttackMobs = _G.AttackMobs or false
    _G.AttackPlayers = _G.AttackPlayers or true
    _G.M1FireInterval = _G.M1FireInterval or 0.1

    _G.G_AutoHaki = _G.G_AutoHaki or false
    _G.G_AutoV3 = _G.G_AutoV3 or false
    _G.G_AutoV4 = _G.G_AutoV4 or false
    _G.G_NoWalkAnimation = _G.G_NoWalkAnimation or false
    _G.G_AutoSmoothWalk = _G.G_AutoSmoothWalk or false
    _G.G_AutoFlee = _G.G_AutoFlee or false
    _G.G_AutoFleeHP = _G.G_AutoFleeHP or 30
    _G.G_translateSpeed = _G.G_translateSpeed or 50
    _G.G_translateAccel = _G.G_translateAccel or false
    _G.G_jumpHeight = _G.G_jumpHeight or 50
    _G.G_jumpEnabled = _G.G_jumpEnabled or false
    _G.G_Fly = _G.G_Fly or false
    
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
    _G.G_AutoSaveConfig = _G.G_AutoSaveConfig ~= false -- 預設為 true
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
            ["自动 V4"] = "Auto V4",
            ["無走路特效"] = "No Walk Animation",
            ["更换吸血鬼"] = "Change Vampire",
            ["血量低於20%自動更換種族"] = "Auto Race Change on Low HP (<20%)",
            ["選擇低血量切換種族"] = "Select Race for Low HP",
            ["自動順步開關"] = "Auto Smooth Walk Toggle",
            ["已開啟自動順步跟隨"] = "Auto smooth walk enabled",
            ["已關閉自動順步跟隨"] = "Auto smooth walk disabled",
            ["自動保存配置"] = "Auto Save Config",
            ["進遊戲自動加載配置"] = "Auto Load Config",
        }
    }

    local function L(text)
        if _G.G_Language == "English" and Translations["English"][text] then
            return Translations["English"][text]
        end
        return text
    end

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
                AutoV4 = _G.G_AutoV4,
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
                    elseif category == "Auto" or category == "Main" or category == "ESP" or category == "UI" then
                        _G["G_" .. k] = v
                    end
                end
            end
        end
    end

    -- 判斷是否進遊戲自動加載設定
    pcall(function()
        if isfile and readfile and isfile(CONFIG_FILE) then
            local rawData = HttpService:JSONDecode(readfile(CONFIG_FILE))
            if rawData and rawData.UI and rawData.UI.AutoLoadConfig then
                _G.G_AutoLoadConfig = true
                LoadConfiguration()
            end
        end
    end)

    -- 執行器與鉤子安全檢測
    local executorName = identifyexecutor and identifyexecutor() or "Unknown"
    local disableHook = false
    pcall(function()
        if not getrawmetatable or not setreadonly then
            disableHook = true
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

            if skills[skillName] ~= nil then
                return skills[skillName] == true
            end

            for _, v in pairs(skills) do
                if v == skillName then
                    return true
                end
            end

            return false
        end
        return true
    end

    local function IsCurrentSkillEnabled()
        return IsSkillSelected(LastSkillPressed)
    end

    local function IsAlive(character)
        if not character then return false end
        local hum = character:FindFirstChildOfClass("Humanoid")
        local root = character:FindFirstChild("HumanoidRootPart")
        return hum ~= nil and hum.Health > 0 and root ~= nil
    end

    local function IsSilentAimAlly(player)
        if not player then return false end
        local main = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main")
        if not main then return false end
        
        local allies = main:FindFirstChild("Allies")
        local container = allies and allies:FindFirstChild("Container")
        local subAllies = container and container:FindFirstChild("Allies")
        if not subAllies then return false end

        local frame = subAllies:FindFirstChild("Frame") 
            or (subAllies:FindFirstChild("ScrollingFrame") and subAllies.ScrollingFrame:FindFirstChild("Frame"))

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
                                    if screenDist > _G.SilentAimFOV then
                                        passFOV = false
                                    end
                                else
                                    passFOV = false
                                end
                            end

                            if passFOV then
                                return part, dist
                            end
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
                    if screenDist > _G.SilentAimFOV then
                        passFOV = false
                    end
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
                        local realStore = {
                            Hit = rawget(MouseModule, "Hit"),
                            Target = rawget(MouseModule, "Target")
                        }

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
                            if key == "Hit" or key == "Target" then
                                realStore[key] = value
                            else
                                rawset(self, key, value)
                            end
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

                    if key == "Hit" then
                        return CFrame.new(targetPos)
                    elseif key == "Target" then
                        return currentSilentAimTarget
                    elseif key == "UnitRay" then
                        return Ray.new(camPos, (targetPos - camPos).Unit)
                    elseif key == "Origin" then
                        return CFrame.new(camPos)
                    elseif key == "Direction" then
                        return (targetPos - camPos).Unit
                    end
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

    -- 快速攻擊邏輯
    task.spawn(function()
        pcall(function()
            local CombatFramework = require(ReplicatedStorage:WaitForChild("CombatFramework"))
            local CombatFrameworkRigModules = require(ReplicatedStorage:WaitForChild("CombatFramework").RigLib)
            
            RunService.RenderStepped:Connect(function()
                if _G.FastAttackMode == "模式1" then
                    pcall(function()
                        local v = CombatFramework.activeController
                        if v and v.equipped then
                            for _, _ in pairs(v.anims.basic) do
                                v.timeToNextAttack = 0
                                v.blocking = false
                                v.hitboxMagnitude = 60
                                v.inactiveCooldown = 0
                            end
                        end
                    end)
                elseif _G.FastAttackMode == "模式2" then
                    pcall(function()
                        local v = CombatFramework.activeController
                        if v and v.equipped then
                            CombatFrameworkRigModules.currentCooldown()
                            v.timeToNextAttack = 0
                            v.tapCooldown = 0
                            v.maxSpeed = 1
                            v.activeCooldown = 0
                        end
                    end)
                end
            end)
        end)
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

    -- 平滑傳送/順步相關函式
    local ActiveTween = nil
    local function SetNoCollide()
        local character = LocalPlayer.Character
        if not character then return end
        for _, v in ipairs(character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
                v.CanTouch   = true
                v.CanQuery   = true
            end
        end
    end
    local function SetCollide()
        local character = LocalPlayer.Character
        if not character then return end
        for _, v in ipairs(character:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
                v.CanTouch   = true
                v.CanQuery   = true
            end
        end
    end
    local function topos(Pos)
        if not LocalPlayer or not LocalPlayer.Character then return end
        local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if not HRP or not Humanoid then return end

        HRP.AssemblyLinearVelocity  = Vector3.zero
        HRP.AssemblyAngularVelocity = Vector3.zero
        Humanoid:ChangeState(Enum.HumanoidStateType.Physics)

        local Distance = (Pos.Position - HRP.Position).Magnitude
        local Speed = 300

        if ActiveTween then ActiveTween:Cancel() end

        ActiveTween = game:GetService("TweenService"):Create(
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
            if Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end
    local function StopTween()
        if ActiveTween then
            ActiveTween:Cancel()
            ActiveTween = nil
        end
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

    -- ========================================================
    -- 【主要控制頁面】快速攻擊與龍槍設定
    -- ========================================================
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

    -- ========================================================
    -- 【PVP 分頁】PVP 控制與自動 V3 / V4 / 無走路特效
    -- ========================================================
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

    -- 自動 V3 與 V4 處理函式與 UI 開關
    local function handleAbility(abilityType)
        task.spawn(function()
            while true do
                if (_G["G_Auto"..abilityType]) then
                    if abilityType == "V4" then
                        local Awakening = LocalPlayer:FindFirstChild("Backpack") and LocalPlayer.Backpack:FindFirstChild("Awakening")
                        if Awakening and Awakening:FindFirstChild("RemoteFunction") then
                            pcall(function() Awakening.RemoteFunction:InvokeServer(true) end)
                        end
                    elseif abilityType == "V3" then
                        local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
                        local CommE = Remotes and Remotes:FindFirstChild("CommE")
                        if CommE then
                            pcall(function() CommE:FireServer("ActivateAbility") end)
                        end
                    end
                end
                task.wait(1)
            end
        end)
    end
    handleAbility("V3")
    handleAbility("V4")

    RJR["PVP"]:Toggle({
        Title = L("自动 V3"),
        Value = _G.G_AutoV3,
        Callback = function(v)
            _G.G_AutoV3 = v
            SaveConfiguration()
        end
    })

    RJR["PVP"]:Toggle({
        Title = L("自动 V4"),
        Value = _G.G_AutoV4,
        Callback = function(v)
            _G.G_AutoV4 = v
            SaveConfiguration()
        end
    })

    -- 放在自動 V4 下方的「無走路特效」功能
    task.spawn(function()
        RunService.Stepped:Connect(function()
            if _G.G_NoWalkAnimation then
                pcall(function()
                    local char = LocalPlayer.Character
                    if char then
                        local animate = char:FindFirstChild("Animate")
                        if animate and animate:IsA("LocalScript") then
                            animate.Disabled = true
                        end
                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                                if track.Animation.AnimationId:find("rbxassetid://") then
                                    -- 針對走路與跑步動畫進行停止處理
                                    if track.Name == "WalkAnim" or track.Name == "RunAnim" or track.Name == "ClimbAnim" then
                                        track:Stop()
                                    end
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
                        if animate and animate:IsA("LocalScript") then
                            animate.Disabled = false
                        end
                    end
                end)
            end
        end)
    end)

    RJR["PVP"]:Toggle({
        Title = L("無走路特效"),
        Value = _G.G_NoWalkAnimation,
        Callback = function(v)
            _G.G_NoWalkAnimation = v
            SaveConfiguration()
        end
    })

    RJR["PVP"]:Button({
        Title = L("更换吸血鬼"),
        Icon = "moon",
        Callback = function()
            local args = {"Ectoplasm", "Change", 4}
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
        end
    })

    -- ========================================================
    -- 【特別 分頁】血量低於20%自動更換種族與開關
    -- ========================================================
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
                                local raceId = 4 -- 預設吸血鬼
                                if _G.G_LowHpRaceChoice == "機器人" then
                                    raceId = 3
                                end
                                local args = {"Ectoplasm", "Change", raceId}
                                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer(unpack(args))
                                task.wait(3)
                            end
                        end
                    end
                end)
            end
        end
    end)

    RJR["特別"]:Dropdown({
        Title = L("選擇低血量切換種族"),
        Values = { "吸血鬼", "機器人" },
        Value = _G.G_LowHpRaceChoice,
        Callback = function(v)
            _G.G_LowHpRaceChoice = v
            SaveConfiguration()
        end
    })

    RJR["特別"]:Toggle({
        Title = L("血量低於20%自動更換種族"),
        Value = _G.G_AutoLowHpRace,
        Callback = function(v)
            _G.G_AutoLowHpRace = v
            SaveConfiguration()
        end
    })

    -- ========================================================
    -- 【設置分頁】自動保存與自動加載配置
    -- ========================================================
    RJR[L("设置")]:Toggle({
        Title = L("自動保存配置"),
        Value = _G.G_AutoSaveConfig,
        Callback = function(v)
            _G.G_AutoSaveConfig = v
            SaveConfiguration()
        end
    })

    RJR[L("设置")]:Toggle({
        Title = L("進遊戲自動加載配置"),
        Value = _G.G_AutoLoadConfig,
        Callback = function(v)
            _G.G_AutoLoadConfig = v
            SaveConfiguration()
        end
    })

    -- 創建自瞄 UI 介面
    RJR["Aimbot&M1"]:Toggle({ 
        Title = "開啟自瞄 (技能 & M1)", 
        Value = _G.SilentAimEnabled, 
        Locked = disableHook, 
        LockedTitle = disableHook and ("目前不支援 " .. executorName .. " 執行器") or nil, 
        Callback = function(v) 
            if disableHook then return end 
            _G.SilentAimEnabled = v 
        end 
    })

    RJR["Aimbot&M1"]:Dropdown({ 
        Title = "自瞄招式", 
        Values = { "M1 (普攻)", "Z", "X", "C", "V", "F", "R" }, 
        Value = _G.SilentAimSkills,
        Multi = true, 
        Callback = function(v) 
            _G.SilentAimSkills = v 
        end 
    })

    local function GetSilentAimPlayerList()
        local list = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then 
                table.insert(list, plr.Name) 
            end
        end
        return list
    end

    local silentAimPlayerDropdown
    silentAimPlayerDropdown = RJR["Aimbot&M1"]:Dropdown({ 
        Title = "選擇指定玩家", 
        Values = GetSilentAimPlayerList(), 
        Value = nil,
        Callback = function(v)
            _G.SilentAimSelectedPlayer = nil
            _G.G_SelectPly = v 
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr.Name == v then 
                    _G.SilentAimSelectedPlayer = plr
                    break 
                end
            end
        end
    })

    Players.PlayerAdded:Connect(function() 
        if silentAimPlayerDropdown then
            silentAimPlayerDropdown:Refresh(GetSilentAimPlayerList()) 
        end
    end)

    Players.PlayerRemoving:Connect(function() 
        if silentAimPlayerDropdown then
            silentAimPlayerDropdown:Refresh(GetSilentAimPlayerList()) 
        end
    end)

    RJR["Aimbot&M1"]:Dropdown({ 
        Title = "瞄準模式", 
        Values = { "最近目標", "指定玩家" }, 
        Value = _G.SilentAimTargetMode, 
        Callback = function(v) 
            _G.SilentAimTargetMode = v 
        end 
    })

    RJR["Aimbot&M1"]:Toggle({ 
        Title = "瞄準玩家", 
        Value = _G.SilentAimTargetPlayers, 
        Callback = function(v) 
            _G.SilentAimTargetPlayers = v 
        end 
    })

    RJR["Aimbot&M1"]:Toggle({ 
        Title = "隊伍檢測(不瞄隊友)", 
        Value = _G.SilentAimTeamCheck, 
        Callback = function(v) 
            _G.SilentAimTeamCheck = v 
        end 
    })

    RJR["Aimbot&M1"]:Toggle({ 
        Title = "瞄準 NPC ", 
        Value = _G.SilentAimTargetMobs, 
        Callback = function(v) 
            _G.SilentAimTargetMobs = v 
        end 
    })

    RJR["Aimbot&M1"]:Toggle({ 
        Title = "顯示射線 (指向最近目標)", 
        Value = _G.SilentAimShowLine, 
        Callback = function(v) 
            _G.SilentAimShowLine = v 
        end 
    })

    RJR["Aimbot&M1"]:Toggle({ 
        Title = "顯示 FOV ", 
        Value = _G.SilentAimShowFOV, 
        Callback = function(v) 
            _G.SilentAimShowFOV = v 
        end 
    })

    RJR["Aimbot&M1"]:Dropdown({ 
        Title = "FOV 圓圈位置", 
        Values = { "跟随鼠標", "屏幕中心" }, 
        Value = _G.SilentAimFOVMode, 
        Callback = function(v) 
            _G.SilentAimFOVMode = v 
        end 
    })

    RJR["Aimbot&M1"]:Slider({ 
        Title = "FOV 範圍大小", 
        Value = { Min = 10, Max = 1000, Default = _G.SilentAimFOV }, 
        Callback = function(v) 
            _G.SilentAimFOV = v 
        end 
    })

    RJR["Aimbot&M1"]:Slider({ 
        Title = "FOV 線條粗細", 
        Value = { Min = 1, Max = 10, Default = _G.SilentAimFOVThickness }, 
        Callback = function(v) 
            _G.SilentAimFOVThickness = v 
        end 
    })

    RJR["Aimbot&M1"]:Slider({ 
        Title = "FOV 透明度", 
        Value = { Min = 0, Max = 1, Default = _G.SilentAimFOVTransparency, Increment = 0.1 }, 
        Callback = function(v) 
            _G.SilentAimFOVTransparency = v 
        end 
    })

    local function hexToColor3(hex)
        hex = tostring(hex or "00FF88"):gsub("#", "")
        if #hex < 6 then hex = "00FF88" end
        local r = tonumber(hex:sub(1, 2), 16) or 0
        local g = tonumber(hex:sub(3, 4), 16) or 255
        local b = tonumber(hex:sub(5, 6), 16) or 136
        return Color3.fromRGB(r, g, b)
    end

    local ESPRunning = false
    local espObjects = {}
    local espUpdateConnection = nil
    local playerCache = {}
    local lastESPUpdate = 0
    local ESP_UPDATE_INTERVAL = 0.1

    local function getTeamInfo(player)
        if not player.Team then
            return "Unknown", Color3.fromRGB(255, 255, 255)
        end
        if player.Team.Name == "Marines" then
            return "海軍", Color3.fromRGB(0, 170, 255)
        end
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
        return player:GetAttribute("IsAuthor")
            or player.Name == "Mas_Yes"
            or player.Name == "sjqgduf"
            or player.Name == "huha123444"
            or player.Name == "ksxrcm111"
            or player.Name == "Dddyy5"
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
        text.TextScaled = false
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

        espObjects[player] = {
            gui = billboard,
            label = text,
            char = char,
            highlight = highlight
        }
    end

    local function getPlayerData(player)
        if not playerCache[player] then
            playerCache[player] = {
                level = "?",
                fruit = "None",
                bounty = 0,
                team = "Unknown",
                color = Color3.fromRGB(255, 255, 255),
                lastUpdate = 0
            }
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

                    local warnTag = pData.bounty > 10000000 and "⚠ " or ""
                    local pvpState = "⚔ PVP已開啟 "
                    local pvpIcon = "🔴 "
                    local isPvpDisabled = player:GetAttribute("PvpDisabled") == true

                    if isPvpDisabled then
                        pvpState = "PvP已關閉 "
                        pvpIcon = "🟢 "
                    end

                    data.label.TextColor3 = pData.color
                    data.label.TextSize = _G.G_ESP_TextSize

                    local parts = {}
                    if _G.G_ESP_Name then
                        parts[#parts + 1] = warnTag .. "[" .. pData.team .. "] <font color=\"rgb(0,255,136)\">" .. player.Name .. "</font>"
                    end
                    if _G.G_ESP_Level then parts[#parts + 1] = " [Lv." .. pData.level .. "]" end

                    if isPvpDisabled then
                        parts[#parts + 1] = "\n<font color=\"rgb(0,255,0)\">" .. pvpIcon .. pvpState .. "</font>\n"
                    else
                        parts[#parts + 1] = "\n" .. pvpIcon .. pvpState .. "\n"
                    end

                    if _G.G_ESP_Fruit then parts[#parts + 1] = "水果: " .. tostring(pData.fruit) .. "\n" end
                    if _G.G_ESP_Bounty then parts[#parts + 1] = "賞金: " .. math.floor(pData.bounty / 1000000) .. "M\n" end
                    if _G.G_ESP_Distance then parts[#parts + 1] = distance .. "米 | " end
                    if _G.G_ESP_HP then parts[#parts + 1] = "生命 " .. hp .. "%" end

                    data.label.Text = table.concat(parts)

                    if _G.G_ESP_Highlight then
                        local hlColor = hexToColor3(_G.G_ESP_HighlightColor)
                        if not data.highlight or not data.highlight.Parent then
                            local hl = Instance.new("Highlight")
                            hl.Name = "ESP_PlayerHighlight"
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.FillColor = hlColor
                            hl.FillTransparency = 0.5
                            hl.OutlineColor = hlColor
                            hl.OutlineTransparency = 0
                            hl.Parent = char
                            data.highlight = hl
                        else
                            data.highlight.FillColor = hlColor
                            data.highlight.OutlineColor = hlColor
                        end
                    elseif data.highlight then
                        data.highlight:Destroy()
                        data.highlight = nil
                    end
                end
            end
        end
    end

    local function EnableESP()
        if ESPRunning then return end
        ESPRunning = true

        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end

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

        for player in pairs(espObjects) do
            removeESP(player)
        end
        espObjects = {}
    end

    if not _G.ESP_Initialized then
        _G.ESP_Initialized = true
        Players.PlayerRemoving:Connect(function(player)
            removeESP(player)
            playerCache[player] = nil
        end)
    end

    task.spawn(function()
        task.wait(1)
        if _G.G_ESPEnabled then EnableESP() end
    end)

    RJR["ESP"]:Toggle({
        Title = L("ESP 開關"),
        Value = _G.G_ESPEnabled,
        Callback = function(state)
            _G.G_ESPEnabled = state
            if state then EnableESP() else DisableESP() end
            SaveConfiguration()
        end
    })

    RJR["ESP"]:Toggle({
        Title = L("顯示玩家名字"),
        Value = _G.G_ESP_Name,
        Callback = function(v)
            _G.G_ESP_Name = v
            SaveConfiguration()
        end
    })

    RJR["ESP"]:Toggle({
        Title = L("顯示玩家等級"),
        Value = _G.G_ESP_Level,
        Callback = function(v)
            _G.G_ESP_Level = v
            SaveConfiguration()
        end
    })

    RJR["ESP"]:Toggle({
        Title = L("顯示玩家賞金"),
        Value = _G.G_ESP_Bounty,
        Callback = function(v)
            _G.G_ESP_Bounty = v
            SaveConfiguration()
        end
    })

    RJR["ESP"]:Toggle({
        Title = L("顯示惡魔果實"),
        Value = _G.G_ESP_Fruit,
        Callback = function(v)
            _G.G_ESP_Fruit = v
            SaveConfiguration()
        end
    })

    RJR["ESP"]:Toggle({
        Title = L("顯示距離"),
        Value = _G.G_ESP_Distance,
        Callback = function(v)
            _G.G_ESP_Distance = v
            SaveConfiguration()
        end
    })

    RJR["ESP"]:Toggle({
        Title = L("顯示血量"),
        Value = _G.G_ESP_HP,
        Callback = function(v)
            _G.G_ESP_HP = v
            SaveConfiguration()
        end
    })

    RJR["ESP"]:Toggle({
        Title = L("高亮顯示玩家"),
        Value = _G.G_ESP_Highlight,
        Callback = function(v)
            _G.G_ESP_Highlight = v
            SaveConfiguration()
        end
    })

    RJR["ESP"]:Colorpicker({
        Title = L("高亮顏色"),
        Default = hexToColor3(_G.G_ESP_HighlightColor),
        Transparency = 0,
        Callback = function(color)
            _G.G_ESP_HighlightColor = string.format(
                "%02X%02X%02X",
                math.floor(color.R * 255 + 0.5),
                math.floor(color.G * 255 + 0.5),
                math.floor(color.B * 255 + 0.5)
            )
            SaveConfiguration()
        end
    })

    RJR["ESP"]:Slider({
        Title = L("ESP 字體大小"),
        Value = {
            Min = 8,
            Max = 32,
            Default = _G.G_ESP_TextSize or 14
        },
        Callback = function(v)
            _G.G_ESP_TextSize = v
            SaveConfiguration()
        end
    })

    pcall(function()
        Window:SelectTab(RJR[L("主要功能")])
    end)
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

local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local CONFIG_FILE = "PVvX7r_NEW_C.json"

_G.G_FastAttack       = _G.G_FastAttack ~= true
_G.G_FastAttackMode   = _G.G_FastAttackMode or "模式2(部分帳號失效用)"
_G.G_AttackMobs       = _G.G_AttackMobs ~= true
_G.G_AttackPlayers    = _G.G_AttackPlayers ~= true
_G.G_DragonGunM1      = _G.G_DragonGunM1 or false
_G.G_DragonGunSpeed   = _G.G_DragonGunSpeed or 0.085
_G.G_FruitM1          = _G.G_FruitM1 or false
_G.G_AutoHaki         = _G.G_AutoHaki or false
_G.G_AutoV3           = _G.G_AutoV3 or false
_G.G_AutoV4           = _G.G_AutoV4 or false

_G.G_AutoLowHpRace = _G.G_AutoLowHpRace or false
_G.G_LowHpRaceChoice = _G.G_LowHpRaceChoice or "吸血鬼"

_G.G_ESPEnabled       = _G.G_ESPEnabled ~= false
_G.G_ESP_Name         = _G.G_ESP_Name ~= false
_G.G_ESP_Level        = _G.G_ESP_Level ~= false
_G.G_ESP_Bounty       = _G.G_ESP_Bounty ~= false
_G.G_ESP_Fruit        = _G.G_ESP_Fruit ~= false
_G.G_ESP_Distance     = _G.G_ESP_Distance ~= false
_G.G_ESP_HP           = _G.G_ESP_HP ~= false
_G.G_ESP_TextSize     = _G.G_ESP_TextSize or 14
_G.G_ESP_Highlight    = _G.G_ESP_Highlight or false
_G.G_ESP_HighlightColor = _G.G_ESP_HighlightColor or "FF0000"

_G.G_SilentAimM1R   = _G.G_SilentAimM1R or false
_G.G_SilentAimSkill = _G.G_SilentAimSkill or false
_G.G_SilentAimShowFOV = _G.G_SilentAimShowFOV or false
_G.G_SilentAimFOV     = _G.G_SilentAimFOV or 100
_G.G_SilentAimPart    = _G.G_SilentAimPart or "Head"
_G.G_SilentAimFOVThickness = _G.G_SilentAimFOVThickness or 2
_G.G_SilentAimFOVTransparency = _G.G_SilentAimFOVTransparency or 1
_G.G_SilentAimTargetPlayers = _G.G_SilentAimTargetPlayers or false
_G.G_SilentAimTargetMobs    = _G.G_SilentAimTargetMobs or false
_G.G_SilentAimShowLine      = _G.G_SilentAimShowLine or false
_G.G_SilentAimFOVMode       = _G.G_SilentAimFOVMode or "跟隨滑鼠"
_G.G_SilentAimTeamCheck     = _G.G_SilentAimTeamCheck or false
_G.G_SilentAimMethod        = _G.G_SilentAimMethod or "滑鼠最近的玩家"
_G.G_LockHotkey              = _G.G_LockHotkey or false
_G.G_LockHotkeyMode          = _G.G_LockHotkeyMode or "鎖人1"
_G.G_AutoSoru                = _G.G_AutoSoru or false

_G.G_AutoLoadConfig   = _G.G_AutoLoadConfig or false
_G.G_AutoSaveConfig   = _G.G_AutoSaveConfig or false
_G.G_Theme            = _G.G_Theme or "Light"
_G.G_Language         = _G.G_Language or "中文"

-- ========== 新增 DragonGun 独立变量（V2） ==========
_G.G_DragonGunM1_V2 = _G.G_DragonGunM1_V2 or false
_G.G_M1FireInterval_V2 = _G.G_M1FireInterval_V2 or 0.2
_G.G_AttackMobs_V2 = _G.G_AttackMobs_V2 or false
_G.G_AttackPlayers_V2 = _G.G_AttackPlayers_V2 or false

-- ========== 新增传送功能（从 RJR 提取） ==========
local TeleportLocations = {}
local function SetupTeleportLocations()
    local placeId = game.PlaceId
    if placeId == 4442272183 or placeId == 79091703265657 then -- World2
        TeleportLocations = {
            ["豪宅"] = Vector3.new(-390, 332, 673),
            ["天鹅房间"] = Vector3.new(2285, 15, 905),
            ["鬼船"] = Vector3.new(923, 126, 32852),
            ["僵尸岛"] = Vector3.new(-6509, 83, -133),
        }
    elseif placeId == 7449423635 or placeId == 100117331123089 then -- World3
        TeleportLocations = {
            ["海洋城堡"] = Vector3.new(-12463.6, 376.26, -7566.08),
            ["海龟豪宅"] = Vector3.new(-5060.41, 316.43, -3192.30),
            ["司法"] = Vector3.new(-5096.48, 316.43, -3177.91),
            ["九头蛇"] = Vector3.new(-5027.03, 316.43, -3206.07),
            ["P2"] = Vector3.new(5650.94482, 1034.45056, -350.383636),
        }
    else
        TeleportLocations = {}
    end
end
SetupTeleportLocations()

local function RequestEntrance(pos)
    local args = { "requestEntrance", pos }
    pcall(function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
    end)
end
-- =================================================

local Translations = {
    ["中文"] = {},
    ["English"] = {
        ["PVvX7r"] = "PVvX7r",
        ["公告"] = "Notice",
        ["目前無法使用更改機器人"] = "Currently unable to change robot",
        ["主要功能"] = "Main",
        ["ESP"] = "ESP",
        ["繪製"] = "Aimbot",
        ["設置"] = "Settings",
        ["FOV"] = "FOV",
        ["特別"] = "Special",
        ["開啟快速攻擊"] = "Enable Fast Attack",
        ["快速攻擊模式"] = "Fast Attack Mode",
        ["槍械 m1"] = "Dragon Gun M1",
        ["龍槍攻速調整"] = "Dragon Gun Speed",
        ["果實m1"] = "Fruit M1",
        ["自動武裝色"] = "Auto Haki",
        ["自動 V3"] = "Auto V3",
        ["自動 V4"] = "Auto V4",
        ["選擇低血量切換種族"] = "Select Low HP Race",
        ["血量低於20%自動更換種族"] = "Auto Change Race on Low HP",
        ["ESP 開關"] = "ESP Toggle",
        ["顯示玩家名字"] = "Show Player Name",
        ["顯示玩家等級"] = "Show Player Level",
        ["顯示玩家賞金"] = "Show Bounty",
        ["顯示惡魔果實"] = "Show Devil Fruit",
        ["顯示距離"] = "Show Distance",
        ["顯示血量"] = "Show HP",
        ["高亮顯示玩家"] = "Highlight Players",
        ["高亮顏色"] = "Highlight Color",
        ["ESP 字體大小"] = "ESP Text Size",
        ["選擇主題"] = "Select Theme",
        ["自動保存配置"] = "Auto Save Config",
        ["進遊戲自動加載配置"] = "Auto Load Config",
        ["保存配置"] = "Save Config",
        ["加載配置"] = "Load Config",
        ["視窗切換鍵"] = "Toggle Window Key",
        ["自瞄範圍設置"] = "Aimbot Range Settings",
        ["顯示 FOV 範圍"] = "Show FOV Range",
        ["FOV 位置"] = "FOV Position",
        ["FOV 半徑大小"] = "FOV Radius",
        ["FOV 範圍顏色"] = "FOV Range Color",
        ["自瞄設置"] = "Aimbot Settings",
        ["M1 自瞄"] = "M1 Aimbot",
        ["技能自瞄"] = "Skill Aimbot",
        ["瞄準玩家"] = "Target Players",
        ["瞄準 NPC"] = "Target NPCs",
        ["團隊檢測"] = "Team Check",
        ["顯示鎖定紅線"] = "Show Lock Line",
        ["瞄準部位"] = "Target Part",
        ["靜默瞄準方法"] = "Silent Aim Method",
        ["滑鼠最近的玩家"] = "Closest to Mouse",
        ["最近的玩家"] = "Closest Player",
        ["選擇玩家"] = "Selected Player",
        ["語言"] = "Language",
        ["中文"] = "Chinese",
        ["語言已切換為: 中文"] = "Language switched to: Chinese",
        ["語言已切換為: English"] = "Language switched to: English",
    }
}

local function L(text)
    if _G.G_Language == "English" and Translations["English"][text] then
        return Translations["English"][text]
    end
    return text
end

local function CollectConfig()
    return {
        Attack = {
            FastAttack     = _G.G_FastAttack,
            FastAttackMode = _G.G_FastAttackMode,
            AttackMobs     = _G.G_AttackMobs,
            AttackPlayers  = _G.G_AttackPlayers,
            DragonGunM1    = _G.G_DragonGunM1,
            DragonGunSpeed = _G.G_DragonGunSpeed,
            FruitM1        = _G.G_FruitM1,
        },
        Auto = {
            AutoHaki       = _G.G_AutoHaki,
            AutoV3         = _G.G_AutoV3,
            AutoV4         = _G.G_AutoV4,
            AutoLowHpRace  = _G.G_AutoLowHpRace,
            LowHpRaceChoice = _G.G_LowHpRaceChoice,
            AutoSoru       = _G.G_AutoSoru,
        },
        ESP = {
            ESPEnabled   = _G.G_ESPEnabled,
            ESP_Name     = _G.G_ESP_Name,
            ESP_Level    = _G.G_ESP_Level,
            ESP_Bounty   = _G.G_ESP_Bounty,
            ESP_Fruit    = _G.G_ESP_Fruit,
            ESP_Distance = _G.G_ESP_Distance,
            ESP_HP       = _G.G_ESP_HP,
            ESP_TextSize = _G.G_ESP_TextSize,
            ESP_Highlight = _G.G_ESP_Highlight,
            ESP_HighlightColor = _G.G_ESP_HighlightColor,
        },
        Drawing = {
            SilentAimM1R   = _G.G_SilentAimM1R,
            SilentAimSkill = _G.G_SilentAimSkill,
            SilentAimShowFOV = _G.G_SilentAimShowFOV,
            SilentAimFOV     = _G.G_SilentAimFOV,
            SilentAimPart    = _G.G_SilentAimPart,
            SilentAimFOVThickness = _G.G_SilentAimFOVThickness,
            SilentAimFOVTransparency = _G.G_SilentAimFOVTransparency,
            SilentAimTargetPlayers = _G.G_SilentAimTargetPlayers,
            SilentAimTargetMobs    = _G.G_SilentAimTargetMobs,
            SilentAimShowLine      = _G.G_SilentAimShowLine,
            SilentAimFOVMode       = _G.G_SilentAimFOVMode,
            SilentAimTeamCheck     = _G.G_SilentAimTeamCheck,
            SilentAimMethod        = _G.G_SilentAimMethod,
            LockHotkey             = _G.G_LockHotkey,
            LockHotkeyMode         = _G.G_LockHotkeyMode,
        },
        Setting = {
            AutoLoadConfig = _G.G_AutoLoadConfig,
            AutoSaveConfig = _G.G_AutoSaveConfig,
        },
        UI = {
            Theme = _G.G_Theme,
            Language = _G.G_Language
        }
    }
end

function SaveConfiguration()
    local data = CollectConfig()
    writefile(CONFIG_FILE, HttpService:JSONEncode(data))
end

function LoadConfiguration()
    if not isfile(CONFIG_FILE) then return end
    local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
    for section, values in pairs(data) do
        for k, v in pairs(values) do
            _G["G_" .. k] = v
        end
    end
end

pcall(LoadConfiguration)
_G.FOVMode = _G.G_SilentAimFOVMode or "跟隨滑鼠"

local WindUI = loadstring(request({
    Url = "https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"
}).Body)()

WindUI:SetTheme(_G.G_Theme)

local Window = WindUI:CreateWindow({
    Title = "PVvX7r",
    Icon = "",
    Author = "PVvX7r",
    Folder = "WindUI",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = _G.G_Theme,
    Acrylic = false,
    HideSearchBar = false,
    SideBarWidth = 200,
    OpenButton = {
        Title = "PVvX7r",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        OnlyMobile = false,
        Draggable = true,
        OnlyIcon = false,
        Color = ColorSequence.new(
            Color3.fromHex("#FF4444"),
            Color3.fromHex("#FF8800")
        ),
    },
    ToggleKey = Enum.KeyCode.G,
})

local Tabs = {
    [L("公告")] = Window:Section({ Title = L("公告"), Opened = true }),
    [L("主要功能")] = Window:Section({ Title = L("主要功能"), Opened = true }),
    [L("設置")] = Window:Section({ Title = L("設置"), Opened = true }),
}

local PVvX7r = {
    [L("公告")] = Tabs[L("公告")]:Tab({ Title = L("公告"), Icon = "bell" }),
    [L("主要功能")] = Tabs[L("主要功能")]:Tab({ Title = L("主要功能"), Icon = "zap" }),
    ["ESP"]     = Tabs[L("主要功能")]:Tab({ Title = "ESP", Icon = "eye" }),
    [L("繪製")]     = Tabs[L("主要功能")]:Tab({ Title = L("FOV"), Icon = "pen-tool" }),
    ["特別"]     = Tabs[L("主要功能")]:Tab({ Title = L("特別"), Icon = "star" }),
    [L("設置")]     = Tabs[L("設置")]:Tab({ Title = L("設置"), Icon = "settings" }),
    ["飛行與移動"] = Tabs[L("主要功能")]:Tab({ Title = "飛行與移動", Icon = "rocket" }),
    ["DragonGun"] = Tabs[L("主要功能")]:Tab({ Title = "DragonGun", Icon = "crosshair" }),
    -- ========== 新增传送 Tab ==========
    ["传送"] = Tabs[L("主要功能")]:Tab({ Title = "传送", Icon = "map" }),
}

PVvX7r[L("公告")]:Paragraph({
    Title = L("公告"),
    Desc = L("目前無法使用更改機器人")
})

local function IsAlive(character)
    if not character then return false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.Health and humanoid.Health > 0
end

local function GetRandomValidPart(target)
    if not target then return nil end
    local hrp = target:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local parts = { target:FindFirstChild("Head"), target:FindFirstChild("UpperTorso"), target:FindFirstChild("LowerTorso"), target:FindFirstChild("Torso"), hrp }
    local validParts = {}
    for _, p in ipairs(parts) do
        if p and p:IsA("BasePart") then table.insert(validParts, p) end
    end
    if #validParts > 0 then return validParts[math.random(1, #validParts)] end
    return hrp
end

local M1_State = { consecutiveFailures = 0, maxConsecutiveFailures = 5, Remotes = nil, Net = nil, RegisterAttack = nil, RegisterHit = nil, Enemies = nil }

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

task.spawn(function()
    local Modules = ReplicatedStorage:WaitForChild("Modules")
    local DragonNet = Modules:WaitForChild("Net")
    local ShootGunEvent = DragonNet:WaitForChild("RE/ShootGunEvent")
    local Validator2 = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Validator2")
    local getupval = debug.getupvalue or getupvalue
    local setupval = debug.setupvalue or setupval
    local getupvals = debug.getupvalues or getupvals
    local ShootFunction
    local V_Idx = { v26 = 12, v22 = 13, v25 = 14, v21 = 15, v23 = 16, v24 = 17, v27 = 18 }
    
    local function InitDragonGun()
        local success, result = pcall(require, ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("CombatController"))
        if success and type(result) == "table" and result.Attack then ShootFunction = getupval(result.Attack, 9) end
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
    
    local function GetClosestTarget()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local closest, dist = nil, math.huge
        local myPos = root.Position
        if _G.G_AttackMobs then
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
        if _G.G_AttackPlayers then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local pHum = player.Character:FindFirstChildOfClass("Humanoid")
                    local pRoot = player.Character:FindFirstChild("HumanoidRootPart")
                    if pHum and pHum.Health > 0 and pRoot then
                        local d = (pRoot.Position - myPos).Magnitude
                        if d < dist then dist = d; closest = pRoot end
                    end
                end
            end
        end
        return closest
    end
    
    while true do
        local currentSpeed = _G.G_DragonGunSpeed
        if not currentSpeed or currentSpeed < 0 then
            currentSpeed = 0.001
        end
        task.wait(currentSpeed)
        
        if not _G.G_DragonGunM1 then continue end
        pcall(function()
            local char = LocalPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if not tool or tool.ToolTip ~= "Gun" then return end
            local targetPart = GetClosestTarget()
            if not targetPart then return end
            local valCode, valCount = GetNextValidator()
            if valCode ~= 0 then Validator2:FireServer(valCode, valCount) end
            tool:SetAttribute("LocalOverheat", 0)
            tool:SetAttribute("LocalTotalShots", (tool:GetAttribute("LocalTotalShots") or 0) + 1)
            ShootGunEvent:FireServer(targetPart.Position, { targetPart })
        end)
    end
end)

local FruitAttackConnection = nil
local FruitAttack = false

local function GetPlayerFruit()
    local char = LocalPlayer.Character
    if not char then return nil end
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
            return tool
        end
    end
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.ToolTip == "Blox Fruit" then
                return tool
            end
        end
    end
    return nil
end

local function SetFruitM1Enabled(enabled)
    FruitAttack = enabled
    if enabled then
        if FruitAttackConnection then
            task.cancel(FruitAttackConnection)
        end
        FruitAttackConnection = task.spawn(function()
            while FruitAttack do
                task.wait(0.1)
                local fruit = GetPlayerFruit()
                if not fruit then continue end
                local remote = fruit:FindFirstChild("LeftClickRemote")
                if not remote then continue end
                local char = LocalPlayer.Character
                local myHRP = char and char:FindFirstChild("HumanoidRootPart")
                if not myHRP then continue end
                if _G.G_AttackPlayers then
                    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                            local hum       = player.Character:FindFirstChild("Humanoid")
                            if targetHRP and hum and hum.Health > 0 then
                                  if (targetHRP.Position - myHRP.Position).Magnitude < 500 then
                                      local dir = (targetHRP.Position - myHRP.Position).Unit
                                    pcall(function() remote:FireServer(Vector3.new(dir.X, dir.Y, dir.Z), 1, true) end)
                                end
                            end
                        end
                    end
                end
                if _G.G_AttackMobs then
                    local enemiesFolder = workspace:FindFirstChild("Enemies")
                    if enemiesFolder then
                        for _, npc in pairs(enemiesFolder:GetChildren()) do
                            local targetHRP = npc:FindFirstChild("HumanoidRootPart")
                            local hum       = npc:FindFirstChild("Humanoid")
                              if targetHRP and hum and hum.Health > 0 then
                                  if (targetHRP.Position - myHRP.Position).Magnitude < 500 then
                                      local dir = (targetHRP.Position - myHRP.Position).Unit
                                      pcall(function() remote:FireServer(Vector3.new(dir.X, dir.Y, dir.Z), 1, true) end)
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        if FruitAttackConnection then
            task.cancel(FruitAttackConnection)
            FruitAttackConnection = nil
        end
    end
end

if _G.G_FruitM1 then
    SetFruitM1Enabled(true)
end

local function startAutoHakiLoop()
    task.spawn(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local remotes = ReplicatedStorage:WaitForChild("Remotes", 5)
        local commF = remotes and remotes:WaitForChild("CommF_", 5)
        while true do
            task.wait(2) 
            if _G.G_AutoHaki and commF then
                local Character = LocalPlayer.Character
                if Character and not Character:FindFirstChild("HasBuso") then
                    pcall(function()
                        commF:InvokeServer("Buso")
                    end)
                end
            end
        end
    end)
end

local function GetAwakeningRemote()
    local p = Players.LocalPlayer
    if not p then return nil end
    local backpack = p:FindFirstChild("Backpack")
    local awakening = backpack and backpack:FindFirstChild("Awakening")
    if awakening and awakening:FindFirstChild("RemoteFunction") then
        return awakening.RemoteFunction
    end
    local char = p.Character
    local charAwakening = char and char:FindFirstChild("Awakening")
    if charAwakening and charAwakening:FindFirstChild("RemoteFunction") then
        return charAwakening.RemoteFunction
    end
    return nil
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.G_AutoV4 then
            local remote = GetAwakeningRemote()
            if remote then
                task.spawn(function()
                    pcall(function()
                        remote:InvokeServer(true)
                    end)
                end)
            end
        end
    end
end)

local function handleAbility(abilityType)
    task.spawn(function()
        while true do
            if abilityType == "V3" and _G["G_Auto"..abilityType] then
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local CommE = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommE")
                if CommE then
                    pcall(function() CommE:FireServer("ActivateAbility") end)
                end
            end
            task.wait(1)
        end
    end)
end

startAutoHakiLoop()
handleAbility("V3")

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

-- ==========================================
-- 主要功能标签页的控件
-- ==========================================
PVvX7r[L("主要功能")]:Toggle({
    Title = L("自動武裝色"),
    Value = _G.G_AutoHaki,
    Callback = function(v)
        _G.G_AutoHaki = v
        SaveConfiguration()
    end
})

PVvX7r[L("主要功能")]:Toggle({
    Title = L("自動 V3"),
    Value = _G.G_AutoV3,
    Callback = function(v)
        _G.G_AutoV3 = v
        SaveConfiguration()
    end
})

PVvX7r[L("主要功能")]:Toggle({
    Title = L("自動 V4"),
    Desc = "自動開啟V4",
    Value = _G.G_AutoV4,
    Callback = function(v)
        _G.G_AutoV4 = v
        SaveConfiguration()
    end
})

-- ========== 从 PVP 移入的两个控件 ==========
PVvX7r[L("主要功能")]:Toggle({
    Title = L("開啟快速攻擊"),
    Value = _G.G_FastAttack,
    Callback = function(v)
        _G.G_FastAttack = v
        SaveConfiguration()
    end
})

PVvX7r[L("主要功能")]:Dropdown({
    Title = L("快速攻擊模式"),
    Values = {"模式1", "模式2(部分帳號失效用)"},
    Value = _G.G_FastAttackMode,
    Callback = function(v)
        _G.G_FastAttackMode = v
        SaveConfiguration()
    end
})
-- ==========================================

-- ==========================================
-- 自动瞬步 (AutoSoru) 功能 - 新增
-- ==========================================
local AutoSoruConn = nil

local function SoruTo(targetPosition)
    local Character = LocalPlayer.Character
    if not Character then return end

    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not HumanoidRootPart or not Humanoid or Humanoid.Health <= 0 then return end

    local startCFrame = HumanoidRootPart.CFrame
    local finalPos = targetPosition
    local finalCFrame = (startCFrame - startCFrame.Position) + finalPos + Vector3.new(0, HumanoidRootPart.Size.Y * 1.5, 0)

    local randomId = math.random(1, 999999999)
    ReplicatedStorage.Remotes.CommE:FireServer(
        "Soru",
        startCFrame,
        finalCFrame,
        workspace:GetServerTimeNow(),
        randomId
    )
end

local function GetClosestPlayerForSoru()
    local closestPlayer = nil
    local shortestDistance = math.huge

    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end

    local myPos = Character.HumanoidRootPart.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local otherChar = player.Character
            local otherHum = otherChar and otherChar:FindFirstChild("Humanoid")
            local otherRoot = otherChar and otherChar:FindFirstChild("HumanoidRootPart")
            if otherHum and otherRoot and otherHum.Health > 0 then
                local distance = (otherRoot.Position - myPos).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    return closestPlayer
end

local function SoruToClosestPlayer()
    local targetPlayer = GetClosestPlayerForSoru()
    local targetChar = targetPlayer and targetPlayer.Character
    if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
        local targetPos = (targetChar.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)).Position
        SoruTo(targetPos)
    end
end

local function StartAutoSoru()
    if AutoSoruConn then return end
    AutoSoruConn = task.spawn(function()
        while _G.G_AutoSoru do
            pcall(SoruToClosestPlayer)
            task.wait(1)   -- 每秒一次，可自行调整
        end
    end)
end

local function StopAutoSoru()
    if AutoSoruConn then
        task.cancel(AutoSoruConn)
        AutoSoruConn = nil
    end
end

PVvX7r[L("主要功能")]:Toggle({
    Title = "自动瞬步",
    Desc = "每15秒强制打你2500血你气不气😂",
    Value = _G.G_AutoSoru,
    Callback = function(v)
        _G.G_AutoSoru = v
        if v then
            StartAutoSoru()
        else
            StopAutoSoru()
        end
        SaveConfiguration()
    end
})
-- ==========================================

local FlyTab = PVvX7r["飛行與移動"]

_G.G_FlyEnabled = _G.G_FlyEnabled or false
_G.G_NoclipEnabled = _G.G_NoclipEnabled or false
_G.G_FlySpeed = _G.G_FlySpeed or 1

local flying = _G.G_FlyEnabled
local flyConnection = nil
local noclipOn = _G.G_NoclipEnabled
local noclipConnection = nil
local speeds = _G.G_FlySpeed
local ctrl = {f = 0, b = 0, l = 0, r = 0, u = 0, d = 0}

local keyMap = {
    [Enum.KeyCode.W] = "f",
    [Enum.KeyCode.S] = "b",
    [Enum.KeyCode.A] = "l",
    [Enum.KeyCode.D] = "r",
    [Enum.KeyCode.E] = "u",
    [Enum.KeyCode.Q] = "d"
}

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    local dir = keyMap[input.KeyCode]
    if dir then
        ctrl[dir] = (dir == "b" or dir == "l" or dir == "d") and -1 or 1
    end
end)

UIS.InputEnded:Connect(function(input)
    local dir = keyMap[input.KeyCode]
    if dir then
        ctrl[dir] = 0
    end
end)

local function stopFlying()
    flying = false
    _G.G_FlyEnabled = false
    ctrl.u = 0
    ctrl.d = 0
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
            local bg = root:FindFirstChild("FlyBodyGyro")
            local bv = root:FindFirstChild("FlyBodyVelocity")
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end
        if char:FindFirstChild("Animate") then
            char.Animate.Disabled = false
        end
    end
end

local function startFlying()
    flying = true
    _G.G_FlyEnabled = true
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not rootPart or not hum then return end

    hum.PlatformStand = true
    if char:FindFirstChild("Animate") then
        char.Animate.Disabled = true
    end

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
            bv.velocity = moveDir.Unit * (baseSpeed * speeds)
        else
            bv.velocity = Vector3.new(0, 0, 0)
        end
        bg.cframe = cam.CFrame
    end)
end

LocalPlayer.CharacterAdded:Connect(function()
    stopFlying()
end)

FlyTab:Paragraph({
    Title = "⚡ 飛行與移動控制面板",
    Desc = "在此控制您的飛行、穿牆、移動速度及上下升降狀態。"
})

FlyTab:Toggle({
    Title = "開啟飛行",
    Value = _G.G_FlyEnabled,
    Callback = function(v)
        if v then
            startFlying()
        else
            stopFlying()
        end
        SaveConfiguration()
    end
})

FlyTab:Toggle({
    Title = "開啟穿牆",
    Value = _G.G_NoclipEnabled,
    Callback = function(v)
        _G.G_NoclipEnabled = v
        noclipOn = v
        if noclipOn then
            noclipConnection = RunService.Stepped:Connect(function()
                local char = LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
        SaveConfiguration()
    end
})

FlyTab:Slider({
    Title = "飛行速度",
    Value = {
        Min = 1,
        Max = 10,
        Default = _G.G_FlySpeed or 1
    },
    Callback = function(v)
        speeds = v
        _G.G_FlySpeed = v
        SaveConfiguration()
    end
})

FlyTab:Button({
    Title = "上升 (Press / Hold)",
    Callback = function()
        ctrl.u = 1
        task.delay(0.2, function() ctrl.u = 0 end)
    end
})

FlyTab:Button({
    Title = "下降 (Press / Hold)",
    Callback = function()
        ctrl.d = -1
        task.delay(0.2, function() ctrl.d = 0 end)
    end
})

PVvX7r["特別"]:Dropdown({ Title = L("選擇低血量切換種族"), Values = { "吸血鬼", "機器人" }, Value = _G.G_LowHpRaceChoice, Callback = function(v) _G.G_LowHpRaceChoice = v; SaveConfiguration() end })
PVvX7r["特別"]:Toggle({ Title = L("血量低於20%自動更換種族"), Value = _G.G_AutoLowHpRace, Callback = function(v) _G.G_AutoLowHpRace = v; SaveConfiguration() end })

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    if _G.G_SilentAimSkill and _G.G_SilentAimTargetPos and (method == "FireServer" or method == "InvokeServer") then
        local sName = tostring(self)
        if sName == "RemoteEvent" or sName == "CommE" or sName == "RemoteFunction" then
            for i, v in pairs(args) do
                if typeof(v) == "Vector3" then
                    args[i] = _G.G_SilentAimTargetPos
                end
            end
            return oldNamecall(self, unpack(args))
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

local ESPRunning = false
local espObjects = {}
local espUpdateConnection = nil

local function getTeamInfo(player)
    if not player.Team then
        return "Unknown", Color3.fromRGB(255,255,255)
    end
    if player.Team.Name == "Marines" then
        return "海軍", Color3.fromRGB(0,170,255)
    else
        return "海賊", Color3.fromRGB(255,70,70)
    end
end

local function hexToColor3(hex)
    local r = tonumber(hex:sub(1,2), 16) / 255 or 0
    local g = tonumber(hex:sub(3,4), 16) / 255 or 1
    local b = tonumber(hex:sub(5,6), 16) / 255 or 0
    return Color3.new(r, g, b)
end

local function removeESP(player)
    if espObjects[player] then
        pcall(function()
            espObjects[player].gui:Destroy()
            if espObjects[player].highlight then
                espObjects[player].highlight:Destroy()
            end
        end)
        espObjects[player] = nil
    end
end

local function createESP(player)
    if player:GetAttribute("IsAuthor") or 
       player.Name == "Mas_Yes" or 
       player.Name == "sjqgduf" or 
       player.Name == "huha123444" or 
       player.Name == "ksxrcm111" or
       player.Name == "Dddyy5" then 
        return 
    end
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local team, color = getTeamInfo(player)
    local billboard = Instance.new("BillboardGui")
    billboard.Adornee = head
    billboard.Size = UDim2.new(0,200,0,70)
    billboard.StudsOffset = Vector3.new(0,3,0)
    billboard.AlwaysOnTop = true
    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.TextScaled = false
    text.TextSize = _G.G_ESP_TextSize
    text.RichText = true
    text.Font = Enum.Font.SourceSansBold
    text.TextStrokeTransparency = 0
    text.TextColor3 = color
    text.Parent = billboard
    billboard.Parent = head
    local highlight = nil
    if _G.G_ESP_Highlight then
        local hlColor = hexToColor3(_G.G_ESP_HighlightColor)
        highlight = Instance.new("Highlight")
        highlight.Name = "ESP_PlayerHighlight"
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = hlColor
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = hlColor
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

local lastESPUpdate = 0
local ESP_UPDATE_INTERVAL = 0.1
local playerCache = {}

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
    for _,player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player:GetAttribute("IsAuthor") or 
               player.Name == "Mas_Yes" or 
               player.Name == "sjqgdu6" or 
               player.Name == "huha124444" or 
               player.Name == "ksxrcn111" or
               player.Name == "Dddyy5" then 
                if espObjects[player] then
                    removeESP(player)
                end
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
                if data then
                    removeESP(player)
                end
                continue
            end
            if not data then continue end
            if char then
                local hum = char:FindFirstChild("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum and root then
                    local distance = math.floor((root.Position - myPos).Magnitude)
                    local hp = math.floor((hum.Health/hum.MaxHealth)*100)
                    local pData = getPlayerData(player)
                    local level = pData.level
                    local fruit = pData.fruit
                    local bounty = pData.bounty
                    local team = pData.team
                    local color = pData.color
                    local warnTag = ""
                    if bounty > 10000000 then
                        warnTag = "⚠ "
                    end
                    local pvpState = "⚔ PVP已開啟 "
                    local pvpIcon = "🔴 "
                    local isPvpDisabled = false
                    if player:GetAttribute("PvpDisabled") == true then
                        pvpState = "PvP已關閉 "
                        pvpIcon = "🟢 "
                        isPvpDisabled = true
                    end
                    data.label.TextColor3 = color
                    if data.label.TextSize ~= _G.G_ESP_TextSize then
                        data.label.TextSize = _G.G_ESP_TextSize
                    end
                    local parts = {}
                    if _G.G_ESP_Name then parts[#parts+1] = warnTag .. "[" .. team .. "] <font color=\"rgb(255,255,0)\">" .. player.Name .. "</font>" end
                    if _G.G_ESP_Level then parts[#parts+1] = " [Lv." .. level .. "]" end
                    if isPvpDisabled then
                        parts[#parts+1] = "\n<font color=\"rgb(0,255,0)\">" .. pvpIcon .. pvpState .. "</font>\n"
                    else
                        parts[#parts+1] = "\n" .. pvpIcon .. pvpState .. "\n"
                    end
                    if _G.G_ESP_Fruit then parts[#parts+1] = "水果: " .. fruit .. "\n" end
                    if _G.G_ESP_Bounty then parts[#parts+1] = "賞金: " .. math.floor(bounty/1000000) .. "M\n" end
                    if _G.G_ESP_Distance then parts[#parts+1] = distance .. "米 | " end
                    if _G.G_ESP_HP then parts[#parts+1] = "生命 " .. hp .. "%" end
                    data.label.Text = table.concat(parts)
            
                    if _G.G_ESP_Highlight then
                        local hlColor = hexToColor3(_G.G_ESP_HighlightColor)
                        pcall(function()
                            for _, child in ipairs(char:GetChildren()) do
                                if child:IsA("Highlight") and child.Name ~= "ESP_PlayerHighlight" then
                                    child.FillColor = hlColor
                                    child.OutlineColor = hlColor
                                    child.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                end
                            end
                        end)
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
                            data.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        end
                    else
                        if data.highlight then
                            data.highlight:Destroy()
                            data.highlight = nil
                        end
                    end
                end
            end
        end
    end
end

function EnableESP()
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

function DisableESP()
    ESPRunning = false
    espUpdateConnection = nil
    for player, _ in pairs(espObjects) do
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
    if _G.G_ESPEnabled then
        EnableESP()
    end
end)

PVvX7r["ESP"]:Toggle({
    Title = L("ESP 開關"),
    Value = _G.G_ESPEnabled,
    Callback = function(state)
        _G.G_ESPEnabled = state
        if state then EnableESP() else DisableESP() end
        SaveConfiguration()
    end
})

PVvX7r["ESP"]:Toggle({
    Title = L("顯示玩家名字"),
    Value = _G.G_ESP_Name,
    Callback = function(v)
        _G.G_ESP_Name = v
        SaveConfiguration()
    end
})

PVvX7r["ESP"]:Toggle({
    Title = L("顯示玩家等級"),
    Value = _G.G_ESP_Level,
    Callback = function(v)
        _G.G_ESP_Level = v
        SaveConfiguration()
    end
})

PVvX7r["ESP"]:Toggle({
    Title = L("顯示玩家賞金"),
    Value = _G.G_ESP_Bounty,
    Callback = function(v)
        _G.G_ESP_Bounty = v
        SaveConfiguration()
    end
})

PVvX7r["ESP"]:Toggle({
    Title = L("顯示惡魔果實"),
    Value = _G.G_ESP_Fruit,
    Callback = function(v)
        _G.G_ESP_Fruit = v
        SaveConfiguration()
    end
})

PVvX7r["ESP"]:Toggle({
    Title = L("顯示距離"),
    Value = _G.G_ESP_Distance,
    Callback = function(v)
        _G.G_ESP_Distance = v
        SaveConfiguration()
    end
})

PVvX7r["ESP"]:Toggle({
    Title = L("顯示血量"),
    Value = _G.G_ESP_HP,
    Callback = function(v)
        _G.G_ESP_HP = v
        SaveConfiguration()
    end
})

PVvX7r["ESP"]:Toggle({
    Title = L("高亮顯示玩家"),
    Value = _G.G_ESP_Highlight,
    Callback = function(v)
        _G.G_ESP_Highlight = v
        SaveConfiguration()
    end
})

PVvX7r["ESP"]:Colorpicker({
    Title = L("高亮顏色"),
    Default = hexToColor3(_G.G_ESP_HighlightColor),
    Transparency = 0,
    Callback = function(color)
        _G.G_ESP_HighlightColor = string.format("%02X%02X%02X",
            math.floor(color.R * 255 + 0.5),
            math.floor(color.G * 255 + 0.5),
            math.floor(color.B * 255 + 0.5))
        SaveConfiguration()
    end
})

PVvX7r["ESP"]:Slider({
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

local currentThemeName = WindUI:GetCurrentTheme()
local availableThemes = WindUI:GetThemes()
local themeList = {}
for themeName, _ in pairs(availableThemes) do
    table.insert(themeList, themeName)
end

PVvX7r[L("設置")]:Keybind({
    Title = L("視窗切換鍵"),
    Desc = L("切換視窗顯示狀態"),
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

PVvX7r[L("設置")]:Button({
    Title = L("語言") .. " (" .. _G.G_Language .. ")",
    Icon = "globe",
    Callback = function()
        if _G.G_Language == "中文" then
            _G.G_Language = "English"
        else
            _G.G_Language = "中文"
        end
        SaveConfiguration()
        WindUI:Notify({
            Title = L("語言"),
            Content = _G.G_Language == "English" and L("語言已切換為: English") or L("語言已切換為: 中文"),
            Duration = 3
        })
    end
})

PVvX7r[L("設置")]:Dropdown({
    Title = L("選擇主題"),
    Values = themeList,
    Value = _G.G_Theme,
    Callback = function(v)
        _G.G_Theme = v
        WindUI:SetTheme(v)
        if _G.G_AutoSaveConfig then SaveConfiguration() end
    end
})

PVvX7r[L("設置")]:Toggle({
    Title = L("自動保存配置"),
    Value = _G.G_AutoSaveConfig,
    Callback = function(v)
        _G.G_AutoSaveConfig = v
    end
})

PVvX7r[L("設置")]:Toggle({
    Title = L("進遊戲自動加載配置"),
    Value = _G.G_AutoLoadConfig,
    Callback = function(v)
        _G.G_AutoLoadConfig = v
    end
})

PVvX7r[L("設置")]:Button({
    Title = L("保存配置"),
    Callback = function()
        SaveConfiguration()
        WindUI:Notify({ Title = L("保存配置"), Content = L("加載完成"), Duration = 2 })
    end
})

PVvX7r[L("設置")]:Button({
    Title = L("加載配置"),
    Callback = function()
        LoadConfiguration()
        WindUI:Notify({ Title = L("加載配置"), Content = L("加載完成"), Duration = 2 })
    end
})

local function IsAlive(character)
    if not character then return false end
    local hum = character:FindFirstChildOfClass("Humanoid")
    return hum ~= nil and hum.Health > 0
end

local c = Drawing.new("Circle")
c.Visible = false                   
c.Color = Color3.fromRGB(255, 0, 0) 
c.Radius = 150                      
c.Thickness = 2
c.Filled = false

local Line = Drawing.new("Line")
Line.Thickness = 2
Line.Color = Color3.fromRGB(255, 0, 0)
Line.Transparency = 1
Line.Visible = false

if _G.G_SilentAimShowFOV then c.Visible = true end
if _G.G_SilentAimFOV then c.Radius = _G.G_SilentAimFOV end

task.spawn(function()
    RunService.RenderStepped:Connect(function()
        if not c.Visible then return end
        local p
        if _G.FOVMode == "螢幕中心" then
            local v = workspace.CurrentCamera.ViewportSize
            p = Vector2.new(v.X / 2, v.Y / 2)
        else
            p = UIS:GetMouseLocation()
            if p.X <= 0 or p.Y <= 0 then
                local v = workspace.CurrentCamera.ViewportSize
                p = Vector2.new(v.X / 2, v.Y / 2)
            end
        end
        c.Position = p
    end)
end)

local currentSilentAimTarget = nil

local function IsSilentAimAlly(player)
    local main = LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Main")
    local frame = main and main:FindFirstChild("Allies")
        and main.Allies:FindFirstChild("Container")
        and main.Allies.Container:FindFirstChild("Allies")
        and main.Allies.Container.Allies:FindFirstChild("ScrollingFrame")
        and main.Allies.Container.Allies.ScrollingFrame:FindFirstChild("Frame")
    if not frame then return false end
    return frame:FindFirstChild(player.Name) ~= nil
end

local function IsSilentAimEnemy(player)
    if not player or player == LocalPlayer then return false end
    if IsSilentAimAlly(player) then return false end
    local myTeam, targetTeam = LocalPlayer.Team, player.Team
    if myTeam and targetTeam and myTeam.Name == "Marines" and targetTeam.Name == "Marines" then
        return false
    end
    return true
end

local function GetSilentAimOrigin()
    local p = UIS:GetMouseLocation()
    if _G.FOVMode == "螢幕中心" or p.X <= 0 or p.Y <= 0 then
        local v = workspace.CurrentCamera.ViewportSize
        return Vector2.new(v.X / 2, v.Y / 2)
    end
    return p
end

local function GetClosestTargetToMouse()
    local method = _G.G_SilentAimMethod or "滑鼠最近的玩家"

    if method == "選擇玩家" then
        if not _G.G_SilentAimTargetPlayers then return nil end
        local name = _G.G_SilentAimSelectedPlayer
        if not name or name == "" then return nil end
        local player = Players:FindFirstChild(name)
        if not player or player == LocalPlayer then return nil end
        if _G.G_SilentAimTeamCheck and not IsSilentAimEnemy(player) then return nil end
        local character = player.Character
        if not IsAlive(character) then return nil end
        return character:FindFirstChild(_G.G_SilentAimPart) or character:FindFirstChild("HumanoidRootPart")
    end

    if method == "最近的玩家" then
        local myChar = LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil end
        local closest, shortest = nil, math.huge
        local myPos = myRoot.Position

        local function checkNearest(character)
            if not IsAlive(character) then return end
            local part = character:FindFirstChild(_G.G_SilentAimPart) or character:FindFirstChild("HumanoidRootPart")
            if not part then return end
            local d = (part.Position - myPos).Magnitude
            if d < shortest then closest, shortest = part, d end
        end

        if _G.G_SilentAimTargetPlayers then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    if not _G.G_SilentAimTeamCheck or IsSilentAimEnemy(player) then
                        checkNearest(player.Character)
                    end
                end
            end
        end
        if _G.G_SilentAimTargetMobs and workspace:FindFirstChild("Enemies") then
            for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
                checkNearest(enemy)
            end
        end
        return closest
    end

    local origin = GetSilentAimOrigin()
    local closest, shortest = nil, c.Radius

    local function check(character)
        if not IsAlive(character) then return end
        local part = character:FindFirstChild(_G.G_SilentAimPart) or character:FindFirstChild("HumanoidRootPart")
        if not part then return end
        local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(part.Position)
        if onScreen then
            local dist = (Vector2.new(pos.X, pos.Y) - origin).Magnitude
            if dist < shortest then closest, shortest = part, dist end
        end
    end

    if _G.G_SilentAimTargetPlayers then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if not _G.G_SilentAimTeamCheck or IsSilentAimEnemy(player) then
                    check(player.Character)
                end
            end
        end
    end
    if _G.G_SilentAimTargetMobs and workspace:FindFirstChild("Enemies") then
        for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
            check(enemy)
        end
    end
    return closest
end

local MouseModuleInstance = ReplicatedStorage:FindFirstChild("Mouse")
local MouseModule = nil
if MouseModuleInstance then
    pcall(function() MouseModule = require(MouseModuleInstance) end)
end
if MouseModule and typeof(MouseModule) == "table" then
    pcall(function()
        local realStore = { Hit = rawget(MouseModule, "Hit"), Target = rawget(MouseModule, "Target") }
        local mmt = getrawmetatable(MouseModule)
        if mmt then setreadonly(mmt, false) else mmt = {}; setmetatable(MouseModule, mmt) end
        rawset(MouseModule, "Hit", nil); rawset(MouseModule, "Target", nil)
        mmt.__index = function(self, key)
            if key == "Hit" then
                if _G.G_SilentAimSkill and currentSilentAimTarget then return CFrame.new(currentSilentAimTarget.Position) end
                return realStore.Hit
            elseif key == "Target" then
                if _G.G_SilentAimSkill and currentSilentAimTarget then return currentSilentAimTarget end
                return realStore.Target
            end
        end
        mmt.__newindex = function(self, key, value)
            if key == "Hit" or key == "Target" then realStore[key] = value else rawset(self, key, value) end
        end
        setreadonly(mmt, true)
    end)
end

local mouse = LocalPlayer:GetMouse()
local oldIndex
pcall(function()
    oldIndex = hookmetamethod(game, "__index", function(self, key)
        if _G.G_SilentAimM1R and currentSilentAimTarget and not checkcaller() and self == mouse then
            local tp = currentSilentAimTarget.Position
            local cp = workspace.CurrentCamera.CFrame.Position
            if key == "Hit" then return CFrame.new(tp)
            elseif key == "Target" then return currentSilentAimTarget
            elseif key == "UnitRay" then return Ray.new(cp, (tp - cp).Unit)
            elseif key == "Origin" then return cp
            elseif key == "Direction" then return (tp - cp).Unit
            end
        end
        return oldIndex(self, key)
    end)
end)

RunService.RenderStepped:Connect(function()
    local p = UIS:GetMouseLocation()
    if _G.FOVMode == "螢幕中心" or p.X <= 0 or p.Y <= 0 then
        local v = workspace.CurrentCamera.ViewportSize
        p = Vector2.new(v.X / 2, v.Y / 2)
    end

    if _G.G_SilentAimM1R or _G.G_SilentAimSkill then
        currentSilentAimTarget = GetClosestTargetToMouse()
    else
        currentSilentAimTarget = nil
    end

    if _G.G_SilentAimShowLine and currentSilentAimTarget then
        local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(currentSilentAimTarget.Position)
        if onScreen then
            Line.Visible = true
            Line.From = p
            Line.To = Vector2.new(pos.X, pos.Y)
        else
            Line.Visible = false
        end
    else
        Line.Visible = false
    end
end)

-- ==========================================
-- FOV（繪製）标签页的控件（已删除龙枪功能）
-- ==========================================
local FOVTab = PVvX7r[L("繪製")]

FOVTab:Paragraph({
    Title = L("自瞄範圍設置"),
    Desc = L("在此處放置自瞄範圍、視野距離等相關調整。")
})

FOVTab:Toggle({
    Title = L("顯示 FOV 範圍"),
    Value = _G.G_SilentAimShowFOV,
    Callback = function(v)
        _G.G_SilentAimShowFOV = v
        c.Visible = v
        SaveConfiguration()
    end
})

FOVTab:Dropdown({
    Title = L("FOV 位置"),
    Values = {"跟隨滑鼠", "螢幕中心"},
    Value = _G.G_SilentAimFOVMode,
    Callback = function(v)
        _G.G_SilentAimFOVMode = v
        _G.FOVMode = v
        SaveConfiguration()
    end
})

FOVTab:Slider({
    Title = L("FOV 半徑大小"),
    Value = {
        Min = 10,
        Max = 800,
        Default = _G.G_SilentAimFOV or 100
    },
    Callback = function(v)
        _G.G_SilentAimFOV = v
        c.Radius = v
        SaveConfiguration()
    end
})

FOVTab:Colorpicker({
    Title = L("FOV 範圍顏色"),
    Default = c.Color,
    Transparency = 0,
    Callback = function(color)
        c.Color = color
        Line.Color = color
        SaveConfiguration()
    end
})

FOVTab:Divider()   -- 此分隔线现在直接连接自瞄设置部分

FOVTab:Paragraph({
    Title = L("自瞄設置"),
    Desc = L("在此處放置自瞄相關設定。")
})

FOVTab:Toggle({
    Title = L("M1 自瞄"),
    Value = _G.G_SilentAimM1R,
    Callback = function(v)
        _G.G_SilentAimM1R = v
        SaveConfiguration()
    end
})

FOVTab:Toggle({
    Title = L("技能自瞄"),
    Value = _G.G_SilentAimSkill,
    Callback = function(v)
        _G.G_SilentAimSkill = v
        SaveConfiguration()
    end
})

FOVTab:Toggle({
    Title = L("瞄準玩家"),
    Value = _G.G_SilentAimTargetPlayers,
    Callback = function(v)
        _G.G_SilentAimTargetPlayers = v
        SaveConfiguration()
    end
})

FOVTab:Toggle({
    Title = L("瞄準 NPC"),
    Value = _G.G_SilentAimTargetMobs,
    Callback = function(v)
        _G.G_SilentAimTargetMobs = v
        SaveConfiguration()
    end
})

FOVTab:Toggle({
    Title = L("團隊檢測"),
    Value = _G.G_SilentAimTeamCheck,
    Callback = function(v)
        _G.G_SilentAimTeamCheck = v
        SaveConfiguration()
    end
})

FOVTab:Toggle({
    Title = L("顯示鎖定紅線"),
    Value = _G.G_SilentAimShowLine,
    Callback = function(v)
        _G.G_SilentAimShowLine = v
        SaveConfiguration()
    end
})

FOVTab:Dropdown({
    Title = L("靜默瞄準方法"),
    Values = {"滑鼠最近的玩家", "最近的玩家", "選擇玩家"},
    Value = _G.G_SilentAimMethod,
    Callback = function(v)
        _G.G_SilentAimMethod = v
        SaveConfiguration()
    end
})

-- ============================================================
-- 独立 DragonGun Tab（完整保留）
-- ============================================================
local DragonGunTab = PVvX7r["DragonGun"]

DragonGunTab:Toggle({
    Title = "槍 M1",
    Value = _G.G_DragonGunM1_V2,
    Callback = function(v) 
        _G.G_DragonGunM1_V2 = v
        SaveConfiguration()
    end
})

DragonGunTab:Slider({
    Title = "槍 M1 發射間隔",
    Step = 0.001,
    Value = {
        Min = 0.001,
        Max = 0.2,
        Default = _G.G_M1FireInterval_V2
    },
    Callback = function(v)
        _G.G_M1FireInterval_V2 = v
        SaveConfiguration()
    end
})

DragonGunTab:Toggle({
    Title = "攻擊 NPC",
    Value = _G.G_AttackMobs_V2,
    Callback = function(v) 
        _G.G_AttackMobs_V2 = v
        SaveConfiguration()
    end
})

DragonGunTab:Toggle({
    Title = "攻擊玩家",
    Value = _G.G_AttackPlayers_V2,
    Callback = function(v) 
        _G.G_AttackPlayers_V2 = v
        SaveConfiguration()
    end
})

-- ============================================================
-- DragonGun V2 核心循环（完整保留）
-- ============================================================
task.spawn(function()
    local Modules = ReplicatedStorage:WaitForChild("Modules")
    local DragonNet = Modules:WaitForChild("Net")
    local ShootGunEvent = DragonNet:WaitForChild("RE/ShootGunEvent")
    local Validator2 = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Validator2")
    local getupval = debug.getupvalue or getupvalue
    local setupval = debug.setupvalue or setupval
    local getupvals = debug.getupvalues or getupvals
    local ShootFunction
    local V_Idx = { v26 = 12, v22 = 13, v25 = 14, v21 = 15, v23 = 16, v24 = 17, v27 = 18 }
    
    local function InitDragonGun()
        local success, result = pcall(require, ReplicatedStorage:WaitForChild("Controllers"):WaitForChild("CombatController"))
        if success and type(result) == "table" and result.Attack then ShootFunction = getupval(result.Attack, 9) end
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
        
        if _G.G_AttackMobs_V2 then
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
        
        if _G.G_AttackPlayers_V2 then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    if not _G.G_SilentAimTeamCheck or IsSilentAimEnemy(player) then
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
        task.wait(_G.G_M1FireInterval_V2)
        if not _G.G_DragonGunM1_V2 then continue end
        pcall(function()
            local char = LocalPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if not tool or tool.ToolTip ~= "Gun" then return end
            local targetPart = GetClosestDragonTarget()
            if not targetPart then return end
            local valCode, valCount = GetNextValidator()
            if valCode ~= 0 then Validator2:FireServer(valCode, valCount) end
            tool:SetAttribute("LocalOverheat", 0)
            tool:SetAttribute("LocalTotalShots", (tool:GetAttribute("LocalTotalShots") or 0) + 1)
            ShootGunEvent:FireServer(targetPart.Position, { targetPart })
        end)
    end
end)

-- ==========================================
-- 启动自动瞬步（若配置已开启）
-- ==========================================
if _G.G_AutoSoru then 
    StartAutoSoru() 
end

-- ==========================================
-- 新增传送 Tab 的内容（简体中文）
-- ==========================================
local TeleportTab = PVvX7r["传送"]

if next(TeleportLocations) == nil then
    TeleportTab:Paragraph({
        Title = "提示",
        Desc = "当前服务器不支持传送点（需在第二或第三世界）"
    })
else
    TeleportTab:Paragraph({
        Title = "快捷传送",
        Desc = "点击下方按钮直接传送至指定位置"
    })

    for name, pos in pairs(TeleportLocations) do
        TeleportTab:Button({
            Title = name,
            Icon = "map-pin",
            Callback = function()
                RequestEntrance(pos)
                WindUI:Notify({
                    Title = "传送",
                    Content = "正在传送至 " .. name,
                    Duration = 2
                })
            end
        })
    end
end

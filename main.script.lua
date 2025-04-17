-- OrionLibの読み込み
local OrionLib = loadstring(game:HttpGet("https://pastebin.com/raw/WRUyYTdY"))()

-- 必要なサービスと変数
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- GUIウィンドウ
local Window = OrionLib:MakeWindow({
    Name = "Blue Lock Rivals GUI | by Masashi",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MasashiBlueLock"
})

-- 速度制御用変数
local customSpeed = 16
local speedEnabled = false

-- スタミナ制御用変数
local infiniteStamina = false

-- メインタブ
local MainTab = Window:MakeTab({
    Name = "⚙️ 機能",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- スピードスライダー
MainTab:AddSlider({
    Name = "移動スピード（1〜500）",
    Min = 1,
    Max = 500,
    Default = 16,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        customSpeed = value
    end
})

MainTab:AddToggle({
    Name = "スピード適用ON/OFF",
    Default = false,
    Callback = function(state)
        speedEnabled = state
    end
})

-- スタミナ無限トグル
MainTab:AddToggle({
    Name = "スタミナ無限",
    Default = false,
    Callback = function(bool)
        infiniteStamina = bool
    end
})

-- 自動ゴール機能
MainTab:AddButton({
    Name = "自動ゴール",
    Callback = function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local goalPosition = Vector3.new(325, 20, -49)
        rootPart.CFrame = CFrame.new(goalPosition)
        task.wait(1.5)

        local shoot = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("BallService"):WaitForChild("RE"):WaitForChild("Shoot")
        local args = {
            [1] = {
                ["Power"] = 100,
                ["Curve"] = 0,
                ["Vertical"] = 0,
                ["Auto"] = true
            }
        }
        shoot:FireServer(unpack(args))
    end
})

-- スピードとスタミナの実行処理（毎フレームチェック）
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and speedEnabled then
            humanoid.WalkSpeed = customSpeed
        end
    end

    if infiniteStamina then
        local success, err = pcall(function()
            ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("StaminaService"):WaitForChild("RE"):WaitForChild("DecreaseStamina"):FireServer(0)
        end)
        if not success then
            warn("スタミナ無限失敗: " .. tostring(err))
        end
    end
end)

OrionLib:Init()

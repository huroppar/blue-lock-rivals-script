local Solara = loadstring(game:HttpGet("https://solara-dev.github.io/repo/solara.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 許可されたユーザー（自動認証）
local allowedUsers = {
    ["Furoppersama"] = true,
}

-- キー認証処理
local correctKey = "Masashi0407"
local isAuthenticated = false

if allowedUsers[LocalPlayer.Name] then
    isAuthenticated = true
else
    local input = tostring(game:GetService("Players"):PromptInput("キーを入力してください（Masashi0407）"))
    if input == correctKey then
        isAuthenticated = true
    else
        warn("❌ 認証失敗。正しいキーを入力してください。")
        return
    end
end

-- 認証後UI表示
local Window = Solara:CreateWindow("Blue Lock RIVAL GUI", "ようこそ " .. LocalPlayer.Name)
local MainTab = Window:CreateTab("Main")

-- スピード変更
local speed = 16
MainTab:CreateInput("Speed入力", function(val)
    speed = tonumber(val) or speed
    LocalPlayer.Character.Humanoid.WalkSpeed = speed
end)

MainTab:CreateSlider("Speed", 1, 500, function(val)
    speed = val
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end)

-- スタミナ無限
local staminaLoop = false
MainTab:CreateToggle("スタミナ無限", false, function(state)
    staminaLoop = state
    while staminaLoop do
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Stats") and char.Stats:FindFirstChild("Stamina") then
            char.Stats.Stamina.Value = 100
        end
        task.wait(0.1)
    end
end)

-- 自動ゴールボタン
MainTab:CreateButton("⚽ 自動ゴール", function()
    local goalPosition = Vector3.new(100, 10, 50) -- ←ゴール座標は要調整
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:MoveTo(goalPosition)
        task.wait(0.5)
        -- ここにシュート処理があれば追加（例えばリモートイベントなど）
        print("🌀 ゴール位置に移動しました（要シュート処理追加）")
    end
end)

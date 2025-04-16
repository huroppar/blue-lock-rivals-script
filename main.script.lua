--// ローダー準備
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

--// 複数ユーザー許可リスト
local allowedUsers = {
    ["Furoppersama"] = true,
    ["MyOtherUser"] = true,
    ["BestFriend123"] = true,
}

local correctKey = "Masashi0407"
local isAuthenticated = false
local localUsername = LocalPlayer and LocalPlayer.Name or "Unknown"

if allowedUsers[localUsername] then
    isAuthenticated = true
    warn("✅ ユーザー認証済み：「" .. localUsername .. "」")
else
    warn("⚠️ ユーザー名「" .. localUsername .. "」は登録されていません。キー認証が必要です。")
end

--// UI生成
local Window = Rayfield:CreateWindow({
    Name = "Blue Lock RIVAL GUI | " .. localUsername,
    LoadingTitle = "Blue Lock 起動中...",
    LoadingSubtitle = "By Masashi",
    ConfigurationSaving = {
        Enabled = false,
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

--// 認証用タブ
local AuthTab = Window:CreateTab("🔑 認証")
--// 機能用タブ（認証後に表示）
local MainTab = Window:CreateTab("⚽ 機能")

--// キー認証処理（ユーザー名一致しない人だけ）
if not isAuthenticated then
    AuthTab:CreateInput({
        Name = "キーを入力",
        PlaceholderText = "ここにキーを入力",
        RemoveTextAfterFocusLost = false,
        Callback = function(input)
            if input == correctKey then
                isAuthenticated = true
                Rayfield:Notify({
                    Title = "認証成功",
                    Content = "ようこそ！アクセスが許可されました。",
                    Duration = 5,
                })
            else
                Rayfield:Notify({
                    Title = "認証失敗",
                    Content = "キーが違います。",
                    Duration = 5,
                })
            end
        end
    })
end

--// 認証後に使える機能
task.spawn(function()
    while not isAuthenticated do task.wait(0.5) end

    MainTab:CreateSlider({
        Name = "移動速度",
        Range = {16, 100},
        Increment = 1,
        CurrentValue = 16,
        Callback = function(Value)
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    })

    MainTab:CreateToggle({
        Name = "スタミナ無限",
        CurrentValue = false,
        Callback = function(Value)
            while Value and task.wait(0.1) do
                local stamina = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Stamina")
                if stamina and stamina:IsA("NumberValue") then
                    stamina.Value = stamina.MaxValue or 100
                end
            end
        end
    })

    MainTab:CreateButton({
        Name = "自動ゴール機能（実験）",
        Callback = function()
            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local goal = workspace:FindFirstChild("Goal") or workspace:FindFirstChild("GoalPost")
            if goal then
                char:MoveTo(goal.Position + Vector3.new(0, 3, 0))
                Rayfield:Notify({
                    Title = "ゴール移動完了",
                    Content = "位置にテレポートしました。",
                    Duration = 4
                })
            else
                Rayfield:Notify({
                    Title = "ゴールが見つかりません",
                    Content = "ワークスペース内にGoalが見つかりません。",
                    Duration = 4
                })
            end
        end
    })
end)

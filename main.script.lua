--// Rayfieldの読み込み
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

--// プレイヤー名の取得（nil対策）
local localPlayer = game.Players.LocalPlayer
local localUsername = (localPlayer and localPlayer.Name) or "UnknownPlayer"

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

--// 認証フラグ（仮の変数：あとで上書き or 認証処理で更新）
local isAuthenticated = (localUsername == "Furoppersama") -- ここは例として書き換え可能
local correctKey = "masashi123" -- 任意のキーを設定してね

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

    -- GUI機能追加
    MainTab:CreateSlider({
        Name = "移動速度",
        Range = {16, 100},
        Increment = 1,
        CurrentValue = 16,
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    })

    MainTab:CreateToggle({
        Name = "スタミナ無限",
        CurrentValue = false,
        Callback = function(Value)
            local player = game.Players.LocalPlayer
            while Value and task.wait(0.1) do
                local stamina = player.Character and player.Character:FindFirstChild("Stamina")
                if stamina and stamina:IsA("NumberValue") then
                    stamina.Value = stamina.MaxValue or 100
                end
            end
        end
    })

    MainTab:CreateButton({
        Name = "自動ゴール機能（実験）",
        Callback = function()
            local player = game.Players.LocalPlayer
            local char = player.Character or player.CharacterAdded:Wait()
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

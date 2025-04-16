--[[  
  🌟 Blue Lock RIVAL Script - by Masashi 🌟
  ✅ 専用ユーザー: I_loveMidori
  ✅ キー認証: Masashi0407
  ✅ GUI: Rayfield UI
--]]

-- ユーザー名認証
if game.Players.LocalPlayer.Name ~= "I_loveMidori" then
    game.Players.LocalPlayer:Kick("このスクリプトは専用ユーザーのみ使用できます。")
    return
end

-- ライブラリ読み込み（Rayfield）
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- 正しいキー
local correctKey = "Masashi0407"

-- 認証状態
local isAuthenticated = false

-- GUI作成
local Window = Rayfield:CreateWindow({
    Name = "Blue Lock RIVAL - Masashi Edition",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by Masashi",
    ConfigurationSaving = {
       Enabled = true,
       FolderName = "BLRConfig",
       FileName = "UserConfig"
    },
    Discord = {
       Enabled = false
    },
    KeySystem = false
})

-- 認証ページ
local AuthTab = Window:CreateTab("🔐 認証", 4483362458)

AuthTab:CreateInput({
    Name = "キーを入力",
    PlaceholderText = "ここにキーを入力",
    RemoveTextAfterFocusLost = false,
    Callback = function(input)
        if input == correctKey then
            isAuthenticated = true
            Rayfield:Notify({
                Title = "認証成功",
                Content = "ようこそ、I_loveMidori さん！",
                Duration = 5,
                Image = nil
            })
        else
            Rayfield:Notify({
                Title = "認証失敗",
                Content = "キーが間違っています。",
                Duration = 5,
                Image = nil
            })
        end
    end
})

-- メイン機能タブ
local MainTab = Window:CreateTab("⚙️ メイン機能", 4483362458)

-- スピード調整
MainTab:CreateSlider({
    Name = "スピード調整",
    Range = {16, 500},
    Increment = 1,
    CurrentValue = 16,
    Flag = "SpeedSlider",
    Callback = function(Value)
        if isAuthenticated then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

-- スタミナ無限
local infiniteStamina = false
MainTab:CreateToggle({
    Name = "スタミナ無限",
    CurrentValue = false,
    Callback = function(Value)
        if isAuthenticated then
            infiniteStamina = Value
        end
    end,
})

-- 自動ゴール（仮実装）
MainTab:CreateButton({
    Name = "自動ゴール（仮）",
    Callback = function()
        if isAuthenticated then
            local char = game.Players.LocalPlayer.Character
            local goal = workspace:FindFirstChild("Goal") or workspace:FindFirstChild("Goals") -- ゴール位置取得
            if goal and char then
                char:MoveTo(goal.Position + Vector3.new(0, 3, 0)) -- ゴールへ移動
                wait(1)
                -- シュートのRemoteがあればここで叩ける（未調査）
            else
                Rayfield:Notify({
                    Title = "エラー",
                    Content = "ゴールが見つかりませんでした。",
                    Duration = 4
                })
            end
        end
    end,
})

-- スタミナ無限処理ループ
game:GetService("RunService").RenderStepped:Connect(function()
    if infiniteStamina and isAuthenticated then
        local stats = game.Players.LocalPlayer:FindFirstChild("Stamina") or game.Players.LocalPlayer:FindFirstChild("Stats")
        if stats then
            if stats:FindFirstChild("Stamina") then
                stats.Stamina.Value = 100
            end
        end
    end
end)

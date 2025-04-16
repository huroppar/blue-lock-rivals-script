-- OrionLibの読み込み
local OrionLib = loadstring(game:HttpGet("https://pastebin.com/raw/WRUyYTdY"))()

-- プレイヤー確認
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local allowedUser = "Furoppersama"
local authKey = "Masashi0407"

-- GUI作成
local Window = OrionLib:MakeWindow({
    Name = "🏀 Basketball Script | by Masashi",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MasashiBasketball"
})

-- 認証チェック
if LocalPlayer.Name ~= allowedUser then
    OrionLib:MakeNotification({
        Name = "認証システム",
        Content = "キーを入力してください。",
        Image = "rbxassetid://4483345998",
        Time = 5
    })

    OrionLib:MakeWindow({
        Name = "キー認証",
        HidePremium = false,
        IntroEnabled = false,
        SaveConfig = false
    }):AddTextbox({
        Name = "キーを入力",
        Default = "",
        TextDisappear = true,
        Callback = function(text)
            if text == authKey then
                OrionLib:MakeNotification({
                    Name = "成功",
                    Content = "認証成功！",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            else
                OrionLib:MakeNotification({
                    Name = "失敗",
                    Content = "キーが無効です",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
                task.wait(1)
                game:Shutdown()
            end
        end
    })
else
    OrionLib:MakeNotification({
        Name = "スキップ",
        Content = "Furoppersamaのため認証スキップ！",
        Image = "rbxassetid://4483345998",
        Time = 3
    })
end

-- メインタブ
local Tab = Window:MakeTab({
    Name = "メイン",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- スピードスライダー＆手入力
Tab:AddTextbox({
    Name = "スピード（手入力）",
    Default = "16",
    TextDisappear = false,
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 1 and num <= 500 then
            LocalPlayer.Character.Humanoid.WalkSpeed = num
        end
    end
})

Tab:AddSlider({
    Name = "スピードスライダー",
    Min = 1,
    Max = 500,
    Default = 16,
    Increment = 1,
    ValueName = "Speed",
    Callback = function(value)
        LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- スタミナ無限（毎フレーム満タンに）
local infiniteStamina = false
Tab:AddToggle({
    Name = "スタミナ無限",
    Default = false,
    Callback = function(bool)
        infiniteStamina = bool
        while infiniteStamina do
            pcall(function()
                -- 仮のスタミナプロパティ（ゲームにより変わる）
                LocalPlayer.Character.Stamina.Value = 100 -- ←ここは環境によって要調整
            end)
            task.wait(0.1)
        end
    end
})

-- 自動ゴール
Tab:AddButton({
    Name = "自動ゴール",
    Callback = function()
        local goalPosition = Vector3.new(100, 10, 50) -- ←ここにゴールの座標入れて
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        char:MoveTo(goalPosition)

        task.wait(1.5) -- 移動完了待ち（必要なら調整）

        -- シュート処理（ここも環境に合わせて調整）
        -- 例: fireproximityprompt(char:FindFirstChild("ShootPrompt"))
    end
})

OrionLib:Init()

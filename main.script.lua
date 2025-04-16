-- OrionLibの読み込み
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

-- プレイヤーとサービスの取得
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- 認証設定
local allowedUser = "Furoppersama"
local authKey = "Masashi0407"
local isAuthenticated = false

-- GUI作成
local Window = OrionLib:MakeWindow({
    Name = "Blue Lock Rivals GUI | by Masashi",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MasashiBlueLock"
})

-- 認証チェック
if LocalPlayer.Name ~= allowedUser then
    local AuthTab = Window:MakeTab({
        Name = "🔑 認証",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    AuthTab:AddTextbox({
        Name = "キーを入力",
        Default = "",
        TextDisappear = true,
        Callback = function(text)
            if text == authKey then
                isAuthenticated = true
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
    isAuthenticated = true
    OrionLib:MakeNotification({
        Name = "スキップ",
        Content = "Furoppersamaのため認証スキップ！",
        Image = "rbxassetid://4483345998",
        Time = 3
    })
end

-- メインタブ（認証後に表示）
if isAuthenticated then
    local MainTab = Window:MakeTab({
        Name = "⚽ メイン",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    -- スピードスライダー＆手入力
    MainTab:AddTextbox({
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

    MainTab:AddSlider({
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

    -- スタミナ無限（サーバーとの通信を利用）
    local infiniteStamina = false
    MainTab:AddToggle({
        Name = "スタミナ無限",
        Default = false,
        Callback = function(bool)
            infiniteStamina = bool
            while infiniteStamina do
                local args = { [1] = 0/0 }
                local success, err = pcall(function()
                    ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("StaminaService"):WaitForChild("RE"):WaitForChild("DecreaseStamina"):FireServer(unpack(args))
                end)
                if not success then
                    warn("スタミナ無限化に失敗しました:", err)
                end
                task.wait(0.1)
            end
        end
    })

    -- 自動ゴール
    MainTab:AddButton({
        Name = "自動ゴール",
        Callback = function()
            local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
            local rootPart = character:WaitForChild("HumanoidRootPart")
            local goalPosition = Vector3.new(325, 20, -49) -- ゴールの座標を適宜変更
            rootPart.CFrame = CFrame.new(goalPosition)
            task.wait(1.5) -- 移動完了待ち

            -- シュート処理
            local ballServiceRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("Services"):WaitForChild("BallService"):WaitForChild("RE"):WaitForChild("Shoot")
            local args = {
                [1] = {
                    ["Power"] = 100,
                    ["Curve"] = 0,
                    ["Vertical"] = 0,
                    ["Auto"] = true
                }
            }
            ballServiceRemote:FireServer(unpack(args))
        end
    })
end

OrionLib:Init()


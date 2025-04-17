-- GUIライブラリ読み込み
local OrionLib = loadstring(game:HttpGet("https://pastebin.com/raw/WRUyYTdY"))()
local Window = OrionLib:MakeWindow({Name = "Blue Lock Script", HidePremium = false, SaveConfig = false, IntroEnabled = false})

local ToggleValues = {
    Stamina = false,
    AutoGoal = false,
}

-- スタミナ無限の処理
task.spawn(function()
    while true do
        if ToggleValues.Stamina then
            local char = game.Players.LocalPlayer.Character
            local staminaFlag = char and char:FindFirstChild("OutOfStamina", true)
            if staminaFlag then
                staminaFlag:Destroy()
            end
        end
        task.wait(0.1)
    end
end)

-- 自動ゴールの処理
task.spawn(function()
    while true do
        if ToggleValues.AutoGoal then
            local lp = game.Players.LocalPlayer
            local ball = workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball")
            local goals = workspace:FindFirstChild("Goals")
            local char = lp.Character
            if not (ball and goals and char) then task.wait(0.3) continue end

            local team = lp.Team and lp.Team.Name
            local goalTarget = nil

            if team == "Red" then
                goalTarget = goals:FindFirstChild("Goal2") -- 敵ゴール
            elseif team == "Blue" then
                goalTarget = goals:FindFirstChild("Goal1")
            end

            if goalTarget and ball:IsA("BasePart") then
                ball.CFrame = CFrame.new(goalTarget.Position + Vector3.new(0, 1, 0))
            end
        end
        task.wait(0.5)
    end
end)

-- GUIにトグルを追加
local Tab = Window:MakeTab({Name = "メイン", Icon = "rbxassetid://4483345998", PremiumOnly = false})

Tab:AddToggle({
    Name = "🧃スタミナ無限",
    Default = false,
    Callback = function(Value)
        ToggleValues.Stamina = Value
    end
})

Tab:AddToggle({
    Name = "⚽自動ゴール",
    Default = false,
    Callback = function(Value)
        ToggleValues.AutoGoal = Value
    end
})

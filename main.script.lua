local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- GUI準備
local OrionLib = loadstring(game:HttpGet("https://pastebin.com/raw/WRUyYTdY"))()
local Window = OrionLib:MakeWindow({Name = "⚽ Soccer Hacks - Masashi", SaveConfig = true, ConfigFolder = "SoccerAuto"})

local MainTab = Window:MakeTab({Name = "Main", Icon = "🏃", PremiumOnly = false})
local ToggleValues = {Stamina = false, AutoGoal = false}

-- スタミナ無限処理
local function StaminaLoop()
    while ToggleValues.Stamina do
        local char = lp.Character
        local staminaFlag = char and char:FindFirstChild("OutOfStamina", true)
        if staminaFlag then
            staminaFlag:Destroy()
        end
        task.wait(0.1)
    end
end

-- 敵ゴール判定してボール移動
local function AutoGoalLoop()
    while ToggleValues.AutoGoal do
        local ball = workspace:FindFirstChild("Football") or workspace:FindFirstChild("Ball")
        local goals = workspace:FindFirstChild("Goals")
        local char = lp.Character
        if not (ball and goals and char) then task.wait(0.3) continue end

        local team = lp.Team and lp.Team.Name
        local goalTarget = nil

        if team == "Red" then
            goalTarget = goals:FindFirstChild("Goal1")
        elseif team == "Blue" then
            goalTarget = goals:FindFirstChild("Goal2")
        end

        if goalTarget and ball:IsA("BasePart") then
            -- ボールをゴール位置へ少しずつ移動
            ball.CFrame = CFrame.new(goalTarget.Position + Vector3.new(0, 1, 0))
        end

        task.wait(0.3)
    end
end

-- トグル設定
MainTab:AddToggle({
    Name = "スタミナ無限",
    Default = false,
    Callback = function(value)
        ToggleValues.Stamina = value
        if value then
            task.spawn(StaminaLoop)
        end
    end
})

MainTab:AddToggle({
    Name = "自動ゴール",
    Default = false,
    Callback = function(value)
        ToggleValues.AutoGoal = value
        if value then
            task.spawn(AutoGoalLoop)
        end
    end
})

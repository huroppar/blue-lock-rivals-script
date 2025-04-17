--// GUIセットアップ
local OrionLib = loadstring(game:HttpGet("https://pastebin.com/raw/WRUyYTdY"))()
local Window = OrionLib:MakeWindow({Name="⚽ Soccer Hacks - by Masashi", HidePremium=false, IntroText="Loading...", SaveConfig=true, ConfigFolder="SoccerHax"})

--// タブとセクション
local mainTab = Window:MakeTab({Name="Main", Icon="⚡", PremiumOnly=false})
local toggles = {Stamina=false, AutoGoal=false}

--// スタミナ無限処理
local function startStaminaHack()
    task.spawn(function()
        while toggles.Stamina do
            local char = game.Players.LocalPlayer.Character
            local head = char and char:FindFirstChild("Head")
            local stam = head and head:FindFirstChild("OutOfStamina")
            if stam then stam:Destroy() end
            task.wait(0.1)
        end
    end)
end

--// 自動ゴール処理
local function startAutoGoal()
    local ballName = "Football" -- ゲームによって調整
    task.spawn(function()
        while toggles.AutoGoal do
            local ball = workspace:FindFirstChild(ballName)
            local goals = workspace:FindFirstChild("Goals") or workspace:FindFirstChild("Goal") or workspace:FindFirstChild("GoalBox")
            if ball and goals then
                for _,v in pairs(goals:GetDescendants()) do
                    if v:IsA("BasePart") then
                        ball.Position = v.Position + Vector3.new(0, 1, 0) -- ゴールに向かわせる
                        break
                    end
                end
            end
            task.wait(0.3)
        end
    end)
end

--// GUIトグル追加
mainTab:AddToggle({
    Name = "スタミナ無限",
    Default = false,
    Callback = function(v)
        toggles.Stamina = v
        if v then startStaminaHack() end
    end
})

mainTab:AddToggle({
    Name = "自動ゴール送り",
    Default = false,
    Callback = function(v)
        toggles.AutoGoal = v
        if v then startAutoGoal() end
    end
})

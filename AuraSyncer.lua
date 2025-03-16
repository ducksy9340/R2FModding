--[[ 
    How it works
    The players TimeFor particles are the only
    ones that other players can see. This script
    makes it so the rest of their aura is synced 
    with their TimeFor particles.

    
    How to use
    1) Wait for your friend to load their style.
    2) Execute this script.
    3) Ask them to go into a fight, and enable their
    angry mode (Taunt twice to enable) (Important
    otherwise their aura will be red by default)
    4) Ask them to say in chat “syncaura”
    
    After that, you should see the aura their style
    has set for them.
    
    This script also accounts for new players, only
    execute it once.
]]

local players = game:GetService("Players")
local runService = game:GetService("RunService")

local chatCommand = "syncaura"
local auraUpdates = {}

players.LocalPlayer.PlayerGui.Notify:Fire('The chat command is "'..chatCommand..'".', "Gong")

function isInBattle(plr)
    return plr:FindFirstChild("InBattle") and true or false
end

function doingHact(plr)
    return plr.Character and plr.Character:FindFirstChild("Heated") and true or false
end

function showMaxHeatEffect(plr)
    local status = plr:FindFirstChild("Status")
    return status and isInBattle(plr) and not doingHact(plr) and status.Heat.Value >= 100
end

function chatted(plr, message)
    if message:lower() == chatCommand and plr ~= players.LocalPlayer then
        local char = plr.Character
        local status = plr:FindFirstChild("Status")

        if char and status and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("TimeFor") then
            local timeFor = char.HumanoidRootPart.TimeFor
            local heat = status.Heat.Value
            local currentStyle = status.Style.Value

            if currentStyle then
                auraUpdates[plr] = {
                    Color = timeFor.Color,
                    Heat = heat,
                    ShowMaxEffect = showMaxHeatEffect(plr),
                    Style = currentStyle
                }
            end
        end
    end
end

function updateAuras()
    for plr, data in pairs(auraUpdates) do
        local char = plr.Character
        local status = plr:FindFirstChild("Status")

        if char and status and char:FindFirstChild("HumanoidRootPart") then
            if status.Style.Value == data.Style then
                local heat = status.Heat.Value
                local showMaxEffect = data.ShowMaxEffect
                local DSeq = data.Color

                local primaryRate = heat >= 100 and 115 or heat >= 75 and 85 or 80
                local secondaryRate = heat >= 100 and 90 or heat >= 75 and 80 or 70
                local linesRate = heat >= 100 and 60 or heat >= 75 and 40 or 20

                char.HumanoidRootPart.Fire_Main.Color = DSeq
                char.HumanoidRootPart.Fire_Main.Rate = primaryRate

                char.HumanoidRootPart.Fire_Secondary.Color = DSeq
                char.HumanoidRootPart.Fire_Secondary.Rate = secondaryRate

                char.HumanoidRootPart.Lines1.Color = DSeq
                char.HumanoidRootPart.Lines1.Rate = linesRate

                char.HumanoidRootPart.Lines2.Color = DSeq
                char.HumanoidRootPart.Lines2.Rate = linesRate

                char.HumanoidRootPart.Sparks.Color = DSeq

                char.UpperTorso["r2f_aura_burst"].Lines1.Color = DSeq
                char.UpperTorso["r2f_aura_burst"].Lines2.Color = DSeq
                char.UpperTorso["r2f_aura_burst"].Lines1.Enabled = showMaxEffect
                char.UpperTorso["r2f_aura_burst"].Flare.Enabled = showMaxEffect
                char.UpperTorso["r2f_aura_burst"].Flare.Color = DSeq
                char.UpperTorso["r2f_aura_burst"].Smoke.Color = DSeq
            end
        end
    end
end

runService.RenderStepped:Connect(updateAuras)

for _, plr in players:GetPlayers() do
    plr.Chatted:Connect(function(msg)
        chatted(plr, msg)
    end)
end

players.PlayerAdded:Connect(function(plr)
    plr.Chatted:Connect(function(msg)
        chatted(plr, msg)
    end)
end)

players.PlayerRemoving:Connect(function(plr)
    auraUpdates[plr] = nil
end)

local player = game.Players.LocalPlayer
    local pgui = player.PlayerGui
    local menuUI = player:WaitForChild("PlayerGui"):WaitForChild("MenuUI")
    local menu = menuUI:WaitForChild("Menu")
    local abilitiesFrame = menu:WaitForChild("Abilities")
    local frame = abilitiesFrame:WaitForChild("Frame"):WaitForChild("Frame")
    local listFrame =  frame:WaitForChild("Frame"):WaitForChild("List"):WaitForChild("ListFrame")

    if player.Status:FindFirstChild("AbilitiesRan") then
	    return pgui.Notify:Fire("You have all abilities already", "buzz")
    end

    pgui.Notify:Fire("Open abilities menu")

    listFrame.ChildAdded:Wait()
    task.wait(1)
    for _, ability in ipairs(listFrame:GetChildren()) do
	    local styValue = ability:FindFirstChild("sty")
	    if styValue and styValue:IsA("StringValue") then
		    local styleName = styValue.Value
		    local styleFolder = player.Status.Styles:FindFirstChild(styleName)

		    if styleFolder then
			    local newFolder = Instance.new("Folder", styleFolder)
			    newFolder.Name = ability.Name
		    else
			    print("Style '" .. styleName .. "' not found for ability '" .. ability.Name .. "'")
                    continue
		    end
	    end
    end

    Instance.new("Folder", player.Status).Name = "AbilitiesRan"
    pgui.Notify:Fire("You now have all abilities for this session")

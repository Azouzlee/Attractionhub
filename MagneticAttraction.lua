-- Updated magnetic field interaction script
local player = game.Players.LocalPlayer
local targetPlayer
local isAttracting = false

-- Function to find target player based on username prefix
local function findTargetPlayer(partialName)
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr.Name:sub(1, #partialName):lower() == partialName:lower() then
            return plr
        end
    end
    return nil
end

-- Function to simulate magnetic field reaction (North-South interaction)
local function magneticFieldReaction()
    if not targetPlayer or not targetPlayer.Character then return end

    local targetHRP = targetPlayer.Character:WaitForChild("HumanoidRootPart")
    local playerHRP = player.Character:WaitForChild("HumanoidRootPart")
    local direction = (targetHRP.Position - playerHRP.Position).unit
    local distance = (targetHRP.Position - playerHRP.Position).Magnitude

    -- Calculate magnetic force: Attract or repel
    local force = 1000 / math.max(distance, 10) -- Simulate stronger force closer to the target
    local directionForce = direction * force

    -- Add or subtract the force based on distance (repulsion or attraction)
    if distance < 20 then
        -- Attraction (approaching)
        playerHRP.Velocity = playerHRP.Velocity + directionForce * 0.1
    else
        -- Repulsion (moving away)
        playerHRP.Velocity = playerHRP.Velocity - directionForce * 0.1
    end
end

-- Toggle attraction and repulsion when button is clicked
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.E then
        local partialName = "targetPrefix" -- Replace with dynamic input
        targetPlayer = findTargetPlayer(partialName)
        isAttracting = not isAttracting

        while isAttracting and targetPlayer do
            magneticFieldReaction()
            wait(0.1) -- Control reaction frequency
        end
    end
end)

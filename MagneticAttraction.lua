
-- Place this script inside a LocalScript in StarterPlayer -> StarterPlayerScripts

-- Create GUI
local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.5
frame.Visible = false -- Initially hidden
frame.Parent = screenGui

local usernameBox = Instance.new("TextBox")
usernameBox.Size = UDim2.new(0, 200, 0, 40)
usernameBox.Position = UDim2.new(0.5, -100, 0.3, -20)
usernameBox.PlaceholderText = "Enter First Two Letters"
usernameBox.Text = ""
usernameBox.Parent = frame

local attractButton = Instance.new("TextButton")
attractButton.Size = UDim2.new(0, 200, 0, 40)
attractButton.Position = UDim2.new(0.5, -100, 0.6, -20)
attractButton.Text = "Attract"
attractButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
attractButton.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.Text = "Toggle GUI"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
toggleButton.Parent = screenGui

local isAttracting = false
local targetPlayer = nil
local connection = nil
local safeDistance = 5 -- Safe distance from the target

toggleButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local function findPlayerByPartialName(partialName)
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr.Name:sub(1, #partialName):lower() == partialName:lower() then
            return plr
        end
    end
    return nil
end

local function attractPlayer()
    if not targetPlayer or not targetPlayer.Character then
        return
    end

    local targetHumanoidRootPart = targetPlayer.Character:WaitForChild("HumanoidRootPart")
    local localHumanoidRootPart = player.Character:WaitForChild("HumanoidRootPart")
    isAttracting = true

    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if isAttracting and targetPlayer and targetPlayer.Character then
            local direction = (targetHumanoidRootPart.Position - localHumanoidRootPart.Position)
            local distance = direction.Magnitude

            if distance > safeDistance then
                local speed = math.clamp(distance * 2, 10, 50)
                local velocity = direction.unit * speed
                local perpendicular = Vector3.new(-direction.Z, 0, direction.X).unit
                localHumanoidRootPart.Velocity = velocity + perpendicular * 15
            else
                localHumanoidRootPart.Velocity = Vector3.zero
            end
        else
            localHumanoidRootPart.Velocity = Vector3.zero
            connection:Disconnect()
        end
    end)
end

attractButton.MouseButton1Click:Connect(function()
    if isAttracting then
        isAttracting = false
        if connection then
            connection:Disconnect()
        end
        player.Character.HumanoidRootPart.Velocity = Vector3.zero
        return
    end

    local partialName = usernameBox.Text
    targetPlayer = findPlayerByPartialName(partialName)

    if targetPlayer then
        attractPlayer()
    else
        print("Player not found.")
    end
end)

-- Fake Block FE with GitHub Loadstring
-- ZenSaken request: Modern small draggable GUI, infinite stamina, and loadstring raw GitHub script

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Animation IDs
local ANIM_NORMAL_ID  = "72722244508749"
local ANIM_M34_ID     = "96959123077498"
local ANIM_SPECIAL_ID = "95802026624883"
local MODES = {"Normal", "M3&4", "Special"}
local modeIndex = 1

local GUI_NAME = "FakeBlockFE_GitHubLoadstring"

-- Remove old GUI if present
local pg = player:WaitForChild("PlayerGui")
if pg:FindFirstChild(GUI_NAME) then pg[GUI_NAME]:Destroy() end

-- GUI
local sg = Instance.new("ScreenGui", pg)
sg.Name = GUI_NAME
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Name = "Main"
frame.Size = UDim2.new(0, 180, 0, 112)
frame.Position = UDim2.new(0, 32, 0.5, -56)
frame.BackgroundColor3 = Color3.fromRGB(22, 22, 34)
frame.BorderSizePixel = 0
frame.Active = true
frame.ZIndex = 10
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

-- Shadow
local shadow = Instance.new("ImageLabel", frame)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.fromRGB(0,0,0)
shadow.Size = UDim2.new(1, 14, 1, 14)
shadow.Position = UDim2.new(0, -7, 0, -7)
shadow.ZIndex = 9

-- Drag bar
local dragBar = Instance.new("Frame", frame)
dragBar.Size = UDim2.new(1, 0, 0, 18)
dragBar.BackgroundTransparency = 0.2
dragBar.BackgroundColor3 = Color3.fromRGB(30,30,46)
dragBar.BorderSizePixel = 0
Instance.new("UICorner", dragBar).CornerRadius = UDim.new(0,8)
dragBar.ZIndex = 11

local modeLabel = Instance.new("TextLabel", dragBar)
modeLabel.BackgroundTransparency = 1
modeLabel.Size = UDim2.new(1, -34, 1, 0)
modeLabel.Position = UDim2.new(0, 8, 0, 0)
modeLabel.Font = Enum.Font.GothamBold
modeLabel.TextSize = 14
modeLabel.TextColor3 = Color3.fromRGB(170, 200, 255)
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.Text = "Fake Block ["..MODES[modeIndex].."]"
modeLabel.ZIndex = 11

-- Minimize button
local minBtn = Instance.new("TextButton", dragBar)
minBtn.Size = UDim2.new(0, 24, 0, 18)
minBtn.Position = UDim2.new(1, -26, 0, 0)
minBtn.BackgroundTransparency = 1
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.Text = "–"
minBtn.TextColor3 = Color3.fromRGB(120,120,180)
minBtn.ZIndex = 12

-- Play & Special
local playBtn = Instance.new("TextButton", frame)
playBtn.Name = "PlayBtn"
playBtn.Size = UDim2.new(0, 70, 0, 28)
playBtn.Position = UDim2.new(0, 8, 0, 26)
playBtn.BackgroundColor3 = Color3.fromRGB(56, 60, 120)
playBtn.Font = Enum.Font.GothamBold
playBtn.TextSize = 14
playBtn.TextColor3 = Color3.fromRGB(230,230,255)
playBtn.Text = "Play"
Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0, 8)
playBtn.ZIndex = 11

local specialBtn = Instance.new("TextButton", frame)
specialBtn.Name = "SpecialBtn"
specialBtn.Size = UDim2.new(0, 70, 0, 28)
specialBtn.Position = UDim2.new(0, 98, 0, 26)
specialBtn.BackgroundColor3 = Color3.fromRGB(90, 170, 255)
specialBtn.Font = Enum.Font.GothamBold
specialBtn.TextSize = 14
specialBtn.TextColor3 = Color3.fromRGB(10,16,24)
specialBtn.Text = "Special"
Instance.new("UICorner", specialBtn).CornerRadius = UDim.new(0, 8)
specialBtn.ZIndex = 11

-- Stamina bar
local staminaFrame = Instance.new("Frame", frame)
staminaFrame.Size = UDim2.new(1, -16, 0, 10)
staminaFrame.Position = UDim2.new(0, 8, 0, 62)
staminaFrame.BackgroundColor3 = Color3.fromRGB(32,42,44)
staminaFrame.ZIndex = 11
Instance.new("UICorner", staminaFrame).CornerRadius = UDim.new(0,6)

local staminaFill = Instance.new("Frame", staminaFrame)
staminaFill.Size = UDim2.new(1,0,1,0)
staminaFill.BackgroundColor3 = Color3.fromRGB(98,210,110)
staminaFill.ZIndex = 12
Instance.new("UICorner", staminaFill).CornerRadius = UDim.new(0,6)

local staminaText = Instance.new("TextLabel", staminaFrame)
staminaText.Size = UDim2.new(1,0,1,0)
staminaText.BackgroundTransparency = 1
staminaText.Font = Enum.Font.Gotham
staminaText.TextSize = 11
staminaText.TextColor3 = Color3.fromRGB(11,21,18)
staminaText.Text = "Stamina: 100"
staminaText.TextXAlignment = Enum.TextXAlignment.Center
staminaText.ZIndex = 13

-- GitHub Loadstring frame
local loadFrame = Instance.new("Frame", frame)
loadFrame.Size = UDim2.new(1, -16, 0, 28)
loadFrame.Position = UDim2.new(0, 8, 1, -34)
loadFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
loadFrame.ZIndex = 13
Instance.new("UICorner", loadFrame).CornerRadius = UDim.new(0,6)

local urlBox = Instance.new("TextBox", loadFrame)
urlBox.Size = UDim2.new(1, -54, 1, 0)
urlBox.Position = UDim2.new(0, 2, 0, 0)
urlBox.BackgroundTransparency = 1
urlBox.Font = Enum.Font.Gotham
urlBox.TextSize = 13
urlBox.Text = "https://raw.githubusercontent.com/"
urlBox.TextColor3 = Color3.fromRGB(210,210,240)
urlBox.ClearTextOnFocus = false
urlBox.ZIndex = 14

local loadBtn = Instance.new("TextButton", loadFrame)
loadBtn.Size = UDim2.new(0, 44, 1, 0)
loadBtn.Position = UDim2.new(1, -46, 0, 0)
loadBtn.BackgroundColor3 = Color3.fromRGB(80, 180, 255)
loadBtn.Font = Enum.Font.GothamBold
loadBtn.TextSize = 13
loadBtn.TextColor3 = Color3.fromRGB(20, 40, 60)
loadBtn.Text = "Load"
Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0,6)
loadBtn.ZIndex = 15

-- Minimize logic
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame.Size = UDim2.new(0, 180, 0, 24)
        playBtn.Visible = false
        specialBtn.Visible = false
        staminaFrame.Visible = false
        loadFrame.Visible = false
    else
        frame.Size = UDim2.new(0, 180, 0, 112)
        playBtn.Visible = true
        specialBtn.Visible = true
        staminaFrame.Visible = true
        loadFrame.Visible = true
    end
end)

-- Dragging logic
do
    local dragging, dragStart, startPos
    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
        end
    end)
end

-- Animation logic
local animator, currentTrack
local function getAnimator()
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildWhichIsA("Humanoid") or char:WaitForChild("Humanoid")
    if not hum then return nil end
    animator = hum:FindFirstChildWhichIsA("Animator") or Instance.new("Animator", hum)
    return animator
end

local function playAnimId(id)
    if not pcall(getAnimator) or not animator then return end
    if currentTrack then pcall(function() currentTrack:Stop() end) end
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://"..id
    local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
    if not ok then return end
    track.Priority = Enum.AnimationPriority.Action
    pcall(function() track:Play() end)
    currentTrack = track
end

-- Button connections
playBtn.MouseButton1Click:Connect(function()
    modeIndex = (modeIndex % #MODES) + 1
    modeLabel.Text = "Fake Block ["..MODES[modeIndex].."]"
    if MODES[modeIndex] == "Special" then
        playAnimId(ANIM_SPECIAL_ID)
    elseif MODES[modeIndex] == "Normal" then
        playAnimId(ANIM_NORMAL_ID)
    elseif MODES[modeIndex] == "M3&4" then
        playAnimId(ANIM_M34_ID)
    end
end)

specialBtn.MouseButton1Click:Connect(function()
    playAnimId(ANIM_SPECIAL_ID)
end)

-- Hotkeys: Q=Play, E=Special, X=Cycle, Z=Toggle GUI
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        if MODES[modeIndex] == "Special" then
            playAnimId(ANIM_SPECIAL_ID)
        elseif MODES[modeIndex] == "Normal" then
            playAnimId(ANIM_NORMAL_ID)
        elseif MODES[modeIndex] == "M3&4" then
            playAnimId(ANIM_M34_ID)
        end
    elseif input.KeyCode == Enum.KeyCode.E then
        playAnimId(ANIM_SPECIAL_ID)
    elseif input.KeyCode == Enum.KeyCode.X then
        modeIndex = (modeIndex % #MODES) + 1
        modeLabel.Text = "Fake Block ["..MODES[modeIndex].."]"
    elseif input.KeyCode == Enum.KeyCode.Z then
        sg.Enabled = not sg.Enabled
    end
end)

-- Infinite stamina (sticks at 100 always, local-only)
local STAMINA_VALUE = 100
local watchedTextConns = {}
local hideKeywords = {"stamina","stam","energy","sprint","endurance"}

local function setLocalStamina()
    local char = player.Character
    if not char then return end
    local v = char:FindFirstChild("LocalStamina")
    if not v then
        v = Instance.new("NumberValue")
        v.Name = "LocalStamina"
        v.Parent = char
    end
    v.Value = STAMINA_VALUE
end

local function overridePlayerGui()
    local pg = player:FindFirstChild("PlayerGui")
    if not pg then return end
    for _,obj in ipairs(pg:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local ok, txt = pcall(function() return tostring(obj.Text):lower() end)
            if ok and txt then
                for _,k in ipairs(hideKeywords) do
                    if string.find(txt, k, 1, true) then
                        pcall(function() obj.Text = "Stamina: "..tostring(STAMINA_VALUE) end)
                        if watchedTextConns[obj] then
                            pcall(function() watchedTextConns[obj]:Disconnect() end)
                            watchedTextConns[obj] = nil
                        end
                        watchedTextConns[obj] = obj:GetPropertyChangedSignal("Text"):Connect(function()
                            pcall(function() obj.Text = "Stamina: "..tostring(STAMINA_VALUE) end)
                        end)
                        break
                    end
                end
            end
        elseif obj:IsA("GuiObject") then
            local ok, nm = pcall(function() return (obj.Name or ""):lower() end)
            if ok and nm then
                for _,k in ipairs(hideKeywords) do
                    if string.find(nm, k, 1, true) then
                        pcall(function() obj.Visible = false end)
                        break
                    end
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    setLocalStamina()
    staminaFill.Size = UDim2.new(1,0,1,0)
    staminaText.Text = "Stamina: "..tostring(STAMINA_VALUE)
    overridePlayerGui()
end)

player.CharacterAdded:Connect(function()
    animator = nil
    wait(0.12)
    setLocalStamina()
end)

-- Loadstring from GitHub raw URL (exploit only)
loadBtn.MouseButton1Click:Connect(function()
    local url = urlBox.Text
    if typeof(url) ~= "string" or not url:lower():find("githubusercontent.com") then
        urlBox.Text = "Invalid GitHub Raw URL!"
        wait(1)
        urlBox.Text = "https://raw.githubusercontent.com/"
        return
    end
    local src
    local ok, err = pcall(function()
        src = game:HttpGet(url)
    end)
    if ok and type(src) == "string" then
        local s, er = pcall(function()
            loadstring(src)()
        end)
        if not s then
            urlBox.Text = "Script error!"
            wait(1)
            urlBox.Text = url
        end
    else
        urlBox.Text = "Failed to get script!"
        wait(1)
        urlBox.Text = url
    end
end)

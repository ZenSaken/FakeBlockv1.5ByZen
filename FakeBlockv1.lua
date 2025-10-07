-- FakeBlockv1.5ByZen.lua
-- Single-file LocalScript (client-side)
-- Features:
--  - Draggable GU I (small, left-center)
--  - Mode cycle: Normal / M3&4 / Special
--  - Play plays selected mode; Special always plays special animation
--  - Hotkeys: Q = Play, E = Special, X = Cycle mode, Z = Toggle GUI
--  - Local-only "Infinite" Stamina overlay (keeps LocalStamina = 9999 and overrides common stamina UI text)
-- IMPORTANT: This is client-only. It DOES NOT change server-side stamina.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
if not localPlayer then return end

-- ===== YOUR ANIMATION IDs (all set) =====
local ANIM_NORMAL_ID  = "72722244508749"
local ANIM_M34_ID     = "96959123077498"
local ANIM_SPECIAL_ID = "95802026624883"
-- ========================================

local GUI_NAME = "FakeBlockv1_5_ByZen"
local modes = {"Normal","M3&4","Special"}
local modeIndex = 1

-- animator cache
local animator, currentTrack
local animCache = {}

local function ensureAnimator()
    local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local hum = char:FindFirstChildWhichIsA("Humanoid") or char:WaitForChild("Humanoid",5)
    if not hum then return nil end
    animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end
    return animator
end

local function getAnim(id)
    if animCache[id] then return animCache[id] end
    local a = Instance.new("Animation")
    a.Name = "FBAnim_"..id
    a.AnimationId = "rbxassetid://"..id
    animCache[id] = a
    return a
end

local function stopCurrent()
    if currentTrack then
        pcall(function() currentTrack:Stop() end)
        currentTrack = nil
    end
end

local function playAnimId(id, statusLabel)
    if not pcall(ensureAnimator) or not animator then
        if statusLabel then statusLabel.Text = "No Humanoid" end
        return
    end
    local anim = getAnim(id)
    stopCurrent()
    local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
    if not ok or not track then
        if statusLabel then statusLabel.Text = "Load fail" end
        warn("Failed to load animation:", id)
        return
    end
    track.Priority = Enum.AnimationPriority.Action
    pcall(function() track:Play() end)
    currentTrack = track
    if statusLabel then statusLabel.Text = "Playing" end
    track.Stopped:Connect(function()
        if currentTrack == track then currentTrack = nil end
        if statusLabel then statusLabel.Text = "Idle" end
    end)
end

local function playByMode(m, statusLabel)
    if m == "Normal" then
        playAnimId(ANIM_NORMAL_ID, statusLabel)
    elseif m == "M3&4" then
        playAnimId(ANIM_M34_ID, statusLabel)
    elseif m == "Special" then
        playAnimId(ANIM_SPECIAL_ID, statusLabel)
    end
end

-- ========== GUI ========== --
local function createGui()
    local pg = localPlayer:WaitForChild("PlayerGui")
    if pg:FindFirstChild(GUI_NAME) then pg[GUI_NAME]:Destroy() end

    local sg = Instance.new("ScreenGui", pg)
    sg.Name = GUI_NAME
    sg.ResetOnSpawn = false

    local frame = Instance.new("Frame", sg)
    frame.Name = "Main"
    frame.Size = UDim2.new(0, 220, 0, 128)
    frame.Position = UDim2.new(0, 8, 0.45, -64)
    frame.BackgroundColor3 = Color3.fromRGB(22,22,26)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.ZIndex = 2
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

    -- Header (draggable)
    local header = Instance.new("Frame", frame)
    header.Name = "Header"
    header.Size = UDim2.new(1,0,0,36)
    header.Position = UDim2.new(0,0,0,0)
    header.BackgroundTransparency = 0.12
    Instance.new("UICorner", header).CornerRadius = UDim.new(0,8)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(1,-100,1,0)
    title.Position = UDim2.new(0,8,0,0)
    title.BackgroundTransparency = 1
    title.Text = "Fake Block - v1.5"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextColor3 = Color3.fromRGB(230,230,230)
    title.TextXAlignment = Enum.TextXAlignment.Left

    local modeBtn = Instance.new("TextButton", header)
    modeBtn.Name = "ModeBtn"
    modeBtn.Size = UDim2.new(0, 92, 0, 24)
    modeBtn.Position = UDim2.new(1, -96, 0, 6)
    modeBtn.Text = modes[modeIndex]
    modeBtn.Font = Enum.Font.Gotham
    modeBtn.TextSize = 13
    modeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    modeBtn.AutoButtonColor = true
    Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0,6)

    local lockBtn = Instance.new("TextButton", header)
    lockBtn.Size = UDim2.new(0,28,0,28); lockBtn.Position = UDim2.new(1,-36,0,4)
    lockBtn.Text = "🔓"; lockBtn.Font = Enum.Font.Gotham; lockBtn.TextSize = 14; lockBtn.BackgroundTransparency = 0.12
    Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0,8)

    local minBtn = Instance.new("TextButton", header)
    minBtn.Size = UDim2.new(0,28,0,28); minBtn.Position = UDim2.new(1,-68,0,4)
    minBtn.Text = "–"; minBtn.Font = Enum.Font.Gotham; minBtn.TextSize = 18; minBtn.BackgroundTransparency = 0.12
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,8)

    -- Body
    local body = Instance.new("Frame", frame)
    body.Name = "Body"
    body.Size = UDim2.new(1,-8,1,-44)
    body.Position = UDim2.new(0,4,0,40)
    body.BackgroundTransparency = 1

    local status = Instance.new("TextLabel", body)
    status.Name = "Status"
    status.Size = UDim2.new(1,0,0,16)
    status.Position = UDim2.new(0,0,0,0)
    status.BackgroundTransparency = 1
    status.Text = "Idle"
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.TextColor3 = Color3.fromRGB(170,170,170)
    status.TextXAlignment = Enum.TextXAlignment.Left

    local playBtn = Instance.new("TextButton", body)
    playBtn.Name = "Play"
    playBtn.Size = UDim2.new(0.62,-8,0,36)
    playBtn.Position = UDim2.new(0,0,1,-38)
    playBtn.Text = "Play"
    playBtn.Font = Enum.Font.GothamBold
    playBtn.TextSize = 14
    playBtn.BackgroundColor3 = Color3.fromRGB(110,55,230)
    Instance.new("UICorner", playBtn).CornerRadius = UDim.new(0,8)

    local specialBtn = Instance.new("TextButton", body)
    specialBtn.Name = "Special"
    specialBtn.Size = UDim2.new(0.36,-8,0,36)
    specialBtn.Position = UDim2.new(0.62,6,1,-38)
    specialBtn.Text = "Special"
    specialBtn.Font = Enum.Font.GothamBold
    specialBtn.TextSize = 13
    specialBtn.BackgroundColor3 = Color3.fromRGB(80,150,255)
    Instance.new("UICorner", specialBtn).CornerRadius = UDim.new(0,8)

    -- local stamina overlay
    local staminaFrame = Instance.new("Frame", frame)
    staminaFrame.Name = "LocalStaminaFrame"
    staminaFrame.Size = UDim2.new(0.9,0,0,14)
    staminaFrame.Position = UDim2.new(0.05,0,1,-18)
    staminaFrame.BackgroundColor3 = Color3.fromRGB(36,36,40)
    Instance.new("UICorner", staminaFrame).CornerRadius = UDim.new(0,6)

    local staminaFill = Instance.new("Frame", staminaFrame)
    staminaFill.Name = "Fill"
    staminaFill.Size = UDim2.new(1,0,1,0)
    staminaFill.BackgroundColor3 = Color3.fromRGB(98,210,110)
    Instance.new("UICorner", staminaFill).CornerRadius = UDim.new(0,6)

    local staminaText = Instance.new("TextLabel", staminaFrame)
    staminaText.Size = UDim2.new(1,-6,1,0)
    staminaText.Position = UDim2.new(0,3,0,0)
    staminaText.BackgroundTransparency = 1
    staminaText.Font = Enum.Font.Gotham
    staminaText.TextSize = 12
    staminaText.Text = "Stamina: 9999"
    staminaText.TextXAlignment = Enum.TextXAlignment.Left
    staminaText.TextColor3 = Color3.fromRGB(18,18,18)

    -- connections
    modeBtn.MouseButton1Click:Connect(function()
        modeIndex = modeIndex % #modes + 1
        modeBtn.Text = modes[modeIndex]
    end)

    playBtn.MouseButton1Click:Connect(function()
        local m = modes[modeIndex]
        if m == "Special" then
            playAnimId(ANIM_SPECIAL_ID, status)
        else
            playByMode(m, status)
        end
    end)

    specialBtn.MouseButton1Click:Connect(function()
        playAnimId(ANIM_SPECIAL_ID, status)
    end)

    -- lock/minimize
    minBtn.MouseButton1Click:Connect(function()
        if frame.Size.Y.Offset > 60 then
            frame.Size = UDim2.new(0,220,0,48)
            for _,v in ipairs(frame:GetDescendants()) do
                if v ~= header and v ~= title and v ~= modeBtn and v ~= lockBtn and v ~= minBtn then
                    if v:IsA("GuiObject") then v.Visible = false end
                end
            end
        else
            frame.Size = UDim2.new(0,220,0,128)
            for _,v in ipairs(frame:GetDescendants()) do
                if v:IsA("GuiObject") then v.Visible = true end
            end
        end
    end)

    lockBtn.MouseButton1Click:Connect(function()
        lockBtn.Text = (lockBtn.Text == "🔓") and "🔒" or "🔓"
    end)

    -- dragging (header) with lock respect
    do
        local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
        header.InputBegan:Connect(function(input)
            if lockBtn.Text == "🔒" then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        header.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                local newX = startPos.X.Offset + delta.X
                local newY = startPos.Y.Offset + delta.Y
                local cam = workspace.CurrentCamera
                if cam then
                    newX = math.clamp(newX, 0, math.max(0, cam.ViewportSize.X - frame.AbsoluteSize.X))
                    newY = math.clamp(newY, 0, math.max(0, cam.ViewportSize.Y - frame.AbsoluteSize.Y))
                end
                frame.Position = UDim2.new(startPos.X.Scale, newX, startPos.Y.Scale, newY)
            end
        end)
    end

    return {
        screenGui = sg,
        frame = frame,
        modeBtn = modeBtn,
        playBtn = playBtn,
        specialBtn = specialBtn,
        statusLabel = status,
        staminaFill = staminaFill,
        staminaText = staminaText
    }
end

local gui = createGui()

-- ===== local infinite stamina overlay (client-only) =====
local STAMINA_VALUE = 9999
local heartbeatConn
local watchedTextConns = {}
local hideKeywords = {"stamina","stam","energy","sprint","endurance"}

local function setLocalStamina()
    local char = localPlayer.Character
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
    local pg = localPlayer:FindFirstChild("PlayerGui")
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

heartbeatConn = RunService.Heartbeat:Connect(function()
    setLocalStamina()
    if gui and gui.staminaFill and gui.staminaText then
        gui.staminaFill.Size = UDim2.new(1,0,1,0)
        gui.staminaText.Text = "Stamina: "..tostring(STAMINA_VALUE)
    end
    overridePlayerGui()
end)

-- hotkeys
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Q then
        local m = modes[modeIndex]
        if m == "Special" then playAnimId(ANIM_SPECIAL_ID, gui.statusLabel) else playByMode(m, gui.statusLabel) end
    elseif input.KeyCode == Enum.KeyCode.E then
        playAnimId(ANIM_SPECIAL_ID, gui.statusLabel)
    elseif input.KeyCode == Enum.KeyCode.X then
        modeIndex = modeIndex % #modes + 1
        if gui and gui.modeBtn then gui.modeBtn.Text = modes[modeIndex] end
    elseif input.KeyCode == Enum.KeyCode.Z then
        if gui and gui.screenGui then gui.screenGui.Enabled = not gui.screenGui.Enabled end
    end
end)

localPlayer.CharacterAdded:Connect(function()
    animator = nil
    wait(0.12)
    setLocalStamina()
end)

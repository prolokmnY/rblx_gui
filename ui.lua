local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local ui = {}
local dragging = false
local dragInput, dragStart, startPos
local elements = {}
local open = true

local config = {
    title = "UI Library",
    width = 300,
    height = 340,
    transparency = 0.05,
    cornerRadius = UDim.new(0, 10)
}

-- Create UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UILib"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, config.width, 0, config.height)
Main.Position = UDim2.new(0.5, -config.width/2, 0.5, -config.height/2)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.BackgroundTransparency = config.transparency
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = config.cornerRadius
UICorner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 40)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = config.title
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

-- Close and Destroy buttons
local Close = Instance.new("TextButton")
Close.Text = "X"
Close.Size = UDim2.new(0, 25, 0, 25)
Close.Position = UDim2.new(1, -30, 0, 7)
Close.BackgroundTransparency = 1
Close.TextColor3 = Color3.fromRGB(255, 80, 80)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 18
Close.Parent = Main

local DestroyBtn = Instance.new("TextButton")
DestroyBtn.Text = "!"
DestroyBtn.Size = UDim2.new(0, 25, 0, 25)
DestroyBtn.Position = UDim2.new(1, -60, 0, 7)
DestroyBtn.BackgroundTransparency = 1
DestroyBtn.TextColor3 = Color3.fromRGB(255, 255, 0)
DestroyBtn.Font = Enum.Font.GothamBold
DestroyBtn.TextSize = 18
DestroyBtn.Parent = Main

-- Scrollable content
local Content = Instance.new("ScrollingFrame")
Content.Size = UDim2.new(1, -20, 1, -50)
Content.Position = UDim2.new(0, 10, 0, 45)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.ScrollBarThickness = 4
Content.BackgroundTransparency = 1
Content.Parent = Main

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = Content

-- Scroll update
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- Button Function
function ui:addButton(text, callback, opts)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Text = (opts and opts.icon and (opts.icon .. " ") or "") .. text
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.Parent = Content

    local corner = Instance.new("UICorner")
    corner.CornerRadius = config.cornerRadius
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
end

-- Slider Function
function ui:addSlider(label, callback, opts)
    opts = opts or { min = 0, max = 100 }

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 40)
    container.BackgroundTransparency = 1
    container.Parent = Content

    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Size = UDim2.new(1, 0, 0, 18)
    sliderLabel.Text = label
    sliderLabel.TextSize = 14
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.TextColor3 = Color3.new(1, 1, 1)
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.Parent = container

    local slider = Instance.new("TextButton")
    slider.Size = UDim2.new(1, 0, 0, 15)
    slider.Position = UDim2.new(0, 0, 0, 20)
    slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    slider.Text = ""
    slider.Parent = container

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fill.Parent = slider

    local corner = Instance.new("UICorner")
    corner.CornerRadius = config.cornerRadius
    corner.Parent = slider

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = config.cornerRadius
    fillCorner.Parent = fill

    slider.MouseButton1Down:Connect(function()
        local conn
        conn = game:GetService("RunService").RenderStepped:Connect(function()
            local mouse = UserInputService:GetMouseLocation().X
            local pos = math.clamp(mouse - slider.AbsolutePosition.X, 0, slider.AbsoluteSize.X)
            fill.Size = UDim2.new(0, pos, 1, 0)
            local value = math.floor((pos / slider.AbsoluteSize.X) * (opts.max - opts.min) + opts.min)
            callback(value)
        end)
        UserInputService.InputEnded:Wait()
        conn:Disconnect()
    end)
end

-- Music Function
function ui:addMusic(id)
    local sound = Instance.new("Sound", game:GetService("SoundService"))
    sound.SoundId = "rbxassetid://" .. tostring(id)
    sound.Looped = true
    sound.Volume = 0.5
    sound:Play()
end

-- Set Title / Size
function ui:setConfig(conf)
    if conf.title then Title.Text = conf.title end
    if conf.width and conf.height then
        Main.Size = UDim2.new(0, conf.width, 0, conf.height)
        Main.Position = UDim2.new(0.5, -conf.width/2, 0.5, -conf.height/2)
    end
end

-- Toggle UI
function ui:toggle()
    open = not open
    Main.Visible = open
end

-- Setup
function ui:setup()
    print("[UI] Ready.")
end

-- Button Events
Close.MouseButton1Click:Connect(ui.toggle)
DestroyBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ui:toggle()
    end
end)

return ui

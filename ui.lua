-- ui.lua (Improved by ChatGPT)
local ui = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Prevent multiple UIs
if PlayerGui:FindFirstChild("EZ_UI") then
	return ui
end

-- CONFIG
local config = {
	width = 300,
	height = 360,
	title = "UI Maker",
	color = Color3.fromRGB(30, 30, 30),
	rounded = true,
	blurEnabled = true,
}

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EZ_UI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui

-- Blur Effect (optional)
if config.blurEnabled then
	local blur = Instance.new("BlurEffect")
	blur.Name = "UIBlur"
	blur.Size = 12
	blur.Parent = workspace.CurrentCamera
	screenGui:GetPropertyChangedSignal("Parent"):Connect(function()
		if not screenGui.Parent and blur then
			blur:Destroy()
		end
	end)
end

-- Main Frame
local main = Instance.new("Frame")
main.Name = "MainUI"
main.Size = UDim2.new(0, config.width, 0, config.height)
main.Position = UDim2.new(0.5, -config.width / 2, 0.5, -config.height / 2)
main.BackgroundColor3 = config.color
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = false
main.Parent = screenGui

if config.rounded then
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = main
end

-- Title Bar
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundTransparency = 1
titleBar.Text = config.title
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 16
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.Parent = main

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 10)
padding.Parent = titleBar

-- X Button
local xBtn = Instance.new("TextButton")
xBtn.Name = "CloseBtn"
xBtn.Size = UDim2.new(0, 30, 0, 30)
xBtn.Position = UDim2.new(1, -30, 0, 0)
xBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
xBtn.TextColor3 = Color3.new(1, 1, 1)
xBtn.Font = Enum.Font.GothamBold
xBtn.TextSize = 16
xBtn.Text = "X"
xBtn.Parent = main

Instance.new("UICorner", xBtn).CornerRadius = UDim.new(0, 6)

xBtn.MouseButton1Click:Connect(function()
	TweenService:Create(main, TweenInfo.new(0.25), {Size = UDim2.new(0, 0, 0, 0)}):Play()
	wait(0.25)
	main.Visible = false
end)

-- Destroy (!) Button
local destroyBtn = Instance.new("TextButton")
destroyBtn.Name = "DestroyBtn"
destroyBtn.Size = UDim2.new(0, 30, 0, 30)
destroyBtn.Position = UDim2.new(1, -60, 0, 0)
destroyBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 0)
destroyBtn.TextColor3 = Color3.new(1, 1, 1)
destroyBtn.Font = Enum.Font.GothamBold
destroyBtn.TextSize = 16
destroyBtn.Text = "!"
destroyBtn.Parent = main

Instance.new("UICorner", destroyBtn).CornerRadius = UDim.new(0, 6)

destroyBtn.MouseButton1Click:Connect(function()
	if workspace.CurrentCamera:FindFirstChild("UIBlur") then
		workspace.CurrentCamera.UIBlur:Destroy()
	end
	screenGui:Destroy()
end)

-- Drag System
local dragging = false
local offset
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		offset = input.Position - main.AbsolutePosition
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		main.Position = UDim2.new(0, input.Position.X - offset.X, 0, input.Position.Y - offset.Y)
	end
end)

-- Container
local container = Instance.new("ScrollingFrame")
container.Name = "Container"
container.Size = UDim2.new(1, -10, 1, -40)
container.Position = UDim2.new(0, 5, 0, 35)
container.BackgroundTransparency = 1
container.ScrollBarThickness = 5
container.CanvasSize = UDim2.new(0, 0, 0, 0)
container.AutomaticCanvasSize = Enum.AutomaticSize.Y
container.ClipsDescendants = true
container.Parent = main

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)
layout.Parent = container

-- BUTTON
function ui:addButton(text, callback, opts)
	opts = opts or {}
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = opts.color or Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = (opts.icon and (opts.icon .. " ") or "") .. text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.BackgroundTransparency = opts.transparency or 0
	btn.Parent = container
	if opts.rounded ~= false then
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	end
	btn.MouseButton1Click:Connect(callback)
end

-- SLIDER
function ui:addSlider(label, callback, opts)
	opts = opts or {}
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 50)
	frame.BackgroundTransparency = 1
	frame.Parent = container

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, 0, 0.5, 0)
	text.BackgroundTransparency = 1
	text.Text = label .. ": 0"
	text.Font = Enum.Font.Gotham
	text.TextColor3 = Color3.new(1, 1, 1)
	text.TextSize = 14
	text.Parent = frame

	local bar = Instance.new("TextButton")
	bar.Size = UDim2.new(1, 0, 0.5, 0)
	bar.Position = UDim2.new(0, 0, 0.5, 0)
	bar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	bar.Text = ""
	bar.AutoButtonColor = false
	bar.BackgroundTransparency = opts.transparency or 0
	bar.Parent = frame

	if opts.rounded ~= false then
		Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 6)
	end

	bar.MouseButton1Down:Connect(function()
		local conn
		conn = game:GetService("RunService").RenderStepped:Connect(function()
			local mouse = UIS:GetMouseLocation().X
			local relX = math.clamp((mouse - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			local value = math.floor((opts.max or 100) * relX)
			text.Text = label .. ": " .. value
			callback(value)
		end)
		UIS.InputEnded:Wait()
		conn:Disconnect()
	end)
end

-- MUSIC
function ui:addMusic(id)
	local sound = SoundService:FindFirstChild("EZMusic")
	if sound then sound:Destroy() end

	local newSound = Instance.new("Sound")
	newSound.Name = "EZMusic"
	newSound.SoundId = "rbxassetid://" .. id
	newSound.Volume = 0.5
	newSound.Looped = true
	newSound.Parent = SoundService
	newSound:Play()
end

-- TOGGLE
function ui:toggle()
	main.Visible = not main.Visible
end

-- STYLE
function ui:setStyle(opts)
	opts = opts or {}
	main.BackgroundTransparency = opts.transparency or 0.1
	if opts.rounded == false then
		local r = main:FindFirstChildWhichIsA("UICorner")
		if r then r:Destroy() end
	end
end

-- CONFIG UPDATE
function ui:setConfig(opts)
	opts = opts or {}
	if opts.title then titleBar.Text = opts.title end
	if opts.width and opts.height then
		main.Size = UDim2.new(0, opts.width, 0, opts.height)
		main.Position = UDim2.new(0.5, -opts.width / 2, 0.5, -opts.height / 2)
	end
end

-- FINAL SETUP
function ui:setup()
	main.Visible = true
end

return ui

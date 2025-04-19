-- ui.lua
local ui = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EZ_UI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 270, 0, 320)
main.Position = UDim2.new(0.5, -135, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BackgroundTransparency = 0.1
main.BorderSizePixel = 0
main.Active = true
main.Name = "MainUI"
main.Parent = screenGui

local round = Instance.new("UICorner", main)
round.CornerRadius = UDim.new(0, 10)

-- Title Bar
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundTransparency = 1
titleBar.Text = "UI Maker"
titleBar.TextColor3 = Color3.new(1,1,1)
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 16
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.Parent = main

local padding = Instance.new("UIPadding", titleBar)
padding.PaddingLeft = UDim.new(0, 10)

-- X Button
local xBtn = Instance.new("TextButton")
xBtn.Text = "X"
xBtn.Size = UDim2.new(0, 30, 0, 30)
xBtn.Position = UDim2.new(1, -30, 0, 0)
xBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
xBtn.TextColor3 = Color3.new(1,1,1)
xBtn.Font = Enum.Font.GothamBold
xBtn.TextSize = 16
xBtn.Parent = main
Instance.new("UICorner", xBtn).CornerRadius = UDim.new(0, 6)

xBtn.MouseButton1Click:Connect(function()
	main.Visible = false
end)

-- Drag system
local dragging = false
local offset
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		offset = Vector2.new(input.Position.X - main.AbsolutePosition.X, input.Position.Y - main.AbsolutePosition.Y)
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

-- Content container
local container = Instance.new("Frame")
container.Size = UDim2.new(1, -10, 1, -40)
container.Position = UDim2.new(0, 5, 0, 35)
container.BackgroundTransparency = 1
container.ClipsDescendants = true
container.Parent = main

local layout = Instance.new("UIListLayout", container)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 6)

-- BUTTON
function ui:addButton(text, callback, opts)
	opts = opts or {}
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
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
			local value = math.floor(relX * 100)
			text.Text = label .. ": " .. value
			callback(value)
		end)
		UIS.InputEnded:Wait()
		conn:Disconnect()
	end)
end

-- MUSIC
function ui:addMusic(id)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. id
	sound.Volume = 0.5
	sound.Looped = true
	sound.Name = "EZMusic"
	sound.Parent = SoundService
	sound:Play()
end

-- TOGGLE
function ui:toggle()
	main.Visible = not main.Visible
end

-- STYLING
function ui:setStyle(opts)
	opts = opts or {}
	main.BackgroundTransparency = opts.transparency or 0.1
	if opts.rounded == false then
		local r = main:FindFirstChildWhichIsA("UICorner")
		if r then r:Destroy() end
	end
end

-- INIT
function ui:setup()
	main.Visible = true
end

return ui

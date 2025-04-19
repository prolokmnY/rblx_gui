-- ui.lua
local ui = {}
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

-- UI Container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EZ_UI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main UI Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 250, 0, 300)
main.Position = UDim2.new(0.5, -125, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.BorderSizePixel = 0
main.BackgroundTransparency = 0.1
main.Name = "MainUI"
main.Parent = screenGui

-- Round corners
local round = Instance.new("UICorner")
round.CornerRadius = UDim.new(0, 10)
round.Parent = main

-- Drag logic
local dragging, offset
main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		offset = input.Position - main.Position
	end
end)
UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		main.Position = UDim2.new(0, input.Position.X - offset.X.Offset, 0, input.Position.Y - offset.Y.Offset)
	end
end)
UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Layout
local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = main

-- BUTTON (with optional icon, transparency, round)
function ui:addButton(text, callback, options)
	options = options or {}
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, 0)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = options.icon and ("🔹 " .. text) or text
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.AutoButtonColor = true
	btn.BackgroundTransparency = options.transparency or 0
	btn.Parent = main

	if options.rounded ~= false then
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 6)
		c.Parent = btn
	end

	btn.MouseButton1Click:Connect(callback)
end

-- SLIDER
function ui:addSlider(title, callback, options)
	options = options or {}
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 40)
	frame.BackgroundTransparency = 1
	frame.Parent = main

	local label = Instance.new("TextLabel")
	label.Text = title .. ": 0"
	label.Size = UDim2.new(1, 0, 0.5, 0)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.Parent = frame

	local slider = Instance.new("TextButton")
	slider.Size = UDim2.new(1, 0, 0.5, 0)
	slider.Position = UDim2.new(0, 0, 0.5, 0)
	slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	slider.Text = ""
	slider.AutoButtonColor = false
	slider.BackgroundTransparency = options.transparency or 0
	slider.Parent = frame

	if options.rounded ~= false then
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(0, 6)
		c.Parent = slider
	end

	local value = 0
	slider.MouseButton1Down:Connect(function()
		local con
		con = game:GetService("RunService").RenderStepped:Connect(function()
			local mouse = UIS:GetMouseLocation().X
			local relX = math.clamp((mouse - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
			value = math.floor(relX * 100)
			label.Text = title .. ": " .. value
			callback(value)
		end)
		UIS.InputEnded:Wait()
		con:Disconnect()
	end)
end

-- MUSIC
function ui:addMusic(soundId)
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://" .. soundId
	s.Volume = 0.5
	s.Looped = true
	s.Name = "EZMusic"
	s.Parent = SoundService
	s:Play()
end

-- TOGGLE SHOW/HIDE
function ui:toggle()
	main.Visible = not main.Visible
end

-- OPTIONAL SETUP
function ui:setup()
	main.Visible = true
end

-- Allow changing corner radius & transparency globally
function ui:setStyle(opts)
	if opts.transparency then
		main.BackgroundTransparency = opts.transparency
	end
	if opts.rounded == false then
		main:FindFirstChildWhichIsA("UICorner"):Destroy()
	end
end

return ui

-- notifications.lua
local notif = {}
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "EZ_NOTIF"
gui.ResetOnSpawn = false
gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local holder = Instance.new("Frame")
holder.Size = UDim2.new(1, 0, 1, 0)
holder.BackgroundTransparency = 1
holder.Parent = gui

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 5)
layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
layout.Parent = holder

function notif:notify(title, text, duration)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 250, 0, 60)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BackgroundTransparency = 0.1
	frame.BorderSizePixel = 0
	frame.Parent = holder

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Text = title
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 16
	titleLabel.TextColor3 = Color3.new(1,1,1)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Size = UDim2.new(1, -10, 0, 20)
	titleLabel.Position = UDim2.new(0, 5, 0, 5)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = frame

	local messageLabel = Instance.new("TextLabel")
	messageLabel.Text = text
	messageLabel.Font = Enum.Font.Gotham
	messageLabel.TextSize = 14
	messageLabel.TextColor3 = Color3.new(1,1,1)
	messageLabel.BackgroundTransparency = 1
	messageLabel.Size = UDim2.new(1, -10, 0, 20)
	messageLabel.Position = UDim2.new(0, 5, 0, 30)
	messageLabel.TextXAlignment = Enum.TextXAlignment.Left
	messageLabel.Parent = frame

	-- Fade in
	frame.BackgroundTransparency = 1
	TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()

	-- Auto-destroy after duration
	task.delay(duration or 3, function()
		TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
		task.wait(0.3)
		frame:Destroy()
	end)
end

return notif

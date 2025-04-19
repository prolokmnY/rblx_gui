-- Encapsulate in a local environment
local _ENV = setmetatable({}, {__index = getfenv()})

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local SecureUI = {}

local mainUI
local config = {
	title = "UI",
	width = 300,
	height = 340,
	visible = true
}

local elements = {}
local dragging = false
local inputStart, dragStart

function SecureUI:setup()
	if mainUI then return end

	mainUI = Instance.new("ScreenGui")
	mainUI.Name = "SecureUI_" .. math.random(1000,9999)
	mainUI.ResetOnSpawn = false
	mainUI.IgnoreGuiInset = true
	mainUI.Parent = game:GetService("CoreGui")

	local frame = Instance.new("Frame", mainUI)
	frame.Size = UDim2.new(0, config.width, 0, config.height)
	frame.Position = UDim2.new(0.5, -config.width / 2, 0.5, -config.height / 2)
	frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	frame.BorderSizePixel = 0
	frame.Name = "MainFrame"
	frame.Active = true
	frame.Draggable = false
	frame.ClipsDescendants = true
	frame.BackgroundTransparency = 0.2
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.ZIndex = 10
	frame.Visible = config.visible
	frame.Parent = mainUI
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.ClipsDescendants = true
	frame:SetAttribute("Locked", false)
	frame:ApplyDescription(Enum.ApplyDescriptionMode.ReuseProperties)

	local uicorner = Instance.new("UICorner", frame)
	uicorner.CornerRadius = UDim.new(0, 10)

	local title = Instance.new("TextLabel", frame)
	title.Size = UDim2.new(1, -30, 0, 30)
	title.Position = UDim2.new(0, 5, 0, 0)
	title.BackgroundTransparency = 1
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 16
	title.Font = Enum.Font.SourceSansSemibold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Name = "Title"
	title.Text = config.title

	local xBtn = Instance.new("TextButton", frame)
	xBtn.Size = UDim2.new(0, 20, 0, 20)
	xBtn.Position = UDim2.new(1, -25, 0, 5)
	xBtn.Text = "X"
	xBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	xBtn.TextColor3 = Color3.new(1, 1, 1)
	xBtn.Font = Enum.Font.SourceSans
	xBtn.TextSize = 14
	xBtn.Name = "CloseBtn"

	local uilist = Instance.new("UIListLayout", frame)
	uilist.SortOrder = Enum.SortOrder.LayoutOrder
	uilist.Padding = UDim.new(0, 5)
	uilist.VerticalAlignment = Enum.VerticalAlignment.Top

	local contentPad = Instance.new("UIPadding", frame)
	contentPad.PaddingTop = UDim.new(0, 35)
	contentPad.PaddingLeft = UDim.new(0, 10)
	contentPad.PaddingRight = UDim.new(0, 10)
	contentPad.PaddingBottom = UDim.new(0, 10)

	xBtn.MouseButton1Click:Connect(function()
		frame.Visible = false
	end)

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			inputStart = input.Position
			dragStart = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - inputStart
			frame.Position = dragStart + UDim2.new(0, delta.X, 0, delta.Y)
		end
	end)
end

function SecureUI:setConfig(cfg)
	for k, v in pairs(cfg) do
		if config[k] ~= nil then
			config[k] = v
		end
	end
	if mainUI and mainUI:FindFirstChild("MainFrame") then
		local frame = mainUI.MainFrame
		frame.Size = UDim2.new(0, config.width, 0, config.height)
		local title = frame:FindFirstChild("Title")
		if title then title.Text = config.title end
	end
end

function SecureUI:addButton(text, callback)
	local frame = mainUI.MainFrame
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 16
	btn.Name = "SecureButton"

	local uicorner = Instance.new("UICorner", btn)
	uicorner.CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
end

function SecureUI:addSlider(label, callback, opts)
	local min = opts and opts.min or 0
	local max = opts and opts.max or 100

	local frame = mainUI.MainFrame
	local container = Instance.new("Frame", frame)
	container.Size = UDim2.new(1, -20, 0, 40)
	container.BackgroundTransparency = 1

	local lbl = Instance.new("TextLabel", container)
	lbl.Size = UDim2.new(1, 0, 0.5, 0)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.Text = label
	lbl.Font = Enum.Font.SourceSans
	lbl.TextSize = 14

	local slider = Instance.new("TextButton", container)
	slider.Size = UDim2.new(1, 0, 0.5, 0)
	slider.Position = UDim2.new(0, 0, 0.5, 0)
	slider.Text = tostring(min)
	slider.TextColor3 = Color3.new(1, 1, 1)
	slider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	slider.Font = Enum.Font.SourceSans
	slider.TextSize = 14

	local uicorner = Instance.new("UICorner", slider)
	uicorner.CornerRadius = UDim.new(0, 4)

	local value = min
	slider.MouseButton1Click:Connect(function()
		value = value + 1
		if value > max then value = min end
		slider.Text = tostring(value)
		pcall(callback, value)
	end)
end

function SecureUI:addMusic(id)
	local s = Instance.new("Sound", workspace)
	s.SoundId = "rbxassetid://" .. id
	s.Volume = 1
	s.Looped = true
	s:Play()
end

function SecureUI:toggle()
	if not mainUI or not mainUI:FindFirstChild("MainFrame") then return end
	mainUI.MainFrame.Visible = not mainUI.MainFrame.Visible
end

return SecureUI

# Roblox UI Library

Welcome to the **Roblox UI Library**! This is a customizable and easy-to-use UI library designed for Roblox developers. It allows you to easily create interactive and draggable UIs with buttons, sliders, and other elements, while also supporting music integration and notifications.

## Features:
- **Draggable UI**
- **Buttons and Sliders**
- **Icons support for buttons**
- **Customizable transparency and rounded corners**
- **Easy music integration**
- **Notifications system (custom-built, not Roblox's default)**
- **Fly, Speed, and other admin functionalities**
- **Toggleable via Right Shift**
- **Clean UI setup and configuration**

---

## Getting Started

### 1. Clone or Download the Repository

You can either clone or download the repository to your local machine.

To clone:
```bash
git clone https://github.com/prolokmnY/rblx_gui.git

To download, click the green "Code" button and select "Download ZIP."
2. Setup Instructions

    First, make sure you have the necessary modules in your game. You can get them from the main.lua file hosted on GitHub.

local modules = loadstring(game:HttpGet("https://raw.githubusercontent.com/prolokmnY/rblx_gui/refs/heads/main/main.lua"))()
local ui = modules.ui
local notify = modules.notify

    Setting up the UI:

ui:setup()

    Customizing UI:

        You can set a custom title and the size of the UI:

ui:setConfig({
    title = "Super Cool UI",  -- Custom title for your UI
    width = 300,              -- Width of the UI
    height = 340              -- Height of the UI
})

    Adding Buttons:

    To add a button with an action, use the addButton method:

ui:addButton("Say Hi", function()
    notify:notify("Hey!", "You clicked the button", 3)
end, { icon = "💬" }) -- a cool icon or not? 

    Adding Sliders:

    To add a slider (for example, for controlling the fly speed):

ui:addSlider("Fly Speed", function(value)
    print("Fly Speed:", value)
end, { min = 50, max = 300 })

    Adding Music:

    To add a music track to your UI:

ui:addMusic(184012138)  -- Replace with the track ID you want to use

    Toggle UI Visibility:

    You can use the Right Shift key to toggle the visibility of the UI:

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        ui:toggle()  -- Toggle UI visibility
    end
end)

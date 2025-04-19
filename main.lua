local base = "https://raw.githubusercontent.com/prolokmnY/rblx_gui/refs/heads/main"

local ui = loadstring(game:HttpGet(base .. "/ui.lua"))()
local notify = loadstring(game:HttpGet(base .. "/notifications.lua"))()

ui:setup()
notify:notify("✅ UI Loaded SECSEFULY!", "Made by Prolokmn", 3)

return {
    ui = ui,
    notify = notify
}

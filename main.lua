local repo = "https://yourcdn.com/uimaker" -- or your raw GitHub or website

local ui = loadstring(game:HttpGet(repo .. "/ui.lua"))()
local notify = loadstring(game:HttpGet(repo .. "/notifications.lua"))()

-- Setup UI
ui:setup()
notify:notify("Loaded!", "Your UI is ready.", 3)

-- Optionally export both
return {
    ui = ui,
    notify = notify
}

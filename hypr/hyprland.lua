-- yonux Hyprland config. Lives in the yonux-shell repo and is symlinked to
-- ~/.config/hypr (see install.sh). Each concern is its own module under
-- modules/; order matters where later modules override earlier ones.

-- Load a module only when its file exists, so an optional drop-in that was
-- never created does not show up in Hyprland's config-error overlay.
local function optional(mod)
    if package.searchpath == nil or package.searchpath(mod, package.path) then
        local ok, err = pcall(require, mod)
        if not ok then
            print("yonux: optional config module '" .. mod .. "' failed to load: " .. tostring(err))
        end
    end
end

require("modules.env")
require("modules.gpu")
require("modules.monitors")
require("modules.input")
require("modules.misc")
require("modules.decoration")
require("modules.animations")
require("modules.binds")
require("modules.resize")
require("modules.special")
require("modules.window_rules")
require("modules.autostart")

-- Machine-local overrides (gitignored). Loads last, so it wins.
optional("user")

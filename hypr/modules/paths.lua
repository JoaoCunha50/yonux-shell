-- Shared paths. Resolved through ~/.config/hypr so they work whether that is
-- the repo's hypr/ folder symlinked in place or a plain copy.
local home = os.getenv("HOME") or ""
local config = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config")
local cache = os.getenv("XDG_CACHE_HOME") or (home .. "/.cache")

return {
    hypr = config .. "/hypr",
    -- rendered by matugen from quickshell/matugen/templates/ on every wallpaper change
    colors = cache .. "/yonux/hypr-colors.lua",
    -- `qs -c yonux` finds the shell through ~/.config/quickshell/yonux
    qs = "qs -c yonux",
}

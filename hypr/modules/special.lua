-- Special workspaces. The app ones launch their app on first toggle and are
-- where that app always opens.
local apps = {
    chat = { key = "SUPER + D", class = "^(vesktop|discord)$", command = "vesktop" },
    music = { key = "SUPER + M", class = "^[Ss]potify$", command = "spotify" },
}

for name, app in pairs(apps) do
    hl.window_rule({ name = "special-" .. name, match = { class = app.class }, workspace = "special:" .. name, tile = true })
    hl.bind(app.key, function()
        if #hl.get_windows({ class = app.class }) == 0 then
            hl.dispatch(hl.dsp.exec_cmd(app.command))
        end
        hl.dispatch(hl.dsp.workspace.toggle_special(name))
    end, { description = "Toggle " .. name .. " special workspace" })
end
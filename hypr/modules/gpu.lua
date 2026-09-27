-- Render on the discrete GPU (0000:03:00.0); the other GPU stays listed so the
-- monitor wired to it keeps working through reverse PRIME. The first device is
-- the primary renderer. Read once at compositor start.
local gpus = { "pci-0000:03:00.0-card", "pci-0000:11:00.0-card" }

-- AQ_DRM_DEVICES is ':'-separated, so the by-path names (which contain ':')
-- are resolved to their /dev/dri/cardN targets, which are only stable per boot.
local devices = {}
for _, name in ipairs(gpus) do
    local p = io.popen("readlink -f /dev/dri/by-path/" .. name .. " 2>/dev/null")
    local dev = p and p:read("l")
    if p then p:close() end
    if dev and dev ~= "" then
        table.insert(devices, dev)
    end
end
if #devices > 0 then
    hl.env("AQ_DRM_DEVICES", table.concat(devices, ":"))
end

-- Reverse PRIME scans the cursor out on another GPU than the one rendering it,
-- and the hardware cursor plane can get stuck on a stale image.
hl.config({ cursor = { no_hardware_cursors = true } })

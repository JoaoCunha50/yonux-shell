hl.config({
    misc = {
        -- keyboard focus follows an app's activation request, else a window
        -- mapping on another monitor comes up un-typeable
        focus_on_activate = true,
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
        -- a locker that crashes while locked can be replaced instead of
        -- stranding the session on a black screen
        allow_session_lock_restore = true,
        -- Super+A snaps a window to a centred float; animate the resize so the
        -- app gets one final-size configure instead of flickering mid-jump
        animate_manual_resizes = true,
    },
    xwayland = {
        force_zero_scaling = true,
        use_nearest_neighbor = true,
    },
    render = {
        direct_scanout = 1,
    },
    dwindle = {
        preserve_split = true,
    },
})

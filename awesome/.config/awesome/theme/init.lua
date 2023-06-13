local theme_assets = require("beautiful.theme_assets")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local gcolor = require("gears.color")
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local assets_path = '/home/sean/.config/awesome/theme/assets'
local theme = {}

theme.font = 'Iosevka Nerd Font 10'
theme.taglist_font = 'Iosevka Nerd Font Mono 10'

theme.bg_normal    = "#1e2030"
theme.bg_focus    = "#1e2030"
theme.bg_urgent   = "#1e2030"
theme.bg_minimize = "#1e2030"
theme.bg_systray  = theme.bg_normal

theme.fg_normal   = "#7f849c"
theme.fg_focus    = "#fab387"
theme.fg_urgent   = "#f38ba8"
theme.fg_minimize = "#ffffff"

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(2)
theme.border_normal = "#45475a"
theme.border_focus  = "#7f849c"

theme.border_marked = "#fab387"

local memicon = wibox.widget.imagebox(theme.widget_mem)
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)

theme.menu_submenu_icon = themes_path .. 'default/submenu.png'
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active   = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active    = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active   = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active    = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active   = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active    = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = themes_path .. "default/titlebar/maximized_focus_active.png"

theme.layout_fairh      = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv      = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating   = assets_path .. "/floating.png"
theme.layout_magnifier  = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max        = assets_path .. "/max.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft   = assets_path .. "/tileleft.png"
theme.layout_tile       = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop    = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral     = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle    = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw   = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne   = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw   = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse   = themes_path .. "default/layouts/cornersew.png"

theme.wallpaper = assets_path .. '/wallpaper.png'

theme.layout_archlogo = assets_path .. '/arch_logo.png'


for _, value in ipairs { true, false } do
    beautiful.tasklist_plain_task_name = false
end

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- local icons = {}

-- icons.launcher = assets_path .. '/arch_logo.png'

-- theme.icons = icons

return theme


local filesystem = require('gears.filesystem')

return {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'konsole',
    editor = 'code',
    rofi = 'rofi -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi/sidebar/rofi.rasi',
    rofiappmenu = 'rofi -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi/appmenu/drun.rasi',
    lock = 'dm-tool lock',
    quake = 'kitty --title QuakeTerminal'
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
    'compton --config ' .. filesystem.get_configuration_dir() .. '/configuration/compton.conf', -- Compositor
    'xcape -e "Super_L=Control_L|Shift_L|Alt_L|Super_L|D"',
    'blueman-applet', -- Bluetooth tray icon
    'xfce4-power-manager', -- Power manager
    'xfsettingsd', -- Settings Daemon
    'xrdb $HOME/.Xresources', -- X Colors
    'nm-applet', -- NetworkManager Applet
    'mpd', -- Music Server
    'pulseeffects --gapplication-service', -- Equalizer
    'redshift-gtk -l 14.45:121.05', -- Redshift
    '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)' -- credential manager
  }
}

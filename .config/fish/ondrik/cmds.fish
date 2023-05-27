# TODO: redo this with switch to wayland?
# export GTK_IM_PROFILE='fcitx'
# export QT_IM_PROFILE='fcitx'
# export SDL_IM_PROFILE='fcitx'
# export XMODIFIERS='@im=fcitx'
fish_add_path -aP /usr/lib/rustup/bin/

# not needed on WSL and such
setxkbmap -option compose:rctrl
# saves like 30 MB of ram lmfao
killall nm-applet
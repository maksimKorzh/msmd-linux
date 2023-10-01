/usr/local/bin/Xorg -nolisten tcp &
export XPID=$!
waitforX || ! echo failed in waitforX || exit
"$DESKTOP" 2>/tmp/wm_errors &
export WM_PID=$!
[ -x $HOME/.setbackground ] && $HOME/.setbackground
[ -x $HOME/.mouse_config ] && $HOME/.mouse_config &
[ $(which "$ICONS".sh) ] && ${ICONS}.sh &
[ -d "/usr/local/etc/X.d" ] && find "/usr/local/etc/X.d" -type f -o -type l | sort | while read F; do . "$F"; done
[ -d "$HOME/.X.d" ] && find "$HOME/.X.d" -type f -o -type l | sort | while read F; do . "$F"; done
xset fp+ /usr/local/share/fonts/terminus/
xset fp rehash

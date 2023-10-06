Xfbdev -br -screen 1366x768x32 -shadow -2button -mouse /dev/input/mice,5 -nolisten tcp -I >/dev/null 2>&1 &
export XPID=$!
waitforX || ! echo failed in waitforX || exit
"$DESKTOP" 2>/tmp/wm_errors &
export WM_PID=$!
[ -x $HOME/.setbackground ] && $HOME/.setbackground
xset fp+ /usr/local/share/fonts/terminus/
xset fp rehash

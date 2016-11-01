# x settings
# remove annoing beep
xset -b
setterm -blength 0

# so awesome execute command uses aliases
# (with display manager exit /etc/X11/Xsession.d)
#source ~/.config/zsh/plugin/core/core.plugin.zsh
#source ~/.config/zsh/plugin/autorandr/autorandr.plugin.zsh

# start one session of ssh agent per X session
#eval $(ssh-agent) using gpg zsh plugin

# monitors detect
autorandr -c &

# start awesome window manager
exec awesome # should log to file ?

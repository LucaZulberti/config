GR=$HOME/git-repos
CFG=$GR/config
WC=workenv-$USER-config

# TimeZone
TZ=${TZ:-UTC}

# we : easy to type with left hand (WorkEnv)
alias we="TZ=$TZ workenv"

alias we-home="we $CFG $HOME"
alias we-home-clean="docker rm -f $WC-$USER"

alias we-config="we $CFG $CFG"
alias we-config-clean="docker rm -f $WC-config"


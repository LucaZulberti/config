GR=$HOME/git-repos
CFG=$GR/config
WC=workenv-$USER-config

# we : easy to type with left hand (WorkEnv)
alias we-home="workenv $CFG $HOME"
alias we-home-clean="docker rm -f $WC-$USER"

alias we-config="workenv $CFG $CFG"
alias we-config-clean="docker rm -f $WC-config"


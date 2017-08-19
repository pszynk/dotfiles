
#-------------------------------
# env vars for ZSH
#-------------------------------

## WARNING !!! PATH set in ~/.zprofile due to bug/behaviour
## https://wiki.archlinux.org/index.php/zsh#Configuring_.24PATH
## 
## export PATH
# $LIB_INCLUDE_PATH (custom set in .pam_environment)
export C_INCLUDE_PATH="$LIB_INCLUDE_PATH/:$C_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="$LIB_INCLUDE_PATH/:$CPLUS_INCLUDE_PATH"
export CXX_INCLUDE_PATH="$LIB_INCLUDE_PATH/:$CXX_INCLUDE_PATH"

#export XDG_CONFIG_HOME="$HOME/.config"
#export XDG_CACHE_HOME="$HOME/.cache"
#export EDITOR=vim
#export DEFAULT_USER="pawel"
#export PERSONAL_DIR="$HOME/Personal"
#export WORKON_HOME="$HOME/.miniconda3/envs"
#
# for xtrace (bash debug) file + line number
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

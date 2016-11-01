# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh



#-------------------------------
# remote plugins
#-------------------------------

##########
# prezto #
##########
zplug "sorin-ionescu/prezto", as:plugin, use:init.zsh,\
    hook-build:"ln -s $ZPLUG_ROOT/repos/sorin-ionescu/prezto ${ZDOTDIR:-$HOME}/.zprezto"

function {
    # settings
    zstyle ':prezto:*:*' color 'yes'
    zstyle ':prezto:module:pacman' frontend 'pacaur'
    zstyle ':prezto:module:prompt' theme sorin
    #zstyle ':prezto:module:ssh' identities 'id_repo'
    zstyle ':prezto:module:terminal' auto-title 'yes'

    # modules
    modules_core=(
        'environment'
        'terminal'
        'editor'
        'history'
        'directory'
        'spectrum'
        'utility'
        'completion'
        )

    modules_tools=(
        'fasd'
        'git'
        'tmux'
        'command-not-found'
        'archive'
        'node'
        'rsync'
        'python'
        # 'gpg' has errors
        )

    modules_dist=()
    if [[ $(uname -r) =~ ARCH ]]
    then
        modules_dist=('pacman')
    fi

    modules_style=(
        'syntax-highlighting'
        'history-substring-search'
        'autosuggestions'
        'prompt'
    )
    pmodules=($modules_core $modules_tools $modules_dist $modules_style)
    zstyle ':prezto:load' pmodule $pmodules
}

#############
# oh-my-zsh #
#############
zplug "plugins/pip", from:oh-my-zsh

#########
# other #
#########
zplug "horosgrisa/zsh-dropbox"
zplug "unixorn/git-extra-commands"
zplug "sobolevn/git-secret"
zplug "seebi/dircolors-solarized"

# TODO
#zplug hchbaw/zce zce # easy motion
#zplug fbterm
#sharat87/zsh-vim-mode
#zsh-users/zaw

#zplug tarruda/zsh-autosuggestions

#-------------------------------
# local plugins
#-------------------------------

load_pszynk() {
    for p in $@; do
        zplug "pszynk/zsh", use:"plugins/$p/*.zsh"
    done
}

local -a main_plugins
local -a solarized_plugins

# always load
main_plugins=(
    'core'      # alias
    'folders'   # funcs
    'power'     # env vars
    'autorandr'
    'lesspipe'  # format & colour with less
    'gpg'
)

# load my plugins
load_pszynk $main_plugins


solarized_plugins=(
    #'manpage'  # opts
)

#-------------------------------
# Specific terminals
#-------------------------------

[[ $EMACS = t ]] && unsetopt zle

if [ "$TERM" != "linux" ]; then
    # Load solarized plugins
    load_pszynk $solarized_plugins
else
    zstyle ':prezto:module:prompt' theme sorin
fi

unset -f load_pszynk

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# load zplug
zplug load --verbose

#-------------------------------
# opts for ZSH
#-------------------------------

# extended glob (i.e. '^',...)
setopt extended_glob

setopt autopushd

#-------------------------------
# rest
#-------------------------------
# dircolors
eval `dircolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark`
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

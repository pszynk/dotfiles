# Check if zplug is installed

if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
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
    zstyle ':prezto:module:pacman' frontend 'yay'
    #zstyle ':prezto:module:ssh' identities 'id_repo'
    zstyle ':prezto:module:terminal' auto-title 'yes'
    
    local _theme=nicoulaj
    if [[ $TERM =~ "xterm" || $TERM = 'xterm-termite' || $TERM = 'alacritty' || $TMUX ]]; then
      _theme=sorin
    fi
    zstyle ':prezto:module:prompt' theme $_theme
      

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
        #'history-substring-search'
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
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/golang", from:oh-my-zsh

#########
# other #
#########
zplug "horosgrisa/zsh-dropbox"
zplug "unixorn/git-extra-commands"
# git secret - encrypt/decrypt + git
zplug "sobolevn/git-secret"

zstyle ':pszynk:module:dircolors' scheme 'gruvbox'
zplug "pszynk/zsh-dircolors"
# show alias hints
zplug "djui/alias-tips", from:github, defer:3

# zplug itself 
# TODO (but i think it doesn't work)
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# TODO check if worth
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
    'core'      # alias misc
    'folders'   # funcs
    'power'     # env vars
    'autorandr'
    'lesspipe'  # format & colour with less
    'docker'
    'gpg'
)

# this should be set in ~/.pam_environment
# SSH_AGENT_PID  DEFAULT=
# SSH_AUTH_SOCK  DEFAULT="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"
zstyle ':pszynk:plugins:gpg' set_ssh no

# load my plugins
load_pszynk $main_plugins


solarized_plugins=(
    #'manpage'  # opts
)

# TODO (nie dziala?)
#zplug "/home/pawel/.zshrc.local", from:local
# no to tak...
source "/home/pawel/.zshrc.local"

#-------------------------------
# colors
#-------------------------------

# dircolors
#eval `dircolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.256dark`
#if [ -n "$LS_COLORS" ]; then
#    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#fi

 # Load solarized plugins
[[ "$TERM" != "linux" ]] && load_pszynk $solarized_plugins

unset -f load_pszynk

#-------------------------------
# ZPLUG epilogue
#-------------------------------

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# load zplug
zplug load #--verbose

#-------------------------------
# Software
#-------------------------------

source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

CONDA="/etc/profile.d/conda.sh" && [[ -f "$CONDA" ]] && . "$CONDA"

# emacs
[[ $EMACS = t ]] && unsetopt zle

# fzf and fd integration (use/create plugin?)

export FZF_DEFAULT_COMMAND='fd --color=always --follow --hidden --exclude .git'
export FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} --ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"


#-------------------------------
# opts for ZSH
#-------------------------------

# extended glob (i.e. '^',...)
setopt extended_glob

setopt autopushd

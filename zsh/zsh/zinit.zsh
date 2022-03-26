### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

#-------------------------------
# remote plugins
#-------------------------------

##########
# prezto #
##########

load_prezto() {
    for p in $@; do
        zinit  snippet "PZT::modules/$p"
    done
}

function {
    # settings
    zstyle ':prezto:*:*' color 'yes'
    zstyle ':prezto:module:pacman' frontend 'yay'
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
        'gpg' #has errors?
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
    #zstyle ':prezto:load' pmodule $pmodules
    load_prezto $pmodules
}

unset -f load_prezto

#############
# oh-my-zsh #
#############
zinit snippet OMZ::plugins/pip
zinit snippet OMZ::plugins/docker
zinit snippet OMZ::plugins/golang

#########
# other #
#########
zinit light "horosgrisa/zsh-dropbox"
zinit light "unixorn/git-extra-commands"
# git secret - encrypt/decrypt + git
zinit light "sobolevn/git-secret"

zstyle ':pszynk:module:dircolors' scheme 'gruvbox'
#zinit light "pszynk/zsh-dircolors"
# show alias hints
zinit light "djui/alias-tips"#, from:github, defer:3

# zplug itself 
# TODO (but i think it doesn't work)
#zplug 'zplug/zplug', hook-build:'zplug --self-manage'

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
#zstyle ':pszynk:plugins:gpg' set_ssh no

# load my plugins
#load_pszynk $main_plugins


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
#if ! zplug check --verbose; then
#    printf "Install? [y/N]: "
#    if read -q; then
#        echo; zplug install
#    fi
#fi

# load zplug
#zplug load #--verbose

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

# this line is for emacs TRAMP, remember to set it on
# your remote hosts!
[ $TERM = "dumb" ] && unsetopt zle && PS1='$ '


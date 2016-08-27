# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/zplug

#-------------------------------
# local plugins
#-------------------------------

# TODO
# lokalne pluginy z githuba
# przy okazji troche je postprzatac
# ----
# sprawdzic zakomentaowane paczki
# poszukac innych
bundle_local() {
    local local_path=${2:="$HOME/.config/zsh/plugin"}
    zplug "${local_path}/$1", from:local
}

local -a local_plugins
local -a solarized_plugins
local local_plugin_path

# always load
local_plugins=(
core # alias
folders # funcs
power  # env vars
#vim
autorandr
lesspipe # format & colour with less
pachelp # pacman helpers (powerpill & bauerbill)
)

# load local plugins
for p in $local_plugins; do
    bundle_local $p
done

solarized_plugins=(
manpage  # opts
#dircolors
)

zplug "pszynk/zsh", use:"plugins/vim/*.zsh", nice:10

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
    zstyle ':prezto:module:ssh' identities 'id_repo'
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
        'gpg'
        'node'
        'rsync'
        'ssh'
        )

    modules_dist=()
    if [[ $(uname -r) =~ ARCH ]]
    then
        modules_dist=('pacman')
    fi

    modules_style=(
        'syntax-highlighting'
        'history-substring-search'
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
# Specific terminals
#-------------------------------

[[ $EMACS = t ]] && unsetopt zle

if [ "$TERM" != "linux" ]; then
    # Load solarized plugins
    for p in $solarized_plugins; do
        bundle_local $p
    done
else
    zstyle ':prezto:module:prompt' theme sorin
fi

unset -f bundle_local

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

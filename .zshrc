# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle :compinstall filename '/home/rumi/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=5000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install

# Modify path

# Stop commands preceded by a space from being added to history
setopt histignorespace

# source .zsh_aliases
if [ -f ~/.zsh_aliases ]; then
	. ~/.zsh_aliases
fi

#alias ls,grep to --color = auto
alias ls='ls --color=auto'
alias grep='grep --color=auto'

#alias df to df -h(human readable)
alias df='df -h'

#PS1
#PS1='%F{128}%n@%m%f in  %F{045}%~%f $ '

#add REDSHIFT_RUNNING to list of env variables
export REDSHIFT_RUNNING=0
#pfetch
pfetch

# powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

#fzf
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore .snapshots -f -g "" --depth=10'


#modify cd to activate virtual env whenever you enter into a directory with one
#source ~/.config/zsh/activate_env.sh

#change default editor to nvim
export EDITOR="$(which 'nvim')"

#zsh syntax highlighting
source ~/Programs/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

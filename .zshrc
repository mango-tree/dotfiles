# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  zsh-recall
)

source $ZSH/oh-my-zsh.sh

alias ll="ls -al"
alias history="recall"

eval "$(pyenv init -)"
autoload -U colors && colors

local virtualenv='$(get_virtualenv)'
get_virtualenv() {
  VENV_NAME="$(basename $VIRTUAL_ENV 2> /dev/null)"
  if [ ! -z "$VIRTUAL_ENV" ]; then
    echo -n "$fg[blue][$VENV_NAME]$reset_color"
  fi
}

local k8s_context='$(get_k8s_context)' 
get_k8s_context() {
  CONTEXT="$(kubectl config current-context 2>/dev/null)"
  if [[ ! -z $BRANCH ]]; then
    echo -n "$fg[blue][$BRANCH]$reset_color"
  else
    echo -n "$fg[black][no k8s context]$reset_color"
  fi
}

local git_branch='$(get_git_branch)' 
get_git_branch () {
  BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  if [[ ! -z $BRANCH ]]; then
    echo -n "$fg[blue][$BRANCH]$reset_color"
  else
    echo -n "$fg[black][no git branch]$reset_color"
  fi
}
local git_diff='$(get_git_diff)'
get_git_diff() {
  GIT_INSERTION=$(git diff --shortstat 2>/dev/null| awk '{print $4}')
  GIT_DELETION=$(git diff --shortstat 2>/dev/null| awk '{print $6}')
  if [[ ! -z $GIT_INSERTION ]]; then
    echo -n "[$fg[green]+${GIT_INSERTION} $fg[red]-${GIT_DELETION}$reset_color]"
  fi
}
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
RPS1='${return_code}'

PROMPT="%{$fg[black]%}%D{[%I:%M:%S]} %{$reset_color%}$fg[green]%n$reset_color@$fg[magenta]%m$reset_color ${virtualenv}${k8s_context}${git_branch}${git_diff}
%{$fg[cyan]%}%~%{$reset_color%} $%{$reset_color%} "


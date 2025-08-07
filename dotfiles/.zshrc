# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/.zsh/
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

#历史纪录条目数量
export HISTSIZE=10000
#注销后保存的历史纪录条目数量
export SAVEHIST=10000
#历史纪录文件
export HISTFILE=~/.histfile
#以附加的方式写入历史纪录
setopt INC_APPEND_HISTORY
#如果连续输入的命令相同，历史纪录中只保留一个
setopt HIST_IGNORE_DUPS
#为历史纪录中的命令添加时间戳
#setopt EXTENDED_HISTORY     

alias c='clear'
alias la='ls -a'

ZSH_THEME="powerlevel10k"

source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


export http_proxy=http://127.0.0.1:7897
export https_proxy=http://127.0.0.1:7897


## [Completion]
## Completion scripts setup. Remove the following line to uninstall
# [[ -f /home/tumeScent/.dart-cli-completion/zsh-config.zsh ]] && . /home/tumeScent/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]

# FZF plugin
export PATH="$HOME/.zsh/fzf-zsh-plugin/bin:$PATH"
source <(fzf --zsh)
export FZF_COMPLETION_TRIGGER='\'

# bind keys
bindkey -r '^I'
bindkey '^I' autosuggest-accept

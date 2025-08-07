#!/bin/zsh
mkdir ~/.zsh/
cd ~/.zsh/

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
ehco 'source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh' >>~/.zshrc

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc

git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
echo 'source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh' >>~/.zshrc

git clone --depth 1 git@github.com:unixorn/fzf-zsh-plugin.git
echo 'source ~/.zsh/fzf-zsh-plugin/fzf-zsh-plugin.plugin.zsh' >>~/.zshrc
echo 'PATH="~/.zsh/fzf-zsh-plugin/bin:$PATH" >>~/.zshrc

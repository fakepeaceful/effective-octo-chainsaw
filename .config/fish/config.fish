set -g fish_cursor_default underscore
set -g fish_cursor_insert underscore
set -g fish_cursor_replace_one underscore

set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less

alias ls='eza -lah --classify --icons --group-directories-first' # pretty useful defulat command
fish_add_path ~/.local/bin

alias v='nvim'
alias s='sudo'
alias c='clear'


#File operations
alias mv='mv -i' # confirms before doing
alias rm='rm -i' # comifrms before deleting
alias cp='cp -i' # confirms before copying


set -g fish_greeting

# fzf
fzf --fish | source
set -gx FZF_DEFAULT_OPTS '--layout reverse --border rounded --info inline'
starship init fish | source

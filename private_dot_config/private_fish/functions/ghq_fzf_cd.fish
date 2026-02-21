function ghq_fzf_cd -d "Move to ghq managed repo"
    set -l repo (ghq list -p | fzf --reverse --height 80% --border --preview 'set -l f (fd -d 1 -i "^README.*" {} | head -n 1); if test -n "$f"; bat --color=always --style=header,grid --line-range :200 "$f"; else; eza --color=always --icons --tree --level 1 {}; end' </dev/tty)
    if test -n "$repo"
        cd "$repo"
    end
    commandline -f repaint
end

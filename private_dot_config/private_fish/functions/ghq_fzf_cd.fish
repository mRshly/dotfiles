function ghq_fzf_cd -d "Move to ghq managed repo"
    set -l out (ghq list -p | fzf --reverse --height 80% --border \
        --preview 'set -l f (fd -d 1 -i "^README.*" {} | head -n 1); if test -n "$f"; CLICOLOR_FORCE=1 glow -s dark -w $FZF_PREVIEW_COLUMNS "$f"; else; eza --color=always --icons --tree --level 1 {}; end' \
        --header 'Enter: cd, Ctrl-y: copy path' \
        --expect=ctrl-y \
        </dev/tty)

    set -l key $out[1]
    set -l repo $out[2]

    if test -n "$repo"
        if test "$key" = "ctrl-y"
            echo "$repo" | pbcopy
        else
            cd "$repo"
        end
    end
    commandline -f repaint
end

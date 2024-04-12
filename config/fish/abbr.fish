# pushd / popd
abbr --add pu pushd
abbr --add po popd

# nvim
abbr --add vim nvim

## docker
abbr --add dc docker compose

## git
abbr --add g git
abbr --add ga git add
abbr --add gb git branch
abbr --add gc git commit
abbr --add gd git diff
abbr --add gl "git log --graph --pretty=format='format:%C(yellow)%h%C(reset) %s %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)'"
abbr --add gp git push origin
abbr --add gcb git checkout -b
abbr --add gch git checkout
abbr --add gcz git cz
abbr --add gsh git show
abbr --add gst git status
abbr --add gsw git switch

## eza
abbr --add la eza --icons --git -al -s Name
abbr --add ll eza --icons --git -l -s Name
abbr --add lar eza --icons --time-style relative --git -al -s Name
abbr --add llr eza --icons --time-style relative --git -l -s Name
abbr --add lt eza --icons --time-style relative --git -lT -L 2 -s Name


## broot
abbr --add br broot -sghd

#!/usr/bin/env fish

set -x NVM_DIR $HOME/.nvm

# if fish shell is not configured, end this script
echo check fish config dir is exist
if not test -d ~/.config/fish
    echo "Not exist: ~/.config/fish "
    exit 1
end

echo current directory is (pwd)
set -l here (dirname (status -f))
pushd (dirname (status -f))

# copy nvm function files to fish shell
for file in functions/*.fish
    echo "copy $file"
    cp $file ~/.config/fish/functions/
end

popd

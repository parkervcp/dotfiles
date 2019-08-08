# dotfiles
My collection of dotfiles

to install
```
mkdir -p  ~/dev/parkervcp/
cd ~/dev/parkervcp/
if [ -z $(which git) ]; then
    echo -e "git needs to be installed"
    exit 1
else
    git clone https://github.com/parkervcp/dotfiles.git
fi
```
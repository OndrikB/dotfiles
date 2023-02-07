#!/bin/bash
EX=0

read -n 1 -s -r -p "Please ensure that you have all of the dependencies for Alacritty, feh and leftwm installed. If you do, press any key to continue installation. If you don't, press Ctrl+C to halt the program"


if git help; then
    echo "Git is installed!"
else
    echo "Git is not installed! Please install it!"
    EX=1
fi
if cargo help; then
    echo "Cargo is set up!"
else
    echo "Cargo is either not installed or not configured!"
    echo "Attempting rustup"
    if rustup default stable; then
        rustup override set stable
        rustup update stable
        echo "Rustup worked! Retrying cargo"
        if cargo help; then
            echo "Cargo works!"
        else
            echo "Cargo is not installed, but rustup is! Something is very wrong!"
            EX=1
        fi
    else
        "Rustup is not installed! Please install it!"
        EX=1
    fi
fi

if [$EX -eq 1]; then
    exit 1
fi

if cd desktop_env; then
    echo "desktop_env directory already exists"
else
    mkdir desktop_env
    cd desktop_env
fi

git clone https://github.com/leftwm/leftwm
cd leftwm
cargo build --profile optimized

sudo rm /usr/bin/leftwm
sudo rm /usr/bin/leftwm-worker
sudo rm /usr/bin/lefthk-worker
sudo rm /usr/bin/leftwm-state
sudo rm /usr/bin/leftwm-check
sudo rm /usr/bin/leftwm-command
sudo ln -s "$(pwd)"/target/optimized/leftwm /usr/bin/leftwm
sudo ln -s "$(pwd)"/target/optimized/leftwm-worker /usr/bin/leftwm-worker
sudo ln -s "$(pwd)"/target/optimized/lefthk-worker /usr/bin/lefthk-worker
sudo ln -s "$(pwd)"/target/optimized/leftwm-state /usr/bin/leftwm-state
sudo ln -s "$(pwd)"/target/optimized/leftwm-check /usr/bin/leftwm-check
sudo ln -s "$(pwd)"/target/optimized/leftwm-command /usr/bin/leftwm-command

cd ..

git clone https://github.com/alacritty/alacritty
cd alacritty
cargo build --release --no-default-features --features=x11

if infocmp alacritty; then
    echo "Alacritty terminfo is installed!"
else
    tic -xe alacritty,alacritty-direct extra/alacritty.info
fi

sudo ln -s "$(pwd)"/target/release/alacritty /usr/local/bin/alacritty
sudo ln -s "$(pwd)"/extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database

echo "source $(pwd)/extra/completions/alacritty.bash" >> ~/.bashrc

cd ..

git clone https://github.com/PonasKovas/rlaunch.git
cd rlaunch
cargo build --release

sudo ln -s "$(pwd)"/target/release/rlaunch /usr/bin/rlaunch

cd ..

git clone https://github.com/derf/feh

# this is written in C!
cd feh

make
sudo make install

cd ..

echo "Please install polybar using the package manager of your choice. The amount of dependencies is, at this point, simply too much to handle. Polybar is available for most distros."

sudo mv ~/dotfiles/.config ~/.config
sudo ln -s ~/.config/leftwm/themes/ondrik ~/.config/leftwm/themes/current

echo "Please also update your .xinitrc file"




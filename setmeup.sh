#!/bin/bash
EX=0
ALACRITTY_INSTALL=0
FEH_INSTALL=0

read -n 1 -s -r -p "Please ensure that you have all of the dependencies for Alacritty, feh and leftwm installed, along with Git, Rustup, GCC, make and cmake. If you do, press any key to continue installation. If you don't, press Ctrl+C to halt the program"


if ! [ -x "$(command -v git)" ]; then
    echo "Git is not installed! Please install it!"
    EX=1
fi
if ! [ -x "$(command -v cc)" ]; then
    echo "GCC is not installed! Please install it!"
    EX=1
fi
if ! [ -x "$(command -v make)" ]; then
    echo "make is not installed! Please install it!"
    EX=1
fi
if [ -x "$(command -v cargo)" ]; then
    echo "Cargo is set up!"
else
    echo "Cargo is either not installed or not configured!"
    echo "Attempting rustup"
    if [ -x "$(command -v rustup)" ]; then
        rustup default stable
        rustup override set stable
        rustup update stable
        echo "Rustup worked! Retrying cargo"
        if [ -x "$(command -v cargo)" ]; then
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

# LeftWM, a Tiling Window Manager written in Rust

git clone https://github.com/leftwm/leftwm
cd leftwm
cargo build --profile optimized --no-default-features --features=lefthk
# this will work even without systemd

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


# Alacritty, a terminal emulator written in Rust

echo "Do you wish to install Alacritty manually? (NOTE: should only be done if it isn't in your package manager!)"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) ALACRITTY_INSTALL=1; break;;
        No ) break;;
    esac
done

if [$ALACRITTY_INSTALL -eq 1]; then
    git clone https://github.com/alacritty/alacritty
    cd alacritty
    cargo build --release --no-default-features --features=x11

    if infocmp alacritty; then
        echo "Alacritty terminfo is installed!"
    else
        tic -xe alacritty,alacritty-direct extra/alacritty.info
    fi

    sudo rm /usr/local/bin/alacritty
    sudo rm /usr/share/pixmaps/Alacritty.svg
    sudo ln -s "$(pwd)"/target/release/alacritty /usr/local/bin/alacritty
    sudo ln -s "$(pwd)"/extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    sudo desktop-file-install extra/linux/Alacritty.desktop
    sudo update-desktop-database

    echo "source $(pwd)/extra/completions/alacritty.bash" >> ~/.bashrc

    cd ..

fi

# rlaunch, a program launcher written in Rust (because dmenu wasn't fast enough lol)

git clone https://github.com/PonasKovas/rlaunch.git
cd rlaunch
cargo build --release

sudo rm /usr/bin/rlaunch
sudo ln -s "$(pwd)"/target/release/rlaunch /usr/bin/rlaunch

cd ..

# feh (this is written in C!)
echo "Do you wish to install feh manually? (NOTE: should only be done if it isn't in your package manager!)"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) FEH_INSTALL=1; break;;
        No ) break;;
    esac
done

if [$FEH_INSTALL -eq 1]; then

    git clone https://github.com/derf/feh
    cd feh

    make
    sudo make install

    cd ..
fi

# rlock, so I can actually lock my screen - written in, you guessed it, Rust!

git clone https://github.com/akermu/rlock
cd rlock

cargo build --release
sudo chown root target/release/rlock
sudo chmod u+s target/release/rlock
sudo ln -s "$(pwd)"/target/release/rlock /usr/local/bin/rlock



echo "Please install polybar using the package manager of your choice. The amount of dependencies is, at this point, simply too much to handle. Polybar is available for most distros."

sudo cp -r ~/dotfiles/.config/* ~/.config
sudo ln -s ~/.config/leftwm/themes/ondrik ~/.config/leftwm/themes/current
sudo chmod +x ~/.config/leftwm/themes/current/up
sudo chmod +x ~/.config/leftwm/themes/current/down


echo "Please also update your .xinitrc file"




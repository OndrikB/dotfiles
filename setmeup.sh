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



# --- ROOT REQUIRED HERE ---
rm /usr/bin/leftwm
rm /usr/bin/leftwm-worker
rm /usr/bin/lefthk-worker
rm /usr/bin/leftwm-state
rm /usr/bin/leftwm-check
rm /usr/bin/leftwm-command
ln -s "$(pwd)"/target/optimized/leftwm /usr/bin/leftwm
ln -s "$(pwd)"/target/optimized/leftwm-worker /usr/bin/leftwm-worker
ln -s "$(pwd)"/target/optimized/lefthk-worker /usr/bin/lefthk-worker
ln -s "$(pwd)"/target/optimized/leftwm-state /usr/bin/leftwm-state
ln -s "$(pwd)"/target/optimized/leftwm-check /usr/bin/leftwm-check
ln -s "$(pwd)"/target/optimized/leftwm-command /usr/bin/leftwm-command
# --- ROOT NO LONGER REQUIRED ---


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

    # --- ROOT REQUIRED HERE ---
    rm /usr/local/bin/alacritty
    rm /usr/share/pixmaps/Alacritty.svg
    ln -s "$(pwd)"/target/release/alacritty /usr/local/bin/alacritty
    ln -s "$(pwd)"/extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
    desktop-file-install extra/linux/Alacritty.desktop
    update-desktop-database
    # --- ROOT NO LONGER REQUIRED ---

    echo "source $(pwd)/extra/completions/alacritty.bash" >> ~/.bashrc

    cd ..

fi

# rlaunch, a program launcher written in Rust (because dmenu wasn't fast enough lol)

git clone https://github.com/PonasKovas/rlaunch.git
cd rlaunch
cargo build --release

# --- ROOT REQUIRED HERE ---
rm /usr/bin/rlaunch
ln -s "$(pwd)"/target/release/rlaunch /usr/bin/rlaunch
# --- ROOT NO LONGER REQUIRED ---

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
    # --- ROOT REQUIRED HERE ---
    make install
    # --- ROOT NO LONGER REQUIRED ---

    cd ..
fi

# rlock, so I can actually lock my screen - written in, you guessed it, Rust!

git clone https://github.com/akermu/rlock
cd rlock

cargo build --release

# --- ROOT REQUIRED HERE ---
chown root target/release/rlock
chmod u+s target/release/rlock
ln -s "$(pwd)"/target/release/rlock /usr/local/bin/rlock
# --- ROOT NO LONGER REQUIRED ---



echo "Please install polybar using the package manager of your choice. The amount of dependencies is, at this point, simply too much to handle. Polybar is available for most distros."

# --- ROOT REQUIRED HERE ---
cp -r ~/dotfiles/.config/* ~/.config
ln -s ~/.config/leftwm/themes/ondrik ~/.config/leftwm/themes/current
chmod +x ~/.config/leftwm/themes/current/up
chmod +x ~/.config/leftwm/themes/current/down
# --- ROOT NO LONGER REQUIRED ---

echo "Please also update your .xinitrc file"
echo "Please also remember to update the polybar.config with the correct battery name, network interface name, etc."



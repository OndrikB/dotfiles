# dotfiles
Linux config files (currently lots of example configs, will customize at some point)

-- currently using:

 - leftwm
 - alacritty
 - rlaunch
 - polybar
 - feh

## Todo:

 - create an update script, to run alongside `pacman -Syu`
 - more nvim things

## Setup

for setup, clone this, copy `setmeup.sh` into the home directory and run it
This is all expected to be done from your user's home directory, and will create a `desktop_env` folder inside. 
DO NOT delete this folder as it contains the binaries which are symlinked to your `/usr/bin` (more on this in the Information section)

## Information

`setmeup.sh` MUST be run with root privileges or as root directly. The commands where this is required are clearly marked with `ROOT REQUIRED HERE`.

The use cases requiring root involve:
 - Removing existing `/usr/bin` binaries for binaries compiled by the script, if any exist
 - Adding symlinks to `/usr/bin` from the new folder
 - Using `chown` and `chmod` on the `rlock` binary
 - Using `chmod` on the `up` and `down` scripts for the leftwm theme

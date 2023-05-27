# most important alias!
alias please="doas "
# Holdover from W*nd*ws
alias cls="clear"
# justlsthings
#abbr -a lsf ls -lA
#abbr -a lsr ls -R
#abbr -a lsfr ls -lAR
#abbr -a lsrf ls -lAR
alias lsf="ls -lA"
alias lsr="ls -R"
alias lsfr="lsf -R"
alias lsrf="lsfr"
# predicates!
# If I'm looking for a file anywhere, I want root
alias anyfind="please find / -name"
alias afind="anyfind"
alias finda="anyfind"
# fs manip 
alias cp="cp -rv"
alias mv="mv -v"
alias rm="rm -v"
alias rmd="rm -rfv"
# TODO: something to make me understand that cp -rv ./ and cp -rv ./* are different
# don't think I can just do this in an alias, that might have to be a script...

# TODO: update neovim also?
# alias full_update = "paru && paru --clean && nvim -c \"Mason\""
# this command will die when one doas verification fails
alias updf="paru && paru --clean"
alias fupd="updf"

alias krb="doas kexec -l /boot/vmlinuz-linux --initrd=/boot/initramfs-linux.img --reuse-cmdline && echo Kexec ready. Inputting your password on the next prompt will lead to a reboot. && doas reboot -k"
alias showcam="mpv --demuxer-lavf-format=video4linux2 --demuxer-lavf-o-set=input_format=mjpeg av://v4l2:/dev/video0 --profile=low-latency --untimed"
alias termcam="showcam --vo=tct"

alias cbat="cat /sys/class/power_supply/BAT1/energy_now"

# dotfiles

I use [yadm](https://github.com/TheLocehiliosan/yadm) to manage my dotfiles between devices.

One of my main goals with these configs is trying to squeeze as much functionality out of everything as I can, without having to resort to plugin frameworks and addons that I know I'll never use a fraction of. So my .zshrc, .vimrc, etc. have as many built-in tricks as I can find, and I'm adding new stuff as I go.

---
## New install programs

### Essentials (shell)
```
exa                         better ls. pretty colors
git                         duh
netctl                      \
networkmanager              / network manager stuff
tmux                        screen but better
vim                         obviously
yadm-git                    dotfiles manager
yay                         aur/pacman frontend
zsh                         of course
```

### Essentials (graphical)
```
dmenu                       app launcher
dunst                       desktop notifications
dwm                         tiling window manager. my version is here: https://github.com/reyemxela/dwm
termite                     terminal with the best pro/con ratio I've found so far
```

### Shell utilities
```
bc                          pipeable cli calculator
calc                        cli calculator
dhex                        hex editor
entr                        actual magic. runs commands when files change
gtop                        better top
htop                        better top
neofetch                    system stats
nmap                        it's nmap
openbsd-netcat              it's netcat
transmission-cli            torrents
ranger                      terminal file browser with vi keybindings
w3m                         lynx on steroids
```

### GUI/Audio stuff
```
arandr                      gui xrandr frontend
autorandr                   auto monitor control for laptops when docked/undocked
compton-tryone-git          compton fork with good blurring
feh                         image viewer
i3lock                      good lockscreen utility
networkmanager-dmenu-git    networkmanager integration for dmenu
nitrogen                    wallpaper setter
pulseaudio                  \
pulseaudio-alsa              | pulseaudio stuff
pulsemixer                  /
python-pywal                if you want terminal colors based on wallpaper
scrot                       screenshots
sxiv                        simple image viewer
virt-manager                QEMU/KVM frontend
vscode                      best text editor that's not vim
xclip                       clipboard from the terminal
xorg-server                 \
xorg-xbacklight              | xorg utilities
xorg-xinit                   | and such
xorg-xrandr                  |
xwallpaper                  /
```

### Fonts
```
ttf-dejavu                  \
ttf-liberation               | basic system
ttf-roboto                   | fonts
ttf-ubuntu-font-family      /
nerd-fonts-dejavu-complete  \
nerd-fonts-hack              | nerd
nerd-fonts-inconsolata       | fonts
nerd-fonts-roboto-mono      /
otf-exo                     exo font
```

### Fun stuff
```
cmatrix                     there is no spoon
figlet                      fun terminal ascii text
lolcat                      fun colors
pipes.sh                    terminal pipes
toilet                      more fun ascii text
```

### Drivers and such
```
clinfo                      OpenCL info
intel-media-driver          intel iGPU driver
intel-opencl-runtime        intel OpenCL driver
libva-intel-driver          more intel driver stuff 
xf86-input-synaptics        touchpads are a pain to get right
xf86-video-intel            intel drivers
xf86-video-vesa             vesa drivers
```

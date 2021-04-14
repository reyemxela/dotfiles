# dotfiles

I have moved from using [yadm](https://github.com/TheLocehiliosan/yadm) to using [GNU Stow](https://www.gnu.org/software/stow/).

One of my main goals with these configs is trying to squeeze as much functionality out of everything as I can, without having to resort to plugin frameworks and addons that I know I'll never use a fraction of. So my .zshrc, .vimrc, etc. have as many built-in tricks as I can find, and I'm adding new stuff as I go.

```
[~/dotfiles]$ stow [pkgname]      #to "install" a set of config files
[~/dotfiles]$ stow -D [pkgname]   #to "uninstall"/remove a set of configs
```


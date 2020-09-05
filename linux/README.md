```bash
sudo apt install gnome-tweak-tool vim-gnome htop terminator npm kazam gimp meld p7zip-full vnstat vlc 
```

## Common dirs for windows and ubuntu

Open "Disks" app and setup the auto mount for the common drive (X drive).

Update `.confg/user-dirs.dirs` to setup common dirs to windows and ubuntu (copy `user-dirs.dirs` from backup)
Copy over the `.desktop` files to `.local/share/applications/`, from backup to create shortcuts for `gvim-tab`, `postman` and `eclipse`

Update `.profile` and add the `sources.sh` (which has all references to other scripts; exports and all). This will update path outside of terminal as well.

VIM Plug

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

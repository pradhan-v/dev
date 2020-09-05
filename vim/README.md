# VIM setup

### Find in all files under the `pwd`

`:grep hello **/*.java`
This will display the results and will also populate the `Quickfix List`.
`:copen` opens the Quickfix List.
`:cclose` closes the list.
`:cn` moves cursor to the next entry in the list
`:cp` moves cursor to the previous entry in the list.

## Window

### Split
`:split` Horizontal split
`:vsplit` Vertical Split

#### `C-w`
- Navigation keys `jkhl` : Move/switch between the split-ed windows use .
- `JKHL` : Move the windows itself. For example, to move the current window to the left use `C-w J`
- `w` : Cycle the cursor between windows.
- `r` : Rotate the window positions

## VIM Plug

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

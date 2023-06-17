#!/bin/bash

pacman --noconfirm -Sy - < ./packages.txt

# yay --noconfirm -Sy - < ./aur-packages.txt
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

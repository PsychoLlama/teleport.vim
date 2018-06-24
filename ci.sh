#!/usr/bin/env bash
vimrc="
filetype off
set rtp+=vader.vim
set rtp+=.
set rtp+=after
filetype plugin indent on
syntax enable
"

vim -Nu <(echo "$vimrc") -c 'Vader! tests/*'

# teleport.vim
Vim + [z](https://github.com/rupa/z) = lightning fast navigation

<p align="center">
  <img alt="demo: navigating the file system with teleport.vim" src="https://cdn.rawgit.com/PsychoLlama/teleport.vim/master/assets/demo.gif" width="500" />
</p>

## Purpose
If you're reading this, you probably use [`z`](https://github.com/rupa/z)
to jump around your file system. It's a magical experience, and probably
one of my favorite CLI tools. If you don't use it, I highly recommend
checking it out, even without this plugin.

It's a critical part of my CLI workflow, and I wanted that same magic for vim.

Say you've got a project named `drone-security-guard/`. Normally to reach
this project you'd write

```sh
$ z drone
```

and it figures out what you mean and jumps into the directory. This plugin
works much the same:

```viml
:Z drone
```

The command above will open the `drone-security-guard/` directory using
whatever directory browser you've got configured.

> **Note:** I use [netrw](https://shapeshed.com/vim-netrw/) for navigation
  because it's awesome. This should work for NERDTree too, but I never test
  against it.

## Installation
[**vim-plug**](https://github.com/junegunn/vim-plug)
```viml
Plug 'PsychoLlama/teleport.vim'
```

[**Vundle**](https://github.com/VundleVim/Vundle.vim)
```viml
Plugin 'PsychoLlama/teleport.vim'
```

[**Pathogen**](https://github.com/tpope/vim-pathogen)
```sh
git clone https://github.com/PsychoLlama/teleport.vim ~/.vim/bundle/teleport.vim
```

## Integrations
`teleport.vim` is compatible with several different implementations.

### [rupa/z](https://github.com/rupa/z)
If you use the [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
framework, `teleport.vim` will work out of the box. You're good to go :rocket:

If not, you'll need to explicitly provide a path to your
[z](https://github.com/rupa/z) installation. Add this to your vimrc:

```viml
let zcd#path = expand('~/path/to/z/z.sh')
```

Where `~/path/to/z/z.sh` is replaced with the actual file path.

### [z.lua](https://github.com/skywind3000/z.lua)
There's also a lua-based implementation of `z`. Configuration is nearly
identical. Just put this in your vimrc:

```viml
let zcd#path = expand('~/path/to/z.lua/z.lua')
```

Where `~/path/to/z.lua/z.lua` is the actual file path, wherever you installed
it.

### [zoxide](https://github.com/ajeetdsouza/zoxide)
Zoxide is automatically detected - you don't have to do anything.

### Setting the integration
If you have more than one of these installed (why???) there's a chance
`teleport.vim` could choose the wrong one. You can force it to use
a particular driver by setting `zcd#driver`.

```viml
let zcd#driver = 'z' " rupa/z
let zcd#driver = 'z.lua' " skywind3000/z.lua
let zcd#driver = 'zoxide' " ajeetdsouza/zoxide
```

If you don't see your favorite program listed here, feel free to [open
a request!](https://github.com/PsychoLlama/teleport.vim/issues/new?title=%5BRequest%5D%20New%20Integration&body=Can%20haz%20%3Cplugin%3E%20integration%3F)

## Documentation
In traditional vim fashion, the documentation is kept in a help page.
After installing the plugin, run:

```viml
:help teleport.vim
```

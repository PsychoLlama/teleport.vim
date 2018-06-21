# z.vim
Vim + [z](https://github.com/rupa/z) = lightning fast navigation

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

## Documentation
In traditional vim fashion, the documentation is kept in a help page.
After installing the plugin run

```viml
:help z.vim
```

## Installation
[**vim-plug**](https://github.com/junegunn/vim-plug)
```viml
Plug 'PsychoLlama/z.vim'
```

[**Vundle**](https://github.com/VundleVim/Vundle.vim)
```viml
Plugin 'PsychoLlama/z.vim'
```

[**Pathogen**](https://github.com/tpope/vim-pathogen)
```sh
git clone https://github.com/PsychoLlama/z.vim ~/.vim/bundle/
```

## Configuration

If you use the [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
framework, `z.vim` will work out of the box. You're good to go :rocket:

If not, you'll need to explicitly provide a path to your
[z](https://github.com/rupa/z) installation. Add this to your vimrc:

```viml
let g:zcd#path = expand('~/path/to/z/z.sh')
```

Where `~/path/to/z/z.sh` is replaced with the actual file path.

## Support
If you run into trouble, feel free to [open an
issue](https://github.com/PsychoLlama/z.vim/issues/new).

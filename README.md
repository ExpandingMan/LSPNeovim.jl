# LSPNeovim.jl
This package is for interfacing the neovim [language server protocol](https://microsoft.github.io/language-server-protocol/) (LSP) client [nvim-lsp](https://github.com/neovim/nvim-lsp) with the Julia language server [LanguageServer.jl](https://github.com/julia-vscode/LanguageServer.jl).

The LSP provides code analysis capabilities for editors such as auto-completion,
jump-to-definition and documentation links.

Note that this requires at least neovim 0.5.  You can get nightly binaries as a convenient AppImage from [here](https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage).

**NOTE:** This package is experimental.  It requires [this
fork](https://github.com/ExpandingMan/nvim-lsp/tree/em/LSPNeovim) of `nvim-lsp` to work.


## Installation
Install [nvim-lsp](https://github.com/neovim/nvim-lsp).  Once that is done, LSPNeovim can
be installed with the command `:LspInstall julials`.

### Requirements:
- Julia 1.4
- Neovim 0.5
- [nvim-lsp](https://github.com/neovim/nvim-lsp)

### `init.vim` Example
The following is an example of an `init.vim` using
[vim-plug](https://github.com/junegunn/vim-plug).
```vim
call plug#begin('~/.config/nvim/plugged')

Plug 'neovim/nvim-lsp'
" the below is not required, but currently nvim-lsp is hard to configure without it
Plug 'haorenW1025/diagnostic-nvim'

call plug#end()

" the below is a Lua code block
lua << EOF
    local nvim_lsp = require'nvim_lsp'
    nvim_lsp.julials.setup({on_attach=require'diagnostic'.on_attach})
EOF
" alternatively one can call `nvim_lsp.julials.setup()` above if not using diagnostic-nvim

" enable completion (requires separate plugin such as deoplete-lsp)
autocmd Filetype julia setlocal omnifunc=v:lua.vim.lsp.omnifunc
```
Note that you will have to run `:LspInstall julials` to install LSPNeovim for use with
neovim.

### Custom Install
LSPNeovim is normally run by nvim-lsp by running Julia in the LSPNeovim environment.  It
is possible to explicitly define the Julia command run by nvim-lsp to start the language
server.  For example
```lua
local nvim_lsp = require'nvim_lsp'
local configs = require'nvim_lsp/configs'
-- Check if it's already defined for when I reload this file.
if not nvim_lsp.julials then
  configs.julials = {
    default_config = {
      cmd = {
              "julia", "--project=/path/to/env", "--startup-file=no", "--history-file=no",
              "/path/to/runscript"
          };
      filetypes = {'julia'};
      root_dir = function(fname)
        return nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
      end;
      settings = {};
    };
  }
end
nvim_lsp.julials.setup{}
```
(this needs to be run in a `lua << EOF ... EOF` block as shown above or from a separate
script using `luafile scriptname.lua` or `lua require'scriptname'`)
The field `cmd` in the table above gives the default command for starting the Julia
language server where `/path/to/env` gives the path to the environment the language server
runs in (i.e. *NOT* the environment you want to analyze).  `/path/to/runscript` is the path
to a script for running the language server.  It is recommended that you only use
`LSPNeovim/bin/run.jl` for this, as this script "bootstraps" Julia into an environment in
which the language server can run.  However, if you wish to install LSPNeovim manually, or
through the Julia package manager in your main environment with `Pkg.add` or `Pkg.dev`,
you will need to modify the above run command to point to your instance of `LSPNeovim`.

### Unobtrusive Mode
Historically getting all of the features of LanguageServer.jl working has been difficult.
If you set all indicators and warnings to be too aggressive, slight breakage can be
infuriating.  If you want to get all available features without being molested by broken
highlights, you can use [diagnostic-nvim](https://github.com/haorenW1025/diagnostic-nvim)
and set the following
```vim
let g:diagnostic_enable_virtual_text = 0
let g:diagnostic_show_sign = 0
let g:diagnostic_enable_underline = 0
```
To use available features on command, you will need to set keys for them, for example
```vim
nnoremap <silent> <leader>lg :lua vim.lsp.util.show_line_diagnostics()<CR>
nnoremap <silent> <leader>lh :lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>lf :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>lr :lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>l0 :lua vim.lsp.buf.document_symbol()<CR>
```

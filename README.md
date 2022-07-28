# Installation Instructions

Clone this repo, cd into it, and 

```sh
julia --project=. -e 'using Pkg; Pkg.build()'
```

Should install the package to `$HOME/.julia/bin/`. Make sure this is in your PATH and then you are good to go! The command `julials` should start the server

An example lsp configuration could be:

```lua
local servers = {
    julials = {

        cmd = {"julials" },
        settings = {
            julia = {
                symbolCacheDownload = false,
                runtimeCompletions = true,
                singleFileSupport = true,
                useRevise = true,
                lint = {
                    NumThreads = 11,
                    missingrefs = "all",
                    iter = true,
                    lazy = true,
                    modname = true,
                },
            },
        },

    },
    sumneko_lua = {
        cmd = {
            "lua-language-server",
        },
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
            },
        },
    },
}

for lsp, setup in pairs(servers) do
    setup.on_attach = on_attach
    setup.capabilities = make_capabilities()
    nvim_lsp[lsp].setup(setup)
end

```

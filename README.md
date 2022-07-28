# Installation Instructions

Clone this repo, cd into it, and 

```sh
./INSTALL
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
                singleFileSupport = false,
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
    -- other servers go here
}

for lsp, setup in pairs(servers) do
    setup.on_attach = on_attach
    setup.capabilities = make_capabilities()
    nvim_lsp[lsp].setup(setup)
end

```

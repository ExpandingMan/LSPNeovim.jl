using Documenter, LSPNeovim

makedocs(modules=[LSPNeovim],
         sitename="LSPNeovim.jl",
         pages=[
                "Home" => "index.md"
               ]
        )

deploydocs(repo="github.com/ExpandingMan/LSPNeovim.jl.git",
           deploy_config=Documenter.SimpleSSHConfig())

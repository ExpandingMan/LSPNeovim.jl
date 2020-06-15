using Pkg

#===================================================================
    bootstrapping into LSPNeovim...
===================================================================#
const PKGDIR = joinpath(@__DIR__,"..")
Pkg.activate(PKGDIR)
Pkg.instantiate()
#==================================================================#

# NOTE: SymbolServer must be used here due to a bizarre bug
# see https://github.com/julia-vscode/LanguageServer.jl/issues/750
using LSPNeovim, SymbolServer
LSPNeovim.run()

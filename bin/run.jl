using Pkg

#===================================================================
    bootstrapping into LSPNeovim...
===================================================================#
const PKGDIR = joinpath(@__DIR__,"..")
Pkg.activate(PKGDIR)
Pkg.instantiate()
#==================================================================#

using LSPNeovim
LSPNeovim.run()

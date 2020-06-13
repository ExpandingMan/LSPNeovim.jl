module LSPNeovim

using Pkg
using LanguageServer, SymbolServer

const PKGDIR = joinpath(@__DIR__,"..")


function activate()
    @info("Activating LSPNeovim environment")
    Pkg.activate(PKGDIR)
end

depotpath() = get(ENV, "JULIA_DEPOT_PATH", Pkg.depots1())

_defaultenvpath() = dirname(Base.load_path_expand("@v#.#"))

hasmanifest(dir::AbstractString) = isfile(joinpath(dir,"Manifest.toml"))
hasmanifest() = hasmanifest(PKGDIR)

function envpath(dirs=[pwd(), joinpath(pwd(),".."), _defaultenvpath()])
    dirs = filter(hasmanifest, dirs)
    if isempty(dirs)
        @warn("Failed to find a usable environment with valid Manifest.toml.  Checked:", dirs)
        return ""
    end
    first(dirs)
end

function run(env=envpath(), depot=depotpath(); input::IO=stdin, output::IO=stdout)
    activate()
    @info("Initializing Language Server", pwd(), env, depot)
    s = LanguageServer.LanguageServerInstance(input, output, env, depot)
    s.runlinter = true
    LanguageServer.run(s)
end

end # module

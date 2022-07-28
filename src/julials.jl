module julials
using Pkg
using LanguageServer, SymbolServer
using Comonicon

# shamelessly borrowed from https://github.com/ExpandingMan/LSPNeovim.jl, which is no longer maintained
depotpath() = get(ENV, "JULIA_DEPOT_PATH", Pkg.depots1())
_defaultenvpath() = dirname(Base.load_path_expand("@v#.#"))

"""
    hasmanifest(dir)
    hasmanifest()

Checks whether there is a valid `Manifest.toml` in directory `dir`.  If no argument is given, it
will check for the `Manifest.toml` in the `LSPNeovim` environment.
"""
hasmanifest(dir::AbstractString) = isfile(joinpath(dir, "Manifest.toml"))

_juliaproject() = get(ENV, "JULIA_PROJECT", nothing)
_juliaprojectbase() = Base.current_project()

function resolve_julia_project()
    return something(
        _juliaproject(),
        _juliaprojectbase(),
        get(Base.load_path(), 1, nothing),
        _defaultenvpath(),
    )
end



"""
    envpath()

Picks an appropriate environment path based on the present working directory.
A valid environment for LanguageServer must contain an `Manifest.toml`.  Directories will be checked
in the following order
1. The present working directory.
2. The immediate parent of the present working directory.
3. The default environment directory.

The first of these to contain a `Manifest.toml` will be the environment used for LanguageServer.
"""
function envpath(dirs = [pwd(), joinpath(pwd(), ".."), _defaultenvpath()])
    dirs = filter(hasmanifest, dirs)
    isempty(dirs) ? resolve_julia_project() : first(dirs)
end

"""
Run the `LanguageServerInstance`.  This will also activate the `LSPNeovim` environment.
By default, this will attempt to determine an appropriate environment, see `envpath`.
"""
function run(
    env = envpath(),
    depot = depotpath();
    input::IO = stdin,
    output::IO = stdout,
    download = false,
)
    @info("Initializing Language Server", pwd(), env, depot)
    s = LanguageServer.LanguageServerInstance(
        input,
        output,
        env,
        depot,
        nothing,
        nothing,
        download,
    )
    s.runlinter = true
    LanguageServer.run(s)
end

"""
`julials`: Start the julia language server
"""
@main function main(; download = false)
    return run(; download)
end # module
end

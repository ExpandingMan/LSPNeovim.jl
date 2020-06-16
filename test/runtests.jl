using Test, LSPNeovim

using LSPNeovim: hasmanifest, envpath

# make sure LSPNeovim environment is initialized
const PKGDIR = joinpath(@__DIR__, "..")
LSPNeovim.Pkg.activate(PKGDIR)
LSPNeovim.Pkg.instantiate()

@testset "environment" begin
    # check that LSPNeovim manifest was generated
    @test hasmanifest()
    cd(PKGDIR)
    @test realpath(envpath()) == realpath(PKGDIR)
end

@testset "language_server" begin
    @test LSPNeovim.LanguageServer.LanguageServerInstance(stdin, stdout, "", "") isa
            LSPNeovim.LanguageServer.LanguageServerInstance
end

module LSPNeovim

using Pkg
using LanguageServer, SymbolServer, StaticLint


function (@main)(args)
    env_path = if length(args) == 1
        args[1]
    elseif length(args) == 0
        LanguageServer.choose_env()
    else
        error("language server entry point accepts at most 1 argument, got $(length(args))")
    end
    runserver(stdin, stdout, env_path)
end

end # module

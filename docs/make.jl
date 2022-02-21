using ChainLadder
using Documenter

makedocs(;
    modules=[ChainLadder],
    authors="Alec Loudenback <alecloudenback@gmail.com> and contributors",
    repo="https://github.com/JuliaActuary/ChainLadder.jl/blob/{commit}{path}#L{line}",
    sitename="ChainLadder.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://JuliaActuary.github.io/ChainLadder.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "API Reference" => "api.md",
    ],
)

deploydocs(;
    repo="github.com/JuliaActuary/ChainLadder.jl",
)

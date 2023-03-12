using JutulDarcy
using Jutul
using Documenter

DocMeta.setdocmeta!(JutulDarcy, :DocTestSetup, :(using JutulDarcy; using Jutul); recursive=true)

makedocs(;
    modules=[JutulDarcy, Jutul],
    authors="Olav Møyner <olav.moyner@sintef.no> and contributors",
    repo="https://github.com/sintefmath/JutulDarcy.jl/blob/{commit}{path}#{line}",
    sitename="JutulDarcy.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://sintefmath.github.io/JutulDarcy.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/sintefmath/JutulDarcy.jl",
    devbranch="main",
)

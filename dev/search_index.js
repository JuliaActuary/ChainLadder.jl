var documenterSearchIndex = {"docs":
[{"location":"api/#ChainLadder-API-Reference","page":"API Reference","title":"ChainLadder API Reference","text":"","category":"section"},{"location":"api/","page":"API Reference","title":"API Reference","text":"Please open an issue if you encounter any issues or confusion with the package.","category":"page"},{"location":"api/","page":"API Reference","title":"API Reference","text":"","category":"page"},{"location":"api/","page":"API Reference","title":"API Reference","text":"Modules = [ChainLadder]","category":"page"},{"location":"api/#ChainLadder.square-Tuple{ChainLadder.ClaimsTriangle, Any}","page":"API Reference","title":"ChainLadder.square","text":"Fill in, or \"square\" the triangle with a fitted model.\n\n\n\n\n\n","category":"method"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = Yields","category":"page"},{"location":"#ChainLadder","page":"Home","title":"ChainLadder","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"(Image: Stable) (Image: Dev) (Image: Build Status) (Image: Coverage)","category":"page"},{"location":"#Help-wanted!","page":"Home","title":"Help wanted!","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"This package is very early in its development cycle.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Interested in developing loss reserving techniques in Julia? Consider contributing to this package. Open an issue, create a pull request, or discuss on the Julia Zulip's #actuary channel.","category":"page"},{"location":"#Quickstart","page":"Home","title":"Quickstart","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"using ChainLadder\nusing CSV\nusing Test\nusing DataFrames\n\nraa = CSV.File(\"test/data/raa.csv\") |> DataFrame\n\nt = CumulativeTriangle(raa.origin,raa.development,raa.values)\n\nlin = LossDevelopmentFactor(t)\n\ns = square(t,lin)\n\ntotal_loss(t,lin)\n\noutstanding_loss(t,lin)\n","category":"page"}]
}

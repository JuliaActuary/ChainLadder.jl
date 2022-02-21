module ChainLadder

import GLM

export Claims,
    latest_diagonal,
    IncrementalTriangle, CumulativeTriangle, Claims,
    linkratio, age_to_age, LDF,
    square, total_loss, outstanding_loss,
    LossDevelopmentFactor

include("Triangle.jl")
include("utils.jl")

include("LossDevelopment.jl")
include("Mack.jl")

end

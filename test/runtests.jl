using ChainLadder
using CSV
using Test
using DataFrames

raa = CSV.File("data/raa.csv") |> DataFrame
@testset "ChainLadder.jl" begin
    t = Claims(raa.origin,raa.development,raa.values)
    @test all(latest_diagonal(t) .== [18834.0,16704.0,23466.0,27067.0,26180.0,15852.0,12314.0,13112.0,5395.0,2063.0])

    lr = linkratio(t)
    @test all(lr[1,:] .== [1.6498403830806065, 1.319022856451808, 1.0823324470523517, 1.1468869123252858, 1.1951399660240787, 1.1129720042024598, 1.0332611472041757, 1.002901977644024, 1.0092165898617511])
    @test lr[end,1] .== 1.7219917012448134
    @test ismissing(lr[end,2])

end

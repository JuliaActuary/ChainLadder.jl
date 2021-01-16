using ChainLadder
using CSV
using Test
using DataFrames

raa = CSV.File("data/raa.csv") |> DataFrame!
@testset "ChainLadder.jl" begin
    t = ClaimTriangle(raa,:origin,:development,:values,IncrementalTriangle())
    @test all(latest_diagonal(t) .== [18834.0,16704.0,23466.0,27067.0,26180.0,15852.0,12314.0,13112.0,5395.0,2063.0])
end

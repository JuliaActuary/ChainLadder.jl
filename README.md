# ChainLadder

[![Build Status](https://github.com/JuliaActuary/ChainLadder.jl/workflows/CI/badge.svg)](https://github.com/JuliaActuary/ChainLadder.jl/actions)

## Help wanted!

This package is very early in its development cycle.

Interested in developing loss reserving techniques in Julia? Consider contributing to this package. Open an issue, create a pull request, or discuss on the [Julia Zulip's #actuary channel](https://julialang.zulipchat.com/#narrow/stream/249536-actuary).

## Quickstart

```julia
using ChainLadder
using CSV
using Test
using DataFrames

raa = CSV.File("test/data/raa.csv") |> DataFrame

t = CumulativeTriangle(raa.origin,raa.development,raa.values)

lin = LossDevelopmentFactor(t)

s = square(t,lin)

total_loss(t,lin)

outstanding_loss(t,lin)

```
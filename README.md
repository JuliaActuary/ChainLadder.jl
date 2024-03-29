# ChainLadder

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://JuliaActuary.github.io/ChainLadder.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://JuliaActuary.github.io/ChainLadder.jl/dev)
[![Build Status](https://github.com/JuliaActuary/ChainLadder.jl/workflows/CI/badge.svg)](https://github.com/JuliaActuary/ChainLadder.jl/actions)
[![Coverage](https://codecov.io/gh/JuliaActuary/ChainLadder.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/JuliaActuary/ChainLadder.jl)

## Help wanted!

This package is very early in its development cycle.

Interested in developing loss reserving techniques in Julia? Consider contributing to this package. Open an issue, create a pull request, or discuss on the [Julia Zulip's #actuary channel](https://julialang.zulipchat.com/#narrow/stream/249536-actuary).

## Quickstart

```julia
using ChainLadder
using CSV
using Test
using DataFrames

csv_data = ChainLadder.sampledata("raa")
raa = CSV.read(csv_data,DataFrame)

t = CumulativeTriangle(raa.origin,raa.development,raa.values)

lin = LossDevelopmentFactor(t)

s = square(t,lin)

total_loss(t,lin)

outstanding_loss(t,lin)

```

## Bundled sample data

Load sample data 
```
csv_data =ChainLadder.sampledata("raa")
raa = CSV.read(csv_data,DataFrame)
t = CumulativeTriangle(raa.origin,raa.development,raa.values)
```

Available datasets (courtesy of Python's [chainladder](https://chainladder-python.readthedocs.io/en/latest/intro.html)):

```
abc
auto
berqsherm
cc_sample
clrd
genins
ia_sample
liab
m3ir5
mcl
mortgage
mw2008
mw2014
prism
quarterly
raa
tail_sample
ukmotor
usaa
usauto
xyz
```

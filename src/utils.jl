"""
    latest_diagonal(t::ClaimsTriangle)

Return the last development value for each origin period.
"""
function latest_diagonal(t::ClaimsTriangle)
    return [row[findlast(x -> !ismissing(x), row)] for row in eachrow(t.claims)]
end

function linkratio(::CumulativeTriangle, v)
    v[2:end] ./ v[1:end-1]
end

function linkratio(::IncrementalTriangle, v)
    cumsum(v)[2:end] ./ v[1:end-1]
end

"""
    linkratio(t::ClaimsTriangle)

Return the link ratios for a given triangle.
"""
function linkratio(t::ClaimsTriangle)
    m, n = size(t.claims)
    lr = similar(t.claims, m - 1, n - 1)

    for i in 1:m-1
        for j in 2:n
            lr[i, j-1] = t.claims[i, j] / t.claims[i, j-1]
        end
    end
    return lr
end


"""
    valuation_date(t::ClaimsTriangle)

Return the last development index.
"""
function valuation_date(t::ClaimsTriangle)
    return last(t.development_indices)
end

"""
    linkratio(t::ClaimsTriangle)

Return the age to age ratios for a given triangle.
"""
function age_to_age(t)
    claims = t.claims
    n_origin, n_dev = size(claims)
    map(2:n_dev) do t
        c = sum(claims[1:end-t+1, t])
        c_prior = sum(claims[1:end-t+1, t-1])
        c / c_prior
    end

end

# function Base.show(io,t::C) where {C<:ClaimsTriangle}
# 	show(io,pretty_table(t.claims,row_names = string.(t.origin), header = string.(t.development)))
# end

function sampledata(name)
    rootpath = Artifacts.artifact"sample_data"
    open(joinpath(rootpath, "$name.csv"))
end
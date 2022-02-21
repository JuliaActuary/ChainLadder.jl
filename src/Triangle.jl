abstract type ClaimsTriangle end

struct IncrementalTriangle <: ClaimsTriangle
    origin
    development
    claims
end

function IncrementalTriangle(origin, development, claims::Vector{T}) where {T<:Real}
    origin_indices, dev_indices, m = _process_triangle(origin, development, claims)
    IncrementalTriangle(origin_indices, dev_indices, m)
end

struct CumulativeTriangle <: ClaimsTriangle
    origin
    development
    claims
end

function CumulativeTriangle(origin, development, claims::Vector{T}) where {T<:Real}
    origin_indices, dev_indices, m = _process_triangle(origin, development, claims)
    CumulativeTriangle(origin_indices, dev_indices, m)
end


function Claims(origin, development, claims)
    origin_indices, dev_indices, m = _process_triangle(origin, development, claims)
    #use a heuristic because the ClaimsTriangle was not specified
    if sum(skipmissing(diff(m, dims = 2) .>= 0)) / sum(.~ismissing.(diff(m, dims = 2))) > 0.95
        return CumulativeTriangle(origin_indices, dev_indices, m)
    else
        return IncrementalTriangle(origin_indices, dev_indices, m)
    end

end

function IncrementalTriangle(c::CumulativeTriangle)
    m = similar(c.claims)

    m[:, 1] .= c.claims[:, 1]
    m[:, 2:end] = diff(c.claims, dims = 2)

    return IncrementalTriangle(c.origin, c.development, m)
end

function CumulativeTriangle(i::IncrementalTriangle)
    m = cumsum(i.claims, dims = 2)
    return CumulativeTriangle(m.origin, m.development, m)
end


function _process_triangle(origin, development, claims)
    origin_indices = sort!(unique(origin))
    dev_indices = sort!(unique(development))
    o_loc = indexin(origin, origin_indices)
    d_loc = indexin(development, dev_indices)
    m = length(origin_indices)
    n = length(dev_indices)
    m = Array{Union{Missing,eltype(claims)}}(missing, m, n)
    fill!(m, missing)
    for (o, d, v) in zip(o_loc, d_loc, claims)
        m[o, d-o+1] = v
    end

    return origin_indices, dev_indices, m
end

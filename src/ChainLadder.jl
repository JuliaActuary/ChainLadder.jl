module ChainLadder

using DataFrames

export ClaimTriangle,
    latest_diagonal,
    IncrementalTriangle, CumulativeTriangle,
    link_ratio

abstract type TriangleType end

struct CumulativeTriangle <: TriangleType end
struct IncrementalTriangle <: TriangleType end

struct ClaimTriangle
	origin
	development
	claims
    kind::TriangleType
end

function Claims(origin, development,values;kind=nothing)
	origin_indices = sort!(unique(origin))
	dev_indices = sort!(unique(development))
	o_loc = indexin(origin,origin_indices)
	d_loc = indexin(development,dev_indices)
	m = length(origin_indices)
	n = length(dev_indices)
	m = Array{Union{Missing, eltype(values)}}(missing, m, n)
	fill!(m,missing)
	for (o,d,v) in zip(o_loc,d_loc,values)
		@show o,d,v
		m[o,d-o+1] = v
	end
	#use a heuristic 
	if isnothing(kind)
		if sum(skipmissing(diff(m,dims=2) .>= 0)) / sum(.~ismissing.(diff(m,dims=2))) > .95
			kind = CumulativeTriangle()
		else
			kind = IncrementalTriangle()
		end
	end

	return ClaimTriangle(origin_indices,dev_indices,m,kind)
end


function latest_diagonal(t::ClaimTriangle)
	return [v[end] for v in t.values]
end

function link_ratio(::CumulativeTriangle,v::Vector)
	v[2:end] ./ v[1:end-1]
end

function link_ratio(::IncrementalTriangle,v::Vector)
	cumsum(v)[2:end] ./ v[1:end-1]
end
	
function link_ratio(t::ClaimTriangle)
    return [link_ratio(t.type,v) for v in t.values[1:end-1]]
end


function valuation_date(t::ClaimTriangle)
	return last(t.development_indices)
end
end

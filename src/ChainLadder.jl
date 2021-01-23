module ChainLadder

using DataFrames

export ClaimTriangle, Claims,
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
	return [row[findlast(x -> !ismissing(x),row)] for row in eachrow(t.claims)]
end

function link_ratio(::CumulativeTriangle,v)
	v[2:end] ./ v[1:end-1]
end

function link_ratio(::IncrementalTriangle,v)
	cumsum(v)[2:end] ./ v[1:end-1]
end
	
function link_ratio(t::ClaimTriangle)
	m,n = size(t.claims)
	lr = similar(t.claims,m-1,n-1)

	for i in 1:m-1
		for j in 2:n
			lr[i,j-1] = t.claims[i,j] / t.claims[i,j-1]
		end
	end
	return lr
end


function valuation_date(t::ClaimTriangle)
	return last(t.development_indices)
end

end

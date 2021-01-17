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
    origin_indices
	development_indices
    values
    type::TriangleType
    
end

function ClaimTriangle(df,origin,development,values,type)
	sort!(df,[origin,order(development, rev=true)])
	vals = map(groupby(df,origin)) do subdf
		return reverse(subdf[:,values])
	end
	
	return ClaimTriangle(
			sort!(unique(df.origin)),
			sort!(unique(df.origin),rev=true),
			vals,
            type
	)
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

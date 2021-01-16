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
			vals,
            type
	)
end


function latest_diagonal(t::ClaimTriangle)
	return [v[end] for v in t.values]
end

function link_ratio(v::Vector)
	lr = zeros(length(v)-1)
	for i in 2:length(v)
		lr[i-1] = v[i] / v[i-1]
	end
	return lr
end
	
function link_ratio(t::ClaimTriangle)
    return [link_ratio(v) for v in t.values[1:end-1]]
end

end

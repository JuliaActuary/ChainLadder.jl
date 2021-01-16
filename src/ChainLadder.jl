module ChainLadder

using DataFrames

export ClaimTriangle,
    latest_diagonal,
    IncrementalTriangle, CumulativeTriangle

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


end

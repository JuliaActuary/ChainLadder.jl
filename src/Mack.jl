 struct LossDevelopmentFactor
    ratios
 end

 function LossDevelopmentFactor(t::ClaimsTriangle)
    ratios = age_to_age(t)
    log_ratios = log.(ratios .- 1)
    dev_length = length(t.development)
    data = [(ratio = r,time = t) for (r,t) in  zip(log_ratios,1:dev_length-1)]
    lin = GLM.lm(GLM.@formula(ratio ~ time), data)
    b,a = GLM.coef(lin)

    predict(x) = exp(a*x + b) + 1

    projected_ratios = predict.(dev_length:dev_length*10)

    tail = prod(projected_ratios)

    return LossDevelopmentFactor([ratios; tail])
    
 end


function square(t::CumulativeTriangle,fit::LossDevelopmentFactor)
    △ = t.claims
    rows,cols = size(△)

    □ = zeros(rows,cols+1)
    
    for r in 1:rows, c in 1:cols
        if ismissing(△[r,c])
            □[r,c] = □[r,c-1] * fit.ratios[c-1]
        else
            □[r,c] = △[r,c]
        end
    end

    # fill in the ultimates
    □[:,end] .= □[:,cols] .* fit.ratios[end]

    return □

end

function total_loss(t::ClaimsTriangle,fit::LossDevelopmentFactor)

    # sum the ultimate claims
   return sum(square(t,fit)[:,end])
end

function outstanding_loss(t::ClaimsTriangle,fit::LossDevelopmentFactor)

    # sum the ultimate claims
   return total_loss(t,fit) - sum(latest_diagonal(t))
end

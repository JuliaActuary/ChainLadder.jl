struct LossDevelopmentFactor
    ratios
end

"""
    LossDevelopmentFactor(t::ClaimsTriangle;tail=nothing)

A development model using volume weighted age-to-age ratios of losses. Use log-ratios for the tail estimator unless user has specified a tail.
"""
function LossDevelopmentFactor(t::IncrementalTriangle; tail = nothing)
    c = CumulativeTriangle(t)
    return LossDevelopmentFactor(c, tail = tail)
end

function LossDevelopmentFactor(t::CumulativeTriangle; tail = nothing)
    ratios = age_to_age(t)
    if isnothing(tail)

        log_ratios = log.(ratios .- 1)
        dev_length = length(t.development)
        data = [(ratio = r, time = t) for (r, t) in zip(log_ratios, 1:dev_length-1)]
        lin = GLM.lm(GLM.@formula(ratio ~ time), data)
        b, a = GLM.coef(lin)

        predict(x) = exp(a * x + b) + 1

        projected_ratios = predict.(dev_length:dev_length*10)

        tail = prod(projected_ratios)

        return LossDevelopmentFactor([ratios; tail])
    else
        return LossDevelopmentFactor([ratios; tail])
    end

end


function square(t::CumulativeTriangle, fit::LossDevelopmentFactor)
    △ = t.claims
    rows, cols = size(△)

    □ = zeros(rows, cols + 1)

    for r in 1:rows, c in 1:cols
        if ismissing(△[r, c])
            □[r, c] = □[r, c-1] * fit.ratios[c-1]
        else
            □[r, c] = △[r, c]
        end
    end

    # fill in the ultimates
    □[:, end] .= □[:, cols] .* fit.ratios[end]

    return □

end

function total_loss(t::ClaimsTriangle, fit::LossDevelopmentFactor)

    # sum the ultimate claims
    return sum(square(t, fit)[:, end])
end

function outstanding_loss(t::ClaimsTriangle, fit::LossDevelopmentFactor)

    # sum the ultimate claims
    return total_loss(t, fit) - sum(latest_diagonal(t))
end

function LDF(fit::LossDevelopmentFactor)
    return reverse!(cumprod(fit.ratios))
end
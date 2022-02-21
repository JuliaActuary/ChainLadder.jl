abstract type LossDevelopment end

"""
Fill in, or "square" the triangle with a fitted model.
"""
function square(t::ClaimsTriangle,fit)
    # TODO

end

function total_loss(t::ClaimsTriangle,fit)

    # sum the ultimate claims
   return sum(square(t,fit)[:,end])
end


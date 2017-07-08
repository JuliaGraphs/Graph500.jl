struct kroneckerState
    edge::Array{Int,2}
    weight::Array{Float64}
end

"""
    Generates a kronecker Graph. `SCALE` is the logarithm base two of the number of vertices.
    `edgefactor` is the ratio of the graph’s edge count to its vertex count (i.e., half the
    average degree of a vertex in the graph).

###
References
- http://graph500.org/?page_id=12#alg:generator
"""

function kronecker_generator(SCALE, edgefactor, A=0.57, B=0.19, C=0.19)
    N  = 2^SCALE            # Set number of vertices
    M  = edgefactor * N     # Set number of edges
    ij = ones(Int, M, 2)    # Create index arrays
    ijw = rand(Float64, M)  # Generate weights

    # Loop over each order of bit
    ab = A + B
    c_norm = C/(1 - (A + B))
    a_norm = A/(A + B)

    temp =  @parallel (+) for ib in 1:SCALE
        # Compare with probabilities and set bits of indices.
        random_bits = falses(M, 2)
        random_bits[:, 1] = rand(M) .> (ab)
        random_bits[:, 2] = rand(M) .> ( c_norm.*(random_bits[:, 1]) + a_norm.*.!(random_bits[:, 1]) )
        2^(ib-1).*random_bits
    end

    ij[:, 1:2] += temp

    # Permute vertex labels
    p = randperm(N)
    ij[:, 1:2] = p[ij[:, 1:2]]

    # Permute the edge list
    p = randperm(M)
    ij = ij[p, :]
    ijw = ijw[p]

    return kroneckerState(ij, ijw)
end

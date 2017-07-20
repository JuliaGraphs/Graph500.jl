.struct kroneckerState{T<:Integer, R<:Real}
    edge::Array{T,2}
    weight::Array{R}
end

"""
    Returns a kroneckerState. `SCALE` is the logarithm base two of the number of vertices.
    `edgefactor` is the ratio of the graph’s edge count to its vertex count (i.e., half the
    average degree of a vertex in the graph).

###
References
- http://graph500.org/?page_id=12#alg:generator
"""

function kronecker_generator(
  SCALE::Integer,
  edgefactor::Integer;
  replicate::Bool=false,
  seed::AbstractArray=[],
  A::AbstractFloat=0.57,
  B::AbstractFloat=0.19,
  C::AbstractFloat=0.19
  )
    N  = 2^SCALE            # Set number of vertices
    M  = edgefactor * N     # Set number of edges
    ij = ones(Int, 2, M)      # Create index arrays

    # Loop over each order of bit
    ab = A + B
    c_norm = C/(1 - (A + B))
    a_norm = A/(A + B)

    #Seeding the processors if replicate is true
    if replicate
      for i in 1:nprocs()
         @spawnat i srand(seed[i])
      end
    end

    temp =  @parallel (+) for ib in 1:SCALE
        # Compare with probabilities and set bits of indices.
        random_bits = falses(2, M)
        random_bits[1, :] = rand(M) .> (ab)
        random_bits[2, :] = rand(M) .> ( c_norm.*(random_bits[1, :]) + a_norm.*.!(random_bits[1, :]) )
        2^(ib-1).*random_bits
    end

    ij += temp

    # Generate weights
    if replicate
      srand(seed[nprocs() + 1])
    end
    ijw = rand(Float64, M)

    # Permute vertex labels
    p = randperm(N)
    ij[1:2, :] = p[ij[1:2, :]]

    # Permute the edge list
    p = randperm(M)
    ij = ij[:, p]
    ijw = ijw[p]

    return kroneckerState{Int64, Float64}(ij, ijw)
end

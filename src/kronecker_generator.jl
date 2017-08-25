"""
    get_min_type(n)

Return the minimum Integer type which can contain `n`
"""
function get_min_type(n::Integer)
    (n >= 64 ) && error("scale must be less than equal to 64")
    (n < 8)  && return UInt8
    (n < 16) && return UInt16
    (n < 32) && return UInt32
    (n < 64) && return UInt64
end

"""
    function kronecker_generator(scale, edgefactor; replicate, seed, A=0.57, B=0.19, C=0.19)

Generate a edge_list based on kronecker algorithm(http://graph500.org/?page_id=12#sec-3)
with kronecker parameters `A`, `B` and `C`. `scale` is the logarithm base two of the number
of vertices. `edgefactor` is the ratio of the graph’s edge count to its vertex count (i.e.,
half the average degree of a vertex in the graph)

###
References
- http://graph500.org/?page_id=12#alg:generator
"""

function kronecker_generator(
  scale::Integer,
  edgefactor::Integer;
  replicate::Bool=false,
  seed::AbstractArray=[],
  A::AbstractFloat=0.57,
  B::AbstractFloat=0.19,
  C::AbstractFloat=0.19
  )
    N  = 2^scale            # Set number of vertices
    M  = edgefactor * N     # Set number of edges

    # getting correct Inttype
    T = get_min_type(scale)

    # loop over each order of bit
    ab = A + B
    c_norm = C/(1 - (A + B))
    a_norm = A/(A + B)


    ij = ones(T, 2, M)    # Create index arrays
    T_one = T(1)
    T_two = T(2)

    # seeding the processors if replicate is true
    if replicate
      for i in 1:nprocs()
         @spawnat i srand(seed[i])
      end
    end

    temp =  @parallel (+) for ib in 1:T(scale)
        # Compare with probabilities and set bits of indices.
        random_bits = falses(2, M)
        random_bits[1, :] = rand(M) .> (ab)
        random_bits[2, :] = rand(M) .> ( c_norm.*(random_bits[1, :]) + a_norm.*.!(random_bits[1, :]) )
        T_two^(ib-T_one).*random_bits
    end

    ij += temp

    # Permute vertex labels
    p = randperm(N)
    ij[1:2, :] = p[ij[1:2, :]]

    return ij
end

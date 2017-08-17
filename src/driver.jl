struct Graph500Results
    SCALE::Integer
    NBFS::Integer
    kernel_1_time::Float64
    kernel_2_time::Vector{Float64}
    kernel_2_nedge::Vector{Float64}
end

Graph500Results() = Graph500Results(0,0,0.0,zeros(0),zeros(0))

"""
    Driver function for the Graph500 test
"""
function driver(
  SCALE::Integer,
  edgefactor::Integer;
  replicate::Bool=false,
  seed::AbstractArray=[])

    # generate edge list
    ij = kronecker_generator(SCALE, edgefactor;replicate=replicate,seed=seed)

    # timing kernel 1
    tic()
    g = kernel_1(ij)
    kernel_1_time = toq()

    # For computing the graph element type
    T = eltype(g)

    search_key = key_sampling(g)
    NBFS  = length(search_key)
    kernel_2_time =  zeros(Float64,NBFS)
    kernel_2_nedge = zeros(Float64,NBFS)

    for (k, key) in enumerate(search_key)
        tic()
        parent_ = kernel_2(g, key)
        kernel_2_time[k] = toq()
        err = validate(g, parent_, ij, key)
        err <= 0 && error("BFS ",k ," from search key ",key," failed to validate: ",err)

        # Volume/2
        total_edges_traversed = 0
        for i in 1:length(parent_)
            if(parent_[i]>0)
                total_edges_traversed += indegree(g, parent_[i])
            end
        end
        kernel_2_nedge[k] = Float64(total_edges_traversed)/2
    end

    # printing information
    stats = Graph500Results(SCALE, NBFS, kernel_1_time, kernel_2_time, kernel_2_nedge)
    result = Dict{Graph{T},Graph500Results}()
    result[g] = stats
    output(stats, nv(g), ne(g))
    return result
end


struct Graph500Results
    scale::Integer
    nbfs::Integer
    kernel_1_time::Float64
    kernel_2_time::Vector{Float64}
    kernel_2_nedge::Vector{Float64}
end

### required for initialising Dict{Graph{T},Graph500Results}() constructor
Graph500Results() = Graph500Results(0, 0, 0.0, zeros(0), zeros(0))

@doc_str """
    driver(scale, edgefactor; replicate, seed)

Run Graph500 benchmark(http://graph500.org/?page_id=12) on a graph with `2^scale` vertices and
`2^scale*edgefactor` edges. Returns a `ResultStatistic` structure

### Optional Arguments
- `replicate=true`: If true, returns a graph generated with intitial seed = `seed`
"""
function driver(
  scale::Integer,
  edgefactor::Integer;
  replicate::Bool=false,
  seed::AbstractArray=[])

    println("Generating graph.")
    ij = kronecker_generator(scale, edgefactor; replicate=replicate, seed=seed)   # generate edge list

    println("Starting Kernel 1.")
    tic()
    g = kernel_1(ij)    # kernel1
    kernel_1_time = toq()

    T = eltype(g)
    search_key = key_sampling(g)    # sample min(nv(g),64) vertices for dfs
    nbfs  = length(search_key)      # number of bfs
    kernel_2_time =  zeros(Float64, nbfs)   # stores per bfs time
    kernel_2_nedge = zeros(Float64, nbfs)   # stores number of edges traversed per bfs

    ### kernel_2
    @showprogress 1 "Kernel 2: " for (k, key) in enumerate(search_key)
        tic()
        parent_ = kernel_2(g, key)
        kernel_2_time[k] = toq()
        err = validate(g, parent_, ij, key)
        err <= 0 && error("BFS ", k, " from search key ", key, " failed to validate: ", err)

        ### Volume/2
        total_edges_traversed = 0
        for i in 1:length(parent_)
            if(parent_[i] > 0)
                total_edges_traversed += indegree(g, parent_[i])
            end
        end
        kernel_2_nedge[k] = Float64(total_edges_traversed)/2
    end

    ### Result statistics
    result_state = Graph500Results(scale, nbfs, kernel_1_time, kernel_2_time, kernel_2_nedge)
    result = Dict{Graph{T}, Graph500Results}()
    result[g] = result_state
    output(result_state, nv(g), ne(g))
    return result
end

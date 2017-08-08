struct Graph500Results{T<:Integer}
    g::Graph{T}
    NBFS::Integer
    kernel_1_time::Float64
    kernel_2_time::SharedArray{Float64,1}
    kernel_2_nedge::SharedArray{Int64,1}
end


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
    kernel_1_time = toc()

    # For computing the graph element type
    T = eltype(g)

    search_key = key_sampling(g)
    NBFS = length(search_key)

    kernel_2_time =  zeros(Float64,NBFS)
    kernel_2_nedge = zeros(Float64,NBFS)

    for k in 1:NBFS
        tic()
        parent_ = zeros(T,nv(g))
        kernel_2(g, search_key[k], parent_)
        kernel_2_time[k] = toc()
        err = validate(g, parent_, ij, search_key[k])
        if err <= 0
          error("BFS ",k ," from search key ",search_key[k]," failed to validate: ",err)
        end

        # Volume/2
        for i in 1:length(parent_)
            if(parent_[i]>0)
                kernel_2_nedge[k]+=indegree(g, parent_[i])
            end
        end
    end

    return Graph500Results{T}(g, NBFS, kernel_1_time, kernel_2_time, kernel_2_nedge)
end

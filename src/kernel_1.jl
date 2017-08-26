@doc_str """
    kernel_1(ij)
Create Graph from edge list `ij` based on kernel_1 benchmark(http://graph500.org/?page_id=12#sec-4)
Return `LightGraphs.SimpleGraph` structure
"""
function kernel_1(
  ij::Matrix{T}
  ) where T<:Integer

  # Creating Graph
  nv = maximum(ij) # Number of vertices
  g = Graph{T}(nv) # Creating a graph with `nv` number of vertices

  # removing self Loop and adding edges
  for i in 1:size(ij)[2]
    if(ij[1,i] != ij[2,i])
      add_edge!(g, ij[1,i], ij[2,i]);
    end
  end

  return g
end

function kernel_1_new(
  ij::Matrix{T}
  ) where T<:Integer

  # Creating Graph
  nv = maximum(ij) # Number of vertices
  g = Graph{T}() # Creating a graph with `nv` number of vertices
  v = Vector{Tuple{T,T}}()
  vertex_degree = zeros(T, nv)
  sizehint!(v, size(ij)[2]*2)
  ne = 0

  # removing self Loop and adding edges
  for i in 1:size(ij)[2]
    if(ij[1,i] != ij[2,i])
        push!(v, tuple(ij[1,i],ij[2,i]))
        push!(v, tuple(ij[2,i],ij[1,i]))
        vertex_degree[ij[1,i]]+=1
        vertex_degree[ij[2,i]]+=1
    end
  end

  sort!(v,alg=QuickSort)
  fadjlist = Vector{Vector{T}}()
  sizehint!(fadjlist, nv)
  for i in one(T):nv
      push!(fadjlist, Vector{T}())
      sizehint!(fadjlist[i], vertex_degree[i])
  end

  last_added = Tuple{T,T}([0, 0])
  for edge in v
      if(edge != last_added)
          push!(fadjlist[edge[1]], edge[2])
          last_added = edge
          ne += 1
      end
  end

  g.fadjlist = fadjlist
  g.ne = ne/2
  return g
end

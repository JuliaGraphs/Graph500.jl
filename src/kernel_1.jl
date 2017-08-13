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

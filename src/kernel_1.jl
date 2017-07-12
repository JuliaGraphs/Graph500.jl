function kernel_1(
  edge_list::kroneckerState{T, R}
  ) where T<:Integer where R<:Real

  ij = edge_list.edge
  ijw = edge_list.weight
  cols = size(ij)[2]

  # removing self Loop
  for i in 1:cols
    if(ij[1, i] == ij[2, i])
      ijw[i] = zero(R)
    end
  end

  # Represent an undirected Graph
  srcs = vcat(ij[1,:], ij[2, :])
  dest = vcat(ij[2,:], ij[1, :])
  weight = vcat(ijw, ijw)

  # Construct a sparse matrix and a SimpleWeightedGraph
  sp = sparse(srcs, dest, weight)
  g = SimpleWeightedGraph{T,R}(sp)

  return g
end

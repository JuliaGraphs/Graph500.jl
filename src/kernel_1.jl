function kernel_1(edge_list::kroneckerState)
  ij = edge_list.edge
  ijw = edge_list.weight
  nv = maximum(ij)
  ne = size(ij)[2]
  g = SimpleWeightedGraph(nv)

  @simd for i in 1:ne
    if ij[1, i] != ij[2, i]
      @inbounds add_edge!(g, ij[1, i], ij[2, i], ijw[i])
    end
  end

  return g
end

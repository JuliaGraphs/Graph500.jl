function kernel_3(
  g::SimpleWeightedGraph{T,R},
  key::T
  ) where T<:Integer where R<:Real

  SSSP= dijkstra_shortest_paths(g, key)
  parent = SSSP.parents
  d = SSSP.dists
  parent[key] = key
  parent = parent - 1
  return (parent, d)
end

function kernel_1(
  edge_list::kroneckerState{T}
  ) where T<:Integer

  # Creating Graph
  ne = maximum(edge_list.edge)
  g = Graph(ne)
  g.ne = ne
  edge = edge_list.edge

  # removing self Loop and creating fadjlist
  for i in 1:size(edge)[2]
    if(edge[1,i] != edge[2,i])
      add_edge!(g,edge[1,i],edge[2,i]);
    end
  end

  return g
end

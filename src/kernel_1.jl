function kernel_1(
  edge_list::Array{T,2}
  ) where T<:Integer

  # Creating Graph
  ne = maximum(edge_list)
  g = Graph{T}(ne)
  g.ne = ne

  # removing self Loop and adding edges
  for i in 1:size(edge_list)[2]
    if(edge_list[1,i] != edge_list[2,i])
      add_edge!(g,edge_list[1,i],edge_list[2,i]);
    end
  end

  return g
end

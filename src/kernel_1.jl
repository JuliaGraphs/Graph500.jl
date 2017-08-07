function kernel_1(
  ij::Array{T,2}
  ) where T<:Integer

  # Creating Graph
  ne = maximum(ij)
  g = Graph{T}(ne)
  g.ne = ne

  # removing self Loop and adding edges
  for i in 1:size(ij)[2]
    if(ij[1,i] != ij[2,i])
      add_edge!(g, ij[1,i], ij[2,i]);
    end
  end

  return g
end

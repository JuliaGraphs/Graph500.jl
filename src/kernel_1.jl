function kernel_1(
  edge_list::kroneckerState{T, R}
  ) where T<:Integer where R<:Real


  ij1  = Vector{T}()
  ij2  = Vector{T}()
  ijw  = Vector{R}()

  # removing self Loop
  cols = length(edge_list.weight)
  sizehint!(ij1,cols)
  sizehint!(ij2,cols)
  sizehint!(ijw,cols)
  index = 1
  @simd for i in 1:cols
    @inbounds if edge_list.edge[1,i] != edge_list.edge[2,i]
      push!(ij1, edge_list.edge[1,i])
      push!(ij2, edge_list.edge[2,i])
      push!(ijw, edge_list.weight[i])
      index += 1
    end
  end

  # Represent an undirected Graph
  srcs = vcat(ij1, ij2)
  dest = vcat(ij2, ij1)
  weight = vcat(ijw, ijw)

  # Construct a sparse matrix and a SimpleWeightedGraph
  sp = sparse(srcs, dest, weight)
  g = SimpleWeightedGraph{T,R}(sp)

  return g
end

function key_sampling(
  g::Graph{T}
  ) where T<:Integer

  n_v = nv(g)
  rand_keys = sample(1:n_v, 64, replace = false)
  keys = Vector{T}()
  sizehint!(keys, 64)

  for i in 1:64
    if degree(g, rand_keys[i]) > 0
      push!(keys, rand_keys[i])
    end
  end

  return keys
end

function kernel_2(
  g::Graph{T},
  key::T
  ) where T<:Integer

  parent = dijkstra_shortest_paths(g, key).parents
  parent[key] = key
  return parent
end

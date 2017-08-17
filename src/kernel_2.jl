function key_sampling(
  g::Graph{T}
  ) where T<:Integer

  n_v = nv(g)
  keys = Set{T}()
  sizehint!(keys, 64)
  NBFS = n_v > 64 ? 64 : n_v
  length_keys = 0
  i = 0  #Exit loop after a fixed number of iterations

  while length_keys < NBFS && i < 1000
      keys_required = (NBFS - length_keys)
      rand_keys = sample(1:n_v,keys_required)
      union!(keys, filter(x->degree(g,x)>0, rand_keys))
      length_keys = length(keys)
      i = i + 1;
  end

  return keys
end


kernel_2(g::Graph{T}, s::T) where T<:Integer = bfs_parents(g,s)

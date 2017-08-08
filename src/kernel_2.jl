function key_sampling(
  g::Graph{T}
  ) where T<:Integer

  n_v = nv(g)
  rand_keys = randperm(n_v)
  keys = Vector{T}()
  sizehint!(keys, 64)

  for i in 1:n_v
    if length(keys) == 64
        break
    else
        if degree(g, rand_keys[i]) > 0
            push!(keys, rand_keys[i])
        end
    end
  end

  return keys
end

function kernel_2(g::Graph{T}, s::T, parents::Vector{T}) where T<:Integer
    Q=Vector{T}()
    seen = falses(nv(g))
    parents[s] = s
    seen[s] = true
    push!(Q, s)
    while !isempty(Q)
        src = shift!(Q)
        for vertex in out_neighbors(g, src)
            if !seen[vertex]
                push!(Q, vertex) #Push onto queue
                parents[vertex] = src
                seen[vertex] = true
            end
        end
    end
    return parents
end

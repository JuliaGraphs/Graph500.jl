function validate(
  g::SimpleWeightedGraph{T,R},
  parent_::Vector{T},
  edge_list::kroneckerState{T, R},
  search_key::T,
  d::Vector{R},
  is_sssp::Bool
  ) where T<:Integer where R<:Real

    # Default: no error.
    out = 1

    # Adjust from zero labels.
    parent_ = parent_ + 1
    search_key = search_key + 1

    ij = edge_list.edge
    ijw = g.weights

    # root must be the parent of itself
    if parent_[search_key] != search_key
      out = 0
      return out
    end

    N = nv(g)
    slice = find(x->(x > 0), parent_)

    #Compute levels and check for cycles.
    level_ = zeros(T, length(parent_))
    level_[slice] = 1
    P = parent_[slice]
    mask = (P .!= search_key)
    k = 0
    while any(mask)
      level_[slice[mask]] = level_[slice[mask]] + 1
      P = parent_[P]
      mask = (P .!= search_key)
      k = k + 1
      if k > N
        #There must be a cycle in the tree.
        out = -3
        return out
      end
    end

    #Check that there are no edges with only one end in the tree.
    #This also checks the component condition.
    lij = level_[ij]
    neither_in = zeros(Bool,size(lij)[2])
    not_neither_in_or_both_in = zeros(Bool,size(lij)[2])
    for i in 1:size(lij)[2]
      if ij[1,i] != ij[2,i]
        neither_in[i] = (lij[1,i] == 0 && lij[2,i] == 0)
        not_neither_in_or_both_in[i] = !((lij[1,i] == 0 && lij[2,i] == 0) || (lij[1,i] > 0 && lij[2,i] > 0))
      else
        neither_in[i] = true
        not_neither_in_or_both_in[i] = false
      end
    end
    if any(not_neither_in_or_both_in)
      out = -4
      return out
    end

    #Validate the distances/levels.
    respects_tree_level = trues(1, size(ij)[2])
    not_neither_in_or_respects_tree_level = zeros(Bool,size(ij)[2])
    if !is_sssp
      for i in 1:size(ij)[2]
        not_neither_in_or_respects_tree_level[i] = !(neither_in[i] || respects_tree_level[i])
      end
      respects_tree_level = abs.(lij[1,:] .- lij[2,:]) .<= 1
    else
      for i in 1:size(ij)[2]
        respects_tree_level[i] = abs(d[ij[1,i]] - d[ij[2,i]]) <= ijw[ij[1,i],ij[2,i]]
        not_neither_in_or_respects_tree_level[i] = !(neither_in[i] || respects_tree_level[i])
      end
    end

    if any(not_neither_in_or_respects_tree_level)
      out = -5
      return out
    end

    return out
  end

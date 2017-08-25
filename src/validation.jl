@doc_str """
    validate(g, parent_, ij, search_key)
validate `parent_` info for bfs on graph `g` with key `search_key` based on Graph500 result
validation(http://graph500.org/?page_id=12#sec-8)
Return `1` for no error
"""
function validate(
  g::Graph{T},
  parent_::Vector{T},
  ij::Array{T,2},
  search_key::T
  ) where T<:Integer

    out = 1 # Default: no error.

    if parent_[search_key] != search_key
      # root must be the parent of itself
      out = 0
      return out
    end

    N = nv(g)
    slice = find(x->(x > zero(T)), parent_)

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
    neither_in = zeros(Bool, size(lij)[2])
    not_neither_in_or_both_in = zeros(Bool, size(lij)[2])
    for i in 1:size(lij)[2]
      if ij[1,i] != ij[2,i]
        neither_in[i] = (lij[1,i] == 0 && lij[2,i] == 0)
        not_neither_in_or_both_in[i] = !(neither_in[i] || (lij[1,i] > 0 && lij[2,i] > 0))
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
    level_difference = one(T);
    @simd for i in 1:size(ij)[2]
        # To prevent Unsigned integer overflows
        if(lij[1,i] > lij[2,i])
            respects_tree_level[i] = (lij[1,i] .- lij[2,i]) <= level_difference
        else
            respects_tree_level[i] = (lij[2,i] .- lij[1,i]) <= level_difference
        end

        not_neither_in_or_respects_tree_level[i] = !(neither_in[i] || respects_tree_level[i])
    end
    if any(not_neither_in_or_respects_tree_level)
      out = -5
      return out
    end

    return out
  end

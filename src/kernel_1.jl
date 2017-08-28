@doc_str """
    get_next_type(T)
Return a data with a Integer Datatype twice the size of `T`
"""
function get_next_type(T::DataType)
    (T== UInt8) && return  (UInt16,8)
    (T== UInt16) && return (UInt32,16)
    (T== UInt32) && return (UInt64,32)
    (T== UInt64) && return (UInt128,64)
end

@doc_str """
    kernel_1(ij)
Create Graph from edge list `ij` based on kernel_1 benchmark(http://graph500.org/?page_id=12#sec-4)
Return `LightGraphs.SimpleGraph` structure
"""
function kernel_1(
  ij::Matrix{T}
  ) where T<:Integer

  # Creating Graph
  nv = maximum(ij) # Number of vertices
  g = Graph{T}(nv) # Creating a graph with `nv` number of vertices
  T_upper, sftamt = get_next_type(T)
  v = Vector{T_upper}()
  vertex_degree = zeros(T_upper, nv)  # Edgefactor could not exceed 2^(SCALE)...Increase SCALE
  sizehint!(v, size(ij)[2]*2)
  ne = 0

  for i in 1:size(ij)[2]
    if(ij[1,i] != ij[2,i])
        push!(v,  (T_upper(ij[1,i]) << sftamt) + ij[2,i])
        push!(v,  (T_upper(ij[2,i]) << sftamt) + ij[1,i])
        vertex_degree[T_upper(ij[1,i])]+=1
        vertex_degree[T_upper(ij[2,i])]+=1
    end
  end

 sort!(v)

 for i in one(T):nv
      sizehint!(g.fadjlist[i], vertex_degree[i])
 end

 last_added = zero(Int128)
 for edge in v
     if(edge != last_added)
         push!(g.fadjlist[T(edge >> sftamt)], T(edge & typemax(T)))
         last_added = edge
         g.ne += 1
     end
 end

  g.ne /= 2
  return g
end

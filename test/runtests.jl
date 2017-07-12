using Graph500
using Base.Test

@testset begin
  include("kronecker_generator.jl")
  include("kernel_1.jl")
end

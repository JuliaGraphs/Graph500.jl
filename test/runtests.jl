using Graph500
using Base.Test

@testset begin
  include("kronecker_generator.jl")
  include("kernel_1.jl")
  include("kernel_2.jl")
  include("validation.jl")
  include("output.jl")
  include("driver.jl")
end

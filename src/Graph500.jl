__precompile__(true)
module Graph500

  # Dependencies
  using LightGraphs
  # using SimpleWeightedGraphs

  export
  # kronecker_generator
  kronecker_generator,

  # kernel_1
  kernel_1

  Graph500
  include("kronecker_generator.jl")
  include("kernel_1.jl")

end # module

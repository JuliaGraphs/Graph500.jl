__precompile__(true)
module Graph500

  # Dependencies
  using LightGraphs
  using SimpleWeightedGraphs
  using StatsBase

  export
  # kronecker_generator
  kronecker_generator,

  # kernel_1
  kernel_1,

  # kernel_2
  key_sampling, kernel_2,

  #kernel_3
  kernel_3

  Graph500
  include("kronecker_generator.jl")
  include("kernel_1.jl")
  include("kernel_2.jl")
  include("kernel_3.jl")

end # module

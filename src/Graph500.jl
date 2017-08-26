__precompile__(true)
module Graph500

  # Dependencies
  using LightGraphs
  using StatsBase
  using ProgressMeter
  import LightGraphs.sample

  export
  # kronecker_generator
  kronecker_generator,get_min_type,

  # kernel_1
  kernel_1, kernel_1_new,

  # kernel_2
  key_sampling, kernel_2,

  # bfs validation
  validate,

  # driver function
  driver,

  # print statistics
  output

  Graph500
  include("kronecker_generator.jl")
  include("kernel_1.jl")
  include("kernel_2.jl")
  include("validation.jl")
  include("driver.jl")
  include("output.jl")

end # module

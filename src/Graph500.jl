module Graph500

  # Dependencies
  using LightGraphs
  using StatsBase
  using ProgressMeter
  import LightGraphs.sample
  using Distributed: @everywhere, @spawnat, @distributed, nprocs, myid
  using Markdown: @doc_str
  using Random
  using Statistics: std


  export
  # kronecker_generator
  kronecker_generator,get_min_type,

  # kernel_1
  kernel_1, get_next_type,

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

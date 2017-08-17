@testset "kernel_2" begin
  using LightGraphs
  kg = kronecker_generator(10,2)
  g = kernel_1(kg)
  keys_ = @inferred key_sampling(g)
  @test length(keys_) <= 64
  kg = kronecker_generator(2,2)
  g = kernel_1(kg)
  keys_ = @inferred key_sampling(g)
  @test length(keys_) <= 64
  T = eltype(g)
  parent_  = @inferred  kernel_2(g,0x01)
  @test length(parent_) <= 2^2
end

@testset "kernel_2" begin
  kg = kronecker_generator(10,1)
  g = kernel_1(kg)
  keys_ = @inferred key_sampling(g)
  @test length(keys_) <= 64
  parent = @inferred kernel_2(g,1)
  @test length(parent) <= 2^10
end

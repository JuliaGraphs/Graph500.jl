@testset "kernel_2" begin
  kg = kronecker_generator(10,1)
  g = kernel_1(kg)
  keys_ = @inferred key_sampling(g)
  @test length(keys) <= 64
end

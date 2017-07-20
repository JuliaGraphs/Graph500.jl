@testset "kernel_3" begin
  kg = kronecker_generator(10,1)
  g = kernel_1(kg)
  parent,distance = @inferred kernel_3(g,1)
  @test length(parent) <= 2^10
end

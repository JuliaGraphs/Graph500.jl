@testset "kernel_1" begin
  using LightGraphs
  kg = kronecker_generator(2,1)
  g = @inferred kernel_1(kg)
  @test !is_directed(g)
  @test nv(g) == 4
  @test get_next_type(UInt64) == (UInt128,64) 
end

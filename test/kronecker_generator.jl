@testset "kronecker_generator" begin
  ij =  kronecker_generator(2,2)
  @test size(ij) == (2,8)
  ij1 = kronecker_generator(2,2;replicate=true,seed=[10,4,78,12,5,72])
  ij2 = kronecker_generator(2,2;replicate=true,seed=[10,4,78,12,5,72])
  @test ij1 == ij2
  @test get_min_type(4) == UInt8
  @test get_min_type(63) == UInt64
end

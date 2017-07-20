@testset "kronecker_generator" begin
  kg = @inferred kronecker_generator(2,2)
  @test size(kg.edge) == (2,8)
  @test length(kg.weight) == (8)

  kg1 = @inferred kronecker_generator(2,2;replicate=true,seed=[10,4,78,12,5,72])
  kg2 = @inferred kronecker_generator(2,2;replicate=true,seed=[10,4,78,12,5,72])
  @test kg1.edge == kg2.edge
  @test kg1.weight == kg2.weight
end

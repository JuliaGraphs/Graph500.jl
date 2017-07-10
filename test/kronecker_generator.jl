@testset "kronecker_generator" begin
  kg = @inferred kronecker_generator(2,2)
  @test size(kg.edge) == (2,8)
  @test length(kg.weight) == (8)
end

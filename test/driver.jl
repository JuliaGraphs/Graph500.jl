@testset "driver" begin
  using LightGraphs
  result = driver(4,2)
  for g in keys(result)
      @test nv(g) == 16
  end

  import Graph500.Graph500Results
  @test Graph500Results().SCALE == 0
end

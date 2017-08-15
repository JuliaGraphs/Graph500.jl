@testset "driver" begin
  using LightGraphs
  result = driver(4,2)
  for g in keys(result)
      @test nv(g) == 16
  end
end

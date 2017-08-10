@testset "driver" begin
  using LightGraphs
  @test nv(driver(4,2).g) == 16
end

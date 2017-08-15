@testset "output" begin
  using LightGraphs
  result = driver(4,2)
  for g in keys(result)
      @test output(result[g],nv(g),ne(g)) == 1
  end
end

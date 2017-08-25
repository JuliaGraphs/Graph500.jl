@testset "output" begin
  using LightGraphs
  result = driver(4,2)
  for g in keys(result)
      output(result[g],nv(g),ne(g))
  end
end

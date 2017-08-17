@testset "validations" begin
  using LightGraphs
  ij = kronecker_generator(2,2;replicate=true,seed=[10,4,78,12,5,72])
  g = kernel_1(ij)
  parent_ = kernel_2(g,0x01)

  # check that parent of search key is itself
  parent_[1] = 0x05
  @test validate(g,parent_,ij,0x01) == 0

  # check for cycle
  g = Graph(4)
  ij = [1 2 2 3; 2 3 4 4]
  parent_ = [1,4,3,2]
  @test validate(g,parent_,ij,1) == -3

  # check for connected component
  parent_ = [1,1,2,0]
  @test validate(g,parent_,ij,1) == -4

  # check for bfs levels
  parent_ = [1,1,4,2]
  @test validate(g,parent_,ij,1) == -5
end

@testset "validations" begin
  using LightGraphs
  ij = kronecker_generator(2,2;replicate=true,seed=[10,4,78,12,5,72])
  g = kernel_1(ij)
  parent_ = zeros(eltype(g),nv(g))
  kernel_2(g,0x01,parent_)
  parent_[1] = 0x05
  @test validate(g,parent_,ij,0x01) == 0
  parent_[1] = 0x01
  @test validate(g,parent_,ij,0x01) == 1
end

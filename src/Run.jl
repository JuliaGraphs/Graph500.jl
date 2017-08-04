function Graphtest()
  kg = kronecker_generator(16,4);
  g = @time kernel_1(kg);
  keys_ = key_sampling(g);
  @time @parallel for k in keys_
      kernel_2(g, k);
    end
end

function output(result::Graph500Results)

      # Benchmark info
      println("\n")
      println("Scale : ", result.SCALE)
      println("Number of vertices : ", ne(result.g))
      println("Number of Edges : ", nv(result.g))
      println("Number of Bfs : ", result.NBFS);

      # kernel 1 Construction time
      println("Graph Construction Time : ", result.kernel_1_time)
      println("\n")

      # bfs time statistics
      S = summarystats(result.kernel_2_time)
      println("BFS min time : ", S.min)
      println("BFS first quartile time : ", S.q25)
      println("BFS median time : ", S.median)
      println("BFS third quartile time : ", S.q75)
      println("BFS max time : ", S.max)
      println("BFS mean time : ", S.mean)
      println("BFS standard deviation time : ", std(result.kernel_2_time))
      println("\n")

      # bfs statistics based on number of edges
      S = summarystats(result.kernel_2_nedge)
      println("BFS min nedge : ", S.min)
      println("BFS first quartile nedge : ", S.q25)
      println("BFS median nedge : ", S.median)
      println("BFS third quartile nedge : ", S.q75)
      println("BFS max nedge : ", S.max)
      println("BFS mean nedge : ", S.mean)
      println("BFS standard deviation nedge : ", std(result.kernel_2_nedge))
      println("\n")


      # statistics on traversed edges per second
      K2TEPS = result.kernel_2_nedge ./ result.kernel_2_time
      K2N = length(K2TEPS)
      S = summarystats(K2TEPS)

      # TEPS : Traversed edges per second
      println("BFS min TEPS : ", S.min)
      println("BFS first quartile TEPS : ", S.q25)
      println("BFS median TEPS : ", S.median)
      println("BFS third quartile TEPS : ", S.q75)
      println("BFS max TEPS : ", S.max)


      # harmomnic mean of TEPS
      k2tmp = 1.0 ./ K2TEPS
      k2tmp = k2tmp - (1/harmmean(K2TEPS))
      harmonic_std = (sqrt(sum(k2tmp.^2)) / (K2N-1)) * harmmean(K2TEPS)^2

      println("BFS harmonic mean TEPS : ", harmmean(K2TEPS))
      println("BFS harmonic standard deviation TEPS : ", harmonic_std)

      return 1
  end

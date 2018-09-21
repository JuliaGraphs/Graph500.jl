doc"""
    output(result, nv, ne)

Print Graph500 Benchmark statistics(http://graph500.org/?page_id=12#sec-9_3)
"""
function output(result::Graph500Results,nv::Integer,ne::Integer)
    io = IOContext(stdout, :color=>true)
    printstyled(io, "\n", "Benchmark Info", "\n", color=:green)
    println("Scale : ", result.scale)
    println("Number of vertices : ", nv)
    println("Number of Edges : ", ne)
    println("Number of Bfs : ", result.nbfs, "\n")
    
    # kernel 1 Construction time
    printstyled(io, "\n", "Graph construction time", "\n", color=:green)
    println("Graph Construction Time : ", result.kernel_1_time, "\n")
    
    # bfs time statistics
    bfs_time_stats = summarystats(result.kernel_2_time)
    printstyled(io, "\n", "BFS time statistics", "\n", color=:green)
    println("BFS min time : ", bfs_time_stats.min)
    println("BFS first quartile time : ", bfs_time_stats.q25)
    println("BFS median time : ", bfs_time_stats.median)
    println("BFS third quartile time : ", bfs_time_stats.q75)
    println("BFS max time : ", bfs_time_stats.max)
    println("BFS mean time : ", bfs_time_stats.mean)
    println("BFS standard deviation time : ", std(result.kernel_2_time), "\n")
    
    # bfs statistics based on number of edges
    bfs_edgetraversed_stats = summarystats(result.kernel_2_nedge)
    printstyled(io, "\n", "Edges traversed per BFS statistics", "\n", color=:green)
    println("BFS min nedge : ", bfs_edgetraversed_stats.min)
    println("BFS first quartile nedge : ", bfs_edgetraversed_stats.q25)
    println("BFS median nedge : ", bfs_edgetraversed_stats.median)
    println("BFS third quartile nedge : ", bfs_edgetraversed_stats.q75)
    println("BFS max nedge : ", bfs_edgetraversed_stats.max)
    println("BFS mean nedge : ", bfs_edgetraversed_stats.mean)
    println("BFS standard deviation nedge : ", std(result.kernel_2_nedge), "\n")
    
    # statistics on traversed edges per second(teps)
    bfs_teps = result.kernel_2_nedge ./ result.kernel_2_time
    bfs_n = length(bfs_teps)
    teps_stats = summarystats(bfs_teps)
    printstyled(io, "\n", "Edges traversed per second statistics", "\n", color=:green)
    println("BFS min TEPS : ", teps_stats.min)
    println("BFS first quartile TEPS : ", teps_stats.q25)
    println("BFS median TEPS : ", teps_stats.median)
    println("BFS third quartile TEPS : ", teps_stats.q75)
    println("BFS max TEPS : ", teps_stats.max)
    
    # harmomnic mean of teps
    k2tmp = 1.0 ./ bfs_teps
    k2tmp = k2tmp .- (1/harmmean(bfs_teps))
    harmonic_std = (sqrt(sum(k2tmp.^2)) / (bfs_n-1)) * harmmean(bfs_teps)^2
    println("BFS harmonic mean TEPS : ", harmmean(bfs_teps))
    println("BFS harmonic standard deviation TEPS : ", harmonic_std, "\n")
end

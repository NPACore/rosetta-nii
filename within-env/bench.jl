using Statistics
using NIfTI
using BenchmarkTools
using Glob

struct bmk
    file :: String;
    time :: Float64;
end

"""
generalize
 niimean = @benchmark include("scripts/niimean.jl")

store file and mean run time in bmk struct
"""
function bmark(f)
   fn = basename(f);
   bm = @benchmark include($f); # $f to reach out of benchmark's scope

   # dump(niimean) # has params, times, memory
   time = mean(bm.times)/10e8;  # now in seconds
   #return Dict([("file",fn), ("time",time)])
   return bmk(fn,time)
end

jlscripts = glob("scripts/*jl");
bmarks = map(f-> bmark(f), jlscripts);

# write mirobenchmarks to file
cpu = read(`./cpu-info.pl`, String)[1:end-1]
fout="out/$cpu/julia-bench.csv"
f = open(fout, "w")
for b in bmarks
    write(f, "$(b.file),$(b.time)\n")
end
close(f)

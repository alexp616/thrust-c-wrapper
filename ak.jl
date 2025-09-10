using BenchmarkTools, AcceleratedKernels, CUDA

ak_sort!(v, temp) = (AcceleratedKernels.sort!(v, temp=temp, block_size=256); synchronize())

for i in 4:8
display(@benchmark ak_sort!(v, temp) setup = begin
  v = CUDA.rand(Int64, 10^$(i))
  temp = similar(v)
end)
end
using CUDA
using BenchmarkTools

WRAPPED_TYPES = Union{UInt32, UInt64, Int32, Int64, Float32, Float64}

function thrust_sort!(arr::CuVector{T}) where T<:WRAPPED_TYPES
    ptr = pointer(arr)
    n = UInt64(length(arr))
    eval(Meta.parse(
        "ccall((:thrust_sort_$T, \"./libthrustwrapper.so\"), Cvoid, (CuPtr{$T}, UInt64), $ptr, $n)"
    ))
end

function bench() 
    for i in 4:8
        display(@benchmark (CUDA.@sync thrust_sort!(arr)) setup=(arr=CUDA.rand(Int64, 10^$(i))))
    end
end

bench()
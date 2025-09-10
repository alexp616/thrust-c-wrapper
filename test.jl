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

function thrust_sort_by_key!(keys::CuVector{T}, values::CuVector{V}) where {T<:WRAPPED_TYPES, V<:WRAPPED_TYPES}
    kptr = pointer(keys)
    vptr = pointer(values)
    n = UInt64(length(keys))

    if length(values) != n
        throw(DimensionMismatch("keys and values must be the the same length"))
    end
    eval(Meta.parse(
        "ccall((:thrust_sort_by_key_$T_$V, \"./libthrustwrapper.so\"), Cvoid, (CuPtr{$T}, CuPtr{$V}, UInt64), $kptr, $vptr, $n)"
    ))
end

function thrust_merge!(arr1::CuVector{T}, arr2::CuVector{T}, output::CuVector{T}) where T<:WRAPPED_TYPES
    ptr1 = pointer(arr1)
    ptr2 = pointer(arr2)
    optr = pointer(output)
    n1 = UInt64(length(arr1))
    n2 = UInt64(length(arr2))

    if length(output) != n1 + n2
        throw(DimensionMismatch("Sum of lengths of two input arrays must be equal to length of output"))
    end
    eval(Meta.parse(
        "ccall((:thrust_merge_$T, \"./libthrustwrapper.so\"), Cvoid, (CuPtr{$T}, UInt64, CuPtr{$T}, UInt64, CuPtr{$T}), $ptr1, $n1, $ptr2, $n2, $optr)"
    ))
end

function thrust_merge_by_key!(keys1::CuVector{T}, keys2::CuVector{T}, values1::CuVector{V}, values2::CuVector{V}, outputkeys::CuVector{T}, outputvalues::CuVector{V}) where {T<:WRAPPED_TYPES, V<:WRAPPED_TYPES}
    kptr1 = pointer(keys1)
    kptr2 = pointer(keys2)
    vptr1 = pointer(values1)
    vptr2 = pointer(values2)
    kptro = pointer(outputkeys)
    vptro = pointer(outputvalues)
    n1 = UInt64(length(keys1))
    n2 = UInt64(length(keys2))
    if (
        n1 + n2 != length(outputkeys) ||
        length(outputkeys) != length(outputvalues) ||
        length(values1) != n1 || length(values2) != n2
    )
        throw(DimensionMismatch())
    end

    eval(Meta.parse(
        "ccall((:thrust_merge_by_key_$(T)_$(V), \"./libthrustwrapper.so\"), Cvoid, (CuPtr{$T}, UInt64, CuPtr{$T}, UInt64, CuPtr{$V}, CuPtr{$V}, CuPtr{$T}, CuPtr{$V}), $kptr1, $n1, $kptr2, $n2, $vptr1, $vptr2, $kptro, $vptro)"
    ))
end

function thrust_reduce_by_key!(keys::CuVector{T}, values::CuVector{V}, outputkeys::CuVector{T}, outputvalues::CuVector{V}) where {T<:WRAPPED_TYPES, V<:WRAPPED_TYPES}
    kptr = pointer(keys)
    vptr = pointer(values)
    kptro = pointer(outputkeys)
    vptro = pointer(outputvalues)
    n = length(keys)
    if n != length(values)
        throw(DimensionMismatch("keys and values must be the same length"))
    end
    return eval(Meta.parse(
        "ccall((:thrust_reduce_by_key_$(T)_$(V), \"./libthrustwrapper.so\"), UInt64, (CuPtr{$T}, UInt64, CuPtr{$T}, CuPtr{$V}, CuPtr{$V}), $kptr, $n, $vptr, $kptro, $vptro)"
    ))
end

function main() 
    arr1 = CuArray([4, 5, 5, 7, 8, 9])
    arr2 = CuArray(Float32.([3, 6, 7, 3, 3, 4]))
    arr5 = CUDA.zeros(Int64, 6)
    arr6 = CUDA.zeros(Float32, 6)
    println(thrust_reduce_by_key!(arr1, arr2, arr5, arr6))
    display(arr5)
    display(arr6)
end
function bench() 
    display(@benchmark (CUDA.@sync thrust_sort!(arr)) setup=(arr=CUDA.rand(Float32, 10^8)))
    display(@benchmark (CUDA.@sync sort!(arr)) setup=(arr=CUDA.rand(Float32, 10^8)))
    display(@benchmark (sort!(arr)) setup=(arr=rand(Float32, 10^8)))
    # thrust_sort!(arr)
    # display(arr)
end

main()
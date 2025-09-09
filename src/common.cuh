#include <cstdint>

typedef uint32_t UInt32;
typedef uint64_t UInt64;
typedef int32_t Int32;
typedef int64_t Int64;
typedef float Float32;
typedef float Float64;

#define DEF(F) \
F(UInt32) \
F(UInt64) \
F(Int32) \
F(Int64) \
F(Float32) \
F(Float64)

#define DEF2(F) \
DEF2_HELPER(F, UInt32) \
DEF2_HELPER(F, UInt64) \
DEF2_HELPER(F, Int32) \
DEF2_HELPER(F, Int64) \
DEF2_HELPER(F, Float32) \
DEF2_HELPER(F, Float64)

#define DEF2_HELPER(F, T) \
F(UInt32, T) \
F(UInt64, T) \
F(Int32, T) \
F(Int64, T) \
F(Float32, T) \
F(Float64, T)

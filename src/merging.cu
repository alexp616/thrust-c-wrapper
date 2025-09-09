#include <thrust/device_vector.h>
#include <thrust/merge.h>
#include "common.cuh"

#define MERGE(T) \
void thrust_merge_##T(T* arr1, size_t n1, T* arr2, size_t n2, T* result) { \
    thrust::device_ptr<T> p1(arr1); \
    thrust::device_ptr<T> p2(arr2); \
    thrust::device_ptr<T> r(result); \
    thrust::merge(p1, p1 + n1, p2, p2 + n2, r); \
}

#define MERGE_BY_KEY(T, V) \
void thrust_merge_by_key_##T##_##V(T* keys1, size_t n1, T* keys2, size_t n2, V* values1, V* values2, T* keys_result, V* values_result) { \
    thrust::device_ptr<T> k1(keys1); \
    thrust::device_ptr<T> k2(keys2); \
    thrust::device_ptr<V> v1(values1); \
    thrust::device_ptr<V> v2(values2); \
    thrust::device_ptr<T> rk(keys_result); \
    thrust::device_ptr<V> rv(values_result); \
    thrust::merge_by_key(k1, k1 + n1, k2, k2 + n2, v1, v2, rk, rv); \
}

extern "C" {
DEF(MERGE)
DEF2(MERGE_BY_KEY)
}
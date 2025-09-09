#include <thrust/device_vector.h>
#include <thrust/reduce.h>
#include "common.cuh"

#define REDUCE_BY_KEY(T, V) \
size_t thrust_reduce_by_key_##T##_##V(T* keys, size_t n1, V* values, T* keys_output, V* values_output) { \
    thrust::device_ptr<T> pk(keys); \
    thrust::device_ptr<V> pv(values); \
    thrust::device_ptr<T> ok(keys_output); \
    thrust::device_ptr<V> vk(values_output); \
    thrust::pair<thrust::device_ptr<T>, thrust::device_ptr<V>> new_end = thrust::reduce_by_key(pk, pk + n1, pv, ok, vk); \
    return new_end.first - ok; \
}

extern "C" {
DEF2(REDUCE_BY_KEY)
}
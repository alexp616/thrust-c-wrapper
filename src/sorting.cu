#include <thrust/device_vector.h>
#include <thrust/sort.h>
#include "common.cuh"

#define SORT(T) \
void thrust_sort_##T(T* data, size_t n) { \
    thrust::device_ptr<T> p(data); \
    thrust::sort(p, p + n); \
}

#define SORT_BY_KEY(T, V) \
void thrust_sort_by_key_##T##_##V(T* keys, V* values, size_t n) { \
    thrust::device_ptr<T> p1(keys); \
    thrust::device_ptr<V> p2(values); \
    thrust::sort_by_key(p1, p1 + n, p2); \
}

#define STABLE_SORT(T) \
void thrust_stable_sort_##T(T* data, size_t n) { \
    thrust::device_ptr<T> p(data); \
    thrust::stable_sort(p, p + n); \
}

#define STABLE_SORT_BY_KEY(T, V) \
void thrust_stable_sort_by_key_##T##_##V(T* keys, V* values, size_t n) { \
    thrust::device_ptr<T> p1(keys); \
    thrust::device_ptr<V> p2(values); \
    thrust::stable_sort_by_key(p1, p1 + n, p2); \
}

extern "C" {
DEF(SORT)
DEF2(SORT_BY_KEY)
// These have no point existing right now, since we only have 6 defined  
// types, none of which are affected by stable sort
// DEF(STABLE_SORT)
// DEF2(STABLE_SORT_BY_KEY)
}
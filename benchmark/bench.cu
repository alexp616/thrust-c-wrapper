#include <nvbench/nvbench.cuh>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/sort.h>
#include <thrust/random.h>
#include <thrust/copy.h>
#include <cstdint>

void fill_random(thrust::device_vector<int64_t>& vec)
{
    thrust::default_random_engine rng(12345);
    thrust::uniform_int_distribution<int64_t> dist(INT64_MIN, INT64_MAX);

    thrust::host_vector<int64_t> h_vec(vec.size());
    for (auto& val : h_vec)
    {
        val = dist(rng);
    }

    thrust::copy(h_vec.begin(), h_vec.end(), vec.begin());
}

void radix_sort_int64_benchmark(nvbench::state& state)
{
    const std::size_t size = state.get_int64("N");

    thrust::device_vector<int64_t> d_vec(size);
    fill_random(d_vec);

    state.exec(nvbench::exec_tag::sync, [&](nvbench::launch& launch) {
        thrust::device_vector<int64_t> temp = d_vec;

        thrust::sort(thrust::cuda::par.on(launch.get_stream()), 
             temp.begin(), temp.end());
    });
}

template<typename T>
struct less : public thrust::binary_function<T,T,bool>
{
  __host__ __device__ bool operator()(const T &lhs, const T &rhs) const {
     return lhs < rhs;
  }
}; 

void merge_sort_int64_benchmark(nvbench::state& state)
{
    const std::size_t size = state.get_int64("N");

    thrust::device_vector<int64_t> d_vec(size);
    fill_random(d_vec);

    state.exec(nvbench::exec_tag::sync, [&](nvbench::launch& launch) {
        thrust::device_vector<int64_t> temp = d_vec;

        thrust::sort(thrust::cuda::par.on(launch.get_stream()), 
             temp.begin(), temp.end(), 
             less<int64_t>());
    });
}

NVBENCH_BENCH(radix_sort_int64_benchmark)
    .add_int64_axis("N", {10'000, 100'000, 1'000'000, 10'000'000, 100'000'000});

NVBENCH_BENCH(merge_sort_int64_benchmark)
    .add_int64_axis("N", {10'000, 100'000, 1'000'000, 10'000'000, 100'000'000});
# thrust-c-wrapper
~~Simple C wrapper of most common types for important thrust functions not implemented (or not optimized) in CUDA.jl.~~

Repo containing benchmarks for sorting

For pure thrust:
```bash
$ cd benchmark
$ cmake . -B./build
$ cmake --build ./build/ --parallel
$ ./build/bench_thrust_sort
```

For wrapped thrust:
```bash
$ cd <root of this repo>
$ cmake . -B./build
$ cmake --build ./build/ --parallel
$ mv build/libthrustwrapper.so libthrustwrapper.so
$ julia bench.jl
```

For acceleratedkernels:
```bash
$ cd <root of this repo>
$ julia ak.jl
```
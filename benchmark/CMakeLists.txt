cmake_minimum_required(VERSION 3.26)
project(efefef LANGUAGES C CXX CUDA)

# set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${BINARY_LOCATION})

set(CMAKE_CUDA_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(CUDAToolkit REQUIRED)
if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
    set(CMAKE_CUDA_ARCHITECTURES 75)
endif()

# set(RUNTIME_DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)
# set(LIBRARY_DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
# set(ARCHIVE_DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
# set(INCLUDES_DESTINATION ${CMAKE_INSTALL_PREFIX}/include)

include(FetchContent)
FetchContent_Declare(
  nvbench
  GIT_REPOSITORY https://github.com/NVIDIA/nvbench.git
  GIT_TAG        2d9eafc7654c1d00ab7a14d5e5bd659f6fea0c69
  GIT_SHALLOW    OFF          
)
FetchContent_MakeAvailable(nvbench)

include(FetchContent)
FetchContent_Declare(
  thrust
  GIT_REPOSITORY https://github.com/NVIDIA/thrust.git
  GIT_TAG master 
)
FetchContent_MakeAvailable(thrust)

set(EXECUTABLES
    bench_thrust_sort bench.cu
)

function(add_benchmark exe source)
    add_executable(${exe} ${source})
    target_link_libraries(${exe} PUBLIC CUDA::cudart nvbench::main)
    set_target_properties(${exe} 
        PROPERTIES
        CUDA_SEPARABLE_COMPILATION OFF
        POSITION_INDEPENDENT_CODE ON
        CUDA_RUNTIME_LIBRARY Static
        CUDA_ARCHITECTURES ${CMAKE_CUDA_ARCHITECTURES}
    )
endfunction()

list(LENGTH EXECUTABLES EXECUTABLES_LENGTH)
math(EXPR EXECUTABLES_COUNT "${EXECUTABLES_LENGTH} / 2")
math(EXPR EXECUTABLES_COUNT_LOOP "${EXECUTABLES_COUNT} - 1")

foreach(i RANGE 0 ${EXECUTABLES_COUNT_LOOP})
    math(EXPR index1 "${i} * 2")
    math(EXPR index2 "${i} * 2 + 1")
    list(GET EXECUTABLES ${index1} exe)
    list(GET EXECUTABLES ${index2} source)
    add_benchmark(${exe} ${source})
endforeach()
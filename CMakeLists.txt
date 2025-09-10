cmake_minimum_required(VERSION 3.18)
project(ThrustWrapper LANGUAGES CXX CUDA)

find_package(CUDAToolkit REQUIRED)

file(GLOB SRC_FILES CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cu")

add_library(thrustwrapper SHARED ${SRC_FILES})

target_include_directories(thrustwrapper
  PUBLIC
    ${CUDAToolkit_INCLUDE_DIRS}
)

target_link_libraries(thrustwrapper
  PUBLIC
    CUDA::cudart  
)

set_target_properties(thrustwrapper PROPERTIES
  CUDA_SEPARABLE_COMPILATION ON
  POSITION_INDEPENDENT_CODE ON
)
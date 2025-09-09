BUILD_FLAGS = -O3 -Xcompiler="-fpic"
SRC_FILES = src/sorting.cu src/merging.cu src/reductions.cu
OBJ_FILES = build/sorting.o build/merging.o build/reductions.o

main: $(OBJ_FILES)
	nvcc -shared -o libthrustwrapper.so $(OBJ_FILES)

build/sorting.o: src/sorting.cu
	nvcc $(BUILD_FLAGS) -c $< -o $@

build/merging.o: src/merging.cu
	nvcc $(BUILD_FLAGS) -c $< -o $@

build/reductions.o: src/reductions.cu
	nvcc $(BUILD_FLAGS) -c $< -o $@

clean:
	rm build/*
	rm libthrustwrapper.so
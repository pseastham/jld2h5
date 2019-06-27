# Purpose

The `jld2h5` Julia function is designed to convert data in the `jld` format into the `hdf5` format. The `hdf5` format is more general and allows data to be used by other programs and languages, e.g. Matlab.

The `jld` format is described [here](https://github.com/JuliaIO/JLD.jl), and the `hdf5` format is describerd [here](https://www.hdfgroup.org/solutions/hdf5/). 

# Usage

To use this function:

1. export data generated in Julia in the jld format
2. run `jld2h5()` on `jld` file
3. load new `h5` file into program of your choice

# Requirements

This function requires the [`JLD`](https://github.com/JuliaIO/JLD.jl) and [`HDF5`](https://github.com/JuliaIO/HDF5.jl) Julia packages.

# Special Cases

Julia allows certain types that are not represented in the `hdf5` format. Two examples that `jld2h5` is designed to handle automatically are the `StepRangeLen{Float64}` and `Vector{Vector{Float64}}` types, which are converted into vectors and matrices, respectively. 

# Contact Info 

If you notice any bugs, or would like more features, feel free to email me. More Julia code that I've written can be found [here](https://www.math.fsu.edu/~peastham/scripts/code.html).

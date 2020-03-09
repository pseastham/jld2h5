# test file to generate and convert jld2 data into hdf5

using JLD2, HDF5

include("../src/jld2h5.jl")

function run_test()
    datafn = "data.jld2"

    # =====================================
    # Generate data and save in *.jld2 file
    # =====================================
    arr1 = rand(7)
    arr2 = range(0.0,stop=1.0,length=4)
    mat1 = rand(3,3)
    f1   = rand()

    save(datafn,
            "arr1",arr1,
            "arr2",arr2,
            "mat1",mat1,
            "f1",f1)

    # ================================================
    # log values to be able to verify matlab has same
    # ================================================
    logfn = "julia_data_verify.log"
    f = open(logfn,"w")
    println(f,"arr1:")
    println(f,arr1)
    println(f)
    println(f,"arr2:")
    println(f,arr2)
    println(f)
    println(f,"mat1:")
    Base.print_matrix(f,mat1)
    println(f)
    println(f)
    println(f,"f1: ",f1)

    close(f)

    # ==============================================
    # load back same jld2 data (verification of JLD2)
    # ==============================================
    arr1TEST = load(datafn,"arr1")
    arr2TEST = load(datafn,"arr2")
    mat1TEST = load(datafn,"mat1")
    f1TEST   = load(datafn,"f1")

    checkBOOL = false
    if (arr1 != arr1TEST) ||
       (arr2 != arr2TEST) ||
       (mat1 != mat1TEST) ||
       (f1   != f1TEST)  
        error("JLD2 save failed to preserve accuracy")
    end

    # =========================
    # Convert jld file to hdf5
    # =========================
    jld2h5(datafn)

    nothing
end

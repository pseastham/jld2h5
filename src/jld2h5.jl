# Function for converting jld file to h5 file, specifically 
#   tested to be opened in Matlab

using HDF5, JLD

function jld2h5(filename::String)   
    # add check that extension is jld
    Nchar = length(filename)
    fileBase = filename[1:Nchar-4]
    if filename[Nchar-3:Nchar] != ".jld"
        error("input file was not *.jld")
    end

    # load jld file into dictionary
    d = load(filename)

    # save dictionary d into h5 format
    h5filename = string(fileBase,".h5")
    fid = h5open(h5filename, "w")
    for k in keys(d)
        # check for StepRangeLen
        if typeof(d[k]) == StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
            println("StepRangeLen converted to Vector")
            d[k] = collect(d[k])
        end
        # check for array of arrays
        if typeof(d[k]) == Array{Array{Float64,1},1}
            n1 = length(d[k])
            n2 = length(d[k][1])
            newArr = zeros(Float64,n1,n2)
            for i=1:n1, j=1:n2
                newArr[i,j] = d[k][i][j]
            end
            println("Array of Array converted to matrix")
            d[k] = newArr
        end
        write(fid, string(k), d[k])
    end
    close(fid)

    nothing
end
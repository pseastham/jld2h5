using HDF5, JLD2

function jld2h5(JLDfileName::String)
    checkExtensionIsJLD(JLDfileName)

    dict = load(JLDfileName)
    h5IO = createIOStreamForH5(JLDfileName)
    writeJLDDataToH5(h5IO,dict)
    close(h5IO)

    nothing
end

function checkExtensionIsJLD(fileName::String)
    nCharsInFile = length(fileName)
    fileExtension = fileName[nCharsInFile-4 : nCharsInFile]
    if fileExtension != ".jld2"
        error("input extension was '$(fileExtension)', not '.jld2'")
    end
end

function getFileBase(fileName::String)
    nCharsInFile = length(fileName)
    fileBase = fileName[1 : nCharsInFile-5]
    return fileBase
end

function createIOStreamForH5(fileName::String)
    fileBase = getFileBase(fileName)
    h5FileName = string(fileBase,".h5")
    h5IO = h5open(h5FileName, "w")
    return h5IO
end

function writeJLDDataToH5(h5IO,dict)
    for key in keys(dict)
        checkAndModifyDataIfSpecialCase(dict,key)
        write(h5IO, string(key), dict[key])
    end
end

function valueIsStepRangeLen(value)
    if typeof(value) == StepRangeLen{Float64,Base.TwicePrecision{Float64},Base.TwicePrecision{Float64}}
        return true
    else
        return false
    end
end

function modifyForStepRangeLen!(dict,key)
    println("StepRangeLen converted to Vector")
    dict[key] = collect(dict[key])
    nothing
end

function valueIsArrayOfArrays(value)
    if typeof(value) == Array{Array{Float64,1},1}
        return true
    else
        return false
    end
end

function modifyForArrayOfArrays!(dict,key)
    n1 = length(dict[key])
    n2 = length(dict[key][1])
    newArr = zeros(Float64,n1,n2)
    for i=1:n1, j=1:n2
        newArr[i,j] = dict[key][i][j]
    end
    println("Array of Array converted to matrix")
    dict[key] = newArr
    nothing
end

function checkAndModifyDataIfSpecialCase(dict,key)
    if valueIsStepRangeLen(dict[key])
        modifyForStepRangeLen!(dict,key)
    elseif valueIsArrayOfArrays(dict[key])
        modifyForArrayOfArrays!(dict,key)
    end
    nothing
end
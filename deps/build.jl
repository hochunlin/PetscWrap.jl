# This file has been copied (and slightly modified) from GridapPETSC.jl
using Libdl
include(joinpath(@__DIR__, "..", "src", "const_arch_ind.jl"))

@static if haskey(ENV, "PETSC_ARCH") && !isempty(rstrip(ENV["PETSC_ARCH"]))
    petsc_dir = joinpath(ENV["PETSC_DIR"], ENV["PETSC_ARCH"])
    @info """ Non-empty PETSC_ARCH environment variable found.
    Trying to use the PETSc installation it points to.
    PETSc dir = $(petsc_dir)
    """
    libpetsc_found = true
    libpetsc_provider = "USER_PETSC_LIBRARY"

    # Define default paths
    libpetsc_lib_path = joinpath(petsc_dir, "lib")

    # Check libpetsc_lib_path (.../libpetsc.so or .../libpetsc_real.so file) exists
    if isfile(joinpath(libpetsc_lib_path, "libpetsc.so"))
        libpetsc_path = joinpath(libpetsc_lib_path, "libpetsc.so")
    elseif isfile(joinpath(libpetsc_lib_path, "libpetsc_real.so"))
        libpetsc_path = joinpath(libpetsc_lib_path, "libpetsc_real.so")
    elseif isfile(joinpath(libpetsc_lib_path, "libpetsc_complex.so"))
        libpetsc_path = joinpath(libpetsc_lib_path, "libpetsc_complex.so")
    end

else
    @info """ No user installation of PETSc found.
    Trying to use the PETSc installation provided by PETSc_jll.
    """
    using PETSc_jll
    libpetsc_found = true
    libpetsc_provider = "PETSc_jll"
    libpetsc_path = PETSc_jll.libpetsc_Float64_Complex_Int64_path
end

const libpetsc = libpetsc_path

"""
    Retrieve a PETSc datatype from a String
"""
function DataTypeFromString(name::AbstractString)
    dtype_ref = Ref{PetscDataType}()
    found_ref = Ref{PetscBool}()
    ccall(
        (:PetscDataTypeFromString, libpetsc),
        PetscErrorCode,
        (Cstring, Ptr{PetscDataType}, Ptr{PetscBool}),
        name,
        dtype_ref,
        found_ref,
    )
    @assert found_ref[] == PETSC_TRUE
    return dtype_ref[]
end

"""
    Retrieve a PETSc datatype from a PETSc datatype
"""
function PetscDataTypeGetSize(dtype::PetscDataType)
    datasize_ref = Ref{Csize_t}()
    ccall(
        (:PetscDataTypeGetSize, libpetsc),
        PetscErrorCode,
        (PetscDataType, Ptr{Csize_t}),
        dtype,
        datasize_ref,
    )
    return datasize_ref[]
end

"""
    Find the Julia type for `PetscReal`
"""
function PetscReal2Type()
    PETSC_REAL = DataTypeFromString("Real")
    result =
        PETSC_REAL == PETSC_DOUBLE ? Cdouble :
        PETSC_REAL == PETSC_FLOAT ? Cfloat :
        error("PETSC_REAL = $PETSC_REAL not supported.")
    return result
end

"""
    Find the Julia type for PetscScalar. This function must be called after
    the line `const PetscReal = PetscReal2Type` since it uses `PetscReal`.
"""
function PetscScalar2Type()
    PETSC_REAL = DataTypeFromString("Real")
    PETSC_SCALAR = DataTypeFromString("Scalar")
    result =
        PETSC_SCALAR == PETSC_REAL ? PetscReal :
        PETSC_SCALAR == PETSC_COMPLEX ? Complex{PetscReal} :
        error("PETSC_SCALAR = $PETSC_SCALAR not supported.")
    return result
end

"""
    Find the Julia type for `PetscInt`
"""
function PetscInt2Type()
    PETSC_INT_SIZE = PetscDataTypeGetSize(PETSC_INT)
    result =
        PETSC_INT_SIZE == 4 ? Int32 :
        PETSC_INT_SIZE == 8 ? Int64 :
        error("PETSC_INT_SIZE = $PETSC_INT_SIZE not supported.")
    return result
end

PetscReal = PetscReal2Type()
PetscScalar = PetscScalar2Type()
PetscInt = PetscInt2Type()

@info """
PETSc configuration summary:
libpetsc_provider = $(libpetsc_provider)
libpetsc_path     = $(libpetsc)
PetscReal         = $(PetscReal)
PetscScalar       = $(PetscScalar)
PetscInt          = $(PetscInt)
"""
open(joinpath(@__DIR__, "deps.jl"), "w") do f
    println(f, "# This file is automatically generated at build-time.")
    println(f, "# Do not edit")
    println(f)
    println(f, :(const libpetsc_found = $(libpetsc_found)))
    println(f, :(const libpetsc_provider = $(libpetsc_provider)))
    println(f, :(const _libpetsc_path = $(libpetsc)))
    println(f)
    println(f, :("\"\"\""))
    println(f, "Julia alias for `PetscReal` C type.\n")
    println(
        f,
        "See [PETSc manual](https://www.mcs.anl.gov/petsc/petsc-current/docs/manualpages/Sys/PetscReal.html).",
    )
    println(f, :("\"\"\""))
    println(f, :(const PetscReal = $(PetscReal)))
    println(f)
    println(f, :("\"\"\""))
    println(f, "Julia alias for `PetscScalar` C type.\n")
    println(
        f,
        "See [PETSc manual](https://www.mcs.anl.gov/petsc/petsc-current/docs/manualpages/Sys/PetscScalar.html).",
    )
    println(f, :("\"\"\""))
    println(f, :(const PetscScalar = $(PetscScalar)))
    println(f)
    println(f, :("\"\"\""))
    println(f, "Julia alias for `PetscInt` C type.\n")
    println(
        f,
        "See [PETSc manual](https://www.mcs.anl.gov/petsc/petsc-current/docs/manualpages/Sys/PetscInt.html).",
    )
    println(f, :("\"\"\""))
    println(f, :(const PetscInt = $(PetscInt)))
    println(f)
    println(f, :(const PetscIntOne = PetscInt(1)))
end

# define common PETSc constants, independant from PETSC_ARCH
# -> directly copied from https://github.com/JuliaParallel/PETSc.jl.git

const PetscErrorCode = Cint

const PETSC_DEFAULT = -2
const PETSC_DECIDE  = -1

"""
    Macro to automatically export all items of an enum
"""
macro exported_enum(name, args...)
    esc(quote
        @enum($name, $(args...))
        export $name
        $([:(export $arg) for arg in args]...)
        end)
end


@enum PetscBool PETSC_FALSE PETSC_TRUE

@enum PetscDataType begin
    PETSC_DATATYPE_UNKNOWN  = 0
    PETSC_DOUBLE            = 1
    PETSC_COMPLEX           = 2
    PETSC_LONG              = 3
    PETSC_SHORT             = 4
    PETSC_FLOAT             = 5
    PETSC_CHAR              = 6
    PETSC_BIT_LOGICAL       = 7
    PETSC_ENUM              = 8
    PETSC_BOOL              = 9
    PETSC_FLOAT128          = 10
    PETSC_OBJECT            = 11
    PETSC_FUNCTION          = 12
    PETSC_STRING            = 13
    PETSC___FP16            = 14
    PETSC_STRUCT            = 15
    PETSC_INT               = 16
    PETSC_INT64             = 17
end

const Petsc64bitInt  = Int64
const PetscLogDouble = Cdouble

@enum InsertMode begin
    NOT_SET_VALUE
    INSERT_VALUES
    ADD_VALUES
    MAX_VALUES
    MIN_VALUES
    INSERT_ALL_VALUES
    ADD_ALL_VALUES
    INSERT_BC_VALUES
    ADD_BC_VALUES
end

@enum NormType begin
    NORM_1 = 0
    NORM_2 = 1
    NORM_FROBENIUS = 2
    NORM_INFINITY = 3
    NORM_1_AND_2 = 4
end

@enum MatAssemblyType begin
    MAT_FLUSH_ASSEMBLY = 1
    MAT_FINAL_ASSEMBLY = 0
end

@enum MatFactorType begin
    MAT_FACTOR_NONE     = 0
    MAT_FACTOR_LU       = 1
    MAT_FACTOR_CHOLESKY = 2
    MAT_FACTOR_ILU      = 3
    MAT_FACTOR_ICC      = 4
    MAT_FACTOR_ILUDT    = 5
end

@enum PetscViewerFormat begin
    PETSC_VIEWER_DEFAULT
    PETSC_VIEWER_ASCII_MATLAB
    PETSC_VIEWER_ASCII_MATHEMATICA
    PETSC_VIEWER_ASCII_IMPL
    PETSC_VIEWER_ASCII_INFO
    PETSC_VIEWER_ASCII_INFO_DETAIL
    PETSC_VIEWER_ASCII_COMMON
    PETSC_VIEWER_ASCII_SYMMODU
    PETSC_VIEWER_ASCII_INDEX
    PETSC_VIEWER_ASCII_DENSE
    PETSC_VIEWER_ASCII_MATRIXMARKET
    PETSC_VIEWER_ASCII_VTK
    PETSC_VIEWER_ASCII_VTK_CELL
    PETSC_VIEWER_ASCII_VTK_COORDS
    PETSC_VIEWER_ASCII_PCICE
    PETSC_VIEWER_ASCII_PYTHON
    PETSC_VIEWER_ASCII_FACTOR_INFO
    PETSC_VIEWER_ASCII_LATEX
    PETSC_VIEWER_ASCII_XML
    PETSC_VIEWER_ASCII_GLVIS
    PETSC_VIEWER_ASCII_CSV
    PETSC_VIEWER_DRAW_BASIC
    PETSC_VIEWER_DRAW_LG
    PETSC_VIEWER_DRAW_LG_XRANGE
    PETSC_VIEWER_DRAW_CONTOUR
    PETSC_VIEWER_DRAW_PORTS
    PETSC_VIEWER_VTK_VTS
    PETSC_VIEWER_VTK_VTR
    PETSC_VIEWER_VTK_VTU
    PETSC_VIEWER_BINARY_MATLAB
    PETSC_VIEWER_NATIVE
    PETSC_VIEWER_HDF5_PETSC
    PETSC_VIEWER_HDF5_VIZ
    PETSC_VIEWER_HDF5_XDMF
    PETSC_VIEWER_HDF5_MAT
    PETSC_VIEWER_NOFORMAT
    PETSC_VIEWER_LOAD_BALANCE
end

@enum MatOperation begin
    MATOP_SET_VALUES=0
    MATOP_GET_ROW=1
    MATOP_RESTORE_ROW=2
    MATOP_MULT=3
    MATOP_MULT_ADD=4
    MATOP_MULT_TRANSPOSE=5
    MATOP_MULT_TRANSPOSE_ADD=6
    MATOP_SOLVE=7
    MATOP_SOLVE_ADD=8
    MATOP_SOLVE_TRANSPOSE=9
    MATOP_SOLVE_TRANSPOSE_ADD=10
end
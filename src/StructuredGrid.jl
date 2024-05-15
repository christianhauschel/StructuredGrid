module StructuredGrid

include("grid.jl")
export Grid, _check_vector_grid, _check_scalar_grid, get_ni, get_nj, get_nk, get_val

include("surface.jl")
export midpoints_facial, normals_facial, normals_nodal

end
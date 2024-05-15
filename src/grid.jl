
"""
    Grid

A structured grid representing a scalar or vector field. Alias for `Array{Float64,4}`.

The first dimension is spacial dimension, which must be 1 (scalar field) or 3 (vector field). 
The second, third, and fourth dimensions are the number of points in the i-th, j-th, 
and k-th directions, respectively. 

The scalars/vectors are stored in the first dimension. 


**Example:**
`grid[:, i, j, k]` is the scalar/vector at `(i, j, k)`.

"""
const Grid = Array{Float64,4}


function get_ni(grid::Grid)
    return size(grid)[2]
end

function get_nj(grid::Grid)
    return size(grid)[3]
end

function get_nk(grid::Grid)
    return size(grid)[4]
end

"""
    get_val(grid::Grid, i::Int, j::Int, k::Int)
"""
function get_val(grid::Grid, i::Int, j::Int, k::Int)

    if i > get_ni(grid)
        error("i is out of bounds.")
    end
    if j > get_nj(grid)
        error("j is out of bounds.")
    end
    if k > get_nk(grid)
        error("k is out of bounds.")
    end


    return grid[:, i, j, k]
end


function _check_vector_grid(grid::Grid)
    dims = size(grid)
    if dims[1] != 3
        error("The first dimension must be 3.")
    end

    if dims[2] < 1 || dims[3] < 1 || dims[4] < 1
        error("Grid must have at least one element in each dimension.")
    end
end

function _check_scalar_grid(grid::Grid)
    dims = size(grid)
    if dims[1] != 1
        error("The first dimension must be 1.")
    end

    if dims[2] < 1 || dims[3] < 1 || dims[4] < 1
        error("Grid must have at least one element in each dimension.")
    end
end
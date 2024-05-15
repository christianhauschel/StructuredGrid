using LinearAlgebra
using .StructuredGrid

"""
    `check_surface(grid::Grid)`

Check if the grid is a surface.
"""
function _check_surface(grid::Grid)
    _check_vector_grid(grid)
    nk = get_nk(grid)
    if nk != 1
        throw(ArgumentError("Grid must be a surface (i.e. nk must be 1)."))
    end
end

"""
    `normals_facial(grid::Grid)::Grid`

Compute the normals of the faces of a structured grid.

# Returns 
`normals::Grid` - The normals of the faces of the grid.
"""
function normals_facial(grid::Grid)::Grid
    ni = get_ni(grid)
    nj = get_nj(grid)

    _check_surface(grid)

    normals = zeros(3, ni - 1, nj - 1, 1)

    for i in 1:ni-1
        for j in 1:nj-1
            v1 = grid[:, i+1, j, 1] - grid[:, i, j, 1]
            v2 = grid[:, i, j+1, 1] - grid[:, i, j, 1]
            normal = cross(v1, v2)
            normals[:, i, j, 1] = normal / norm(normal)
        end
    end

    return Grid(normals)
end

"""
    `midpoints_facial(grid::Grid)::Grid`

Compute the midpoints of the faces of a structured grid.

# Returns
`midpoints::Grid` - The midpoints of the faces of the grid.
"""
function midpoints_facial(grid::Grid)::Grid

    # Error checking
    _check_vector_grid(grid)
    _check_surface(grid)

    ni = get_ni(grid)
    nj = get_nj(grid)


    midpoints = zeros(3, ni - 1, nj - 1, 1)

    for i in 1:ni-1
        for j in 1:nj-1
            midpoints[:, i, j, 1] = (grid[:, i, j, 1] + grid[:, i+1, j, 1] + grid[:, i, j+1, 1] + grid[:, i+1, j+1, 1]) / 4
        end
    end

    return Grid(midpoints)

end

"""
    `normals_nodal(grid::Grid)::Grid`

Compute the normals of the nodes of a structured grid.

# Returns
`normals::Grid` - The normals of the nodes of the grid.

"""
function normals_nodal(grid::Grid)::Grid
    _check_surface(grid)

    normals_face = normals_facial(grid)
    mids = midpoints_facial(grid)
    dims = size(grid)
    normals = zeros(dims)

    ni = get_ni(grid)
    nj = get_nj(grid)

    for i in 1:ni
        for j in 1:nj
            if i == 1 && j == 1
                normals[:, i, j, 1] = normals_face[:, i, j, 1]
            elseif i == ni && j == nj
                normals[:, i, j, 1] = normals_face[:, i-1, j-1, 1]
            elseif i == 1 && j < nj
                d0 = norm(mids[:, i, j-1, 1] - grid[:, i, j, 1])
                d1 = norm(mids[:, i, j, 1] - grid[:, i, j, 1])
                normal = (normals_face[:, i, j-1, 1] / d0 + normals_face[:, i, j, 1] / d1) / 2
                normals[:, i, j, 1] = normal / norm(normal)
            elseif j == 1 && i < ni
                d0 = norm(mids[:, i-1, j, 1] - grid[:, i, j, 1])
                d1 = norm(mids[:, i, j, 1] - grid[:, i, j, 1])
                normal = (normals_face[:, i-1, j, 1] / d0 + normals_face[:, i, j, 1] / d1) / 2
                normals[:, i, j, 1] = normal / norm(normal)
            elseif i == ni && j == 1
                normals[:, i, j, 1] = normals_face[:, i-1, j, 1]
            elseif j == nj && i == 1
                normals[:, i, j, 1] = normals_face[:, i, j-1, 1]
            elseif i == ni
                d0 = norm(mids[:, i-1, j-1, 1] - grid[:, i, j, 1])
                d1 = norm(mids[:, i-1, j, 1] - grid[:, i, j, 1])
                normal = (normals_face[:, i-1, j-1, 1] / d0 + normals_face[:, i-1, j, 1] / d1) / 2
                normals[:, i, j, 1] = normal / norm(normal)
            elseif j == nj
                d0 = norm(mids[:, i-1, j-1, 1] - grid[:, i, j, 1])
                d1 = norm(mids[:, i, j-1, 1] - grid[:, i, j, 1])
                normal = (normals_face[:, i-1, j-1, 1] / d0 + normals_face[:, i, j-1, 1] / d1) / 2
                normals[:, i, j, 1] = normal / norm(normal)
            else
                d0 = norm(mids[:, i, j, 1] - grid[:, i, j, 1])
                d1 = norm(mids[:, i-1, j, 1] - grid[:, i, j, 1])
                d2 = norm(mids[:, i, j-1, 1] - grid[:, i, j, 1])
                d3 = norm(mids[:, i-1, j-1, 1] - grid[:, i, j, 1])
                normal = (
                    normals_face[:, i, j, 1] / d0 +
                    normals_face[:, i-1, j, 1] / d1 +
                    normals_face[:, i, j-1, 1] / d2 +
                    normals_face[:, i-1, j-1, 1] / d3
                ) / 4
                normals[:, i, j, 1] = normal / norm(normal)
            end
        end
    end

    return Grid(normals)
end